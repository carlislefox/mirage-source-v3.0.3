# Admin panel
Okay, first step: Open up ```frmMirage```.

Make a large picture box. Name it ```picAdmin```. Set the visibility to false.

```
Key: Name - Label (Type)
```

Inside the picAdmin box, make 17 buttons and 3 text boxes named:

(Make two columns of buttons and text boxes)

### (Column 1)  
1. btnBan - Ban (Button)  
2. btnWarpMeTo - Warp To Me (Button)  
3. btnKick - Kick (Button)  
4. btnJail - Jail (Button)  
5. txtPlayer (Text Box)  
_(Skip a small space here)_  
6. btnWarpto - Warpto (Button)  
7. txtMap - (Text Box)  
_(Skip Small Space)_  
8. btnSprite - Set Sprite (Button)  
9. txtSprite - (Text Box)  
_(Skip Small Space)_  
10. btnLOC - Location (Button)  

### (Column 2)
11. btnBanlist - Ban List (Button)
12. btnDelbanlist - Delete List (Button)
_(Skip Small Space)_
13. btnMapeditor - Map Editor (Butotn)
14. btneditspell - Edit Spells (Button)
15. btnedititem - Edit Item (Button)
16. btnEditShops - Edit Shops (Button)
17. btnEditNPC - Edit NPC (Butotn)
_(Skip Small Space)_
18. btnMapreport - Map Report (Button)
19. btnRespawn - Respawn (Butotn)
_(Skip Small Space)_
20. btnclose - Close (Button)

Now, add the following into frmMirage anywhere:

```vba
Private Sub btnJail_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_DEVELOPER Then
Call SendJail(Trim(txtplayer.Text))
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub
Private Sub btnBan_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_DEVELOPER Then
Call SendBan(Trim(txtplayer.Text))
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnBanlist_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_DEVELOPER Then
Call SendBanList
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnDelbanlist_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_DEVELOPER Then
Call SendBanDestroy
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnedititem_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_DEVELOPER Then
Call SendRequestEditItem
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnEditNPC_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_DEVELOPER Then
Call SendRequestEditNpc
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnEditShops_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_DEVELOPER Then
Call SendRequestEditShop
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btneditspell_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_DEVELOPER Then
Call SendRequestEditSpell
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnkick_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_MONITER Then
Call SendKick(Trim(txtplayer.Text))
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnLOC_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_MAPPER Then
Call SendRequestLocation
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnMapeditor_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_MAPPER Then
Call SendRequestEditMap
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnMapreport_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_MAPPER Then
Call SendData("mapreport" & SEP_CHAR & END_CHAR)
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnRespawn_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_MAPPER Then
Call SendMapRespawn
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnWarpmeTo_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_MAPPER Then
Call WarpMeTo(Trim(txtplayer.Text))
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnWarpto_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_MAPPER Then
Call WarpTo(Val(txtmap.Text))
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnWarptome_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_MAPPER Then
Call WarpToMe(Trim(txtplayer.Text))
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub

Private Sub btnclose_Click()
frmMirage.picAdmin.Visible = False
End Sub

Private Sub btnSprite_Click()
If GetPlayerAccess(MyIndex) >= ADMIN_MAPPER Then
Call SendSetSprite(Val(txtSprite.Text))
Else: Call AddText("You are not authorized to carry out that action", BrightRed)
End If
End Sub
```

Now Open ```frmMirage``` and in ```sub Form_KeyUp()```

Right under:

```vba
Call CheckInput(0, KeyCode, Shift)
```

Add:

```vba
If KeyCode = vbKeyF1 Then
If Player(MyIndex).Access > 0 Then
picAdmin.Visible = False

picAdmin.Visible = True
End If
End If
```

This should do the trick! Hit F1 and wala! I hope you noobs enjoy the admin panel with the added Jail button.