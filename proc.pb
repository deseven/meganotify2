Macro softReset()
  megaplanAccess = ""
  megaplanSecret = ""
  If IsThread(connectThread) : KillThread(connectThread) : EndIf
  If IsThread(checkThread) : KillThread(checkThread) : EndIf
  alerts = 0
  megaplanState = #megaplanDisconnected
  updateStatusIcon()
EndMacro

Procedure initResources()
  Protected imageSize.NSSize
  Protected path.s = GetPathPart(ProgramFilename()) + "../Resources/"
  LoadFont(#resFontMono,"Menlo",15,#PB_Font_Bold)
  LoadFont(#resFontMonoX2,"Menlo",30,#PB_Font_Bold)
  If LoadImageEx(#resIcon,path+"status_icon.png") And LoadImageEx(#resIconConn,path+"status_icon_conn.png")
    LoadImageEx(#resIcon1,path+"1.png")
    LoadImageEx(#resIcon2,path+"2.png")
    LoadImageEx(#resIcon3,path+"3.png")
    LoadImageEx(#resIcon4,path+"4.png")
    LoadImageEx(#resIcon5,path+"5.png")
    LoadImageEx(#resIcon6,path+"6.png")
    LoadImageEx(#resIcon7,path+"7.png")
    LoadImageEx(#resIcon8,path+"8.png")
    LoadImageEx(#resIcon9,path+"9.png")
    LoadImageEx(#resIconMore,path+"more.png")
    If getBackingScaleFactor() >= 2.0
      imageSize\width = 20
      imageSize\height = 20
      CocoaMessage(0,ImageID(#resIcon),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIconConn),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIcon1),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIcon2),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIcon3),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIcon4),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIcon5),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIcon6),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIcon7),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIcon8),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIcon9),"setSize:@",@ImageSize)
      CocoaMessage(0,ImageID(#resIconMore),"setSize:@",@ImageSize)
    Else
      ResizeImage(#resIcon,20,20,#PB_Image_Smooth)
      ResizeImage(#resIconConn,20,20,#PB_Image_Smooth)
      ResizeImage(#resIcon1,20,20,#PB_Image_Smooth)
      ResizeImage(#resIcon2,20,20,#PB_Image_Smooth)
      ResizeImage(#resIcon3,20,20,#PB_Image_Smooth)
      ResizeImage(#resIcon4,20,20,#PB_Image_Smooth)
      ResizeImage(#resIcon5,20,20,#PB_Image_Smooth)
      ResizeImage(#resIcon6,20,20,#PB_Image_Smooth)
      ResizeImage(#resIcon7,20,20,#PB_Image_Smooth)
      ResizeImage(#resIcon8,20,20,#PB_Image_Smooth)
      ResizeImage(#resIcon9,20,20,#PB_Image_Smooth)
      ResizeImage(#resIconMore,20,20,#PB_Image_Smooth)
    EndIf
  Else
    Debug "failed to load resources"
    End 1
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
      ; i do know that i should've done it differently, but well... TOO LATE!
      Select alerts
        Case 0
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon))
        Case 1
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon1))
        Case 2
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon2))
        Case 3
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon3))
        Case 4
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon4))
        Case 5
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon5))
        Case 6
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon6))
        Case 7
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon7))
        Case 8
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon8))
        Case 9
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIcon9))
        Default
          CocoaMessage(0,statusItem,"setImage:",ImageID(#resIconMore))
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
  Shared megaplanAccess.s,megaplanSecret.s,megaplanLastMsgId.i
  Repeat
    Protected res.s = mega_query(megaplanAccess,megaplanSecret,"/BumsCommonApiV01/Informer/notifications.api",host,buildTZ(),#myAgent)
    If res = "0" Or res = "-1"
      PostEvent(#eventDisconnected)
      ProcedureReturn
    Else
      res = ReplaceString(res,#DQUOTE$ + "Content" + #DQUOTE$ + ":{" + #DQUOTE$,#DQUOTE$ + "ContentComment" + #DQUOTE$ + ":{" + #DQUOTE$)
      Protected json = ParseJSON(#PB_Any,res,#PB_JSON_NoCase)
      If IsJSON(json)
        Protected queryAnswer.megaplanQuery
        ExtractJSONStructure(JSONValue(json),@queryAnswer,megaplanQuery)
        FreeJSON(json)
        If GetGadgetState(#gadEnableNotifications) = #PB_Checkbox_Checked
          ForEach queryAnswer\data\notifications()
            If queryAnswer\data\notifications()\Id > megaplanLastMsgId
              If Len(queryAnswer\data\notifications()\ContentComment\Subject\Name) ; it's a comment
                ;Debug "title: " + queryAnswer\data\notifications()\name
                ;Debug "subtitle: " + queryAnswer\data\notifications()\ContentComment\Subject\Name + ", " + queryAnswer\data\notifications()\ContentComment\Author\Name
                ;Debug "text: " + queryAnswer\data\notifications()\ContentComment\Text
                deliverNotification(queryAnswer\data\notifications()\name,queryAnswer\data\notifications()\ContentComment\Subject\Name + ", " + queryAnswer\data\notifications()\ContentComment\Author\Name,queryAnswer\data\notifications()\ContentComment\Text)
              Else ; it's something else
                ;Debug "title: " + queryAnswer\data\notifications()\name
                ;Debug "text:" + queryAnswer\data\notifications()\Content
                deliverNotification(queryAnswer\data\notifications()\name,"",queryAnswer\data\notifications()\Content)
              EndIf
            EndIf
          Next
        EndIf
        ForEach queryAnswer\data\notifications()
          If queryAnswer\data\notifications()\Id > megaplanLastMsgId
            megaplanLastMsgId = queryAnswer\data\notifications()\Id
          EndIf
        Next
        PostEvent(#eventAlert,#PB_Ignore,#PB_Ignore,#PB_Ignore,ListSize(queryAnswer\data\notifications()))
      EndIf
    EndIf
    Delay(interval)
  ForEver
EndProcedure
; IDE Options = PureBasic 5.42 LTS (MacOS X - x64)
; Folding = --
; EnableUnicode
; EnableXP