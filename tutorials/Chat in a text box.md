# Chat in a Text Box

In ```frmMirage```:

Make a text box and name it ```txtMyTextBox``` (with out quotations)

In ```modGameLogic```:

In the game loop find:

```vba
' Blit the text they are putting in
```

And Replace with:

```vba
' Blit the text they are putting in

frmMirage.txtMyTextBox.Text = MyText
If Len(MyText) > 4 Then
frmMirage.txtMyTextBox.SelStart = Len(frmMirage.txtMyTextBox.Text) + 1
End If
```

Then Find:

```vba
Sub ResizeGUI()
```

And Replace the Sub with:

```vba
'Sub ResizeGUI()
'If frmMirage.WindowState <> vbMinimized Then
'frmMirage.txtChat.Height = Int(frmMirage.Height / Screen.TwipsPerPixelY) - frmMirage.txtChat.top - 32
'frmMirage.txtChat.Width = Int(frmMirage.Width / Screen.TwipsPerPixelX) - 8
'End If
'End Sub
```

Then Find:

```vba
Sub GameInit()
```

And Replace the whole sub with:
```vba
Sub GameInit()
frmMirage.Visible = True
frmSendGetData.Visible = False
'Call ResizeGUI
Call InitDirectX
End Sub
```