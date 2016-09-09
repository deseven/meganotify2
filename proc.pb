Procedure initResources()
  Protected imageSize.NSSize
  Protected path.s = GetPathPart(ProgramFilename()) + "../Resources/"
  ;LoadFont(#resBigFont,"Courier",18,#PB_Font_Bold)
  If LoadImageEx(#resLogo,path+"main.icns")
    If getBackingScaleFactor() >= 2.0
      If Not LoadImageEx(#resIcon,path+"status_icon@2x.png") : End 1 : EndIf
      If Not LoadImageEx(#resIconConn,path+"status_icon_conn@2x.png") : End 1 : EndIf
      imageSize\width = 20
      imageSize\height = 20
      CocoaMessage(0,ImageID(#resIcon),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIconConn),"setSize:@",@ImageSize)
      ResizeImage(#resLogo,128,128,#PB_Image_Smooth)
      imageSize\width = 64
      imageSize\height = 64
      CocoaMessage(0,ImageID(#resLogo),"setSize:@",@ImageSize)
    Else
      If Not LoadImageEx(#resIcon,path+"status_icon.png") : End 1 : EndIf
      If Not LoadImageEx(#resIconConn,path+"status_icon_conn.png") : End 1 : EndIf
      ResizeImage(#resLogo,64,64,#PB_Image_Smooth)
    EndIf
    ;CocoaMessage(0,ImageID(#resIcon),"setTemplate:",#True)
  Else
    Debug "failed to load resources"
    End 1
  EndIf
EndProcedure

Procedure advancedStatusBar()
  Static statusBar.i,statusItem.i
  Shared app.i
  Protected itemLength.CGFloat = 24
  If GetGadgetState(#gadEnableStatusBar) = #PB_Checkbox_Checked
    If Not statusBar
      statusBar = CocoaMessage(0,0,"NSStatusBar systemStatusBar")
    EndIf
    If Not statusItem
      statusItem = CocoaMessage(0,CocoaMessage(0,statusBar,"statusItemWithLength:",itemLength),"retain")
    EndIf
    CreatePopupMenu(#menu)
    MenuItem(#menuMegaplan,"Open Megaplan")
    MenuBar()
    MenuItem(#menuPrefs,"Preferences")
    MenuItem(#menuAbout,"About")
    MenuItem(#menuQuit,"Quit")
    CocoaMessage(0,statusItem,"setHighlightMode:",#YES)
    CocoaMessage(0,statusItem,"setLength:@",@itemLength)
    CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon))
    CocoaMessage(0,statusItem,"setMenu:",CocoaMessage(0,MenuID(#menu),"firstObject"))
  Else
    If statusBar And statusItem
      CocoaMessage(0,statusBar,"removeStatusItem:",statusItem)
    EndIf
    statusItem = 0
    If IsMenu(#menu) : FreeMenu(#menu) : EndIf
  EndIf
EndProcedure
; IDE Options = PureBasic 5.42 LTS (MacOS X - x64)
; Folding = -
; EnableUnicode
; EnableXP