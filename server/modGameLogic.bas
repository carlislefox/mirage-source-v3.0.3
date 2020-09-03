Attribute VB_Name = "modGameLogic"
Option Explicit

Function GetPlayerDamage(ByVal Index As Long) As Long
Dim WeaponSlot As Long

    GetPlayerDamage = 0
    
    ' Check for subscript out of range
    If IsPlaying(Index) = False Or Index <= 0 Or Index > MAX_PLAYERS Then
        Exit Function
    End If
    
    GetPlayerDamage = Int(GetPlayerSTR(Index) / 2)
    
    If GetPlayerDamage <= 0 Then
        GetPlayerDamage = 1
    End If
    
    If GetPlayerWeaponSlot(Index) > 0 Then
        WeaponSlot = GetPlayerWeaponSlot(Index)
        
        GetPlayerDamage = GetPlayerDamage + Item(GetPlayerInvItemNum(Index, WeaponSlot)).Data2
        
        Call SetPlayerInvItemDur(Index, WeaponSlot, GetPlayerInvItemDur(Index, WeaponSlot) - 1)
        
        If GetPlayerInvItemDur(Index, WeaponSlot) <= 0 Then
            Call PlayerMsg(Index, "Your " & Trim(Item(GetPlayerInvItemNum(Index, WeaponSlot)).Name) & " has broken.", Yellow)
            Call TakeItem(Index, GetPlayerInvItemNum(Index, WeaponSlot), 0)
        Else
            If GetPlayerInvItemDur(Index, WeaponSlot) <= 5 Then
                Call PlayerMsg(Index, "Your " & Trim(Item(GetPlayerInvItemNum(Index, WeaponSlot)).Name) & " is about to break!", Yellow)
            End If
        End If
    End If
End Function

Function GetPlayerProtection(ByVal Index As Long) As Long
Dim ArmorSlot As Long, HelmSlot As Long
    
    GetPlayerProtection = 0
    
    ' Check for subscript out of range
    If IsPlaying(Index) = False Or Index <= 0 Or Index > MAX_PLAYERS Then
        Exit Function
    End If
    
    ArmorSlot = GetPlayerArmorSlot(Index)
    HelmSlot = GetPlayerHelmetSlot(Index)
    GetPlayerProtection = Int(GetPlayerDEF(Index) / 5)

    If ArmorSlot > 0 Then
        GetPlayerProtection = GetPlayerProtection + Item(GetPlayerInvItemNum(Index, ArmorSlot)).Data2
        Call SetPlayerInvItemDur(Index, ArmorSlot, GetPlayerInvItemDur(Index, ArmorSlot) - 1)
        
        If GetPlayerInvItemDur(Index, ArmorSlot) <= 0 Then
            Call PlayerMsg(Index, "Your " & Trim(Item(GetPlayerInvItemNum(Index, ArmorSlot)).Name) & " has broken.", Yellow)
            Call TakeItem(Index, GetPlayerInvItemNum(Index, ArmorSlot), 0)
        Else
            If GetPlayerInvItemDur(Index, ArmorSlot) <= 5 Then
                Call PlayerMsg(Index, "Your " & Trim(Item(GetPlayerInvItemNum(Index, ArmorSlot)).Name) & " is about to break!", Yellow)
            End If
        End If
    End If
    
    If HelmSlot > 0 Then
        GetPlayerProtection = GetPlayerProtection + Item(GetPlayerInvItemNum(Index, HelmSlot)).Data2
        Call SetPlayerInvItemDur(Index, HelmSlot, GetPlayerInvItemDur(Index, HelmSlot) - 1)
        
        If GetPlayerInvItemDur(Index, HelmSlot) <= 0 Then
            Call PlayerMsg(Index, "Your " & Trim(Item(GetPlayerInvItemNum(Index, HelmSlot)).Name) & " has broken.", Yellow)
            Call TakeItem(Index, GetPlayerInvItemNum(Index, HelmSlot), 0)
        Else
            If GetPlayerInvItemDur(Index, HelmSlot) <= 5 Then
                Call PlayerMsg(Index, "Your " & Trim(Item(GetPlayerInvItemNum(Index, HelmSlot)).Name) & " is about to break!", Yellow)
            End If
        End If
    End If
End Function

Function FindOpenPlayerSlot() As Long
Dim i As Long

    FindOpenPlayerSlot = 0
    
    For i = 1 To MAX_PLAYERS
        If Not IsConnected(i) Then
            FindOpenPlayerSlot = i
            Exit Function
        End If
    Next i
End Function

Function FindOpenInvSlot(ByVal Index As Long, ByVal ItemNum As Long) As Long
Dim i As Long
    
    FindOpenInvSlot = 0
    
    ' Check for subscript out of range
    If IsPlaying(Index) = False Or ItemNum <= 0 Or ItemNum > MAX_ITEMS Then
        Exit Function
    End If
    
    If Item(ItemNum).Type = ITEM_TYPE_CURRENCY Then
        ' If currency then check to see if they already have an instance of the item and add it to that
        For i = 1 To MAX_INV
            If GetPlayerInvItemNum(Index, i) = ItemNum Then
                FindOpenInvSlot = i
                Exit Function
            End If
        Next i
    End If
    
    For i = 1 To MAX_INV
        ' Try to find an open free slot
        If GetPlayerInvItemNum(Index, i) = 0 Then
            FindOpenInvSlot = i
            Exit Function
        End If
    Next i
End Function

Function FindOpenMapItemSlot(ByVal MapNum As Long) As Long
Dim i As Long

    FindOpenMapItemSlot = 0
    
    ' Check for subscript out of range
    If MapNum <= 0 Or MapNum > MAX_MAPS Then
        Exit Function
    End If
    
    For i = 1 To MAX_MAP_ITEMS
        If MapItem(MapNum, i).Num = 0 Then
            FindOpenMapItemSlot = i
            Exit Function
        End If
    Next i
End Function

Function FindOpenSpellSlot(ByVal Index As Long) As Long
Dim i As Long

    FindOpenSpellSlot = 0
    
    For i = 1 To MAX_PLAYER_SPELLS
        If GetPlayerSpell(Index, i) = 0 Then
            FindOpenSpellSlot = i
            Exit Function
        End If
    Next i
End Function

Function HasSpell(ByVal Index As Long, ByVal SpellNum As Long) As Boolean
Dim i As Long

    HasSpell = False
    
    For i = 1 To MAX_PLAYER_SPELLS
        If GetPlayerSpell(Index, i) = SpellNum Then
            HasSpell = True
            Exit Function
        End If
    Next i
End Function

Function TotalOnlinePlayers() As Long
Dim i As Long

    TotalOnlinePlayers = 0
    
    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) Then
            TotalOnlinePlayers = TotalOnlinePlayers + 1
        End If
    Next i
End Function

Function FindPlayer(ByVal Name As String) As Long
Dim i As Long

    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) Then
            ' Make sure we dont try to check a name thats to small
            If Len(GetPlayerName(i)) >= Len(Trim(Name)) Then
                If UCase(Mid(GetPlayerName(i), 1, Len(Trim(Name)))) = UCase(Trim(Name)) Then
                    FindPlayer = i
                    Exit Function
                End If
            End If
        End If
    Next i
    
    FindPlayer = 0
End Function

Function HasItem(ByVal Index As Long, ByVal ItemNum As Long) As Long
Dim i As Long
    
    HasItem = 0
    
    ' Check for subscript out of range
    If IsPlaying(Index) = False Or ItemNum <= 0 Or ItemNum > MAX_ITEMS Then
        Exit Function
    End If
    
    For i = 1 To MAX_INV
        ' Check to see if the player has the item
        If GetPlayerInvItemNum(Index, i) = ItemNum Then
            If Item(ItemNum).Type = ITEM_TYPE_CURRENCY Then
                HasItem = GetPlayerInvItemValue(Index, i)
            Else
                HasItem = 1
            End If
            Exit Function
        End If
    Next i
End Function

Sub TakeItem(ByVal Index As Long, ByVal ItemNum As Long, ByVal ItemVal As Long)
Dim i As Long, n As Long
Dim TakeItem As Boolean

    TakeItem = False
    
    ' Check for subscript out of range
    If IsPlaying(Index) = False Or ItemNum <= 0 Or ItemNum > MAX_ITEMS Then
        Exit Sub
    End If
    
    For i = 1 To MAX_INV
        ' Check to see if the player has the item
        If GetPlayerInvItemNum(Index, i) = ItemNum Then
            If Item(ItemNum).Type = ITEM_TYPE_CURRENCY Then
                ' Is what we are trying to take away more then what they have?  If so just set it to zero
                If ItemVal >= GetPlayerInvItemValue(Index, i) Then
                    TakeItem = True
                Else
                    Call SetPlayerInvItemValue(Index, i, GetPlayerInvItemValue(Index, i) - ItemVal)
                    Call SendInventoryUpdate(Index, i)
                End If
            Else
                ' Check to see if its any sort of ArmorSlot/WeaponSlot
                Select Case Item(GetPlayerInvItemNum(Index, i)).Type
                    Case ITEM_TYPE_WEAPON
                        If GetPlayerWeaponSlot(Index) > 0 Then
                            If i = GetPlayerWeaponSlot(Index) Then
                                Call SetPlayerWeaponSlot(Index, 0)
                                Call SendWornEquipment(Index)
                                TakeItem = True
                            Else
                                ' Check if the item we are taking isn't already equipped
                                If ItemNum <> GetPlayerInvItemNum(Index, GetPlayerWeaponSlot(Index)) Then
                                    TakeItem = True
                                End If
                            End If
                        Else
                            TakeItem = True
                        End If
                
                    Case ITEM_TYPE_ARMOR
                        If GetPlayerArmorSlot(Index) > 0 Then
                            If i = GetPlayerArmorSlot(Index) Then
                                Call SetPlayerArmorSlot(Index, 0)
                                Call SendWornEquipment(Index)
                                TakeItem = True
                            Else
                                ' Check if the item we are taking isn't already equipped
                                If ItemNum <> GetPlayerInvItemNum(Index, GetPlayerArmorSlot(Index)) Then
                                    TakeItem = True
                                End If
                            End If
                        Else
                            TakeItem = True
                        End If
                    
                    Case ITEM_TYPE_HELMET
                        If GetPlayerHelmetSlot(Index) > 0 Then
                            If i = GetPlayerHelmetSlot(Index) Then
                                Call SetPlayerHelmetSlot(Index, 0)
                                Call SendWornEquipment(Index)
                                TakeItem = True
                            Else
                                ' Check if the item we are taking isn't already equipped
                                If ItemNum <> GetPlayerInvItemNum(Index, GetPlayerHelmetSlot(Index)) Then
                                    TakeItem = True
                                End If
                            End If
                        Else
                            TakeItem = True
                        End If
                    
                    Case ITEM_TYPE_SHIELD
                        If GetPlayerShieldSlot(Index) > 0 Then
                            If i = GetPlayerShieldSlot(Index) Then
                                Call SetPlayerShieldSlot(Index, 0)
                                Call SendWornEquipment(Index)
                                TakeItem = True
                            Else
                                ' Check if the item we are taking isn't already equipped
                                If ItemNum <> GetPlayerInvItemNum(Index, GetPlayerShieldSlot(Index)) Then
                                    TakeItem = True
                                End If
                            End If
                        Else
                            TakeItem = True
                        End If
                End Select

                
                n = Item(GetPlayerInvItemNum(Index, i)).Type
                ' Check if its not an equipable weapon, and if it isn't then take it away
                If (n <> ITEM_TYPE_WEAPON) And (n <> ITEM_TYPE_ARMOR) And (n <> ITEM_TYPE_HELMET) And (n <> ITEM_TYPE_SHIELD) Then
                    TakeItem = True
                End If
            End If
                            
            If TakeItem = True Then
                Call SetPlayerInvItemNum(Index, i, 0)
                Call SetPlayerInvItemValue(Index, i, 0)
                Call SetPlayerInvItemDur(Index, i, 0)
                
                ' Send the inventory update
                Call SendInventoryUpdate(Index, i)
                Exit Sub
            End If
        End If
    Next i
End Sub

Sub GiveItem(ByVal Index As Long, ByVal ItemNum As Long, ByVal ItemVal As Long)
Dim i As Long

    ' Check for subscript out of range
    If IsPlaying(Index) = False Or ItemNum <= 0 Or ItemNum > MAX_ITEMS Then
        Exit Sub
    End If
    
    i = FindOpenInvSlot(Index, ItemNum)
    
    ' Check to see if inventory is full
    If i <> 0 Then
        Call SetPlayerInvItemNum(Index, i, ItemNum)
        Call SetPlayerInvItemValue(Index, i, GetPlayerInvItemValue(Index, i) + ItemVal)
        
        If (Item(ItemNum).Type = ITEM_TYPE_ARMOR) Or (Item(ItemNum).Type = ITEM_TYPE_WEAPON) Or (Item(ItemNum).Type = ITEM_TYPE_HELMET) Or (Item(ItemNum).Type = ITEM_TYPE_SHIELD) Then
            Call SetPlayerInvItemDur(Index, i, Item(ItemNum).Data1)
        End If
        
        Call SendInventoryUpdate(Index, i)
    Else
        Call PlayerMsg(Index, "Your inventory is full.", BrightRed)
    End If
End Sub

Sub SpawnItem(ByVal ItemNum As Long, ByVal ItemVal As Long, ByVal MapNum As Long, ByVal x As Long, ByVal y As Long)
Dim i As Long

    ' Check for subscript out of range
    If ItemNum < 0 Or ItemNum > MAX_ITEMS Or MapNum <= 0 Or MapNum > MAX_MAPS Then
        Exit Sub
    End If
    
    ' Find open map item slot
    i = FindOpenMapItemSlot(MapNum)
    
    Call SpawnItemSlot(i, ItemNum, ItemVal, Item(ItemNum).Data1, MapNum, x, y)
End Sub

Sub SpawnItemSlot(ByVal MapItemSlot As Long, ByVal ItemNum As Long, ByVal ItemVal As Long, ByVal ItemDur As Long, ByVal MapNum As Long, ByVal x As Long, ByVal y As Long)
Dim Packet As String
Dim i As Long
    
    ' Check for subscript out of range
    If MapItemSlot <= 0 Or MapItemSlot > MAX_MAP_ITEMS Or ItemNum < 0 Or ItemNum > MAX_ITEMS Or MapNum <= 0 Or MapNum > MAX_MAPS Then
        Exit Sub
    End If
    
    i = MapItemSlot
    
    If i <> 0 And ItemNum >= 0 And ItemNum <= MAX_ITEMS Then
        MapItem(MapNum, i).Num = ItemNum
        MapItem(MapNum, i).Value = ItemVal
        
        If ItemNum <> 0 Then
            If (Item(ItemNum).Type >= ITEM_TYPE_WEAPON) And (Item(ItemNum).Type <= ITEM_TYPE_SHIELD) Then
                MapItem(MapNum, i).Dur = ItemDur
            Else
                MapItem(MapNum, i).Dur = 0
            End If
        Else
            MapItem(MapNum, i).Dur = 0
        End If
        
        MapItem(MapNum, i).x = x
        MapItem(MapNum, i).y = y
            
        Packet = "SPAWNITEM" & SEP_CHAR & i & SEP_CHAR & ItemNum & SEP_CHAR & ItemVal & SEP_CHAR & MapItem(MapNum, i).Dur & SEP_CHAR & x & SEP_CHAR & y & SEP_CHAR & END_CHAR
        Call SendDataToMap(MapNum, Packet)
    End If
End Sub

Sub SpawnAllMapsItems()
Dim i As Long
    
    For i = 1 To MAX_MAPS
        Call SpawnMapItems(i)
    Next i
End Sub

Sub SpawnMapItems(ByVal MapNum As Long)
Dim x As Long
Dim y As Long
Dim i As Long

    ' Check for subscript out of range
    If MapNum <= 0 Or MapNum > MAX_MAPS Then
        Exit Sub
    End If
    
    ' Spawn what we have
    For y = 0 To MAX_MAPY
        For x = 0 To MAX_MAPX
            ' Check if the tile type is an item or a saved tile incase someone drops something
            If (Map(MapNum).Tile(x, y).Type = TILE_TYPE_ITEM) Then
                ' Check to see if its a currency and if they set the value to 0 set it to 1 automatically
                If Item(Map(MapNum).Tile(x, y).Data1).Type = ITEM_TYPE_CURRENCY And Map(MapNum).Tile(x, y).Data2 <= 0 Then
                    Call SpawnItem(Map(MapNum).Tile(x, y).Data1, 1, MapNum, x, y)
                Else
                    Call SpawnItem(Map(MapNum).Tile(x, y).Data1, Map(MapNum).Tile(x, y).Data2, MapNum, x, y)
                End If
            End If
        Next x
    Next y
End Sub

Sub PlayerMapGetItem(ByVal Index As Long)
Dim i As Long
Dim n As Long
Dim MapNum As Long
Dim Msg As String

    If IsPlaying(Index) = False Then
        Exit Sub
    End If
    
    MapNum = GetPlayerMap(Index)
    
    For i = 1 To MAX_MAP_ITEMS
        ' See if theres even an item here
        If (MapItem(MapNum, i).Num > 0) And (MapItem(MapNum, i).Num <= MAX_ITEMS) Then
            ' Check if item is at the same location as the player
            If (MapItem(MapNum, i).x = GetPlayerX(Index)) And (MapItem(MapNum, i).y = GetPlayerY(Index)) Then
                ' Find open slot
                n = FindOpenInvSlot(Index, MapItem(MapNum, i).Num)
                
                ' Open slot available?
                If n <> 0 Then
                    ' Set item in players inventor
                    Call SetPlayerInvItemNum(Index, n, MapItem(MapNum, i).Num)
                    If Item(GetPlayerInvItemNum(Index, n)).Type = ITEM_TYPE_CURRENCY Then
                        Call SetPlayerInvItemValue(Index, n, GetPlayerInvItemValue(Index, n) + MapItem(MapNum, i).Value)
                        Msg = "You picked up " & MapItem(MapNum, i).Value & " " & Trim(Item(GetPlayerInvItemNum(Index, n)).Name) & "."
                    Else
                        Call SetPlayerInvItemValue(Index, n, 0)
                        Msg = "You picked up a " & Trim(Item(GetPlayerInvItemNum(Index, n)).Name) & "."
                    End If
                    Call SetPlayerInvItemDur(Index, n, MapItem(MapNum, i).Dur)
                        
                    ' Erase item from the map
                    MapItem(MapNum, i).Num = 0
                    MapItem(MapNum, i).Value = 0
                    MapItem(MapNum, i).Dur = 0
                    MapItem(MapNum, i).x = 0
                    MapItem(MapNum, i).y = 0
                        
                    Call SendInventoryUpdate(Index, n)
                    Call SpawnItemSlot(i, 0, 0, 0, GetPlayerMap(Index), GetPlayerX(Index), GetPlayerY(Index))
                    Call PlayerMsg(Index, Msg, Yellow)
                    Exit Sub
                Else
                    Call PlayerMsg(Index, "Your inventory is full.", BrightRed)
                    Exit Sub
                End If
            End If
        End If
    Next i
End Sub

Sub PlayerMapDropItem(ByVal Index As Long, ByVal InvNum As Long, ByVal Ammount As Long)
Dim i As Long

    ' Check for subscript out of range
    If IsPlaying(Index) = False Or InvNum <= 0 Or InvNum > MAX_INV Then
        Exit Sub
    End If
    
    If (GetPlayerInvItemNum(Index, InvNum) > 0) And (GetPlayerInvItemNum(Index, InvNum) <= MAX_ITEMS) Then
        i = FindOpenMapItemSlot(GetPlayerMap(Index))
        
        If i <> 0 Then
            MapItem(GetPlayerMap(Index), i).Dur = 0
            
            ' Check to see if its any sort of ArmorSlot/WeaponSlot
            Select Case Item(GetPlayerInvItemNum(Index, InvNum)).Type
                Case ITEM_TYPE_ARMOR
                    If InvNum = GetPlayerArmorSlot(Index) Then
                        Call SetPlayerArmorSlot(Index, 0)
                        Call SendWornEquipment(Index)
                    End If
                    MapItem(GetPlayerMap(Index), i).Dur = GetPlayerInvItemDur(Index, InvNum)
                
                Case ITEM_TYPE_WEAPON
                    If InvNum = GetPlayerWeaponSlot(Index) Then
                        Call SetPlayerWeaponSlot(Index, 0)
                        Call SendWornEquipment(Index)
                    End If
                    MapItem(GetPlayerMap(Index), i).Dur = GetPlayerInvItemDur(Index, InvNum)
                    
                Case ITEM_TYPE_HELMET
                    If InvNum = GetPlayerHelmetSlot(Index) Then
                        Call SetPlayerHelmetSlot(Index, 0)
                        Call SendWornEquipment(Index)
                    End If
                    MapItem(GetPlayerMap(Index), i).Dur = GetPlayerInvItemDur(Index, InvNum)
                                    
                Case ITEM_TYPE_SHIELD
                    If InvNum = GetPlayerShieldSlot(Index) Then
                        Call SetPlayerShieldSlot(Index, 0)
                        Call SendWornEquipment(Index)
                    End If
                    MapItem(GetPlayerMap(Index), i).Dur = GetPlayerInvItemDur(Index, InvNum)
            End Select
                                
            MapItem(GetPlayerMap(Index), i).Num = GetPlayerInvItemNum(Index, InvNum)
            MapItem(GetPlayerMap(Index), i).x = GetPlayerX(Index)
            MapItem(GetPlayerMap(Index), i).y = GetPlayerY(Index)
                        
            If Item(GetPlayerInvItemNum(Index, InvNum)).Type = ITEM_TYPE_CURRENCY Then
                ' Check if its more then they have and if so drop it all
                If Ammount >= GetPlayerInvItemValue(Index, InvNum) Then
                    MapItem(GetPlayerMap(Index), i).Value = GetPlayerInvItemValue(Index, InvNum)
                    Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " drops " & GetPlayerInvItemValue(Index, InvNum) & " " & Trim(Item(GetPlayerInvItemNum(Index, InvNum)).Name) & ".", Yellow)
                    Call SetPlayerInvItemNum(Index, InvNum, 0)
                    Call SetPlayerInvItemValue(Index, InvNum, 0)
                    Call SetPlayerInvItemDur(Index, InvNum, 0)
                Else
                    MapItem(GetPlayerMap(Index), i).Value = Ammount
                    Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " drops " & Ammount & " " & Trim(Item(GetPlayerInvItemNum(Index, InvNum)).Name) & ".", Yellow)
                    Call SetPlayerInvItemValue(Index, InvNum, GetPlayerInvItemValue(Index, InvNum) - Ammount)
                End If
            Else
                ' Its not a currency object so this is easy
                MapItem(GetPlayerMap(Index), i).Value = 0
                If Item(GetPlayerInvItemNum(Index, InvNum)).Type >= ITEM_TYPE_WEAPON And Item(GetPlayerInvItemNum(Index, InvNum)).Type <= ITEM_TYPE_SHIELD Then
                    Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " drops a " & Trim(Item(GetPlayerInvItemNum(Index, InvNum)).Name) & " " & GetPlayerInvItemDur(Index, InvNum) & "/" & Item(GetPlayerInvItemNum(Index, InvNum)).Data1 & ".", Yellow)
                Else
                    Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " drops a " & Trim(Item(GetPlayerInvItemNum(Index, InvNum)).Name) & ".", Yellow)
                End If
                
                Call SetPlayerInvItemNum(Index, InvNum, 0)
                Call SetPlayerInvItemValue(Index, InvNum, 0)
                Call SetPlayerInvItemDur(Index, InvNum, 0)
            End If
                                        
            ' Send inventory update
            Call SendInventoryUpdate(Index, InvNum)
            ' Spawn the item before we set the num or we'll get a different free map item slot
            Call SpawnItemSlot(i, MapItem(GetPlayerMap(Index), i).Num, Ammount, MapItem(GetPlayerMap(Index), i).Dur, GetPlayerMap(Index), GetPlayerX(Index), GetPlayerY(Index))
        Else
            Call PlayerMsg(Index, "To many items already on the ground.", BrightRed)
        End If
    End If
End Sub

Sub SpawnNpc(ByVal MapNpcNum As Long, ByVal MapNum As Long)
Dim Packet As String
Dim NpcNum As Long
Dim i As Long, x As Long, y As Long
Dim Spawned As Boolean

    ' Check for subscript out of range
    If MapNpcNum <= 0 Or MapNpcNum > MAX_MAP_NPCS Or MapNum <= 0 Or MapNum > MAX_MAPS Then
        Exit Sub
    End If
    
    Spawned = False
    
    NpcNum = Map(MapNum).Npc(MapNpcNum)
    If NpcNum > 0 Then
        MapNpc(MapNum, MapNpcNum).Num = NpcNum
        MapNpc(MapNum, MapNpcNum).Target = 0
        
        MapNpc(MapNum, MapNpcNum).HP = GetNpcMaxHP(NpcNum)
        MapNpc(MapNum, MapNpcNum).MP = GetNpcMaxMP(NpcNum)
        MapNpc(MapNum, MapNpcNum).SP = GetNpcMaxSP(NpcNum)
                
        MapNpc(MapNum, MapNpcNum).Dir = Int(Rnd * 4)
        
        ' Well try 100 times to randomly place the sprite
        For i = 1 To 100
            x = Int(Rnd * MAX_MAPX)
            y = Int(Rnd * MAX_MAPY)
            
            ' Check if the tile is walkable
            If Map(MapNum).Tile(x, y).Type = TILE_TYPE_WALKABLE Then
                MapNpc(MapNum, MapNpcNum).x = x
                MapNpc(MapNum, MapNpcNum).y = y
                Spawned = True
                Exit For
            End If
        Next i
        
        ' Didn't spawn, so now we'll just try to find a free tile
        If Not Spawned Then
            For y = 0 To MAX_MAPY
                For x = 0 To MAX_MAPX
                    If Map(MapNum).Tile(x, y).Type = TILE_TYPE_WALKABLE Then
                        MapNpc(MapNum, MapNpcNum).x = x
                        MapNpc(MapNum, MapNpcNum).y = y
                        Spawned = True
                    End If
                Next x
            Next y
        End If
             
        ' If we suceeded in spawning then send it to everyone
        If Spawned Then
            Packet = "SPAWNNPC" & SEP_CHAR & MapNpcNum & SEP_CHAR & MapNpc(MapNum, MapNpcNum).Num & SEP_CHAR & MapNpc(MapNum, MapNpcNum).x & SEP_CHAR & MapNpc(MapNum, MapNpcNum).y & SEP_CHAR & MapNpc(MapNum, MapNpcNum).Dir & SEP_CHAR & END_CHAR
            Call SendDataToMap(MapNum, Packet)
        End If
    End If
End Sub

Sub SpawnMapNpcs(ByVal MapNum As Long)
Dim i As Long

    For i = 1 To MAX_MAP_NPCS
        Call SpawnNpc(i, MapNum)
    Next i
End Sub

Sub SpawnAllMapNpcs()
Dim i As Long

    For i = 1 To MAX_MAPS
        Call SpawnMapNpcs(i)
    Next i
End Sub

Function CanAttackPlayer(ByVal Attacker As Long, ByVal Victim As Long) As Boolean
    CanAttackPlayer = False
    
    ' Check for subscript out of range
    If IsPlaying(Attacker) = False Or IsPlaying(Victim) = False Then
        Exit Function
    End If

    ' Make sure they have more then 0 hp
    If GetPlayerHP(Victim) <= 0 Then
        Exit Function
    End If
    
    ' Make sure we dont attack the player if they are switching maps
    If Player(Victim).GettingMap = YES Then
        Exit Function
    End If
    
    ' Make sure they are on the same map
    If (GetPlayerMap(Attacker) = GetPlayerMap(Victim)) And (GetTickCount > Player(Attacker).AttackTimer + 950) Then
        
        ' Check if at same coordinates
        Select Case GetPlayerDir(Attacker)
            Case DIR_UP
                If (GetPlayerY(Victim) + 1 = GetPlayerY(Attacker)) And (GetPlayerX(Victim) = GetPlayerX(Attacker)) Then
                    ' Check to make sure that they dont have access
                    If GetPlayerAccess(Attacker) > ADMIN_MONITER Then
                        Call PlayerMsg(Attacker, "You cannot attack any player for thou art an admin!", BrightBlue)
                    Else
                        ' Check to make sure the victim isn't an admin
                        If GetPlayerAccess(Victim) > ADMIN_MONITER Then
                            Call PlayerMsg(Attacker, "You cannot attack " & GetPlayerName(Victim) & "!", BrightRed)
                        Else
                            ' Check if map is attackable
                            If Map(GetPlayerMap(Attacker)).Moral = MAP_MORAL_NONE Or GetPlayerPK(Victim) = YES Then
                                ' Make sure they are high enough level
                                If GetPlayerLevel(Attacker) < 10 Then
                                    Call PlayerMsg(Attacker, "You are below level 10, you cannot attack another player yet!", BrightRed)
                                Else
                                    If GetPlayerLevel(Victim) < 10 Then
                                        Call PlayerMsg(Attacker, GetPlayerName(Victim) & " is below level 10, you cannot attack this player yet!", BrightRed)
                                    Else
                                        CanAttackPlayer = True
                                    End If
                                End If
                            Else
                                Call PlayerMsg(Attacker, "This is a safe zone!", BrightRed)
                            End If
                        End If
                    End If
                End If
            
            Case DIR_DOWN
                If (GetPlayerY(Victim) - 1 = GetPlayerY(Attacker)) And (GetPlayerX(Victim) = GetPlayerX(Attacker)) Then
                    ' Check to make sure that they dont have access
                    If GetPlayerAccess(Attacker) > ADMIN_MONITER Then
                        Call PlayerMsg(Attacker, "You cannot attack any player for thou art an admin!", BrightBlue)
                    Else
                        ' Check to make sure the victim isn't an admin
                        If GetPlayerAccess(Victim) > ADMIN_MONITER Then
                            Call PlayerMsg(Attacker, "You cannot attack " & GetPlayerName(Victim) & "!", BrightRed)
                        Else
                            ' Check if map is attackable
                            If Map(GetPlayerMap(Attacker)).Moral = MAP_MORAL_NONE Or GetPlayerPK(Victim) = YES Then
                                ' Make sure they are high enough level
                                If GetPlayerLevel(Attacker) < 10 Then
                                    Call PlayerMsg(Attacker, "You are below level 10, you cannot attack another player yet!", BrightRed)
                                Else
                                    If GetPlayerLevel(Victim) < 10 Then
                                        Call PlayerMsg(Attacker, GetPlayerName(Victim) & " is below level 10, you cannot attack this player yet!", BrightRed)
                                    Else
                                        CanAttackPlayer = True
                                    End If
                                End If
                            Else
                                Call PlayerMsg(Attacker, "This is a safe zone!", BrightRed)
                            End If
                        End If
                    End If
                End If
        
            Case DIR_LEFT
                If (GetPlayerY(Victim) = GetPlayerY(Attacker)) And (GetPlayerX(Victim) + 1 = GetPlayerX(Attacker)) Then
                    ' Check to make sure that they dont have access
                    If GetPlayerAccess(Attacker) > ADMIN_MONITER Then
                        Call PlayerMsg(Attacker, "You cannot attack any player for thou art an admin!", BrightBlue)
                    Else
                        ' Check to make sure the victim isn't an admin
                        If GetPlayerAccess(Victim) > ADMIN_MONITER Then
                            Call PlayerMsg(Attacker, "You cannot attack " & GetPlayerName(Victim) & "!", BrightRed)
                        Else
                            ' Check if map is attackable
                            If Map(GetPlayerMap(Attacker)).Moral = MAP_MORAL_NONE Or GetPlayerPK(Victim) = YES Then
                                ' Make sure they are high enough level
                                If GetPlayerLevel(Attacker) < 10 Then
                                    Call PlayerMsg(Attacker, "You are below level 10, you cannot attack another player yet!", BrightRed)
                                Else
                                    If GetPlayerLevel(Victim) < 10 Then
                                        Call PlayerMsg(Attacker, GetPlayerName(Victim) & " is below level 10, you cannot attack this player yet!", BrightRed)
                                    Else
                                        CanAttackPlayer = True
                                    End If
                                End If
                            Else
                                Call PlayerMsg(Attacker, "This is a safe zone!", BrightRed)
                            End If
                        End If
                    End If
                End If
            
            Case DIR_RIGHT
                If (GetPlayerY(Victim) = GetPlayerY(Attacker)) And (GetPlayerX(Victim) - 1 = GetPlayerX(Attacker)) Then
                    ' Check to make sure that they dont have access
                    If GetPlayerAccess(Attacker) > ADMIN_MONITER Then
                        Call PlayerMsg(Attacker, "You cannot attack any player for thou art an admin!", BrightBlue)
                    Else
                        ' Check to make sure the victim isn't an admin
                        If GetPlayerAccess(Victim) > ADMIN_MONITER Then
                            Call PlayerMsg(Attacker, "You cannot attack " & GetPlayerName(Victim) & "!", BrightRed)
                        Else
                            ' Check if map is attackable
                            If Map(GetPlayerMap(Attacker)).Moral = MAP_MORAL_NONE Or GetPlayerPK(Victim) = YES Then
                                ' Make sure they are high enough level
                                If GetPlayerLevel(Attacker) < 10 Then
                                    Call PlayerMsg(Attacker, "You are below level 10, you cannot attack another player yet!", BrightRed)
                                Else
                                    If GetPlayerLevel(Victim) < 10 Then
                                        Call PlayerMsg(Attacker, GetPlayerName(Victim) & " is below level 10, you cannot attack this player yet!", BrightRed)
                                    Else
                                        CanAttackPlayer = True
                                    End If
                                End If
                            Else
                                Call PlayerMsg(Attacker, "This is a safe zone!", BrightRed)
                            End If
                        End If
                    End If
                End If
        End Select
    End If
End Function

Function CanAttackNpc(ByVal Attacker As Long, ByVal MapNpcNum As Long) As Boolean
Dim MapNum As Long, NpcNum As Long

    CanAttackNpc = False
    
    ' Check for subscript out of range
    If IsPlaying(Attacker) = False Or MapNpcNum <= 0 Or MapNpcNum > MAX_MAP_NPCS Then
        Exit Function
    End If
    
    ' Check for subscript out of range
    If MapNpc(GetPlayerMap(Attacker), MapNpcNum).Num <= 0 Then
        Exit Function
    End If
    
    MapNum = GetPlayerMap(Attacker)
    NpcNum = MapNpc(MapNum, MapNpcNum).Num
    
    ' Make sure the npc isn't already dead
    If MapNpc(MapNum, MapNpcNum).HP <= 0 Then
        Exit Function
    End If
    
    ' Make sure they are on the same map
    If IsPlaying(Attacker) Then
        If NpcNum > 0 And GetTickCount > Player(Attacker).AttackTimer + 950 Then
            ' Check if at same coordinates
            Select Case GetPlayerDir(Attacker)
                Case DIR_UP
                    If (MapNpc(MapNum, MapNpcNum).y + 1 = GetPlayerY(Attacker)) And (MapNpc(MapNum, MapNpcNum).x = GetPlayerX(Attacker)) Then
                        If Npc(NpcNum).Behavior <> NPC_BEHAVIOR_FRIENDLY And Npc(NpcNum).Behavior <> NPC_BEHAVIOR_SHOPKEEPER Then
                            CanAttackNpc = True
                        Else
                            Call PlayerMsg(Attacker, "You cannot attack a " & Trim(Npc(NpcNum).Name) & "!", BrightBlue)
                        End If
                    End If
                
                Case DIR_DOWN
                    If (MapNpc(MapNum, MapNpcNum).y - 1 = GetPlayerY(Attacker)) And (MapNpc(MapNum, MapNpcNum).x = GetPlayerX(Attacker)) Then
                        If Npc(NpcNum).Behavior <> NPC_BEHAVIOR_FRIENDLY And Npc(NpcNum).Behavior <> NPC_BEHAVIOR_SHOPKEEPER Then
                            CanAttackNpc = True
                        Else
                            Call PlayerMsg(Attacker, "You cannot attack a " & Trim(Npc(NpcNum).Name) & "!", BrightBlue)
                        End If
                    End If
                
                Case DIR_LEFT
                    If (MapNpc(MapNum, MapNpcNum).y = GetPlayerY(Attacker)) And (MapNpc(MapNum, MapNpcNum).x + 1 = GetPlayerX(Attacker)) Then
                        If Npc(NpcNum).Behavior <> NPC_BEHAVIOR_FRIENDLY And Npc(NpcNum).Behavior <> NPC_BEHAVIOR_SHOPKEEPER Then
                            CanAttackNpc = True
                        Else
                            Call PlayerMsg(Attacker, "You cannot attack a " & Trim(Npc(NpcNum).Name) & "!", BrightBlue)
                        End If
                    End If
                
                Case DIR_RIGHT
                    If (MapNpc(MapNum, MapNpcNum).y = GetPlayerY(Attacker)) And (MapNpc(MapNum, MapNpcNum).x - 1 = GetPlayerX(Attacker)) Then
                        If Npc(NpcNum).Behavior <> NPC_BEHAVIOR_FRIENDLY And Npc(NpcNum).Behavior <> NPC_BEHAVIOR_SHOPKEEPER Then
                            CanAttackNpc = True
                        Else
                            Call PlayerMsg(Attacker, "You cannot attack a " & Trim(Npc(NpcNum).Name) & "!", BrightBlue)
                        End If
                    End If
            End Select
        End If
    End If
End Function

Function CanNpcAttackPlayer(ByVal MapNpcNum As Long, ByVal Index As Long) As Boolean
Dim MapNum As Long, NpcNum As Long
    
    CanNpcAttackPlayer = False
    
    ' Check for subscript out of range
    If MapNpcNum <= 0 Or MapNpcNum > MAX_MAP_NPCS Or IsPlaying(Index) = False Then
        Exit Function
    End If
    
    ' Check for subscript out of range
    If MapNpc(GetPlayerMap(Index), MapNpcNum).Num <= 0 Then
        Exit Function
    End If
    
    MapNum = GetPlayerMap(Index)
    NpcNum = MapNpc(MapNum, MapNpcNum).Num
    
    ' Make sure the npc isn't already dead
    If MapNpc(MapNum, MapNpcNum).HP <= 0 Then
        Exit Function
    End If
    
    ' Make sure npcs dont attack more then once a second
    If GetTickCount < MapNpc(MapNum, MapNpcNum).AttackTimer + 1000 Then
        Exit Function
    End If
    
    ' Make sure we dont attack the player if they are switching maps
    If Player(Index).GettingMap = YES Then
        Exit Function
    End If
    
    MapNpc(MapNum, MapNpcNum).AttackTimer = GetTickCount
    
    ' Make sure they are on the same map
    If IsPlaying(Index) Then
        If NpcNum > 0 Then
            ' Check if at same coordinates
            If (GetPlayerY(Index) + 1 = MapNpc(MapNum, MapNpcNum).y) And (GetPlayerX(Index) = MapNpc(MapNum, MapNpcNum).x) Then
                CanNpcAttackPlayer = True
            Else
                If (GetPlayerY(Index) - 1 = MapNpc(MapNum, MapNpcNum).y) And (GetPlayerX(Index) = MapNpc(MapNum, MapNpcNum).x) Then
                    CanNpcAttackPlayer = True
                Else
                    If (GetPlayerY(Index) = MapNpc(MapNum, MapNpcNum).y) And (GetPlayerX(Index) + 1 = MapNpc(MapNum, MapNpcNum).x) Then
                        CanNpcAttackPlayer = True
                    Else
                        If (GetPlayerY(Index) = MapNpc(MapNum, MapNpcNum).y) And (GetPlayerX(Index) - 1 = MapNpc(MapNum, MapNpcNum).x) Then
                            CanNpcAttackPlayer = True
                        End If
                    End If
                End If
            End If

'            Select Case MapNpc(MapNum, MapNpcNum).Dir
'                Case DIR_UP
'                    If (GetPlayerY(Index) + 1 = MapNpc(MapNum, MapNpcNum).y) And (GetPlayerX(Index) = MapNpc(MapNum, MapNpcNum).x) Then
'                        CanNpcAttackPlayer = True
'                    End If
'
'                Case DIR_DOWN
'                    If (GetPlayerY(Index) - 1 = MapNpc(MapNum, MapNpcNum).y) And (GetPlayerX(Index) = MapNpc(MapNum, MapNpcNum).x) Then
'                        CanNpcAttackPlayer = True
'                    End If
'
'                Case DIR_LEFT
'                    If (GetPlayerY(Index) = MapNpc(MapNum, MapNpcNum).y) And (GetPlayerX(Index) + 1 = MapNpc(MapNum, MapNpcNum).x) Then
'                        CanNpcAttackPlayer = True
'                    End If
'
'                Case DIR_RIGHT
'                    If (GetPlayerY(Index) = MapNpc(MapNum, MapNpcNum).y) And (GetPlayerX(Index) - 1 = MapNpc(MapNum, MapNpcNum).x) Then
'                        CanNpcAttackPlayer = True
'                    End If
'            End Select
        End If
    End If
End Function

Sub AttackPlayer(ByVal Attacker As Long, ByVal Victim As Long, ByVal Damage As Long)
Dim Exp As Long
Dim n As Long
Dim i As Long

    ' Check for subscript out of range
    If IsPlaying(Attacker) = False Or IsPlaying(Victim) = False Or Damage < 0 Then
        Exit Sub
    End If
    
    ' Check for weapon
    If GetPlayerWeaponSlot(Attacker) > 0 Then
        n = GetPlayerInvItemNum(Attacker, GetPlayerWeaponSlot(Attacker))
    Else
        n = 0
    End If
    
    ' Send this packet so they can see the person attacking
    Call SendDataToMapBut(Attacker, GetPlayerMap(Attacker), "ATTACK" & SEP_CHAR & Attacker & SEP_CHAR & END_CHAR)
        
    If Damage >= GetPlayerHP(Victim) Then
        ' Set HP to nothing
        Call SetPlayerHP(Victim, 0)
        
        ' Check for a weapon and say damage
        If n = 0 Then
            Call PlayerMsg(Attacker, "You hit " & GetPlayerName(Victim) & " for " & Damage & " hit points.", White)
            Call PlayerMsg(Victim, GetPlayerName(Attacker) & " hit you for " & Damage & " hit points.", BrightRed)
        Else
            Call PlayerMsg(Attacker, "You hit " & GetPlayerName(Victim) & " with a " & Trim(Item(n).Name) & " for " & Damage & " hit points.", White)
            Call PlayerMsg(Victim, GetPlayerName(Attacker) & " hit you with a " & Trim(Item(n).Name) & " for " & Damage & " hit points.", BrightRed)
        End If
        
        ' Player is dead
        Call GlobalMsg(GetPlayerName(Victim) & " has been killed by " & GetPlayerName(Attacker), BrightRed)
        
        ' Drop all worn items by victim
        If GetPlayerWeaponSlot(Victim) > 0 Then
            Call PlayerMapDropItem(Victim, GetPlayerWeaponSlot(Victim), 0)
        End If
        If GetPlayerArmorSlot(Victim) > 0 Then
            Call PlayerMapDropItem(Victim, GetPlayerArmorSlot(Victim), 0)
        End If
        If GetPlayerHelmetSlot(Victim) > 0 Then
            Call PlayerMapDropItem(Victim, GetPlayerHelmetSlot(Victim), 0)
        End If
        If GetPlayerShieldSlot(Victim) > 0 Then
            Call PlayerMapDropItem(Victim, GetPlayerShieldSlot(Victim), 0)
        End If

        ' Calculate exp to give attacker
        Exp = Int(GetPlayerExp(Victim) / 10)
        
        ' Make sure we dont get less then 0
        If Exp < 0 Then
            Exp = 0
        End If
        
        If Exp = 0 Then
            Call PlayerMsg(Victim, "You lost no experience points.", BrightRed)
            Call PlayerMsg(Attacker, "You received no experience points from that weak insignificant player.", BrightBlue)
        Else
            Call SetPlayerExp(Victim, GetPlayerExp(Victim) - Exp)
            Call PlayerMsg(Victim, "You lost " & Exp & " experience points.", BrightRed)
            Call SetPlayerExp(Attacker, GetPlayerExp(Attacker) + Exp)
            Call PlayerMsg(Attacker, "You got " & Exp & " experience points for killing " & GetPlayerName(Victim) & ".", BrightBlue)
        End If
                
        ' Warp player away
        Call PlayerWarp(Victim, START_MAP, START_X, START_Y)
        
        ' Restore vitals
        Call SetPlayerHP(Victim, GetPlayerMaxHP(Victim))
        Call SetPlayerMP(Victim, GetPlayerMaxMP(Victim))
        Call SetPlayerSP(Victim, GetPlayerMaxSP(Victim))
        Call SendHP(Victim)
        Call SendMP(Victim)
        Call SendSP(Victim)
                
        ' Check for a level up
        Call CheckPlayerLevelUp(Attacker)
        
        ' Check if target is player who died and if so set target to 0
        If Player(Attacker).TargetType = TARGET_TYPE_PLAYER And Player(Attacker).Target = Victim Then
            Player(Attacker).Target = 0
            Player(Attacker).TargetType = 0
        End If
        
        If GetPlayerPK(Victim) = NO Then
            If GetPlayerPK(Attacker) = NO Then
                Call SetPlayerPK(Attacker, YES)
                Call SendPlayerData(Attacker)
                Call GlobalMsg(GetPlayerName(Attacker) & " has been deemed a Player Killer!!!", BrightRed)
            End If
        Else
            Call SetPlayerPK(Victim, NO)
            Call SendPlayerData(Victim)
            Call GlobalMsg(GetPlayerName(Victim) & " has paid the price for being a Player Killer!!!", BrightRed)
        End If
    Else
        ' Player not dead, just do the damage
        Call SetPlayerHP(Victim, GetPlayerHP(Victim) - Damage)
        Call SendHP(Victim)
        
        ' Check for a weapon and say damage
        If n = 0 Then
            Call PlayerMsg(Attacker, "You hit " & GetPlayerName(Victim) & " for " & Damage & " hit points.", White)
            Call PlayerMsg(Victim, GetPlayerName(Attacker) & " hit you for " & Damage & " hit points.", BrightRed)
        Else
            Call PlayerMsg(Attacker, "You hit " & GetPlayerName(Victim) & " with a " & Trim(Item(n).Name) & " for " & Damage & " hit points.", White)
            Call PlayerMsg(Victim, GetPlayerName(Attacker) & " hit you with a " & Trim(Item(n).Name) & " for " & Damage & " hit points.", BrightRed)
        End If
    End If
    
    ' Reset timer for attacking
    Player(Attacker).AttackTimer = GetTickCount
End Sub

Sub NpcAttackPlayer(ByVal MapNpcNum As Long, ByVal Victim As Long, ByVal Damage As Long)
Dim Name As String
Dim Exp As Long
Dim MapNum As Long

    ' Check for subscript out of range
    If MapNpcNum <= 0 Or MapNpcNum > MAX_MAP_NPCS Or IsPlaying(Victim) = False Or Damage < 0 Then
        Exit Sub
    End If
    
    ' Check for subscript out of range
    If MapNpc(GetPlayerMap(Victim), MapNpcNum).Num <= 0 Then
        Exit Sub
    End If
    
    ' Send this packet so they can see the person attacking
    Call SendDataToMap(GetPlayerMap(Victim), "NPCATTACK" & SEP_CHAR & MapNpcNum & SEP_CHAR & END_CHAR)
    
    MapNum = GetPlayerMap(Victim)
    Name = Trim(Npc(MapNpc(MapNum, MapNpcNum).Num).Name)
    
    If Damage >= GetPlayerHP(Victim) Then
        ' Say damage
        Call PlayerMsg(Victim, "A " & Name & " hit you for " & Damage & " hit points.", BrightRed)
        
        ' Player is dead
        Call GlobalMsg(GetPlayerName(Victim) & " has been killed by a " & Name, BrightRed)
        
        ' Drop all worn items by victim
        If GetPlayerWeaponSlot(Victim) > 0 Then
            Call PlayerMapDropItem(Victim, GetPlayerWeaponSlot(Victim), 0)
        End If
        If GetPlayerArmorSlot(Victim) > 0 Then
            Call PlayerMapDropItem(Victim, GetPlayerArmorSlot(Victim), 0)
        End If
        If GetPlayerHelmetSlot(Victim) > 0 Then
            Call PlayerMapDropItem(Victim, GetPlayerHelmetSlot(Victim), 0)
        End If
        If GetPlayerShieldSlot(Victim) > 0 Then
            Call PlayerMapDropItem(Victim, GetPlayerShieldSlot(Victim), 0)
        End If
        
        ' Calculate exp to give attacker
        Exp = Int(GetPlayerExp(Victim) / 3)
        
        ' Make sure we dont get less then 0
        If Exp < 0 Then
            Exp = 0
        End If
        
        If Exp = 0 Then
            Call PlayerMsg(Victim, "You lost no experience points.", BrightRed)
        Else
            Call SetPlayerExp(Victim, GetPlayerExp(Victim) - Exp)
            Call PlayerMsg(Victim, "You lost " & Exp & " experience points.", BrightRed)
        End If
                
        ' Warp player away
        Call PlayerWarp(Victim, START_MAP, START_X, START_Y)
        
        ' Restore vitals
        Call SetPlayerHP(Victim, GetPlayerMaxHP(Victim))
        Call SetPlayerMP(Victim, GetPlayerMaxMP(Victim))
        Call SetPlayerSP(Victim, GetPlayerMaxSP(Victim))
        Call SendHP(Victim)
        Call SendMP(Victim)
        Call SendSP(Victim)
        
        ' Set NPC target to 0
        MapNpc(MapNum, MapNpcNum).Target = 0
        
        ' If the player the attacker killed was a pk then take it away
        If GetPlayerPK(Victim) = YES Then
            Call SetPlayerPK(Victim, NO)
            Call SendPlayerData(Victim)
        End If
    Else
        ' Player not dead, just do the damage
        Call SetPlayerHP(Victim, GetPlayerHP(Victim) - Damage)
        Call SendHP(Victim)
        
        ' Say damage
        Call PlayerMsg(Victim, "A " & Name & " hit you for " & Damage & " hit points.", BrightRed)
    End If
End Sub

Sub AttackNpc(ByVal Attacker As Long, ByVal MapNpcNum As Long, ByVal Damage As Long)
Dim Name As String
Dim Exp As Long
Dim n As Long, i As Long
Dim STR As Long, DEF As Long, MapNum As Long, NpcNum As Long

    ' Check for subscript out of range
    If IsPlaying(Attacker) = False Or MapNpcNum <= 0 Or MapNpcNum > MAX_MAP_NPCS Or Damage < 0 Then
        Exit Sub
    End If
    
    ' Check for weapon
    If GetPlayerWeaponSlot(Attacker) > 0 Then
        n = GetPlayerInvItemNum(Attacker, GetPlayerWeaponSlot(Attacker))
    Else
        n = 0
    End If
    
    ' Send this packet so they can see the person attacking
    Call SendDataToMapBut(Attacker, GetPlayerMap(Attacker), "ATTACK" & SEP_CHAR & Attacker & SEP_CHAR & END_CHAR)
    
    MapNum = GetPlayerMap(Attacker)
    NpcNum = MapNpc(MapNum, MapNpcNum).Num
    Name = Trim(Npc(NpcNum).Name)
        
    If Damage >= MapNpc(MapNum, MapNpcNum).HP Then
        ' Check for a weapon and say damage
        If n = 0 Then
            Call PlayerMsg(Attacker, "You hit a " & Name & " for " & Damage & " hit points, killing it.", BrightRed)
        Else
            Call PlayerMsg(Attacker, "You hit a " & Name & " with a " & Trim(Item(n).Name) & " for " & Damage & " hit points, killing it.", BrightRed)
        End If
                        
        ' Calculate exp to give attacker
        STR = Npc(NpcNum).STR
        DEF = Npc(NpcNum).DEF
        Exp = STR * DEF * 2
        
        ' Make sure we dont get less then 0
        If Exp < 0 Then
            Exp = 1
        End If
        
        ' Check if in party, if so divide the exp up by 2
        If Player(Attacker).InParty = NO Then
            Call SetPlayerExp(Attacker, GetPlayerExp(Attacker) + Exp)
            Call PlayerMsg(Attacker, "You have gained " & Exp & " experience points.", BrightBlue)
        Else
            Exp = Exp / 2
            
            If Exp < 0 Then
                Exp = 1
            End If
            
            Call SetPlayerExp(Attacker, GetPlayerExp(Attacker) + Exp)
            Call PlayerMsg(Attacker, "You have gained " & Exp & " party experience points.", BrightBlue)
            
            n = Player(Attacker).PartyPlayer
            If n > 0 Then
                Call SetPlayerExp(n, GetPlayerExp(n) + Exp)
                Call PlayerMsg(n, "You have gained " & Exp & " party experience points.", BrightBlue)
            End If
        End If
                                
        ' Drop the goods if they get it
        n = Int(Rnd * Npc(NpcNum).DropChance) + 1
        If n = 1 Then
            Call SpawnItem(Npc(NpcNum).DropItem, Npc(NpcNum).DropItemValue, MapNum, MapNpc(MapNum, MapNpcNum).x, MapNpc(MapNum, MapNpcNum).y)
        End If
        
        ' Now set HP to 0 so we know to actually kill them in the server loop (this prevents subscript out of range)
        MapNpc(MapNum, MapNpcNum).Num = 0
        MapNpc(MapNum, MapNpcNum).SpawnWait = GetTickCount
        MapNpc(MapNum, MapNpcNum).HP = 0
        Call SendDataToMap(MapNum, "NPCDEAD" & SEP_CHAR & MapNpcNum & SEP_CHAR & END_CHAR)
        
        ' Check for level up
        Call CheckPlayerLevelUp(Attacker)
        
        ' Check for level up party member
        If Player(Attacker).InParty = YES Then
            Call CheckPlayerLevelUp(Player(Attacker).PartyPlayer)
        End If
    
        ' Check if target is npc that died and if so set target to 0
        If Player(Attacker).TargetType = TARGET_TYPE_NPC And Player(Attacker).Target = MapNpcNum Then
            Player(Attacker).Target = 0
            Player(Attacker).TargetType = 0
        End If
    Else
        ' NPC not dead, just do the damage
        MapNpc(MapNum, MapNpcNum).HP = MapNpc(MapNum, MapNpcNum).HP - Damage
        
        ' Check for a weapon and say damage
        If n = 0 Then
            Call PlayerMsg(Attacker, "You hit a " & Name & " for " & Damage & " hit points.", White)
        Else
            Call PlayerMsg(Attacker, "You hit a " & Name & " with a " & Trim(Item(n).Name) & " for " & Damage & " hit points.", White)
        End If
        
        ' Check if we should send a message
        If MapNpc(MapNum, MapNpcNum).Target = 0 And MapNpc(MapNum, MapNpcNum).Target <> Attacker Then
            If Trim(Npc(NpcNum).AttackSay) <> "" Then
                Call PlayerMsg(Attacker, "A " & Trim(Npc(NpcNum).Name) & " says, '" & Trim(Npc(NpcNum).AttackSay) & "' to you.", SayColor)
            End If
        End If
        
        ' Set the NPC target to the player
        MapNpc(MapNum, MapNpcNum).Target = Attacker
        
        ' Now check for guard ai and if so have all onmap guards come after'm
        If Npc(MapNpc(MapNum, MapNpcNum).Num).Behavior = NPC_BEHAVIOR_GUARD Then
            For i = 1 To MAX_MAP_NPCS
                If MapNpc(MapNum, i).Num = MapNpc(MapNum, MapNpcNum).Num Then
                    MapNpc(MapNum, i).Target = Attacker
                End If
            Next i
        End If
    End If
    
    ' Reset attack timer
    Player(Attacker).AttackTimer = GetTickCount
End Sub

Sub PlayerWarp(ByVal Index As Long, ByVal MapNum As Long, ByVal x As Long, ByVal y As Long)
Dim Packet As String
Dim ShopNum As Long, OldMap As Long

    ' Check for subscript out of range
    If IsPlaying(Index) = False Or MapNum <= 0 Or MapNum > MAX_MAPS Then
        Exit Sub
    End If
    
    ' Check if there was an npc on the map the player is leaving, and if so say goodbye
    ShopNum = Map(GetPlayerMap(Index)).Shop
    If ShopNum > 0 Then
        If Trim(Shop(ShopNum).LeaveSay) <> "" Then
            Call PlayerMsg(Index, Trim(Shop(ShopNum).Name) & " says, '" & Trim(Shop(ShopNum).LeaveSay) & "'", SayColor)
        End If
    End If
    
    ' Save old map to send erase player data to
    OldMap = GetPlayerMap(Index)
    Call SendLeaveMap(Index, OldMap)
    
    Call SetPlayerMap(Index, MapNum)
    Call SetPlayerX(Index, x)
    Call SetPlayerY(Index, y)
    
    ' Check if there is an npc on the map and say hello if so
    ShopNum = Map(GetPlayerMap(Index)).Shop
    If ShopNum > 0 Then
        If Trim(Shop(ShopNum).JoinSay) <> "" Then
            Call PlayerMsg(Index, Trim(Shop(ShopNum).Name) & " says, '" & Trim(Shop(ShopNum).JoinSay) & "'", SayColor)
        End If
    End If
            
    ' Now we check if there were any players left on the map the player just left, and if not stop processing npcs
    If GetTotalMapPlayers(OldMap) = 0 Then
        PlayersOnMap(OldMap) = NO
    End If
    
    ' Sets it so we know to process npcs on the map
    PlayersOnMap(MapNum) = YES
    
    Player(Index).GettingMap = YES
    Call SendDataTo(Index, "CHECKFORMAP" & SEP_CHAR & MapNum & SEP_CHAR & Map(MapNum).Revision & SEP_CHAR & END_CHAR)
End Sub

Sub PlayerMove(ByVal Index As Long, ByVal Dir As Long, ByVal Movement As Long)
Dim Packet As String
Dim MapNum As Long
Dim x As Long
Dim y As Long
Dim i As Long
Dim Moved As Byte

    ' Check for subscript out of range
    If IsPlaying(Index) = False Or Dir < DIR_UP Or Dir > DIR_RIGHT Or Movement < 1 Or Movement > 2 Then
        Exit Sub
    End If
    
    Call SetPlayerDir(Index, Dir)
    
    Moved = NO
    
    Select Case Dir
        Case DIR_UP
            ' Check to make sure not outside of boundries
            If GetPlayerY(Index) > 0 Then
                ' Check to make sure that the tile is walkable
                If Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index) - 1).Type <> TILE_TYPE_BLOCKED Then
                    ' Check to see if the tile is a key and if it is check if its opened
                    If Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index) - 1).Type <> TILE_TYPE_KEY Or (Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index) - 1).Type = TILE_TYPE_KEY And TempTile(GetPlayerMap(Index)).DoorOpen(GetPlayerX(Index), GetPlayerY(Index) - 1) = YES) Then
                        Call SetPlayerY(Index, GetPlayerY(Index) - 1)
                        
                        Packet = "PLAYERMOVE" & SEP_CHAR & Index & SEP_CHAR & GetPlayerX(Index) & SEP_CHAR & GetPlayerY(Index) & SEP_CHAR & GetPlayerDir(Index) & SEP_CHAR & Movement & SEP_CHAR & END_CHAR
                        Call SendDataToMapBut(Index, GetPlayerMap(Index), Packet)
                        Moved = YES
                    End If
                End If
            Else
                ' Check to see if we can move them to the another map
                If Map(GetPlayerMap(Index)).Up > 0 Then
                    Call PlayerWarp(Index, Map(GetPlayerMap(Index)).Up, GetPlayerX(Index), MAX_MAPY)
                    Moved = YES
                End If
            End If
                    
        Case DIR_DOWN
            ' Check to make sure not outside of boundries
            If GetPlayerY(Index) < MAX_MAPY Then
                ' Check to make sure that the tile is walkable
                If Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index) + 1).Type <> TILE_TYPE_BLOCKED Then
                    ' Check to see if the tile is a key and if it is check if its opened
                    If Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index) + 1).Type <> TILE_TYPE_KEY Or (Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index) + 1).Type = TILE_TYPE_KEY And TempTile(GetPlayerMap(Index)).DoorOpen(GetPlayerX(Index), GetPlayerY(Index) + 1) = YES) Then
                        Call SetPlayerY(Index, GetPlayerY(Index) + 1)
                        
                        Packet = "PLAYERMOVE" & SEP_CHAR & Index & SEP_CHAR & GetPlayerX(Index) & SEP_CHAR & GetPlayerY(Index) & SEP_CHAR & GetPlayerDir(Index) & SEP_CHAR & Movement & SEP_CHAR & END_CHAR
                        Call SendDataToMapBut(Index, GetPlayerMap(Index), Packet)
                        Moved = YES
                    End If
                End If
            Else
                ' Check to see if we can move them to the another map
                If Map(GetPlayerMap(Index)).Down > 0 Then
                    Call PlayerWarp(Index, Map(GetPlayerMap(Index)).Down, GetPlayerX(Index), 0)
                    Moved = YES
                End If
            End If
        
        Case DIR_LEFT
            ' Check to make sure not outside of boundries
            If GetPlayerX(Index) > 0 Then
                ' Check to make sure that the tile is walkable
                If Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index) - 1, GetPlayerY(Index)).Type <> TILE_TYPE_BLOCKED Then
                    ' Check to see if the tile is a key and if it is check if its opened
                    If Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index) - 1, GetPlayerY(Index)).Type <> TILE_TYPE_KEY Or (Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index) - 1, GetPlayerY(Index)).Type = TILE_TYPE_KEY And TempTile(GetPlayerMap(Index)).DoorOpen(GetPlayerX(Index) - 1, GetPlayerY(Index)) = YES) Then
                        Call SetPlayerX(Index, GetPlayerX(Index) - 1)
                        
                        Packet = "PLAYERMOVE" & SEP_CHAR & Index & SEP_CHAR & GetPlayerX(Index) & SEP_CHAR & GetPlayerY(Index) & SEP_CHAR & GetPlayerDir(Index) & SEP_CHAR & Movement & SEP_CHAR & END_CHAR
                        Call SendDataToMapBut(Index, GetPlayerMap(Index), Packet)
                        Moved = YES
                    End If
                End If
            Else
                ' Check to see if we can move them to the another map
                If Map(GetPlayerMap(Index)).Left > 0 Then
                    Call PlayerWarp(Index, Map(GetPlayerMap(Index)).Left, MAX_MAPX, GetPlayerY(Index))
                    Moved = YES
                End If
            End If
        
        Case DIR_RIGHT
            ' Check to make sure not outside of boundries
            If GetPlayerX(Index) < MAX_MAPX Then
                ' Check to make sure that the tile is walkable
                If Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index) + 1, GetPlayerY(Index)).Type <> TILE_TYPE_BLOCKED Then
                    ' Check to see if the tile is a key and if it is check if its opened
                    If Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index) + 1, GetPlayerY(Index)).Type <> TILE_TYPE_KEY Or (Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index) + 1, GetPlayerY(Index)).Type = TILE_TYPE_KEY And TempTile(GetPlayerMap(Index)).DoorOpen(GetPlayerX(Index) + 1, GetPlayerY(Index)) = YES) Then
                        Call SetPlayerX(Index, GetPlayerX(Index) + 1)
                        
                        Packet = "PLAYERMOVE" & SEP_CHAR & Index & SEP_CHAR & GetPlayerX(Index) & SEP_CHAR & GetPlayerY(Index) & SEP_CHAR & GetPlayerDir(Index) & SEP_CHAR & Movement & SEP_CHAR & END_CHAR
                        Call SendDataToMapBut(Index, GetPlayerMap(Index), Packet)
                        Moved = YES
                    End If
                End If
            Else
                ' Check to see if we can move them to the another map
                If Map(GetPlayerMap(Index)).Right > 0 Then
                    Call PlayerWarp(Index, Map(GetPlayerMap(Index)).Right, 0, GetPlayerY(Index))
                    Moved = YES
                End If
            End If
    End Select
        
    ' Check to see if the tile is a warp tile, and if so warp them
    If Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index)).Type = TILE_TYPE_WARP Then
        MapNum = Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index)).Data1
        x = Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index)).Data2
        y = Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index)).Data3
                        
        Call PlayerWarp(Index, MapNum, x, y)
        Moved = YES
    End If
    
    ' Check for key trigger open
    If Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index)).Type = TILE_TYPE_KEYOPEN Then
        x = Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index)).Data1
        y = Map(GetPlayerMap(Index)).Tile(GetPlayerX(Index), GetPlayerY(Index)).Data2
        
        If Map(GetPlayerMap(Index)).Tile(x, y).Type = TILE_TYPE_KEY And TempTile(GetPlayerMap(Index)).DoorOpen(x, y) = NO Then
            TempTile(GetPlayerMap(Index)).DoorOpen(x, y) = YES
            TempTile(GetPlayerMap(Index)).DoorTimer = GetTickCount
                            
            Call SendDataToMap(GetPlayerMap(Index), "MAPKEY" & SEP_CHAR & x & SEP_CHAR & y & SEP_CHAR & 1 & SEP_CHAR & END_CHAR)
            Call MapMsg(GetPlayerMap(Index), "A door has been unlocked.", White)
        End If
    End If
    
    ' They tried to hack
    If Moved = NO Then
        Call HackingAttempt(Index, "Position Modification")
    End If
End Sub

Function CanNpcMove(ByVal MapNum As Long, ByVal MapNpcNum As Long, ByVal Dir) As Boolean
Dim i As Long, n As Long
Dim x As Long, y As Long

    CanNpcMove = False
    
    ' Check for subscript out of range
    If MapNum <= 0 Or MapNum > MAX_MAPS Or MapNpcNum <= 0 Or MapNpcNum > MAX_MAP_NPCS Or Dir < DIR_UP Or Dir > DIR_RIGHT Then
        Exit Function
    End If
    
    x = MapNpc(MapNum, MapNpcNum).x
    y = MapNpc(MapNum, MapNpcNum).y
    
    CanNpcMove = True
    
    Select Case Dir
        Case DIR_UP
            ' Check to make sure not outside of boundries
            If y > 0 Then
                n = Map(MapNum).Tile(x, y - 1).Type
                
                ' Check to make sure that the tile is walkable
                If n <> TILE_TYPE_WALKABLE And n <> TILE_TYPE_ITEM Then
                    CanNpcMove = False
                    Exit Function
                End If
                
                ' Check to make sure that there is not a player in the way
                For i = 1 To MAX_PLAYERS
                    If IsPlaying(i) Then
                        If (GetPlayerMap(i) = MapNum) And (GetPlayerX(i) = MapNpc(MapNum, MapNpcNum).x) And (GetPlayerY(i) = MapNpc(MapNum, MapNpcNum).y - 1) Then
                            CanNpcMove = False
                            Exit Function
                        End If
                    End If
                Next i
                
                ' Check to make sure that there is not another npc in the way
                For i = 1 To MAX_MAP_NPCS
                    If (i <> MapNpcNum) And (MapNpc(MapNum, i).Num > 0) And (MapNpc(MapNum, i).x = MapNpc(MapNum, MapNpcNum).x) And (MapNpc(MapNum, i).y = MapNpc(MapNum, MapNpcNum).y - 1) Then
                        CanNpcMove = False
                        Exit Function
                    End If
                Next i
            Else
                CanNpcMove = False
            End If
                
        Case DIR_DOWN
            ' Check to make sure not outside of boundries
            If y < MAX_MAPY Then
                n = Map(MapNum).Tile(x, y + 1).Type
                
                ' Check to make sure that the tile is walkable
                If n <> TILE_TYPE_WALKABLE And n <> TILE_TYPE_ITEM Then
                    CanNpcMove = False
                    Exit Function
                End If
                
                ' Check to make sure that there is not a player in the way
                For i = 1 To MAX_PLAYERS
                    If IsPlaying(i) Then
                        If (GetPlayerMap(i) = MapNum) And (GetPlayerX(i) = MapNpc(MapNum, MapNpcNum).x) And (GetPlayerY(i) = MapNpc(MapNum, MapNpcNum).y + 1) Then
                            CanNpcMove = False
                            Exit Function
                        End If
                    End If
                Next i
                
                ' Check to make sure that there is not another npc in the way
                For i = 1 To MAX_MAP_NPCS
                    If (i <> MapNpcNum) And (MapNpc(MapNum, i).Num > 0) And (MapNpc(MapNum, i).x = MapNpc(MapNum, MapNpcNum).x) And (MapNpc(MapNum, i).y = MapNpc(MapNum, MapNpcNum).y + 1) Then
                        CanNpcMove = False
                        Exit Function
                    End If
                Next i
            Else
                CanNpcMove = False
            End If
                
        Case DIR_LEFT
            ' Check to make sure not outside of boundries
            If x > 0 Then
                n = Map(MapNum).Tile(x - 1, y).Type
                
                ' Check to make sure that the tile is walkable
                If n <> TILE_TYPE_WALKABLE And n <> TILE_TYPE_ITEM Then
                    CanNpcMove = False
                    Exit Function
                End If
                
                ' Check to make sure that there is not a player in the way
                For i = 1 To MAX_PLAYERS
                    If IsPlaying(i) Then
                        If (GetPlayerMap(i) = MapNum) And (GetPlayerX(i) = MapNpc(MapNum, MapNpcNum).x - 1) And (GetPlayerY(i) = MapNpc(MapNum, MapNpcNum).y) Then
                            CanNpcMove = False
                            Exit Function
                        End If
                    End If
                Next i
                
                ' Check to make sure that there is not another npc in the way
                For i = 1 To MAX_MAP_NPCS
                    If (i <> MapNpcNum) And (MapNpc(MapNum, i).Num > 0) And (MapNpc(MapNum, i).x = MapNpc(MapNum, MapNpcNum).x - 1) And (MapNpc(MapNum, i).y = MapNpc(MapNum, MapNpcNum).y) Then
                        CanNpcMove = False
                        Exit Function
                    End If
                Next i
            Else
                CanNpcMove = False
            End If
                
        Case DIR_RIGHT
            ' Check to make sure not outside of boundries
            If x < MAX_MAPX Then
                n = Map(MapNum).Tile(x + 1, y).Type
                
                ' Check to make sure that the tile is walkable
                If n <> TILE_TYPE_WALKABLE And n <> TILE_TYPE_ITEM Then
                    CanNpcMove = False
                    Exit Function
                End If
                
                ' Check to make sure that there is not a player in the way
                For i = 1 To MAX_PLAYERS
                    If IsPlaying(i) Then
                        If (GetPlayerMap(i) = MapNum) And (GetPlayerX(i) = MapNpc(MapNum, MapNpcNum).x + 1) And (GetPlayerY(i) = MapNpc(MapNum, MapNpcNum).y) Then
                            CanNpcMove = False
                            Exit Function
                        End If
                    End If
                Next i
                
                ' Check to make sure that there is not another npc in the way
                For i = 1 To MAX_MAP_NPCS
                    If (i <> MapNpcNum) And (MapNpc(MapNum, i).Num > 0) And (MapNpc(MapNum, i).x = MapNpc(MapNum, MapNpcNum).x + 1) And (MapNpc(MapNum, i).y = MapNpc(MapNum, MapNpcNum).y) Then
                        CanNpcMove = False
                        Exit Function
                    End If
                Next i
            Else
                CanNpcMove = False
            End If
    End Select
End Function

Sub NpcMove(ByVal MapNum As Long, ByVal MapNpcNum As Long, ByVal Dir As Long, ByVal Movement As Long)
Dim Packet As String
Dim x As Long
Dim y As Long
Dim i As Long

    ' Check for subscript out of range
    If MapNum <= 0 Or MapNum > MAX_MAPS Or MapNpcNum <= 0 Or MapNpcNum > MAX_MAP_NPCS Or Dir < DIR_UP Or Dir > DIR_RIGHT Or Movement < 1 Or Movement > 2 Then
        Exit Sub
    End If
    
    MapNpc(MapNum, MapNpcNum).Dir = Dir
    
    Select Case Dir
        Case DIR_UP
            MapNpc(MapNum, MapNpcNum).y = MapNpc(MapNum, MapNpcNum).y - 1
            Packet = "NPCMOVE" & SEP_CHAR & MapNpcNum & SEP_CHAR & MapNpc(MapNum, MapNpcNum).x & SEP_CHAR & MapNpc(MapNum, MapNpcNum).y & SEP_CHAR & MapNpc(MapNum, MapNpcNum).Dir & SEP_CHAR & Movement & SEP_CHAR & END_CHAR
            Call SendDataToMap(MapNum, Packet)
    
        Case DIR_DOWN
            MapNpc(MapNum, MapNpcNum).y = MapNpc(MapNum, MapNpcNum).y + 1
            Packet = "NPCMOVE" & SEP_CHAR & MapNpcNum & SEP_CHAR & MapNpc(MapNum, MapNpcNum).x & SEP_CHAR & MapNpc(MapNum, MapNpcNum).y & SEP_CHAR & MapNpc(MapNum, MapNpcNum).Dir & SEP_CHAR & Movement & SEP_CHAR & END_CHAR
            Call SendDataToMap(MapNum, Packet)
    
        Case DIR_LEFT
            MapNpc(MapNum, MapNpcNum).x = MapNpc(MapNum, MapNpcNum).x - 1
            Packet = "NPCMOVE" & SEP_CHAR & MapNpcNum & SEP_CHAR & MapNpc(MapNum, MapNpcNum).x & SEP_CHAR & MapNpc(MapNum, MapNpcNum).y & SEP_CHAR & MapNpc(MapNum, MapNpcNum).Dir & SEP_CHAR & Movement & SEP_CHAR & END_CHAR
            Call SendDataToMap(MapNum, Packet)
    
        Case DIR_RIGHT
            MapNpc(MapNum, MapNpcNum).x = MapNpc(MapNum, MapNpcNum).x + 1
            Packet = "NPCMOVE" & SEP_CHAR & MapNpcNum & SEP_CHAR & MapNpc(MapNum, MapNpcNum).x & SEP_CHAR & MapNpc(MapNum, MapNpcNum).y & SEP_CHAR & MapNpc(MapNum, MapNpcNum).Dir & SEP_CHAR & Movement & SEP_CHAR & END_CHAR
            Call SendDataToMap(MapNum, Packet)
    End Select
End Sub

Sub NpcDir(ByVal MapNum As Long, ByVal MapNpcNum As Long, ByVal Dir As Long)
Dim Packet As String

    ' Check for subscript out of range
    If MapNum <= 0 Or MapNum > MAX_MAPS Or MapNpcNum <= 0 Or MapNpcNum > MAX_MAP_NPCS Or Dir < DIR_UP Or Dir > DIR_RIGHT Then
        Exit Sub
    End If
    
    MapNpc(MapNum, MapNpcNum).Dir = Dir
    Packet = "NPCDIR" & SEP_CHAR & MapNpcNum & SEP_CHAR & Dir & SEP_CHAR & END_CHAR
    Call SendDataToMap(MapNum, Packet)
End Sub

Sub JoinGame(ByVal Index As Long)
    ' Set the flag so we know the person is in the game
    Player(Index).InGame = True
        
    ' Send a global message that he/she joined
    If GetPlayerAccess(Index) <= ADMIN_MONITER Then
        Call GlobalMsg(GetPlayerName(Index) & " has joined " & GAME_NAME & "!", JoinLeftColor)
    Else
        Call GlobalMsg(GetPlayerName(Index) & " has joined " & GAME_NAME & "!", White)
    End If
        
    ' Send an ok to client to start receiving in game data
    Call SendDataTo(Index, "LOGINOK" & SEP_CHAR & Index & SEP_CHAR & END_CHAR)
    
    ' Send some more little goodies, no need to explain these
    Call CheckEquippedItems(Index)
    Call SendClasses(Index)
    Call SendItems(Index)
    Call SendNpcs(Index)
    Call SendShops(Index)
    Call SendSpells(Index)
    Call SendInventory(Index)
    Call SendWornEquipment(Index)
    Call SendHP(Index)
    Call SendMP(Index)
    Call SendSP(Index)
    Call SendStats(Index)
    Call SendWeatherTo(Index)
    Call SendTimeTo(Index)
    
    ' Warp the player to his saved location
    Call PlayerWarp(Index, GetPlayerMap(Index), GetPlayerX(Index), GetPlayerY(Index))
            
    ' Send welcome messages
    Call SendWelcome(Index)

    ' Send the flag so they know they can start doing stuff
    Call SendDataTo(Index, "INGAME" & SEP_CHAR & END_CHAR)
End Sub

Sub LeftGame(ByVal Index As Long)
Dim n As Long

    If Player(Index).InGame = True Then
        Player(Index).InGame = False
        
        ' Check if player was the only player on the map and stop npc processing if so
        If GetTotalMapPlayers(GetPlayerMap(Index)) = 1 Then
            PlayersOnMap(GetPlayerMap(Index)) = NO
        End If
        
        ' Check for boot map
        If Map(GetPlayerMap(Index)).BootMap > 0 Then
            Call SetPlayerX(Index, Map(GetPlayerMap(Index)).BootX)
            Call SetPlayerY(Index, Map(GetPlayerMap(Index)).BootY)
            Call SetPlayerMap(Index, Map(GetPlayerMap(Index)).BootMap)
        End If
        
        ' Check if the player was in a party, and if so cancel it out so the other player doesn't continue to get half exp
        If Player(Index).InParty = YES Then
            n = Player(Index).PartyPlayer
            
            Call PlayerMsg(n, GetPlayerName(Index) & " has left " & GAME_NAME & ", disbanning party.", Pink)
            Player(n).InParty = NO
            Player(n).PartyPlayer = 0
        End If
            
        Call SavePlayer(Index)
    
        ' Send a global message that he/she left
        If GetPlayerAccess(Index) <= ADMIN_MONITER Then
            Call GlobalMsg(GetPlayerName(Index) & " has left " & GAME_NAME & "!", JoinLeftColor)
        Else
            Call GlobalMsg(GetPlayerName(Index) & " has left " & GAME_NAME & "!", White)
        End If
        Call TextAdd(frmServer.txtText, GetPlayerName(Index) & " has disconnected from " & GAME_NAME & ".", True)
        Call SendLeftGame(Index)
    End If
    
    Call ClearPlayer(Index)
End Sub

Function GetTotalMapPlayers(ByVal MapNum As Long) As Long
Dim i As Long, n As Long

    n = 0
    
    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) And GetPlayerMap(i) = MapNum Then
            n = n + 1
        End If
    Next i
    
    GetTotalMapPlayers = n
End Function

Function GetNpcMaxHP(ByVal NpcNum As Long)
Dim x As Long, y As Long

    ' Prevent subscript out of range
    If NpcNum <= 0 Or NpcNum > MAX_NPCS Then
        GetNpcMaxHP = 0
        Exit Function
    End If
    
    x = Npc(NpcNum).STR
    y = Npc(NpcNum).DEF
    GetNpcMaxHP = x * y
End Function

Function GetNpcMaxMP(ByVal NpcNum As Long)
    ' Prevent subscript out of range
    If NpcNum <= 0 Or NpcNum > MAX_NPCS Then
        GetNpcMaxMP = 0
        Exit Function
    End If
        
    GetNpcMaxMP = Npc(NpcNum).MAGI * 2
End Function

Function GetNpcMaxSP(ByVal NpcNum As Long)
    ' Prevent subscript out of range
    If NpcNum <= 0 Or NpcNum > MAX_NPCS Then
        GetNpcMaxSP = 0
        Exit Function
    End If
        
    GetNpcMaxSP = Npc(NpcNum).SPEED * 2
End Function

Function GetPlayerHPRegen(ByVal Index As Long)
Dim i As Long

    ' Prevent subscript out of range
    If IsPlaying(Index) = False Or Index <= 0 Or Index > MAX_PLAYERS Then
        GetPlayerHPRegen = 0
        Exit Function
    End If
    
    i = Int(GetPlayerDEF(Index) / 2)
    If i < 2 Then i = 2
    
    GetPlayerHPRegen = i
End Function

Function GetPlayerMPRegen(ByVal Index As Long)
Dim i As Long

    ' Prevent subscript out of range
    If IsPlaying(Index) = False Or Index <= 0 Or Index > MAX_PLAYERS Then
        GetPlayerMPRegen = 0
        Exit Function
    End If
    
    i = Int(GetPlayerMAGI(Index) / 2)
    If i < 2 Then i = 2
    
    GetPlayerMPRegen = i
End Function

Function GetPlayerSPRegen(ByVal Index As Long)
Dim i As Long

    ' Prevent subscript out of range
    If IsPlaying(Index) = False Or Index <= 0 Or Index > MAX_PLAYERS Then
        GetPlayerSPRegen = 0
        Exit Function
    End If
    
    i = Int(GetPlayerSPEED(Index) / 2)
    If i < 2 Then i = 2
    
    GetPlayerSPRegen = i
End Function

Function GetNpcHPRegen(ByVal NpcNum As Long)
Dim i As Long

    'Prevent subscript out of range
    If NpcNum <= 0 Or NpcNum > MAX_NPCS Then
        GetNpcHPRegen = 0
        Exit Function
    End If
    
    i = Int(Npc(NpcNum).DEF / 3)
    If i < 1 Then i = 1
    
    GetNpcHPRegen = i
End Function

Sub CheckPlayerLevelUp(ByVal Index As Long)
Dim i As Long

    ' Check if attacker got a level up
    If GetPlayerExp(Index) >= GetPlayerNextLevel(Index) Then
        Call SetPlayerLevel(Index, GetPlayerLevel(Index) + 1)
                    
        ' Get the ammount of skill points to add
        i = Int(GetPlayerSPEED(Index) / 10)
        If i < 1 Then i = 1
        If i > 3 Then i = 3
            
        Call SetPlayerPOINTS(Index, GetPlayerPOINTS(Index) + i)
        Call SetPlayerExp(Index, 0)
        Call GlobalMsg(GetPlayerName(Index) & " has gained a level!", Brown)
        Call PlayerMsg(Index, "You have gained a level!  You now have " & GetPlayerPOINTS(Index) & " stat points to distribute.", BrightBlue)
    End If
End Sub

Sub CastSpell(ByVal Index As Long, ByVal SpellSlot As Long)
Dim SpellNum As Long, MPReq As Long, i As Long, n As Long, Damage As Long
Dim Casted As Boolean

    Casted = False
    
    ' Prevent subscript out of range
    If SpellSlot <= 0 Or SpellSlot > MAX_PLAYER_SPELLS Then
        Exit Sub
    End If
    
    SpellNum = GetPlayerSpell(Index, SpellSlot)
    
    ' Make sure player has the spell
    If Not HasSpell(Index, SpellNum) Then
        Call PlayerMsg(Index, "You do not have this spell!", BrightRed)
        Exit Sub
    End If
    
    i = GetSpellReqLevel(Index, SpellNum)
    MPReq = (i + Spell(SpellNum).Data1 + Spell(SpellNum).Data2 + Spell(SpellNum).Data3)
    
    ' Check if they have enough MP
    If GetPlayerMP(Index) < MPReq Then
        Call PlayerMsg(Index, "Not enough mana points!", BrightRed)
        Exit Sub
    End If
        
    ' Make sure they are the right level
    If i > GetPlayerLevel(Index) Then
        Call PlayerMsg(Index, "You must be level " & i & " to cast this spell.", BrightRed)
        Exit Sub
    End If
    
    ' Check if timer is ok
    If GetTickCount < Player(Index).AttackTimer + 1000 Then
        Exit Sub
    End If
    
    ' Check if the spell is a give item and do that instead of a stat modification
    If Spell(SpellNum).Type = SPELL_TYPE_GIVEITEM Then
        n = FindOpenInvSlot(Index, Spell(SpellNum).Data1)
        
        If n > 0 Then
            Call GiveItem(Index, Spell(SpellNum).Data1, Spell(SpellNum).Data2)
            Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " casts " & Trim(Spell(SpellNum).Name) & ".", BrightBlue)
            
            ' Take away the mana points
            Call SetPlayerMP(Index, GetPlayerMP(Index) - MPReq)
            Call SendMP(Index)
            Casted = True
        Else
            Call PlayerMsg(Index, "Your inventory is full!", BrightRed)
        End If
        
        Exit Sub
    End If
        
    n = Player(Index).Target
    
    If Player(Index).TargetType = TARGET_TYPE_PLAYER Then
        If IsPlaying(n) Then
            If GetPlayerHP(n) > 0 And GetPlayerMap(Index) = GetPlayerMap(n) And GetPlayerLevel(Index) >= 10 And GetPlayerLevel(n) >= 10 And Map(GetPlayerMap(Index)).Moral = MAP_MORAL_NONE And GetPlayerAccess(Index) <= 0 And GetPlayerAccess(n) <= 0 Then
'                If GetPlayerLevel(n) + 5 >= GetPlayerLevel(Index) Then
'                    If GetPlayerLevel(n) - 5 <= GetPlayerLevel(Index) Then
                        Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " casts " & Trim(Spell(SpellNum).Name) & " on " & GetPlayerName(n) & ".", BrightBlue)
                
                        Select Case Spell(SpellNum).Type
                            Case SPELL_TYPE_SUBHP
                        
                                Damage = (Int(GetPlayerMAGI(Index) / 4) + Spell(SpellNum).Data1) - GetPlayerProtection(n)
                                If Damage > 0 Then
                                    Call AttackPlayer(Index, n, Damage)
                                Else
                                    Call PlayerMsg(Index, "The spell was to weak to hurt " & GetPlayerName(n) & "!", BrightRed)
                                End If
                    
                            Case SPELL_TYPE_SUBMP
                                Call SetPlayerMP(n, GetPlayerMP(n) - Spell(SpellNum).Data1)
                                Call SendMP(n)
                
                            Case SPELL_TYPE_SUBSP
                                Call SetPlayerSP(n, GetPlayerSP(n) - Spell(SpellNum).Data1)
                                Call SendSP(n)
                        End Select
'                    Else
'                        Call PlayerMsg(Index, GetPlayerName(n) & " is far to powerful to even consider attacking.", BrightBlue)
'                    End If
'                Else
'                    Call PlayerMsg(Index, GetPlayerName(n) & " is to weak to even bother with.", BrightBlue)
'                End If
            
                ' Take away the mana points
                Call SetPlayerMP(Index, GetPlayerMP(Index) - MPReq)
                Call SendMP(Index)
                Casted = True
            Else
                If GetPlayerMap(Index) = GetPlayerMap(n) And Spell(SpellNum).Type >= SPELL_TYPE_ADDHP And Spell(SpellNum).Type <= SPELL_TYPE_ADDSP Then
                    Select Case Spell(SpellNum).Type
                    
                        Case SPELL_TYPE_ADDHP
                            Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " casts " & Trim(Spell(SpellNum).Name) & " on " & GetPlayerName(n) & ".", BrightBlue)
                            Call SetPlayerHP(n, GetPlayerHP(n) + Spell(SpellNum).Data1)
                            Call SendHP(n)
                                    
                        Case SPELL_TYPE_ADDMP
                            Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " casts " & Trim(Spell(SpellNum).Name) & " on " & GetPlayerName(n) & ".", BrightBlue)
                            Call SetPlayerMP(n, GetPlayerMP(n) + Spell(SpellNum).Data1)
                            Call SendMP(n)
                    
                        Case SPELL_TYPE_ADDSP
                            Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " casts " & Trim(Spell(SpellNum).Name) & " on " & GetPlayerName(n) & ".", BrightBlue)
                            Call SetPlayerMP(n, GetPlayerSP(n) + Spell(SpellNum).Data1)
                            Call SendMP(n)
                    End Select
                    
                    ' Take away the mana points
                    Call SetPlayerMP(Index, GetPlayerMP(Index) - MPReq)
                    Call SendMP(Index)
                    Casted = True
                Else
                    Call PlayerMsg(Index, "Could not cast spell!", BrightRed)
                End If
            End If
        Else
            Call PlayerMsg(Index, "Could not cast spell!", BrightRed)
        End If
    Else
        If Npc(MapNpc(GetPlayerMap(Index), n).Num).Behavior <> NPC_BEHAVIOR_FRIENDLY And Npc(MapNpc(GetPlayerMap(Index), n).Num).Behavior <> NPC_BEHAVIOR_SHOPKEEPER Then
            Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " casts " & Trim(Spell(SpellNum).Name) & " on a " & Trim(Npc(MapNpc(GetPlayerMap(Index), n).Num).Name) & ".", BrightBlue)
            
            Select Case Spell(SpellNum).Type
                Case SPELL_TYPE_ADDHP
                    MapNpc(GetPlayerMap(Index), n).HP = MapNpc(GetPlayerMap(Index), n).HP + Spell(SpellNum).Data1
                
                Case SPELL_TYPE_SUBHP
                    
                    Damage = (Int(GetPlayerMAGI(Index) / 4) + Spell(SpellNum).Data1) - Int(Npc(MapNpc(GetPlayerMap(Index), n).Num).DEF / 2)
                    If Damage > 0 Then
                        Call AttackNpc(Index, n, Damage)
                    Else
                        Call PlayerMsg(Index, "The spell was to weak to hurt " & Trim(Npc(MapNpc(GetPlayerMap(Index), n).Num).Name) & "!", BrightRed)
                    End If
                    
                Case SPELL_TYPE_ADDMP
                    MapNpc(GetPlayerMap(Index), n).MP = MapNpc(GetPlayerMap(Index), n).MP + Spell(SpellNum).Data1
                
                Case SPELL_TYPE_SUBMP
                    MapNpc(GetPlayerMap(Index), n).MP = MapNpc(GetPlayerMap(Index), n).MP - Spell(SpellNum).Data1
            
                Case SPELL_TYPE_ADDSP
                    MapNpc(GetPlayerMap(Index), n).SP = MapNpc(GetPlayerMap(Index), n).SP + Spell(SpellNum).Data1
                
                Case SPELL_TYPE_SUBSP
                    MapNpc(GetPlayerMap(Index), n).SP = MapNpc(GetPlayerMap(Index), n).SP - Spell(SpellNum).Data1
            End Select
        
            ' Take away the mana points
            Call SetPlayerMP(Index, GetPlayerMP(Index) - MPReq)
            Call SendMP(Index)
            Casted = True
        Else
            Call PlayerMsg(Index, "Could not cast spell!", BrightRed)
        End If
    End If

    If Casted = True Then
        Player(Index).AttackTimer = GetTickCount
        Player(Index).CastedSpell = YES
    End If
End Sub

Function GetSpellReqLevel(ByVal Index As Long, ByVal SpellNum As Long)
    GetSpellReqLevel = Spell(SpellNum).Data1 - Int(GetClassMAGI(GetPlayerClass(Index)) / 4)
End Function

Function CanPlayerCriticalHit(ByVal Index As Long) As Boolean
Dim i As Long, n As Long

    CanPlayerCriticalHit = False
    
    If GetPlayerWeaponSlot(Index) > 0 Then
        n = Int(Rnd * 2)
        If n = 1 Then
            i = Int(GetPlayerSTR(Index) / 2) + Int(GetPlayerLevel(Index) / 2)
    
            n = Int(Rnd * 100) + 1
            If n <= i Then
                CanPlayerCriticalHit = True
            End If
        End If
    End If
End Function

Function CanPlayerBlockHit(ByVal Index As Long) As Boolean
Dim i As Long, n As Long, ShieldSlot As Long

    CanPlayerBlockHit = False
    
    ShieldSlot = GetPlayerShieldSlot(Index)
    
    If ShieldSlot > 0 Then
        n = Int(Rnd * 2)
        If n = 1 Then
            i = Int(GetPlayerDEF(Index) / 2) + Int(GetPlayerLevel(Index) / 2)
        
            n = Int(Rnd * 100) + 1
            If n <= i Then
                CanPlayerBlockHit = True
            End If
        End If
    End If
End Function

Sub CheckEquippedItems(ByVal Index As Long)
Dim Slot As Long, ItemNum As Long

    ' We want to check incase an admin takes away an object but they had it equipped
    Slot = GetPlayerWeaponSlot(Index)
    If Slot > 0 Then
        ItemNum = GetPlayerInvItemNum(Index, Slot)
        
        If ItemNum > 0 Then
            If Item(ItemNum).Type <> ITEM_TYPE_WEAPON Then
                Call SetPlayerWeaponSlot(Index, 0)
            End If
        Else
            Call SetPlayerWeaponSlot(Index, 0)
        End If
    End If

    Slot = GetPlayerArmorSlot(Index)
    If Slot > 0 Then
        ItemNum = GetPlayerInvItemNum(Index, Slot)
        
        If ItemNum > 0 Then
            If Item(ItemNum).Type <> ITEM_TYPE_ARMOR Then
                Call SetPlayerArmorSlot(Index, 0)
            End If
        Else
            Call SetPlayerArmorSlot(Index, 0)
        End If
    End If

    Slot = GetPlayerHelmetSlot(Index)
    If Slot > 0 Then
        ItemNum = GetPlayerInvItemNum(Index, Slot)
        
        If ItemNum > 0 Then
            If Item(ItemNum).Type <> ITEM_TYPE_HELMET Then
                Call SetPlayerHelmetSlot(Index, 0)
            End If
        Else
            Call SetPlayerHelmetSlot(Index, 0)
        End If
    End If

    Slot = GetPlayerShieldSlot(Index)
    If Slot > 0 Then
        ItemNum = GetPlayerInvItemNum(Index, Slot)
        
        If ItemNum > 0 Then
            If Item(ItemNum).Type <> ITEM_TYPE_SHIELD Then
                Call SetPlayerShieldSlot(Index, 0)
            End If
        Else
            Call SetPlayerShieldSlot(Index, 0)
        End If
    End If
End Sub
