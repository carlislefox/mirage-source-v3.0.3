# Fill button

This uses the ```Adding more tile layers``` tutorial so it includes the extra layers: mask2, mask2 animation, fringe animation etc. so if you don't have those, you will have to do a little editing to delete/change them.

make a button called ```cmdFill```

put the following code inside it:

```vba
Dim y As Long
Dim x As Long
For y = 0 To MAX_MAPY
For x = 0 To MAX_MAPX
If frmMirage.optLayers.Value = True Then
With Map.Tile(x, y)
If frmMirage.optGround.Value = True Then .Ground = EditorTileY * 7 + EditorTileX
If frmMirage.optMask.Value = True Then .Mask = EditorTileY * 7 + EditorTileX
If frmMirage.optAnim.Value = True Then .Anim = EditorTileY * 7 + EditorTileX
If frmMirage.optMask2.Value = True Then .Mask2 = EditorTileY * 7 + EditorTileX
If frmMirage.optM2Anim.Value = True Then .M2Anim = EditorTileY * 7 + EditorTileX
If frmMirage.optFringe.Value = True Then .Fringe = EditorTileY * 7 + EditorTileX
If frmMirage.optFAnim.Value = True Then .FAnim = EditorTileY * 7 + EditorTileX
If frmMirage.optFringe2.Value = True Then .Fringe2 = EditorTileY * 7 + EditorTileX
If frmMirage.optF2Anim.Value = True Then .F2Anim = EditorTileY * 7 + EditorTileX
End With
End If
Next x
Next y
```

with a little editting you can do the same for attributes

and thaTS ALLL!!!!!!