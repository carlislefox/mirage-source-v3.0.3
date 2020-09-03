# Add bug report

Since nothing is perfect, why not let the players let YOU know what ís wrong with what and so on and so forth.

Lets begin with the Client, you will obviously need some code there.

Open up ```modGameLogic``` and locate

```vba
' Kicking a player 
```

Right under that piece of code for kicking a player, add the following piece of code.

```vba
' Report a bug
If LCase(Mid(MyText, 1, 4)) = "/bug" Then
If Len(MyText) &gt; 5 Then
MyText = Mid(MyText, 6, Len(MyText) - 5)
Call SendBReport(MyText)
End If
MyText = ""
Exit Sub
End If   
```

And now, we open modClientTCP and scroll all way down and add the following code:

```vba
' bugreport
Sub SendBReport(ByVal Text As String)
Dim Packet As String

Packet = "BUGREPORT" &amp; SEP_CHAR &amp; Text &amp; SEP_CHAR &amp; END_CHAR
Call SendData(Packet)
End Sub   
```

Alright, that should do it, save, compile and exit. Now, open the Server project and open ```modDatabase```, right under ```PLAYER_LOG```, add

```vba
Public Const BUG_REPORTS = "bugreports.txt"   
```

Note that you MAY have to change the string for that constant ;P

Anyhow, lets move on and open ```modServerTCP``` and find Location Packet. Just under that piece of code there, add the following:

```vba
' ::::::::::::::::::::::::
' ::  Bugreport packet  ::
' ::::::::::::::::::::::::
If LCase(Parse(0)) = "bugreport" Then

Call PlayerMsg(Index, "Thank you for reporting the bug.", Yellow)
Call AddLog(GetPlayerName(Index) &amp; " reported: " &amp; Parse(1), "bugreports.txt")

Exit Sub
End If
```