# The Mirage Source v3.0.3
This repository contains the original Visual Basic 6 open source code for Mirage Online. The source code here is provided as is and lives here for reference only.

### Working from source
Mirage Online was written in Visual basic 6, which means in order to build, debug and release the code you will need to get hold of Visual Studio 6, which is an old and very dated microsoft IDE build specifically for VB6 developers. Visual Studio 6 is:
 
* No longer available anywhere, digitally or physically
* No longer supported in any way by microsoft
* Abandonware
* The only way to work with this source code

For these reasons I am comfortable hosting a mirror to a version I know works:

http://www.miragerealms.co.uk/downloads/visual-studio-6.rar

Getting this to work on Windows 10 can be... an ordeal. Fortunately someone has built a companion tool specifically for installing VS6 on Windows 10 with minimal effort, so if you want to relive the glory days you can get a free companion installer that will take all the pain from getting it running on Windows 10 on this rather dodgey looking website here:

http://nuke.vbcorner.net/Articles/VB60/VisualStudio6Installer/tabid/93/language/en-US/Default.aspx

### Distributing your game to players
As this is a Visual Basic 6 project, in order for players to be able to run the client on modern windows machines they will need to have the VB6 runtime libs installed. Fortunately, a developer by the name of Aydan has put together a small one-click installer that makes this a non-issue - you can find the executable in the ```tools``` folder.

### Tutorials
The Mirage Source fostered a large community of amateur developers who all banded together to expand upon the original source code, one of the biproducts of this was a large number of tutorials shared on the community forums that explained how to add certain features or change things in certain ways.

A lot of this unfortunately has been lost to the sands of time, however all of the historic tutorials to come out of the community that I can find have been converted to markdown and can be found in the ```tutorials``` folder. GitHub renders markdown files really well so they can be browsed easily online :)

If you have some tutorials stashed away somewhere from back in the day that are missing from the repository, please convert them using the existing ones as a template and submit a pull request to get them preserved here!