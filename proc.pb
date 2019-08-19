Macro softReset()
  megaplanAccess = ""
  megaplanSecret = ""
  If IsThread(connectThread) : KillThread(connectThread) : EndIf
  If IsThread(checkThread) : KillThread(checkThread) : EndIf
  alerts = 0
  megaplanState = #megaplanDisconnected
  updateStatusIcon()
EndMacro

Procedure restartApp(delay.i)
  Protected task = CocoaMessage(0,CocoaMessage(0,CocoaMessage(0,0,"NSTask alloc"),"init"),"autorelease")
  Protected args = CocoaMessage(0,0,"NSMutableArray arrayWithCapacity:",0)
  Protected appPath.s = PeekS(CocoaMessage(0,CocoaMessage(0,CocoaMessage(0,0,"NSBundle mainBundle"),"bundlePath"),"UTF8String"),-1,#PB_UTF8)
  Protected command.s = "sleep " + Str(delay) + ~"; open -a \"" + appPath + ~"\""
  CocoaMessage(0,args,"addObject:$",@"-c")
  CocoaMessage(0,args,"addObject:$",@command)
  CocoaMessage(0,task,"setLaunchPath:$",@"/bin/sh")
  CocoaMessage(0,task,"setArguments:",args)
  CocoaMessage(0,task,"launch")
  End
EndProcedure

Procedure errorHandler()
  ;MessageRequester(#myName,"I'm crashed, press OK to restart...")
  restartApp(3)
  End
EndProcedure

Procedure initResources()
  Protected imageSize.NSSize
  Protected path.s = GetPathPart(ProgramFilename()) + "../Resources/"
  LoadFont(#resFontMono,"Menlo",15,#PB_Font_Bold)
  LoadFont(#resFontMonoX2,"Menlo",30,#PB_Font_Bold)
  If LoadImageEx(#resIcon,path+"status_icon.png") And LoadImageEx(#resIconConn,path+"status_icon_conn.png")
    LoadImageEx(#resIconBack,path+"alerts_back.png")
    LoadImageEx(#resIcon1,path+"1.png")
    LoadImageEx(#resIcon2,path+"2.png")
    LoadImageEx(#resIcon3,path+"3.png")
    LoadImageEx(#resIcon4,path+"4.png")
    LoadImageEx(#resIcon5,path+"5.png")
    LoadImageEx(#resIcon6,path+"6.png")
    LoadImageEx(#resIcon7,path+"7.png")
    LoadImageEx(#resIcon8,path+"8.png")
    LoadImageEx(#resIcon9,path+"9.png")
    LoadImageEx(#resIcon0,path+"0.png")
    If getBackingScaleFactor() >= 2.0
      imageSize\width = 20
      imageSize\height = 20
      CocoaMessage(0,ImageID(#resIcon),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIconConn),"setSize:@",@ImageSize)
    Else
      ResizeImage(#resIcon,20,20,#PB_Image_Smooth)
      ResizeImage(#resIconConn,20,20,#PB_Image_Smooth)
      ResizeImage(#resIcon1,6,10,#PB_Image_Smooth)
      ResizeImage(#resIcon2,6,10,#PB_Image_Smooth)
      ResizeImage(#resIcon3,6,10,#PB_Image_Smooth)
      ResizeImage(#resIcon4,6,10,#PB_Image_Smooth)
      ResizeImage(#resIcon5,6,10,#PB_Image_Smooth)
      ResizeImage(#resIcon6,6,10,#PB_Image_Smooth)
      ResizeImage(#resIcon7,6,10,#PB_Image_Smooth)
      ResizeImage(#resIcon8,6,10,#PB_Image_Smooth)
      ResizeImage(#resIcon9,6,10,#PB_Image_Smooth)
    EndIf
     CocoaMessage(0,ImageID(#resIcon),"setTemplate:",#True)
  Else
    Debug "failed to load resources"
    End 1
  EndIf
EndProcedure

Procedure createNumIcon(num.i)
  Protected imageSize.NSSize
  If IsImage(#resIconNum) : FreeImage(#resIconNum) : EndIf
  CreateImage(#resIconNum,40,40,32)
  StartDrawing(ImageOutput(#resIconNum))
  DrawingMode(#PB_2DDrawing_AllChannels)
  DrawImage(ImageID(#resIconBack),0,0,40,40)
  Select num
    Case 1 To 9
      Select num
        Case 1
          DrawImage(ImageID(#resIcon1),12,6,17,28)
        Case 2
          DrawImage(ImageID(#resIcon2),12,6,17,28)
        Case 3
          DrawImage(ImageID(#resIcon3),12,6,17,28)
        Case 4
          DrawImage(ImageID(#resIcon4),12,6,17,28)
        Case 5
          DrawImage(ImageID(#resIcon5),12,6,17,28)
        Case 6
          DrawImage(ImageID(#resIcon6),12,6,17,28)
        Case 7
          DrawImage(ImageID(#resIcon7),12,6,17,28)
        Case 8
          DrawImage(ImageID(#resIcon8),12,6,17,28)
        Case 9
          DrawImage(ImageID(#resIcon9),12,6,17,28)
        Default
          DrawImage(ImageID(#resIcon0),12,6,17,28)
      EndSelect
    Case 10 To 99
      Select Left(Str(num),1)
        Case "1"
          DrawImage(ImageID(#resIcon1),3,6,17,28)
        Case "2"
          DrawImage(ImageID(#resIcon2),3,6,17,28)
        Case "3"
          DrawImage(ImageID(#resIcon3),3,6,17,28)
        Case "4"
          DrawImage(ImageID(#resIcon4),3,6,17,28)
        Case "5"
          DrawImage(ImageID(#resIcon5),3,6,17,28)
        Case "6"
          DrawImage(ImageID(#resIcon6),3,6,17,28)
        Case "7"
          DrawImage(ImageID(#resIcon7),3,6,17,28)
        Case "8"
          DrawImage(ImageID(#resIcon8),3,6,17,28)
        Case "9"
          DrawImage(ImageID(#resIcon9),3,6,17,28)
        Default
          DrawImage(ImageID(#resIcon0),3,6,17,28)
      EndSelect
      Select Right(Str(num),1)
        Case "1"
          DrawImage(ImageID(#resIcon1),20,6,17,28)
        Case "2"
          DrawImage(ImageID(#resIcon2),20,6,17,28)
        Case "3"
          DrawImage(ImageID(#resIcon3),20,6,17,28)
        Case "4"
          DrawImage(ImageID(#resIcon4),20,6,17,28)
        Case "5"
          DrawImage(ImageID(#resIcon5),20,6,17,28)
        Case "6"
          DrawImage(ImageID(#resIcon6),20,6,17,28)
        Case "7"
          DrawImage(ImageID(#resIcon7),20,6,17,28)
        Case "8"
          DrawImage(ImageID(#resIcon8),20,6,17,28)
        Case "9"
          DrawImage(ImageID(#resIcon9),20,6,17,28)
        Default
          DrawImage(ImageID(#resIcon0),20,6,17,28)
      EndSelect
    Default
      DrawImage(ImageID(#resIcon9),3,6,17,28)
      DrawImage(ImageID(#resIcon9),20,6,17,28)
  EndSelect
  StopDrawing()
  If getBackingScaleFactor() >= 2.0
    imageSize\width = 20
    imageSize\height = 20
    CocoaMessage(0,ImageID(#resIconNum),"setSize:@",@imageSize)
  Else
    ResizeImage(#resIconNum,20,20,#PB_Image_Smooth)
  EndIf
EndProcedure

Procedure advancedStatusBar()
  Shared statusBar.i,statusItem.i,app.i
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
    MenuItem(#menuMarkAllAsRead,"Mark all as read")
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

Procedure updateStatusIcon()
  Shared alerts.i
  Shared statusItem.i
  Shared megaplanState.b
  Protected imageSize.NSSize
  If GetGadgetState(#gadEnableStatusBar) = #PB_Checkbox_Checked
    If megaplanState = #megaplanConnected
      Select alerts
        Case 0
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon))
        Default
          createNumIcon(alerts)
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIconNum))
      EndSelect
    Else
      CocoaMessage(0,statusItem,"setImage:",ImageID(#resIconConn))
    EndIf
  EndIf
EndProcedure

Procedure settings(save.b = #False)
  If FileSize(GetEnvironmentVariable("HOME") + "/.config") = -1
    CreateDirectory(GetEnvironmentVariable("HOME") + "/.config")
  EndIf
  If FileSize(GetEnvironmentVariable("HOME") + "/.config/" + #myName) = -1
    CreateDirectory(GetEnvironmentVariable("HOME") + "/.config/" + #myName)
  EndIf
  Protected path.s = GetEnvironmentVariable("HOME") + "/.config/" + #myName + "/config.ini"
  If save
    CreatePreferences(path,#PB_Preference_GroupSeparator)
    PreferenceGroup("connection")
    WritePreferenceString("host",GetGadgetText(#gadHost))
    WritePreferenceString("login",GetGadgetText(#gadLogin))
    WritePreferenceString("password",GetGadgetText(#gadPassword))
    PreferenceGroup("settings")
    If GetGadgetState(#gadEnableLoginItem) = #PB_Checkbox_Checked
      WritePreferenceString("start_on_login","yes")
    Else
      WritePreferenceString("start_on_login","no")
    EndIf
    If GetGadgetState(#gadEnableUpdatesCheck) = #PB_Checkbox_Checked
      WritePreferenceString("check_for_updates","yes")
    Else
      WritePreferenceString("check_for_updates","no")
    EndIf
    If GetGadgetState(#gadEnableNotifications) = #PB_Checkbox_Checked
      WritePreferenceString("enable_notifications","yes")
    Else
      WritePreferenceString("enable_notifications","no")
    EndIf
    If GetGadgetState(#gadEnableStatusBar) = #PB_Checkbox_Checked
      WritePreferenceString("show_icon_in_statusbar","yes")
    Else
      WritePreferenceString("show_icon_in_statusbar","no")
    EndIf
  Else
    OpenPreferences(path,#PB_Preference_GroupSeparator)
    PreferenceGroup("connection")
    SetGadgetText(#gadHost,ReadPreferenceString("host",""))
    SetGadgetText(#gadLogin,ReadPreferenceString("login",""))
    SetGadgetText(#gadPassword,ReadPreferenceString("password",""))
    PreferenceGroup("settings")
    If ReadPreferenceString("start_on_login","no") = "yes"
      SetGadgetState(#gadEnableLoginItem,#PB_Checkbox_Checked)
    Else
      SetGadgetState(#gadEnableLoginItem,#PB_Checkbox_Unchecked)
    EndIf
    If ReadPreferenceString("check_for_updates","yes") = "yes"
      SetGadgetState(#gadEnableUpdatesCheck,#PB_Checkbox_Checked)
    Else
      SetGadgetState(#gadEnableUpdatesCheck,#PB_Checkbox_Unchecked)
    EndIf
    If ReadPreferenceString("enable_notifications","yes") = "yes"
      SetGadgetState(#gadEnableNotifications,#PB_Checkbox_Checked)
    Else
      SetGadgetState(#gadEnableNotifications,#PB_Checkbox_Unchecked)
    EndIf
    If ReadPreferenceString("show_icon_in_statusbar","yes") = "yes"
      SetGadgetState(#gadEnableStatusBar,#PB_Checkbox_Checked)
    Else
      SetGadgetState(#gadEnableStatusBar,#PB_Checkbox_Unchecked)
    EndIf
  EndIf
  ClosePreferences()
EndProcedure

Procedure megaplanConnect(dummy)
  Protected host.s = GetGadgetText(#gadHost)
  Protected login.s = GetGadgetText(#gadLogin)
  Protected password.s = GetGadgetText(#gadPassword)
  Shared megaplanAccess.s,megaplanSecret.s
  If Len(host) And Len(login) And Len(password)
    Protected res.s = "-1"
    Repeat
      res = mega_auth(login,password,host,#myAgent)
      If res <> "-1"
        If res = "0"
          PostEvent(#eventWrongCredentials)
        Else
          Protected json = ParseJSON(#PB_Any,res,#PB_JSON_NoCase)
          If IsJSON(json)
            Protected authAnswer.megaplanAuth
            ExtractJSONStructure(JSONValue(json),@authAnswer,megaplanAuth)
            FreeJSON(json)
            If authAnswer\status("code") = "ok" And Len(authAnswer\data("AccessId")) And Len(authAnswer\data("SecretKey"))
              megaplanAccess = authAnswer\data("AccessId")
              megaplanSecret = authAnswer\data("SecretKey")
              PostEvent(#eventConnected)
              ProcedureReturn
            EndIf
          EndIf
        EndIf
      EndIf
      Delay(10000)
    ForEver
  Else
    PostEvent(#eventWrongCredentials)
  EndIf
EndProcedure

Procedure megaplanCheck(interval.i)
  Protected host.s = GetGadgetText(#gadHost)
  Protected NewList notificationIds.i()
  Protected Ids.s
  Shared notification.notifications::osxNotification
  Shared megaplanAccess.s,megaplanSecret.s,megaplanLastMsgId.i
  Shared shouldMarkAllAsRead.b
  Repeat
    Protected res.s = mega_query(megaplanAccess,megaplanSecret,"/BumsCommonApiV01/Informer/notifications.api",host,buildTZ(),#myAgent)
    ;Protected res_q.s = mega_query(megaplanAccess,megaplanSecret,"/BumsCommonApiV01/Informer/approvalsCount.api",host,buildTZ(),#myAgent)
    If res = "0" Or res = "-1" ;Or res_q = "0" Or res_q = "-1"
      PostEvent(#eventDisconnected)
      ProcedureReturn
    Else
      res = ReplaceString(res,#DQUOTE$ + "Content" + #DQUOTE$ + ":{" + #DQUOTE$,#DQUOTE$ + "ContentComment" + #DQUOTE$ + ":{" + #DQUOTE$)
      Protected json = ParseJSON(#PB_Any,res,#PB_JSON_NoCase)
      If IsJSON(json)
        Protected *queryAnswer.megaplanQuery = AllocateStructure(megaplanQuery)
        ExtractJSONStructure(JSONValue(json),*queryAnswer,megaplanQuery)
        FreeJSON(json)
        If GetGadgetState(#gadEnableNotifications) = #PB_Checkbox_Checked
          ForEach *queryAnswer\data\notifications()
            If *queryAnswer\data\notifications()\Id > megaplanLastMsgId
              If Len(*queryAnswer\data\notifications()\ContentComment\Subject\Name) ; it's a comment
                notification\title = *queryAnswer\data\notifications()\name
                notification\subTitle = *queryAnswer\data\notifications()\ContentComment\Subject\Name + ", " + *queryAnswer\data\notifications()\ContentComment\Author\Name
                notification\text = *queryAnswer\data\notifications()\ContentComment\Text
                notification\alwaysShow = #True
                notification\deleteAfterClick = #True
                notification\event = #eventNotification
                notification\evData = *queryAnswer\data\notifications()\ContentComment\Subject\Id
                notifications::sendNotification(@notification)
              Else ; it's something else
                notification\title = *queryAnswer\data\notifications()\name
                notification\subTitle = ""
                notification\text = *queryAnswer\data\notifications()\Content
                notification\alwaysShow = #True
                notification\deleteAfterClick = #True
                notification\event = #eventNotification
                notification\evData = *queryAnswer\data\notifications()\Subject\Id
                notifications::sendNotification(@notification)
              EndIf
            EndIf
          Next
        EndIf
        ClearList(notificationIds())
        ForEach *queryAnswer\data\notifications()
          AddElement(notificationIds())
          notificationIds() = *queryAnswer\data\notifications()\Id
          If *queryAnswer\data\notifications()\Id > megaplanLastMsgId
            megaplanLastMsgId = *queryAnswer\data\notifications()\Id
          EndIf
        Next
        If shouldMarkAllAsRead
          If ListSize(notificationIds())
            Ids = ""
            ForEach notificationIds()
              Ids + "Ids[]=" + notificationIds() + "&"
            Next
            Ids = Left(Ids,Len(Ids)-1)
            res = mega_query(megaplanAccess,megaplanSecret,"/BumsCommonApiV01/Informer/deactivateNotification.api?"+Ids,host,buildTZ(),#myAgent)
            If FindString(res,~"\"code\":\"ok\"")
              ClearList(*queryAnswer\data\notifications())
              shouldMarkAllAsRead = #False
            EndIf
          Else
            shouldMarkAllAsRead = #False
          EndIf
        EndIf
        PostEvent(#eventAlert,#PB_Ignore,#PB_Ignore,#PB_Ignore,ListSize(*queryAnswer\data\notifications()))
        FreeStructure(*queryAnswer)
      EndIf
    EndIf
    Delay(interval)
  ForEver
EndProcedure

Procedure checkUpdateAsync(interval.i)
  Shared updateVer.s,updateDetails.s
  Protected *buf,i,strCount
  If Not InitNetwork() : ProcedureReturn : EndIf
  Repeat
    If GetGadgetState(#gadEnableUpdatesCheck) = #PB_Checkbox_Checked
      *buf = ReceiveHTTPMemory(#updateCheckUrl)
      If *buf
        Protected size.i = MemorySize(*buf)
        Protected update.s = PeekS(*buf,size,#PB_UTF8)
        FreeMemory(*buf)
        strCount = CountString(update,Chr(10))
        Protected Dim strings.s(strCount)
        For i = 0 To strCount
          strings(i) = StringField(update,i+1,Chr(10))
        Next
        For i = 0 To strCount
          strings(i) = Trim(strings(i))
        Next
        If FindString(strings(0),#myName) = 1
          Protected newVer.s = StringField(strings(0),2," ")
          If newVer <> updateVer
            updateVer = newVer
            updateDetails = ""
            For i = 1 To strCount
              If Len(strings(i)) > 0
                updateDetails + strings(i) + Chr(10)
              EndIf
            Next
            FreeArray(strings())
            PostEvent(#eventUpdateArrived)
          EndIf
        EndIf
      EndIf
    EndIf
    If interval > 0 : Delay(interval) : Else : ProcedureReturn : EndIf
  ForEver
EndProcedure
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; CursorPosition = 326
; FirstLine = 314
; Folding = --
; EnableXP
; EnableUnicode