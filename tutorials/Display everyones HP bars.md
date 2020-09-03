# Display everyone's HP bars

PlayerS Hp/Mp Bars!

Ok...I got enough of peoples inputs to know this works!!! If you want to add other peoples MP/SP to the bars then it shouldnt be too hard, just follow what was done for the hp Razz

Client Side

In ```modGameLogic``` under:

```vba
' Blit out tile layer fringe
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Call BltFringeTile(x, y)
Next x
Next y
```

add:

```vba
' Blit players bar
Dim GSD As Long
If GetTickCount > GSD + 1000 Then
Call SendData("playershpmp" & SEP_CHAR & END_CHAR)
GSD = GetTickCount
End If

For i = 1 To MAX_PLAYERS
If IsPlaying(i) And GetPlayerMap(i) = GetPlayerMap(MyIndex) Then
Call BltPlayerBars(i)
End If
Next i
```

Now at the very bottom add:

```vba
Sub BltPlayerBars(ByVal Index As Long)
Dim x As Long, y As Long
x = GetPlayerX(Index) * PIC_X + Player(Index).XOffset
y = GetPlayerY(Index) * PIC_Y + Player(Index).YOffset - 4
If Player(Index).HP = 0 Then Exit Sub

Call DD_BackBuffer.SetFillColor(RGB(255, 0, 0))
Call DD_BackBuffer.DrawBox(x, y + 32, x + 32, y + 36)

Call DD_BackBuffer.SetFillColor(RGB(0, 255, 0))
Call DD_BackBuffer.DrawBox(x, y + 32, x + ((Player(Index).HP / 100) / (Player(Index).MaxHP / 100) * 32), y + 36)

If Index = MyIndex Then
Call DD_BackBuffer.SetFillColor(RGB(255, 0, 0))
Call DD_BackBuffer.DrawBox(x, y + 35, x + 32, y + 39)

'draws MP for you
Call DD_BackBuffer.SetFillColor(RGB(0, 0, 255))
Call DD_BackBuffer.DrawBox(x, y + 35, x + ((Player(MyIndex).MP / 100) / (Player(MyIndex).MaxMP / 100) * 32), y + 39)
End If
End Sub
```

now go to ```modClientTCP``` and anywhere you like in the ```Sub HandleData``` add:

```vba
' :::::::::::::::::::::::
' :: Get players stats ::
' :::::::::::::::::::::::
If LCase(Parse(0)) = "playershpmp" Then
n = 1

For i = 1 To MAX_PLAYERS
Player(i).HP = Val(Parse(n))
Player(i).MaxHP = Val(Parse(n + 1))

n = n + 2
Next i

Exit Sub
End If
```

Done for Client Side...*Hopefully*... Now Server Side

in ```modServerTCP``` anywhere in the ```Sub HandleData``` add:

```vba
' :::::::::::::::::::::::
' :: Get players stats ::
' :::::::::::::::::::::::
Dim Packet As String
If LCase(Parse(0)) = "playershpmp" Then
Packet = "playershpmp" & SEP_CHAR
For i = 1 To MAX_PLAYERS
Packet = Packet & GetPlayerHP(i) & SEP_CHAR & GetPlayerMaxHP(i) & SEP_CHAR
Next i
Packet = Packet & END_CHAR
Call SendDataTo(Index, Packet)
Exit Sub
End If
```

that should be it!

> [edit] I got rid of blitting mp for other players, it only blits for you Very Happy

### Additional tutorial content recovered

I am unsure the relevance of this information however it was present in the archive so it is included here for posterity:

```vba
Sub BltPlayerBars(ByVal Index As Long)
Dim x As Long, y As Long
x = GetPlayerX(Index) * PIC_X + Player(Index).XOffset
y = GetPlayerY(Index) * PIC_Y + Player(Index).YOffset - 4
If Player(Index).HP = 0 Then Exit Sub

Call DD_BackBuffer.SetFillColor(RGB(255, 0, 0))
Call DD_BackBuffer.DrawBox(x, y + 32, x + 32, y + 36)

Call DD_BackBuffer.SetFillColor(RGB(0, 255, 0))
Call DD_BackBuffer.DrawBox(x, y + 32, x + ((Player(Index).HP / 100) / (Player(Index).MaxHP / 100) * 32), y + 36)

If Index = MyIndex Then
Call DD_BackBuffer.SetFillColor(RGB(255, 0, 0))
Call DD_BackBuffer.DrawBox(x, y + 35, x + 32, y + 39)

'draws MP for you
Call DD_BackBuffer.SetFillColor(RGB(0, 0, 255))
Call DD_BackBuffer.DrawBox(x, y + 35, x + ((Player(MyIndex).MP / 100) / (Player(MyIndex).MaxMP / 100) * 32), y + 39)
End If
End Sub
```