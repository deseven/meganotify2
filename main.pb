EnableExplicit

IncludeFile "../libmegaplan/pb-wrapper.pb"
IncludeFile "const.pb"

Define app = CocoaMessage(0,0,"NSApplication sharedApplication")

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
StringGadget(#gadPassword,20,85,260,30,"")
CocoaMessage(0,CocoaMessage(0,GadgetID(#gadPassword),"cell"),"setPlaceholderString:$",@"Password")
CocoaMessage(0,GadgetID(#gadPassword),"setBezelStyle:",1)
CocoaMessage(0,GadgetID(#gadPassword),"setFocusRingType:",1)

FrameGadget(#gadFrameSettings,10,125,280,110,"Settings")
CheckBoxGadget(#gadEnableLoginItem,20,145,180,20,"Start on login")
CocoaMessage(0,GadgetID(#gadEnableLoginItem),"setFocusRingType:",1)
CheckBoxGadget(#gadEnableUpdatesCheck,20,165,180,20,"Check for updates")
CocoaMessage(0,GadgetID(#gadEnableUpdatesCheck),"setFocusRingType:",1)
CheckBoxGadget(#gadEnableStatusBar,20,185,180,20,"Enable status bar icon")
CocoaMessage(0,GadgetID(#gadEnableStatusBar),"setFocusRingType:",1)
CheckBoxGadget(#gadEnableNotifications,20,205,180,20,"Enable notifications")
CocoaMessage(0,GadgetID(#gadEnableNotifications),"setFocusRingType:",1)

SetActiveGadget(-1)

If mega_init(0,GetPathPart(ProgramFilename()) + "../Libs/libmegaplan.dylib")
  Debug mega_version()
Else
  MessageRequester(#myName,"Can't load libmegaplan, exiting.")
  End 1
EndIf

;Debug mega_auth("","","plan.home-nadym.ru",#myName + "/" + #myVer)

initResources()

Repeat
  Define ev = WaitWindowEvent()
  Define res.i
  Select ev
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #gadEnableStatusBar
          advancedStatusBar()
        Case #gadEnableLoginItem
          If GetGadgetState(#gadEnableLoginItem) = #PB_Checkbox_Checked
            res = enableLoginItem(#myID,#True)
            MessageRequester(#myName,"result: " + Str(res))
          Else
            res = enableLoginItem(#myID,#False)
            MessageRequester(#myName,"result: " + Str(res))
          EndIf
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #menuMegaplan
          
        Case #menuPrefs
          SetActiveGadget(-1)
          CocoaMessage(0,app,"activateIgnoringOtherApps:",#YES)
        Case #menuAbout
          MessageRequester(#myName + " " + #myVer,~"\ncreated by deseven, 2016")
        Case #menuQuit
          Break
      EndSelect
    Case #PB_Event_CloseWindow
      CocoaMessage(0,app,"hide:")
  EndSelect
ForEver
; IDE Options = PureBasic 5.42 LTS (MacOS X - x64)
; EnableUnicode
; EnableXP