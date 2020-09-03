# Config file

This is a simple config file that stores player's usernames/passwords. It also is an IP config.

> Difficulty 2/5 if copy paste  
> Difficulty 3/5 if customizing

first we have to make some ini read/write functions. That starts by declaring some stuff for ini files

at the top of ```modGeneral``` (right?) put this

```vba
'--------for INI file read/write
Private Declare Function GetPrivateProfileSection Lib "kernel32" Alias "GetPrivateProfileSectionA" (ByVal lpAppName As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Function WritePrivateProfileSection Lib "kernel32" Alias "WritePrivateProfileSectionA" (ByVal lpAppName As String, ByVal lpString As String, ByVal lpFileName As String) As Long
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
'-------------------
```

Now all the way at the bottom of modGeneral put the actual ini functions.

```vba
'reads ini string
Public Function ReadIni(FileName As String, Section As String, Key As String) As String
Dim RetVal As String * 255, v As Long
v = GetPrivateProfileString(Section, Key, "", RetVal, 255, FileName)
ReadIni = Left(RetVal, v)
End Function
 
'reads ini section
Public Function ReadIniSection(FileName As String, Section As String) As String
Dim RetVal As String * 255, v As Long
v = GetPrivateProfileSection(Section, RetVal, 255, FileName)
ReadIniSection = Left(RetVal, v - 1)
End Function
 
'writes ini
Public Sub WriteIni(FileName As String, Section As String, Key As String, Value As String)
WritePrivateProfileString Section, Key, Value, FileName
End Sub
 
'writes ini section
Public Sub WriteIniSection(FileName As String, Section As String, Value As String)
WritePrivateProfileSection Section, Value, FileName
End Sub
```

DON'T FORGET THIS PART!

Create a file called ```Config.ini``` in the client folder.

In my config file I am putting the IP, Player's Username, and Player's Password.

Mine looks like this

```vba
[GENERAL]
Username=Labmonkey
Password=nopeeking
IP=localhost
```

First lets do the ip config

find

```vba
' Winsock globals
```

Replace the entire section (2 lines) with

```vba
' Winsock globals
Public GAME_IP As String
```

Now our ip is a variable, so let us go to Sub Main to set it to what is in our config file.

Find

```vba
Call SetStatus("Loading...")
```

Under it put

```vba
' Get the ip from the file
GAME_IP = ReadIni(App.Path & "\Config.ini", "GENERAL", "Ip")
```

Now lets read the username and password from the config file.

In ```frmLogin```, in ```Sub Form_Load```, under

```vba
Me.Picture = LoadPicture(App.Path & "/gfx/interface/Menu.bmp")
```

put

```vba
txtName.Text = ReadIni(App.Path & "/Config.ini", "GENERAL", "Username")
txtPassword.Text = ReadIni(App.Path & "/Config.ini", "GENERAL", "Password")
```

Now we want to store the username and password in the ini file. We will do that when the player logs in.

still in ```frmLogin```, in ```sub lblConnect_Click```, under

```vba
Call MenuState(MENU_STATE_LOGIN)
```

put

```vba
Call WriteIni(App.Path & "/Config.ini", "GENERAL", "Username", txtName.Text)
```

Now before we put the password in, some people might not want their password stored in a file on their computer for anyone to steal. That is why we are going to make a little "remember password" checkbox. Ok so in frmLogin make a new checkbox. Call it chkRemember. I also suggest making it 13x13, and adding a label saying "Remember Password", but it all depends on how your game looks.

now under where we put

```vba
Call WriteIni(App.Path & "/Config.ini", "GENERAL", "Username", txtName.Text)
```

put

```vba
if chkRemember.Value = 1 Then Call WriteIni(App.Path & "/Config.ini", "GENERAL", "Password", txtPassword.Text) else Call WriteIni(App.Path & "/Config.ini", "GENERAL", "Password", "")
```

In ```frmLogin```, ```sub frmload```, at the bottom right before endsub up

```vba
If txtPassword.Text = "" Then chkRemember.Value = 0 Else chkRemember.Value = 1
```