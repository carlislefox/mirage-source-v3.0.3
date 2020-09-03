# Admin run speed

I make ```GM_WALK_SPEED``` and ```GM_RUN_SPEED```:

Replace:

```vba
Public Const RUN_SPEED = 8
```

with:

```vba
Public Const GM_WALK_SPEED = 8
Public Const GM_RUN_SPEED = 32
```

Replace:

```vba
If Player(Index).Moving = MOVING_RUNNING Then
If Player(Index).Access > 0 Then
Select Case GetPlayerDir(Index)
Case DIR_UP
Player(Index).YOffset = Player(Index).YOffset - GM_SPEED
Case DIR_DOWN
Player(Index).YOffset = Player(Index).YOffset + GM_SPEED
Case DIR_LEFT
Player(Index).XOffset = Player(Index).XOffset - GM_SPEED
Case DIR_RIGHT
Player(Index).XOffset = Player(Index).XOffset + GM_SPEED
End Select
Else
Select Case GetPlayerDir(Index)
Case DIR_UP
Player(Index).YOffset = Player(Index).YOffset - RUN_SPEED
Case DIR_DOWN
Player(Index).YOffset = Player(Index).YOffset + RUN_SPEED
Case DIR_LEFT
Player(Index).XOffset = Player(Index).XOffset - RUN_SPEED
Case DIR_RIGHT
Player(Index).XOffset = Player(Index).XOffset + RUN_SPEED
End Select
End If
```

with:

```vba
If Player(Index).Moving = MOVING_RUNNING Then
If Player(Index).Access > 0 Then
Select Case GetPlayerDir(Index)
Case DIR_UP
Player(Index).YOffset = Player(Index).YOffset - GM_RUN_SPEED
Case DIR_DOWN
Player(Index).YOffset = Player(Index).YOffset + GM_RUN_SPEED
Case DIR_LEFT
Player(Index).XOffset = Player(Index).XOffset - GM_RUN_SPEED
Case DIR_RIGHT
Player(Index).XOffset = Player(Index).XOffset + GM_RUN_SPEED
End Select
Else
Select Case GetPlayerDir(Index)
Case DIR_UP
Player(Index).YOffset = Player(Index).YOffset - RUN_SPEED
Case DIR_DOWN
Player(Index).YOffset = Player(Index).YOffset + RUN_SPEED
Case DIR_LEFT
Player(Index).XOffset = Player(Index).XOffset - RUN_SPEED
Case DIR_RIGHT
Player(Index).XOffset = Player(Index).XOffset + RUN_SPEED
End Select
End If
```

Find:

```vba
If Player(Index).Moving = MOVING_WALKING Then
```

Replace all off it with:

```vba
If Player(Index).Moving = MOVING_WALKING Then
If Player(Index).Access > 0 Then
Select Case GetPlayerDir(Index)
Case DIR_UP
Player(Index).YOffset = Player(Index).YOffset - GM_WALK_SPEED
Case DIR_DOWN
Player(Index).YOffset = Player(Index).YOffset + GM_WALK_SPEED
Case DIR_LEFT
Player(Index).XOffset = Player(Index).XOffset - GM_WALK_SPEED
Case DIR_RIGHT
Player(Index).XOffset = Player(Index).XOffset + GM_WALK_SPEED
End Select
Else
Select Case GetPlayerDir(Index)
Case DIR_UP
Player(Index).YOffset = Player(Index).YOffset - WALK_SPEED
Case DIR_DOWN
Player(Index).YOffset = Player(Index).YOffset + WALK_SPEED
Case DIR_LEFT
Player(Index).XOffset = Player(Index).XOffset - WALK_SPEED
Case DIR_RIGHT
Player(Index).XOffset = Player(Index).XOffset + WALK_SPEED
End Select
End If
```

Thats it, tnx!