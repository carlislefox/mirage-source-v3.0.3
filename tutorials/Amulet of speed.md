# Amulet of speed

ok, ever want to make something REALLY special? well here is a small idea of how you can change around some of the variables and such in mirage to get GREAT end effects....

here is the "Amulet of Speed" item....

now, in ```modGameLogic```, up in the declarations, change

```vba
' Speed moving vars
Public Const WALK_SPEED = 4
Public Const RUN_SPEED = 8
```

to

```vba
' Speed moving vars
Public WALK_SPEED As Integer
Public RUN_SPEED As Integer
```

and then in ```modGameLogic```, find ```UpdateInventory```, and change it from what you have to this...

```vba
Public Sub UpdateInventory()
Dim i As Long

frmMirage.lstInv.Clear

' Show the inventory
For i = 1 To MAX_INV
If GetPlayerInvItemNum(MyIndex, i) > 0 And GetPlayerInvItemNum(MyIndex, i) <= MAX_ITEMS Then
If Item(GetPlayerInvItemNum(MyIndex, i)).Type = ITEM_TYPE_CURRENCY Then
frmMirage.lstInv.AddItem i & ": " & Trim(Item(GetPlayerInvItemNum(MyIndex, i)).Name) & " (" & GetPlayerInvItemValue(MyIndex, i) & ")"
Else
' Check if this item is being worn
If GetPlayerWeaponSlot(MyIndex) = i Or GetPlayerArmorSlot(MyIndex) = i Or GetPlayerHelmetSlot(MyIndex) = i Or GetPlayerShieldSlot(MyIndex) = i Then
frmMirage.lstInv.AddItem i & ": " & Trim(Item(GetPlayerInvItemNum(MyIndex, i)).Name) & " (worn)"
Else
frmMirage.lstInv.AddItem i & ": " & Trim(Item(GetPlayerInvItemNum(MyIndex, i)).Name)

'check for speed-boosting items
If Trim(Item(GetPlayerInvItemNum(MyIndex, i)).Name) = "Amulet of Speed" Then
WALK_SPEED = 8
RUN_SPEED = 16
Else
WALK_SPEED = 4
RUN_SPEED = 8
End If

End If
End If
Else
frmMirage.lstInv.AddItem "<free inventory slot>"
End If
Next i

frmMirage.lstInv.ListIndex = 0
```

well actually all that you have to REALLY do is add in this to the correct place (see above for the correct place)

```vba
'check for speed-boosting items
If Trim(Item(GetPlayerInvItemNum(MyIndex, i)).Name) = "Amulet of Speed" Then
WALK_SPEED = 8
RUN_SPEED = 16
Else
WALK_SPEED = 4
RUN_SPEED = 8
End If
```

now, while in game, do ```/edititem``` and edit an item, name it simple "Amulet of Speed", and set it's picture.

and there you go, now just put down the amulet on the map, pick it up, hell, you can avan check the inventory if you wish to, but your speed will be outstanding now.. if your really smart, you can change the code so that it has to be actually WORN before the effect takes place...