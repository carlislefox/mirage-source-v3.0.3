# Adding more tile layers
Ok, big props to shadow for this little piece of wonder, one in which I think everyone uses. LAYERS!

Aight, this is my Tutorial on how I added layer's as follows:

### Notes
* Adding more Layer's will mean that you will have to re-map what you have already done
* Easiest thing to test this is make a Copy of your Source, and Delete all the maps, then try
* I Say replace alot, you can just add the stuff that isn't there but if you stuff up, don't ask me for help!

### What layers are we adding
> Ground 'already in source code  
> Mask1 'already in source code  
> Mask1 Animation 'already in source code  
> Mask2  
> Mask2 Animation  
> Fringe1 'already in source code  
> Fringe1 Animation  
> Fringe2  
> Fringe2 Animation  

Ok, now open the client project (```Mirage.vbp```)

Open the Module called ```modTypes``` and search for

```vba
Type TileRec
Ground As Integer
Mask As Integer
Anim As Integer
Fringe As Integer
Type As Byte
Data1 As Integer
Data2 As Integer
Data3 As Integer
End Type
```

Replace with

```vba
Type TileRec
Ground As Integer
Mask As Integer
Anim As Integer
Mask2 As Integer
M2Anim As Integer
Fringe As Integer
FAnim As Integer
Fringe2 As Integer
F2Anim As Integer
Type As Byte
Data1 As Integer
Data2 As Integer
Data3 As Integer
End Type
```

So you can see here that:

* 'Mask2 As Integer' will hold the Mask2 Layer  
* 'M2Anim As Integer' will hold the Mask2 Animation Layer  
* 'FAnim As Integer' will hold the Fringe1 Animation Layer  
* 'Fringe2 As Integer' will hold the Fringe2 Layer  
* 'F2Anim As Integer' will hold the Fringe2 Animation Layer  

Now search for (still in ```modTypes```)

```vba
Sub ClearMap()
```

In that sub Replace

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Ground = 0
Map.Tile(x, y).Mask = 0
Map.Tile(x, y).Anim = 0
Map.Tile(x, y).Fringe = 0
Map.Tile(x, y).Type = 0
Map.Tile(x, y).Data1 = 0
Map.Tile(x, y).Data2 = 0
Map.Tile(x, y).Data3 = 0
Next x
Next y
```

With

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Ground = 0
Map.Tile(x, y).Mask = 0
Map.Tile(x, y).Anim = 0
Map.Tile(x, y).Mask2 = 0
Map.Tile(x, y).M2Anim = 0
Map.Tile(x, y).Fringe = 0
Map.Tile(x, y).FAnim = 0
Map.Tile(x, y).Fringe2 = 0
Map.Tile(x, y).F2Anim = 0
Map.Tile(x, y).Type = 0
Map.Tile(x, y).Data1 = 0
Map.Tile(x, y).Data2 = 0
Map.Tile(x, y).Data3 = 0
Next x
Next y
```

Ok that is all in the ```modTypes```, now onto ```modGameLogic```

Search for

```vba
Sub BltTile(ByVal x As Long, ByVal y As Long)
```

in that sub Replace

```vba
Dim Ground As Long
Dim Anim1 As Long
Dim Anim2 As Long
```

With

```vba
Dim Ground As Long
Dim Anim1 As Long
Dim Anim2 As Long
Dim Mask2 As Long
Dim M2Anim As Long
```

Replace

```vba
Ground = Map.Tile(x, y).Ground
Anim1 = Map.Tile(x, y).Mask
Anim2 = Map.Tile(x, y).Anim
```

With

```vba
Ground = Map.Tile(x, y).Ground
Anim1 = Map.Tile(x, y).Mask
Anim2 = Map.Tile(x, y).Anim
Mask2 = Map.Tile(x, y).Mask2
M2Anim = Map.Tile(x, y).M2Anim
```

Replace

```vba
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT)

If (MapAnim = 0) Or (Anim2 <= 0) Then
' Is there an animation tile to plot?
If Anim1 > 0 And TempTile(x, y).DoorOpen = NO Then
rec.Top = Int(Anim1 / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (Anim1 - Int(Anim1 / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If
Else
' Is there a second animation tile to plot?
If Anim2 > 0 Then
rec.Top = Int(Anim2 / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (Anim2 - Int(Anim2 / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If
End If
```

With

```vba
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT)

If (MapAnim = 0) Or (Anim2 <= 0) Then
' Is there an animation tile to plot?
If Anim1 > 0 And TempTile(x, y).DoorOpen = NO Then
rec.Top = Int(Anim1 / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (Anim1 - Int(Anim1 / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If
Else
' Is there a second animation tile to plot?
If Anim2 > 0 Then
rec.Top = Int(Anim2 / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (Anim2 - Int(Anim2 / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If
End If

If (MapAnim = 0) Or (M2Anim <= 0) Then
' Is there an animation tile to plot?
If Mask2 > 0 Then
rec.Top = Int(Mask2 / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (Mask2 - Int(Mask2 / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If
Else
' Is there a second animation tile to plot?
If M2Anim > 0 Then
rec.Top = Int(M2Anim / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (M2Anim - Int(M2Anim / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If
End If
```

Now search for

```vba
Sub BltFringeTile(ByVal x As Long, ByVal y As Long)
```

Replace

```vba
Dim Fringe As Long
```

With

```vba
Dim Fringe As Long
Dim FAnim As Long
Dim Fringe2 As Long
Dim F2Anim As Long
```

Replace

```vba
Fringe = Map.Tile(x, y).Fringe
```

with

```vba
Fringe = Map.Tile(x, y).Fringe
FAnim = Map.Tile(x, y).FAnim
Fringe2 = Map.Tile(x, y).Fringe2
F2Anim = Map.Tile(x, y).F2Anim
```

Replace

```vba
If Fringe > 0 Then
rec.Top = Int(Fringe / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (Fringe - Int(Fringe / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If
```

With

```vba
If (MapAnim = 0) Or (FAnim <= 0) Then
' Is there an animation tile to plot?

If Fringe > 0 Then
rec.Top = Int(Fringe / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (Fringe - Int(Fringe / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If

Else

If FAnim > 0 Then
rec.Top = Int(FAnim / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (FAnim - Int(FAnim / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If

End If

If (MapAnim = 0) Or (F2Anim <= 0) Then
' Is there an animation tile to plot?

If Fringe2 > 0 Then
rec.Top = Int(Fringe2 / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (Fringe2 - Int(Fringe2 / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If

Else

If F2Anim > 0 Then
rec.Top = Int(F2Anim / 7) * PIC_Y
rec.Bottom = rec.Top + PIC_Y
rec.Left = (F2Anim - Int(F2Anim / 7) * 7) * PIC_X
rec.Right = rec.Left + PIC_X
'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End If

End If
```

Now Search for

```vba
Public Sub EditorMouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
```

Replace

```vba
If frmMirage.optGround.Value = True Then .Ground = EditorTileY * 7 + EditorTileX
If frmMirage.optMask.Value = True Then .Mask = EditorTileY * 7 + EditorTileX
If frmMirage.optAnim.Value = True Then .Anim = EditorTileY * 7 + EditorTileX
If frmMirage.optFringe.Value = True Then .Fringe = EditorTileY * 7 + EditorTileX
```

With

```vba
If frmMirage.optGround.Value = True Then .Ground = EditorTileY * 7 + EditorTileX
If frmMirage.optMask.Value = True Then .Mask = EditorTileY * 7 + EditorTileX
If frmMirage.optAnim.Value = True Then .Anim = EditorTileY * 7 + EditorTileX
If frmMirage.optMask2.Value = True Then .Mask2 = EditorTileY * 7 + EditorTileX
If frmMirage.optM2Anim.Value = True Then .M2Anim = EditorTileY * 7 + EditorTileX
If frmMirage.optFringe.Value = True Then .Fringe = EditorTileY * 7 + EditorTileX
If frmMirage.optFAnim.Value = True Then .FAnim = EditorTileY * 7 + EditorTileX
If frmMirage.optFringe2.Value = True Then .Fringe2 = EditorTileY * 7 + EditorTileX
If frmMirage.optF2Anim.Value = True Then .F2Anim = EditorTileY * 7 + EditorTileX
```

Replace

```vba
If frmMirage.optGround.Value = True Then .Ground = 0
If frmMirage.optMask.Value = True Then .Mask = 0
If frmMirage.optAnim.Value = True Then .Anim = 0
If frmMirage.optFringe.Value = True Then .Fringe = 0
```

With

```vba
If frmMirage.optGround.Value = True Then .Ground = 0
If frmMirage.optMask.Value = True Then .Mask = 0
If frmMirage.optAnim.Value = True Then .Anim = 0
If frmMirage.optMask2.Value = True Then .Mask2 = 0
If frmMirage.optM2Anim.Value = True Then .M2Anim = 0
If frmMirage.optFringe.Value = True Then .Fringe = 0
If frmMirage.optFAnim.Value = True Then .FAnim = 0
If frmMirage.optFringe2.Value = True Then .Fringe2 = 0
If frmMirage.optF2Anim.Value = True Then .F2Anim = 0
```

Now Search for

```vba
Public Sub EditorClearLayer()
```

Replace

```vba
' Ground layer
If frmMirage.optGround.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the ground layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Ground = 0
Next x
Next y
End If
End If

' Mask layer
If frmMirage.optMask.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the mask layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Mask = 0
Next x
Next y
End If
End If

' Mask Animation layer
If frmMirage.optAnim.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the animation layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Anim = 0
Next x
Next y
End If
End If

' Fringe layer
If frmMirage.optFringe.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the fringe layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Fringe = 0
Next x
Next y
End If
End If
```

With

```vba
' Ground layer
If frmMirage.optGround.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the ground layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Ground = 0
Next x
Next y
End If
End If

' Mask layer
If frmMirage.optMask.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the mask layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Mask = 0
Next x
Next y
End If
End If

' Mask Animation layer
If frmMirage.optAnim.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the animation layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Anim = 0
Next x
Next y
End If
End If

' Mask 2 layer
If frmMirage.optMask2.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the mask 2 layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Mask2 = 0
Next x
Next y
End If
End If

' Mask 2 Animation layer
If frmMirage.optM2Anim.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the mask 2 animation layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).M2Anim = 0
Next x
Next y
End If
End If

' Fringe layer
If frmMirage.optFringe.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the fringe layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Fringe = 0
Next x
Next y
End If
End If

' Fringe Animation layer
If frmMirage.optFAnim.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the fringe animation layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).FAnim = 0
Next x
Next y
End If
End If

' Fringe 2 layer
If frmMirage.optFringe2.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the fringe 2 layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).Fringe2 = 0
Next x
Next y
End If
End If

' Fringe 2 Animation layer
If frmMirage.optF2Anim.Value = True Then
YesNo = MsgBox("Are you sure you wish to clear the fringe 2 animation layer?", vbYesNo, GAME_NAME)

If YesNo = vbYes Then
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map.Tile(x, y).F2Anim = 0
Next x
Next y
End If
End If
```

Ok that is all in the ```modGameLogic```, now onto ```modClientTCP```

Search for

```vba
If LCase(Parse(0)) = "mapdata" Then
```

Replace

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
SaveMap.Tile(x, y).Ground = Val(Parse(n))
SaveMap.Tile(x, y).Mask = Val(Parse(n + 1))
SaveMap.Tile(x, y).Anim = Val(Parse(n + 2))
SaveMap.Tile(x, y).Fringe = Val(Parse(n + 3))
SaveMap.Tile(x, y).Type = Val(Parse(n + 4))
SaveMap.Tile(x, y).Data1 = Val(Parse(n + 5))
SaveMap.Tile(x, y).Data2 = Val(Parse(n + 6))
SaveMap.Tile(x, y).Data3 = Val(Parse(n + 7))

n = n + 8
Next x
Next y
```

With

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
SaveMap.Tile(x, y).Ground = Val(Parse(n))
SaveMap.Tile(x, y).Mask = Val(Parse(n + 1))
SaveMap.Tile(x, y).Anim = Val(Parse(n + 2))
SaveMap.Tile(x, y).Mask2 = Val(Parse(n + 3))
SaveMap.Tile(x, y).M2Anim = Val(Parse(n + 4))
SaveMap.Tile(x, y).Fringe = Val(Parse(n + 5))
SaveMap.Tile(x, y).FAnim = Val(Parse(n + 6))
SaveMap.Tile(x, y).Fringe2 = Val(Parse(n + 7))
SaveMap.Tile(x, y).F2Anim = Val(Parse(n + Cool)
SaveMap.Tile(x, y).Type = Val(Parse(n + 9))
SaveMap.Tile(x, y).Data1 = Val(Parse(n + 10))
SaveMap.Tile(x, y).Data2 = Val(Parse(n + 11))
SaveMap.Tile(x, y).Data3 = Val(Parse(n + 12))

n = n + 13
Next x
Next y
```

Now Search for

```vba
Sub SendMap()
```

Replace

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
With Map.Tile(x, y)
Packet = Packet & .Ground & SEP_CHAR & .Mask & SEP_CHAR & .Anim & SEP_CHAR & .Fringe & SEP_CHAR & .Type & SEP_CHAR & .Data1 & SEP_CHAR & .Data2 & SEP_CHAR & .Data3 & SEP_CHAR
End With
Next x
Next y
```

With

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
With Map.Tile(x, y)
Packet = Packet & .Ground & SEP_CHAR & .Mask & SEP_CHAR & .Anim & SEP_CHAR & .Mask2 & SEP_CHAR & .M2Anim & SEP_CHAR & .Fringe & SEP_CHAR & .FAnim & SEP_CHAR & .Fringe2 & SEP_CHAR & .F2Anim & SEP_CHAR & .Type & SEP_CHAR & .Data1 & SEP_CHAR & .Data2 & SEP_CHAR & .Data3 & SEP_CHAR
End With
Next x
Next y
```

That's all the Code for in the Client, Now for the hard part, Adding 'Option Buttons' to the Map Editor

Ok, Open the form called ```frmMirage```

Click on the Layers Frame and make it vertically longer so it has room for extra cmd options. Drag the 'Clear Button' down to the bottom, click the OptionButton and add a Few OptionButtons so there are enough for all of the new layers.  Now to name them all, alright, they go like this:

* Ground 's name is 'optGround' (Should already be done)
* Mask 's name is 'optMask' (Should already be done)
* Animation 's (first one, Animates Mask1) name is 'optAnim' (Should already be done)
* Mask2 's name is 'optMask2'
* Animation 's name is 'optM2Anim'
* Fringe 's name is 'optFringe' (Should already be done)
* Animation 's name is 'optFAnim'
* Fringe2 's name is 'optFringe2'
* Animation 's name is 'optF2Anim'

Thats all there is to do in the Client! Congratulations for getting this far, now onto the Server!

Open the Server project (```Server.vbp```) and open the Module called ```modTypes```.

Search for

```vba
Type TileRec
Ground As Integer
Mask As Integer
Anim As Integer
Fringe As Integer
Type As Byte
Data1 As Integer
Data2 As Integer
Data3 As Integer
End Type
```

Replace with

```vba
Type TileRec
Ground As Integer
Mask As Integer
Anim As Integer
Mask2 As Integer
M2Anim As Integer
Fringe As Integer
FAnim As Integer
Fringe2 As Integer
F2Anim As Integer
Type As Byte
Data1 As Integer
Data2 As Integer
Data3 As Integer
End Type
```

Now search for

```vba
Sub ClearMap()
```

In that sub Replace

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map(MapNum).Tile(x, y).Ground = 0
Map(MapNum).Tile(x, y).Mask = 0
Map(MapNum).Tile(x, y).Anim = 0
Map(MapNum).Tile(x, y).Fringe = 0
Map(MapNum).Tile(x, y).Type = 0
Map(MapNum).Tile(x, y).Data1 = 0
Map(MapNum).Tile(x, y).Data2 = 0
Map(MapNum).Tile(x, y).Data3 = 0
Next x
Next y
```

With

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map(MapNum).Tile(x, y).Ground = 0
Map(MapNum).Tile(x, y).Mask = 0
Map(MapNum).Tile(x, y).Anim = 0
Map(MapNum).Tile(x, y).Mask2 = 0
Map(MapNum).Tile(x, y).M2Anim = 0
Map(MapNum).Tile(x, y).Fringe = 0
Map(MapNum).Tile(x, y).FAnim = 0
Map(MapNum).Tile(x, y).Fringe2 = 0
Map(MapNum).Tile(x, y).F2Anim = 0
Map(MapNum).Tile(x, y).Type = 0
Map(MapNum).Tile(x, y).Data1 = 0
Map(MapNum).Tile(x, y).Data2 = 0
Map(MapNum).Tile(x, y).Data3 = 0
Next x
Next y
```

Done with ```modTypes```, now onto ```modServerTCP```

Seach for

```vba
If LCase(Parse(0)) = "mapdata" Then
```

Replace

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map(MapNum).Tile(x, y).Ground = Val(Parse(n))
Map(MapNum).Tile(x, y).Mask = Val(Parse(n + 1))
Map(MapNum).Tile(x, y).Anim = Val(Parse(n + 2))
Map(MapNum).Tile(x, y).Fringe = Val(Parse(n + 3))
Map(MapNum).Tile(x, y).Type = Val(Parse(n + 4))
Map(MapNum).Tile(x, y).Data1 = Val(Parse(n + 5))
Map(MapNum).Tile(x, y).Data2 = Val(Parse(n + 6))
Map(MapNum).Tile(x, y).Data3 = Val(Parse(n + 7))

n = n + 8
Next x
Next y
```

With

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
Map(MapNum).Tile(x, y).Ground = Val(Parse(n))
Map(MapNum).Tile(x, y).Mask = Val(Parse(n + 1))
Map(MapNum).Tile(x, y).Anim = Val(Parse(n + 2))
Map(MapNum).Tile(x, y).Mask2 = Val(Parse(n + 3))
Map(MapNum).Tile(x, y).M2Anim = Val(Parse(n + 4))
Map(MapNum).Tile(x, y).Fringe = Val(Parse(n + 5))
Map(MapNum).Tile(x, y).FAnim = Val(Parse(n + 6))
Map(MapNum).Tile(x, y).Fringe2 = Val(Parse(n + 7))
Map(MapNum).Tile(x, y).F2Anim = Val(Parse(n + Cool)
Map(MapNum).Tile(x, y).Type = Val(Parse(n + 9))
Map(MapNum).Tile(x, y).Data1 = Val(Parse(n + 10))
Map(MapNum).Tile(x, y).Data2 = Val(Parse(n + 11))
Map(MapNum).Tile(x, y).Data3 = Val(Parse(n + 12))

n = n + 13
Next x
Next y
```

Search for

```vba
Sub SendMap(ByVal Index As Long, ByVal MapNum As Long)
```

Replace

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
With Map(MapNum).Tile(x, y)
Packet = Packet & .Ground & SEP_CHAR & .Mask & SEP_CHAR & .Anim & SEP_CHAR & .Fringe & SEP_CHAR & .Type & SEP_CHAR & .Data1 & SEP_CHAR & .Data2 & SEP_CHAR & .Data3 & SEP_CHAR
End With
Next x
Next y
```

With

```vba
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
With Map(MapNum).Tile(x, y)
Packet = Packet & .Ground & SEP_CHAR & .Mask & SEP_CHAR & .Anim & SEP_CHAR & .Mask2 & SEP_CHAR & .M2Anim & SEP_CHAR & .Fringe & SEP_CHAR & .FAnim & SEP_CHAR & .Fringe2 & SEP_CHAR & .F2Anim & SEP_CHAR & .Type & SEP_CHAR & .Data1 & SEP_CHAR & .Data2 & SEP_CHAR & .Data3 & SEP_CHAR
End With
Next x
Next y
```

And you are all done!