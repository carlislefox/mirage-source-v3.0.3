# IP Configuration

Only Client Side:

* 1st make a new form and name it frmIpconfig
* Make 2 txtBoxes named txtIP and txtPort
* Make 2 picBoxes named picConfirm and picCancel

In the code put all this:

```vba
Option Explicit

Private Sub Form_Load()
Dim FileName As String
FileName = App.Path & "\config.ini"
txtIP = ReadINI("IPCONFIG", "IP", FileName)
txtPort = ReadINI("IPCONFIG", "PORT", FileName)
End Sub

Private Sub picCancel_Click()
frmMainMenu.Visible = True
frmIpconfig.Visible = False
End Sub

Private Sub picConfirm_Click()
Dim IP, Port As String
Dim fErr As Integer
Dim Texto As String

IP = txtIP
Port = Val(txtPort)

fErr = 0
If fErr = 0 And Len(Trim(IP)) = 0 Then
fErr = 1
Call MsgBox("Inform a correct IP.", vbCritical, GAME_NAME)
Exit Sub
End If
If fErr = 0 And Port <= 0 Then
fErr = 1
Call MsgBox("Inform a correct Port.", vbCritical, GAME_NAME)
Exit Sub
End If
If fErr = 0 Then
' Rec IP and Port
Call WriteINI("IPCONFIG", "IP", txtIP.Text, (App.Path & "\config.ini"))
Call WriteINI("IPCONFIG", "PORT", txtPort.Text, (App.Path & "\config.ini"))
End If
frmMainMenu.Visible = True
frmIpconfig.Visible = False
End Sub
```

Now lets set the Client to connect to the ip and port in the ```config.ini```

In ```modClientTCP```, find:

```Sub TcpInit()```

Replace it ALL with:

```vba
Sub TcpInit()
SEP_CHAR = Chr(0)
END_CHAR = Chr(237)
PlayerBuffer = ""

Dim IP As String
Dim Port As String
Dim FileName As String
FileName = App.Path & "\config.ini"
If FileExist("config.ini") Then
IP = ReadINI("IPCONFIG", "IP", FileName)
Port = ReadINI("IPCONFIG", "PORT", FileName)
Else
IP = "0.0.0.0"
Port = 0
Call WriteINI("IPCONFIG", "IP", IP, (App.Path & "\config.ini"))
Call WriteINI("IPCONFIG", "PORT", Port, (App.Path & "\config.ini"))
End If
frmMirage.Socket.Close
frmMirage.Socket.RemoteHost = IP
frmMirage.Socket.RemotePort = Val(Port)
End Sub
```

In ```frmMainMenu``` add a ```picBox``` named ```picIpConfig``` and add this sub:

```vba
Private Sub picIpConfig_Click()
frmIpconfig.Visible = True
Me.Visible = False
End Sub
```

This is all, =D