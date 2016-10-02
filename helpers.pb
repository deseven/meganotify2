ImportC "/System/Library/Frameworks/Accelerate.framework/Accelerate"
  vImageUnpremultiplyData_RGBA8888 (*src, *dest, flags) 
EndImport

; concept by Kukulkan (http://forums.purebasic.com/english/viewtopic.php?f=19&t=64057)
Procedure.b enableLoginItem(bundleID.s,state.b)
  Protected loginItemsPath.s = GetHomeDirectory() + "Library/LaunchAgents/"
  Protected loginItemPath.s = loginItemsPath + bundleID + ".plist"
  Protected bundlePathPtr = CocoaMessage(0,CocoaMessage(0,CocoaMessage(0,0,"NSBundle mainBundle"),"bundlePath"),"UTF8String")
  If bundlePathPtr
    Protected bundlePath.s = PeekS(bundlePathPtr,-1,#PB_UTF8)
  Else
    ProcedureReturn #False
  EndIf
  If state
    If FileSize(loginItemsPath) <> -2
      If Not CreateDirectory(loginItemsPath)
        ProcedureReturn #False
      EndIf
    EndIf
    Protected loginItemFile = CreateFile(#PB_Any,loginItemPath)
    If IsFile(loginItemFile)
      Protected loginItemPlist.s = ReplaceString(#loginItemPlist,"{appid}",bundleID)
      loginItemPlist = ReplaceString(loginItemPlist,"{apppath}",bundlePath)
      WriteString(loginItemFile,loginItemPlist,#PB_UTF8)
      CloseFile(loginItemFile)
      RunProgram("launchctl",~"load \"" + loginItemPath + ~"\"","")
    Else
      ProcedureReturn #False
    EndIf
  Else
    If FileSize(loginItemPath) <> -1
      RunProgram("launchctl",~"unload \"" + loginItemPath + ~"\"","")
      If Not DeleteFile(loginItemPath,#PB_FileSystem_Force)
        ProcedureReturn #False
      EndIf
    EndIf
  EndIf
  ProcedureReturn #True
EndProcedure

Procedure.f getBackingScaleFactor()
  Define backingScaleFactor.CGFloat = 1.0
  If OSVersion() >= #PB_OS_MacOSX_10_7
    CocoaMessage(@backingScaleFactor,CocoaMessage(0,0,"NSScreen mainScreen"),"backingScaleFactor")
  EndIf
  ProcedureReturn backingScaleFactor
EndProcedure

; code by wilbert (http://www.purebasic.fr/english/viewtopic.php?p=392073#p392073)
Procedure loadImageEx(Image,Filename.s)
  Protected.i Result, Rep, vImg.vImage_Buffer
  Protected Size.NSSize, Point.NSPoint
  CocoaMessage(@Rep, 0, "NSImageRep imageRepWithContentsOfFile:$", @Filename)
  If Rep
    Size\width = CocoaMessage(0, Rep, "pixelsWide")
    Size\height = CocoaMessage(0, Rep, "pixelsHigh")
    If Size\width And Size\height
      CocoaMessage(0, Rep, "setSize:@", @Size)
    Else
      CocoaMessage(@Size, Rep, "size")
    EndIf
    If Size\width And Size\height
      Result = CreateImage(Image, Size\width, Size\height, 32, #PB_Image_Transparent)
      If Result
        If Image = #PB_Any : Image = Result : EndIf
        StartDrawing(ImageOutput(Image))
        CocoaMessage(0, Rep, "drawAtPoint:@", @Point)
        If CocoaMessage(0, Rep, "hasAlpha")
          vImg\data = DrawingBuffer()
          vImg\width = OutputWidth()
          vImg\height = OutputHeight()
          vImg\rowBytes = DrawingBufferPitch()
          vImageUnPremultiplyData_RGBA8888(@vImg, @vImg, 0)
        EndIf
        StopDrawing()
      EndIf
    EndIf
  EndIf  
  ProcedureReturn Result
EndProcedure

Procedure.s buildTZ()
  Define tz.i = CocoaMessage(0, 0, "NSTimeZone systemTimeZone")
  Define offset = CocoaMessage(0,tz,"secondsFromGMT")/60/60
  If offset = 0
    ProcedureReturn "+0000"
  ElseIf offset > 0 And offset < 10
    ProcedureReturn "+0" + Str(offset) + "00"
  ElseIf offset >= 10
    ProcedureReturn "+" + Str(offset) + "00"
  ElseIf offset < 0 And offset > -10
    ProcedureReturn "-0" + Str(offset*-1) + "00"
  Else
    ProcedureReturn "-" + Str(offset*-1) + "00"
  EndIf
EndProcedure

Procedure hideApp(state)
  Shared app.i
  If state
    CocoaMessage(0,app,"setActivationPolicy:",#NSApplicationActivationPolicyProhibited)
  Else
    CocoaMessage(0,app,"setActivationPolicy:",#NSApplicationActivationPolicyAccessory)
  EndIf
  HideWindow(#wnd,state)
  If Not state
    CocoaMessage(0,app,"activateIgnoringOtherApps:",#YES)
  EndIf
EndProcedure
; IDE Options = PureBasic 5.42 LTS (MacOS X - x64)
; Folding = -
; EnableUnicode
; EnableXP