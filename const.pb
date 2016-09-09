#myName = "MegaNotify"
#myVer = "2.0.0"
#myID = "info.deseven.meganotify"

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
  #menuPrefs
  #menuAbout
  #menuQuit
EndEnumeration

Enumeration resources
  #resLogo
  #resIcon
  #resIconConn
EndEnumeration

#NSWindowButtonMinimize = 1
#NSWindowButtonMaximize = 2

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
; IDE Options = PureBasic 5.42 LTS (MacOS X - x64)
; EnableUnicode
; EnableXP