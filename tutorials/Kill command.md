# Kill command

Made by me a while back.. I posted it a long time ago dunno if it got deleted or what but i found it on my hard drive so i figured id repost it. This lets admins kill a player by typing /kill (playername). They lose exp and all of their items their wearing and are sent back to the start x y and map.

client

```vba
If LCase(Mid(MyText, 1, 5)) = "/kill" Then
If Len(MyText) > 6 Then
MyText = Mid(MyText, 6, Len(MyText) - 5)
Call KillPlayer(MyText) ' Calls the kill player sub
End If
MyText = ""
Exit Sub
End If
```

make new sub

```vba
Sub KillPlayer(ByVal Name As String)
Dim Packet As String
Packet = "KILLTHEPLAYER" & SEP_CHAR & Name & SEP_CHAR & END_CHAR
Call SendData(Packet)
End Sub
```

server

```vba
' ::::::::::::::::::::::::
' :: Kill Player Packet ::
' ::::::::::::::::::::::::
Dim Exp As Long
If LCase(Parse(0)) = "killtheplayer" Then
' Prevent hacking
If GetPlayerAccess(Index) < ADMIN_MAPPER Then
Call HackingAttempt(Index, "Admin Cloning")
Exit Sub
End If

n = FindPlayer(Parse(1))

If n <> Index Then
If n > 0 Then
'Sends the message
Call PlayerMsg(n, "The Gods have decided to kick your ass by killing you..", BrightRed)
Call GlobalMsg(GetPlayerName(n) & " has been killed.", BrightRed)
'Determines EXP Loss
Exp = Int(GetPlayerExp(n) / 10)
' Make sure we dont get less then 0
If Exp < 0 Then
Exp = 0
End If
If Exp = 0 Then
Call PlayerMsg(n, "You lost no experience points.", BrightRed)
Call PlayerMsg(Index, "You received no experience points from that weak insignificant player.", BrightBlue)
Else
Call SetPlayerExp(n, GetPlayerExp(n) - Exp)
Call PlayerMsg(n, "You lost " & Exp & " experience points.", BrightRed)
Call SetPlayerExp(Index, GetPlayerExp(Index) + Exp)
Call PlayerMsg(Index, "You got " & Exp & " experience points for killing " & GetPlayerName(n) & ".", BrightBlue)
End If
'Drop their Items
If GetPlayerWeaponSlot(n) > 0 Then
Call PlayerMapDropItem(n, GetPlayerWeaponSlot(n), 0)
End If
If GetPlayerArmorSlot(n) > 0 Then
Call PlayerMapDropItem(n, GetPlayerArmorSlot(n), 0)
End If
If GetPlayerHelmetSlot(n) > 0 Then
Call PlayerMapDropItem(n, GetPlayerHelmetSlot(n), 0)
End If
If GetPlayerShieldSlot(n) > 0 Then
Call PlayerMapDropItem(n, GetPlayerShieldSlot(n), 0)
End If
'Warp to Start
Call PlayerWarp(n, START_MAP, START_X, START_Y)
Call SetPlayerPK(Index, NO)
Else
Call PlayerMsg(Index, "Player is not online.", White)
End If
Else
Call PlayerMsg(Index, "You cannot kill yourself!", White)
End If

Exit Sub
End If
```