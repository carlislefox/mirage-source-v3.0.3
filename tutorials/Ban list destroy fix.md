# Ban list destroy fix

Only server side, open ```modServerTCP```, find:

```vba
' :: Ban destroy packet ::
```

Replace:

```vba
Call Kill(App.Path & "\banlist.txt")
```

with:

```vba
Call ZeroBanList
```

Now, on ```modDatabase``` add anywhere this sub:

```vba
Sub ZeroBanList()
Dim FileName As String
Dim f As Long, i As Long

FileName = App.Path & "\banlist.txt"
Call Kill(FileName)
' Make sure the file exists
If Not FileExist("banlist.txt") Then
f = FreeFile
Open FileName For Output As #f
Close #f
End If

f = FreeFile
Open FileName For Append As #f
Print #f, "0.0.0.,abc"
Close #f
End Sub
```

Thats it, =D

TUT By Dragoons Master