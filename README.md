# MegaNotify
[Megaplan](https://megaplan.ru/) notifications for OS X 10.8 or higher.  

### binaries
[latest release](http://deseven.info/sys/mn.dmg)  

### compiling from source
MegaNotify created with [PB](http://purebasic.com).  
Depends on [pb-osx-notifications](https://github.com/deseven/pb-osx-notifications).   
You also need [node-appdmg](https://github.com/LinusU/node-appdmg) if you want to build dmg.  
1. Obtain the latest LTS version of pbcompiler, install it to ```/Applications```.  
2. Install xcode command line tools by running ```xcode-select --install```.  
3. Clone MegaNotify repo.   
4. Clone ```pb-osx-notifications``` to neighboring directory.  
5. Run the included ```build/build.sh``` script to build the app. If you want codesigning then provide your developer ID as a first argument.  