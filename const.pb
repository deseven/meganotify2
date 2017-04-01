#myName = "MegaNotify"
#myVer = "2.2.1"
#myAgent = #myName + "/" + #myVer
#myID = "info.deseven.meganotify"

#updateCheckInterval = 86400000 ; 24 hours
#updateCheckUrl = "http://deseven.info/sys/mn.ver"
#updateDownloadUrl = "http://deseven.info/sys/mn.dmg"

#errorMsg = "Something went wrong, please try to reinstall this tool or contact the developer.\nStep: "
#invalidCredentials = "Can't connect with provided credentials. Please re-check the information you provided."
#disabledWarn = ~"Looks like you disabled both notifications and status bar icon. It means that you would not be able to receive any notifications at all.\nIs that really what you want?"

#megaplanCheckInterval = 15000

Enumeration gadgets
  #wnd
  #gadFrameConnection
  #gadHost
  #gadLogin
  #gadPassword
  #gadFrameSettings
  #gadEnableLoginItem
  #gadEnableUpdatesCheck
  #gadEnableStatusBar
  #gadEnableNotifications
EndEnumeration

Enumeration menu
  #menu
  #menuMegaplan
  #menuMarkAllAsRead
  #menuPrefs
  #menuAbout
  #menuQuit
EndEnumeration

Enumeration resources
  #resFontMono
  #resFontMonoX2
  #resIcon
  #resIconConn
  #resIcon0
  #resIcon1
  #resIcon2
  #resIcon3
  #resIcon4
  #resIcon5
  #resIcon6
  #resIcon7
  #resIcon8
  #resIcon9
  #resIconBack
  #resIconNum
EndEnumeration

Enumeration #PB_Event_FirstCustomValue
  #eventConnected
  #eventDisconnected
  #eventAlert
  #eventWrongCredentials
  #eventNotification
  #eventUpdateArrived
EndEnumeration

Enumeration states
  #megaplanDisconnected
  #megaplanConnected
EndEnumeration

#NSWindowButtonMinimize = 1
#NSWindowButtonMaximize = 2
#NSApplicationActivationPolicyRegular = 0
#NSApplicationActivationPolicyAccessory = 1
#NSApplicationActivationPolicyProhibited = 2

#loginItemPlist = ~"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
~"<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n" +
~"<plist version=\"1.0\">\n" +
~"<dict>\n" +
~"\t<key>Label</key>\n" +
~"\t<string>{appid}</string>\n" +
~"\t<key>ProgramArguments</key>\n" +
~"\t<array>\n" +
~"\t\t<string>/usr/bin/open</string>\n" +
~"\t\t<string>{apppath}</string>\n" +
~"\t</array>\n" +
~"\t<key>RunAtLoad</key>\n" +
~"\t<true/>\n" +
~"\t<key>KeepAlive</key>\n" +
~"\t<false/>\n" +
~"\t<key>LimitLoadToSessionType</key>\n" +
~"\t<string>Aqua</string></dict>\n" +
~"</plist>"
; IDE Options = PureBasic 5.44 LTS (MacOS X - x64)
; EnableUnicode
; EnableXP