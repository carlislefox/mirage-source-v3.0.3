# Display guild name

Starting code, just blt's onscreen. With some simple coding (or advance, depending on severity of guild system)

In ```modTypes```, add ```Guild as Long```

then under ```Function GetPlayerName``` add

```vba
Function GetPlayerGuildName(ByVal Index As Long) As String
GetPlayerGuildName = Trim(Player(Index).Guild)
End Function
```

In ```modGamelogic``` find,

```vba
' Lock the backbuffer so we can draw text and names
```

then a little bit below that find

```vba
Call BltPlayerName(i)
```

Directly under that put

```vba
If GetPlayerGuildName(i) = 0 Then

ElseIf GetPlayerGuildName(i) >= 1 Then
Call BltPlayerGuildName(i)
Else

End If
```

Then find Sub ```BltPlayerName```

under that sub add this sub

```vba
Sub BltPlayerGuildName(ByVal Index As Long)
Dim TextX As Long
Dim TextY As Long
Dim Color As Long

' Check access level
If GetPlayerPK(Index) = NO Then
Select Case GetPlayerAccess(Index)
Case 0
If GetPlayerSTR(Index) > 0 Then
Color = QBColor(Yellow)
Else
Color = QBColor(Yellow)
End If

Case 1
Color = QBColor(Yellow)
Case 2
Color = QBColor(Yellow)
Case 3
Color = QBColor(Yellow)
Case 4
Color = QBColor(Yellow)
End Select
Else
Color = QBColor(BrightRed)
End If

' Draw name
TextX = GetPlayerX(Index) * PIC_X + Player(Index).XOffset + Int(PIC_X / 2) - ((Len(GetPlayerGuildName(Index)) / 2) * 8)
TextY = GetPlayerY(Index) * PIC_Y + Player(Index).YOffset - Int(PIC_Y / 2) - 16
Call DrawText(TexthDC, TextX, TextY, GetPlayerGuildName(Index), Color)
End Sub
```