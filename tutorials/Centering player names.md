# Centering player names

[Difficulty: 1/5] (Copy-Paste)

Basically this tut will show you how to use the call ```GetTextExtentPoint32``` to find the width of the name and then how to incorporate it into the ```sub BltPlayerName```.

ALL CLIENTSIDE:

In ```modDeclares```, add this:

```vba
Public Declare Function GetTextExtentPoint32 Lib "gdi32" Alias "GetTextExtentPoint32A" (ByVal hDC As Long, ByVal lpszString As String, ByVal cbString As Integer, ByRef lpSize As Size) As Integer
```

> note ~ I set this to integer because I dont need to find the length of anything more than 255 chars

In ```modTypes```, add this:

```vba
Type Size
cx As Long
cy As Long
End Type
```

This creates the type Size which ```GetExtentPoint32``` needs to dump the text info

Now go to ```BltPlayerName``` and add these at top:

```vba
Dim textSize As Size
Dim textWidth As Integer
```

Under the color assigns, add this:

```vba
'measure width of name
SelectObject TexthDC, GameFont
GetTextExtentPoint32 TexthDC, GetPlayerName(Index), Len(GetPlayerName(Index)), textSize
textWidth = textSize.cx
```

This gets the size info for your name and assigns the width to textWidth

Now replace:

```vba
TextX = GetPlayerX(Index) * PIC_X + Player(Index).XOffset + Int(PIC_X / 2) - ((Len(GetPlayerName(Index)) / 2) * 8)
```

With:

```vba
TextX = (GetPlayerX(Index) * PIC_X) + (Player(Index).XOffset) + (Int(PIC_X / 2)) - (Int(textWidth / 2))
```

This changes the old x coordinate assign to center the text with the new info.

And you're done! You can apply this to NPC names, the map name, and whatever else you want to center.