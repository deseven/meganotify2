EnableExplicit

IncludeFile "../libmegaplan/pb-wrapper.pb"
IncludeFile "const.pb"

Define app = CocoaMessage(0,0,"NSApplication sharedApplication")

IncludeFile "helpers.pb"
IncludeFile "proc.pb"

OpenWindow(#wnd,#PB_Ignore,#PB_Ignore,400,300,#myName,#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
StickyWindow(#wnd,#True)
CocoaMessage(0,CocoaMessage(0,WindowID(#wnd),"standardWindowButton:",#NSWindowButtonMinimize),"setHidden:",#YES)
CocoaMessage(0,CocoaMessage(0,WindowID(#wnd),"standardWindowButton:",#NSWindowButtonMaximize),"setHidden:",#YES)

CheckBoxGadget(#gadEnableStatusBar,10,10,150,20,"enable status bar icon")

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
  Select ev
    Case #PB_Event_Gadget
      advancedStatusBar()
    Case #PB_Event_Menu
      Select EventMenu()
        Case 0
          CocoaMessage(0,app,"activateIgnoringOtherApps:",#YES)
        Case 1
          Break
      EndSelect
    Case #PB_Event_CloseWindow
      CocoaMessage(0,app,"hide:")
  EndSelect
Until ev = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.42 LTS (MacOS X - x64)
; EnableUnicode
; EnableXP