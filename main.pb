EnableExplicit

IncludeFile "../libmegaplan/pb-wrapper.pb"
IncludeFile "const.pb"

Define app = CocoaMessage(0,0,"NSApplication sharedApplication")
Define statusBar.i,statusItem.i,alerts.i,megaplanState.b
Define connectThread.i,checkThread.i
Define megaplanAccess.s,megaplanSecret.s
Define megaplanLastMsgId.i

IncludeFile "helpers.pb"
IncludeFile "proc.pb"

OpenWindow(#wnd,#PB_Ignore,#PB_Ignore,300,240,#myName,#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
StickyWindow(#wnd,#True)
CocoaMessage(0,CocoaMessage(0,WindowID(#wnd),"standardWindowButton:",#NSWindowButtonMinimize),"setHidden:",#YES)
CocoaMessage(0,CocoaMessage(0,WindowID(#wnd),"standardWindowButton:",#NSWindowButtonMaximize),"setHidden:",#YES)

FrameGadget(#gadFrameConnection,10,10,280,110,"Connection")
StringGadget(#gadHost,20,25,260,30,"")
CocoaMessage(0,CocoaMessage(0,GadgetID(#gadHost),"cell"),"setPlaceholderString:$",@"Megaplan hostname")
CocoaMessage(0,GadgetID(#gadHost),"setBezelStyle:",1)
CocoaMessage(0,GadgetID(#gadHost),"setFocusRingType:",1)
StringGadget(#gadLogin,20,55,260,30,"")
CocoaMessage(0,CocoaMessage(0,GadgetID(#gadLogin),"cell"),"setPlaceholderString:$",@"Login")
CocoaMessage(0,GadgetID(#gadLogin),"setBezelStyle:",1)
CocoaMessage(0,GadgetID(#gadLogin),"setFocusRingType:",1)
StringGadget(#gadPassword,20,85,260,30,"",#PB_String_Password)
CocoaMessage(0,CocoaMessage(0,GadgetID(#gadPassword),"cell"),"setPlaceholderString:$",@"Password")
CocoaMessage(0,GadgetID(#gadPassword),"setBezelStyle:",1)
CocoaMessage(0,GadgetID(#gadPassword),"setFocusRingType:",1)

FrameGadget(#gadFrameSettings,10,125,280,110,"Settings")
CheckBoxGadget(#gadEnableLoginItem,20,145,180,20,"Start on login")
CocoaMessage(0,GadgetID(#gadEnableLoginItem),"setFocusRingType:",1)
CheckBoxGadget(#gadEnableUpdatesCheck,20,165,180,20,"Check for updates")
DisableGadget(#gadEnableUpdatesCheck,#True)
CocoaMessage(0,GadgetID(#gadEnableUpdatesCheck),"setFocusRingType:",1)
CheckBoxGadget(#gadEnableStatusBar,20,185,180,20,"Enable status bar icon")
CocoaMessage(0,GadgetID(#gadEnableStatusBar),"setFocusRingType:",1)
CheckBoxGadget(#gadEnableNotifications,20,205,180,20,"Enable notifications")
CocoaMessage(0,GadgetID(#gadEnableNotifications),"setFocusRingType:",1)

initResources()

settings()
If GetGadgetState(#gadEnableStatusBar)
  advancedStatusBar()
EndIf

updateStatusIcon()

SetActiveGadget(-1)

If Len(GetGadgetText(#gadHost)) And Len(GetGadgetText(#gadLogin)) And Len(GetGadgetText(#gadPassword))
  CocoaMessage(0,app,"hide:")
  PostEvent(#eventDisconnected)
EndIf

If mega_init(0,GetPathPart(ProgramFilename()) + "../Libs/libmegaplan.dylib")
  ;Debug mega_version()
Else
  MessageRequester(#myName,#errorMsg + "loading libmegaplan")
  End 1
EndIf

;Define objects.i = CocoaMessage(0,0,"NSArray arrayWithObject:$",@"open_url")
;objects = CocoaMessage(0,objects,"arrayByAddingObject:$",@"ya.ru")
;Define keys.i = CocoaMessage(0,0,"NSArray arrayWithObject:$",@"action")
;keys = CocoaMessage(0,keys,"arrayByAddingObject:$",@"value")
;Define options.i = CocoaMessage(0,0,"NSDictionary dictionaryWithObjects:",objects,"forKeys:",keys)
;CocoaMessage(0,options,"setValue:$",@"Finder","forKey:$",@"open")
;deliverNotification("testTitle","testSubtitle","testText")
;End

Repeat
  Define ev = WaitWindowEvent()
  Define res.i
  Select ev
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #gadEnableStatusBar
          advancedStatusBar()
          settings(#True)
        Case #gadEnableLoginItem
          If GetGadgetState(#gadEnableLoginItem) = #PB_Checkbox_Checked
            If Not enableLoginItem(#myID,#True)
              SetGadgetState(#gadEnableLoginItem,#PB_Checkbox_Unchecked)
              MessageRequester(#myName,#errorMsg + "applying autostart")
            Else
              settings(#True)
            EndIf
          Else
            If Not enableLoginItem(#myID,#False)
              SetGadgetState(#gadEnableLoginItem,#PB_Checkbox_Checked)
              MessageRequester(#myName,#errorMsg + "disabling autostart")
            Else
              settings(#True)
            EndIf
          EndIf
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #menuMegaplan
          If Len(GetGadgetText(#gadHost))
            RunProgram("open",~"\"http://" + GetGadgetText(#gadHost) + ~"\"","")
          Else
            SetActiveGadget(#gadHost)
            CocoaMessage(0,app,"activateIgnoringOtherApps:",#YES)
          EndIf
        Case #menuPrefs
          softReset()
          SetActiveGadget(-1)
          CocoaMessage(0,app,"activateIgnoringOtherApps:",#YES)
        Case #menuAbout
          MessageRequester(#myName + " " + #myVer,~"\ncreated by deseven, 2016")
        Case #menuQuit
          Break
      EndSelect
    Case #eventDisconnected
      softReset()
      connectThread = CreateThread(@megaplanConnect(),#PB_Ignore)
    Case #eventConnected
      megaplanState = #megaplanConnected
      updateStatusIcon()
      checkThread = CreateThread(@megaplanCheck(),#megaplanCheckInterval)
    Case #eventAlert
      If alerts <> EventData()
        alerts = EventData()
        updateStatusIcon()
      EndIf
    Case #eventWrongCredentials
      softReset()
      SetActiveGadget(#gadHost)
      CocoaMessage(0,app,"activateIgnoringOtherApps:",#YES)
      MessageRequester(#myName,#invalidCredentials)
    Case #PB_Event_CloseWindow
      If GetGadgetState(#gadEnableStatusBar) = #PB_Checkbox_Unchecked And GetGadgetState(#gadEnableNotifications) = #PB_Checkbox_Unchecked
        If MessageRequester(#myName,#disabledWarn,#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
          CocoaMessage(0,app,"hide:")
          settings(#True)
          PostEvent(#eventDisconnected)
        EndIf
      Else
        CocoaMessage(0,app,"hide:")
        settings(#True)
        PostEvent(#eventDisconnected)
      EndIf
  EndSelect
ForEver
; IDE Options = PureBasic 5.42 LTS (MacOS X - x64)
; EnableUnicode
; EnableXP