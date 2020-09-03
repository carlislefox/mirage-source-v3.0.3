Attribute VB_Name = "modDatabase"
Option Explicit

Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpString As String, ByVal lpfilename As String) As Long
Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpdefault As String, ByVal lpreturnedstring As String, ByVal nsize As Long, ByVal lpfilename As String) As Long

Public Const START_MAP = 1
Public Const START_X = MAX_MAPX / 2
Public Const START_Y = MAX_MAPY / 2

Public Const ADMIN_LOG = "admin.txt"
Public Const PLAYER_LOG = "player.txt"

Function GetVar(File As String, Header As String, Var As String) As String
Dim sSpaces As String   ' Max string length
Dim szReturn As String  ' Return default value if not found
  
    szReturn = ""
  
    sSpaces = Space(5000)
  
    Call GetPrivateProfileString(Header, Var, szReturn, sSpaces, Len(sSpaces), File)
  
    GetVar = RTrim(sSpaces)
    GetVar = Left(GetVar, Len(GetVar) - 1)
End Function

Sub PutVar(File As String, Header As String, Var As String, Value As String)
    Call WritePrivateProfileString(Header, Var, Value, File)
End Sub

Function FileExist(ByVal FileName As String) As Boolean
    If Dir(App.Path & "\" & FileName) = "" Then
        FileExist = False
    Else
        FileExist = True
    End If
End Function

Sub SavePlayer(ByVal Index As Long)
Dim FileName As String
Dim i As Long
Dim n As Long

    FileName = App.Path & "\accounts\" & Trim(Player(Index).Login) & ".ini"
    
    Call PutVar(FileName, "GENERAL", "Login", Trim(Player(Index).Login))
    Call PutVar(FileName, "GENERAL", "Password", Trim(Player(Index).Password))

    For i = 1 To MAX_CHARS
        ' General
        Call PutVar(FileName, "CHAR" & i, "Name", Trim(Player(Index).Char(i).Name))
        Call PutVar(FileName, "CHAR" & i, "Class", STR(Player(Index).Char(i).Class))
        Call PutVar(FileName, "CHAR" & i, "Sex", STR(Player(Index).Char(i).Sex))
        Call PutVar(FileName, "CHAR" & i, "Sprite", STR(Player(Index).Char(i).Sprite))
        Call PutVar(FileName, "CHAR" & i, "Level", STR(Player(Index).Char(i).Level))
        Call PutVar(FileName, "CHAR" & i, "Exp", STR(Player(Index).Char(i).Exp))
        Call PutVar(FileName, "CHAR" & i, "Access", STR(Player(Index).Char(i).Access))
        Call PutVar(FileName, "CHAR" & i, "PK", STR(Player(Index).Char(i).PK))
        Call PutVar(FileName, "CHAR" & i, "Guild", STR(Player(Index).Char(i).Guild))
        
        ' Vitals
        Call PutVar(FileName, "CHAR" & i, "HP", STR(Player(Index).Char(i).HP))
        Call PutVar(FileName, "CHAR" & i, "MP", STR(Player(Index).Char(i).MP))
        Call PutVar(FileName, "CHAR" & i, "SP", STR(Player(Index).Char(i).SP))
        
        ' Stats
        Call PutVar(FileName, "CHAR" & i, "STR", STR(Player(Index).Char(i).STR))
        Call PutVar(FileName, "CHAR" & i, "DEF", STR(Player(Index).Char(i).DEF))
        Call PutVar(FileName, "CHAR" & i, "SPEED", STR(Player(Index).Char(i).SPEED))
        Call PutVar(FileName, "CHAR" & i, "MAGI", STR(Player(Index).Char(i).MAGI))
        Call PutVar(FileName, "CHAR" & i, "POINTS", STR(Player(Index).Char(i).POINTS))
        
        ' Worn equipment
        Call PutVar(FileName, "CHAR" & i, "ArmorSlot", STR(Player(Index).Char(i).ArmorSlot))
        Call PutVar(FileName, "CHAR" & i, "WeaponSlot", STR(Player(Index).Char(i).WeaponSlot))
        Call PutVar(FileName, "CHAR" & i, "HelmetSlot", STR(Player(Index).Char(i).HelmetSlot))
        Call PutVar(FileName, "CHAR" & i, "ShieldSlot", STR(Player(Index).Char(i).ShieldSlot))
        
        ' Check to make sure that they aren't on map 0, if so reset'm
        If Player(Index).Char(i).Map = 0 Then
            Player(Index).Char(i).Map = START_MAP
            Player(Index).Char(i).x = START_X
            Player(Index).Char(i).y = START_Y
        End If
            
        ' Position
        Call PutVar(FileName, "CHAR" & i, "Map", STR(Player(Index).Char(i).Map))
        Call PutVar(FileName, "CHAR" & i, "X", STR(Player(Index).Char(i).x))
        Call PutVar(FileName, "CHAR" & i, "Y", STR(Player(Index).Char(i).y))
        Call PutVar(FileName, "CHAR" & i, "Dir", STR(Player(Index).Char(i).Dir))
        
        ' Inventory
        For n = 1 To MAX_INV
            Call PutVar(FileName, "CHAR" & i, "InvItemNum" & n, STR(Player(Index).Char(i).Inv(n).Num))
            Call PutVar(FileName, "CHAR" & i, "InvItemVal" & n, STR(Player(Index).Char(i).Inv(n).Value))
            Call PutVar(FileName, "CHAR" & i, "InvItemDur" & n, STR(Player(Index).Char(i).Inv(n).Dur))
        Next n
        
        ' Spells
        For n = 1 To MAX_PLAYER_SPELLS
            Call PutVar(FileName, "CHAR" & i, "Spell" & n, STR(Player(Index).Char(i).Spell(n)))
        Next n
    Next i
End Sub

Sub LoadPlayer(ByVal Index As Long, ByVal Name As String)
Dim FileName As String
Dim i As Long
Dim n As Long

    Call ClearPlayer(Index)
    
    FileName = App.Path & "\accounts\" & Trim(Name) & ".ini"

    Player(Index).Login = GetVar(FileName, "GENERAL", "Login")
    Player(Index).Password = GetVar(FileName, "GENERAL", "Password")

    For i = 1 To MAX_CHARS
        ' General
        Player(Index).Char(i).Name = GetVar(FileName, "CHAR" & i, "Name")
        Player(Index).Char(i).Sex = Val(GetVar(FileName, "CHAR" & i, "Sex"))
        Player(Index).Char(i).Class = Val(GetVar(FileName, "CHAR" & i, "Class"))
        Player(Index).Char(i).Sprite = Val(GetVar(FileName, "CHAR" & i, "Sprite"))
        Player(Index).Char(i).Level = Val(GetVar(FileName, "CHAR" & i, "Level"))
        Player(Index).Char(i).Exp = Val(GetVar(FileName, "CHAR" & i, "Exp"))
        Player(Index).Char(i).Access = Val(GetVar(FileName, "CHAR" & i, "Access"))
        Player(Index).Char(i).PK = Val(GetVar(FileName, "CHAR" & i, "PK"))
        Player(Index).Char(i).Guild = Val(GetVar(FileName, "CHAR" & i, "Guild"))
        
        ' Vitals
        Player(Index).Char(i).HP = Val(GetVar(FileName, "CHAR" & i, "HP"))
        Player(Index).Char(i).MP = Val(GetVar(FileName, "CHAR" & i, "MP"))
        Player(Index).Char(i).SP = Val(GetVar(FileName, "CHAR" & i, "SP"))
        
        ' Stats
        Player(Index).Char(i).STR = Val(GetVar(FileName, "CHAR" & i, "STR"))
        Player(Index).Char(i).DEF = Val(GetVar(FileName, "CHAR" & i, "DEF"))
        Player(Index).Char(i).SPEED = Val(GetVar(FileName, "CHAR" & i, "SPEED"))
        Player(Index).Char(i).MAGI = Val(GetVar(FileName, "CHAR" & i, "MAGI"))
        Player(Index).Char(i).POINTS = Val(GetVar(FileName, "CHAR" & i, "POINTS"))
        
        ' Worn equipment
        Player(Index).Char(i).ArmorSlot = Val(GetVar(FileName, "CHAR" & i, "ArmorSlot"))
        Player(Index).Char(i).WeaponSlot = Val(GetVar(FileName, "CHAR" & i, "WeaponSlot"))
        Player(Index).Char(i).HelmetSlot = Val(GetVar(FileName, "CHAR" & i, "HelmetSlot"))
        Player(Index).Char(i).ShieldSlot = Val(GetVar(FileName, "CHAR" & i, "ShieldSlot"))
        
        ' Position
        Player(Index).Char(i).Map = Val(GetVar(FileName, "CHAR" & i, "Map"))
        Player(Index).Char(i).x = Val(GetVar(FileName, "CHAR" & i, "X"))
        Player(Index).Char(i).y = Val(GetVar(FileName, "CHAR" & i, "Y"))
        Player(Index).Char(i).Dir = Val(GetVar(FileName, "CHAR" & i, "Dir"))
        
        ' Check to make sure that they aren't on map 0, if so reset'm
        If Player(Index).Char(i).Map = 0 Then
            Player(Index).Char(i).Map = START_MAP
            Player(Index).Char(i).x = START_X
            Player(Index).Char(i).y = START_Y
        End If
        
        ' Inventory
        For n = 1 To MAX_INV
            Player(Index).Char(i).Inv(n).Num = Val(GetVar(FileName, "CHAR" & i, "InvItemNum" & n))
            Player(Index).Char(i).Inv(n).Value = Val(GetVar(FileName, "CHAR" & i, "InvItemVal" & n))
            Player(Index).Char(i).Inv(n).Dur = Val(GetVar(FileName, "CHAR" & i, "InvItemDur" & n))
        Next n
        
        ' Spells
        For n = 1 To MAX_PLAYER_SPELLS
            Player(Index).Char(i).Spell(n) = Val(GetVar(FileName, "CHAR" & i, "Spell" & n))
        Next n
    Next i
End Sub

Function AccountExist(ByVal Name As String) As Boolean
Dim FileName As String

    FileName = "accounts\" & Trim(Name) & ".ini"
    
    If FileExist(FileName) Then
        AccountExist = True
    Else
        AccountExist = False
    End If
End Function

Function CharExist(ByVal Index As Long, ByVal CharNum As Long) As Boolean
    If Trim(Player(Index).Char(CharNum).Name) <> "" Then
        CharExist = True
    Else
        CharExist = False
    End If
End Function

Function PasswordOK(ByVal Name As String, ByVal Password As String) As Boolean
Dim FileName As String
Dim RightPassword As String

    PasswordOK = False
    
    If AccountExist(Name) Then
        FileName = App.Path & "\accounts\" & Trim(Name) & ".ini"
        RightPassword = GetVar(FileName, "GENERAL", "Password")
        
        If UCase(Trim(Password)) = UCase(Trim(RightPassword)) Then
            PasswordOK = True
        End If
    End If
End Function

Sub AddAccount(ByVal Index As Long, ByVal Name As String, ByVal Password As String)
Dim i As Long

    Player(Index).Login = Name
    Player(Index).Password = Password
    
    For i = 1 To MAX_CHARS
        Call ClearChar(Index, i)
    Next i
    
    Call SavePlayer(Index)
End Sub

Sub AddChar(ByVal Index As Long, ByVal Name As String, ByVal Sex As Byte, ByVal ClassNum As Byte, ByVal CharNum As Long)
Dim f As Long

    If Trim(Player(Index).Char(CharNum).Name) = "" Then
        Player(Index).CharNum = CharNum
        
        Player(Index).Char(CharNum).Name = Name
        Player(Index).Char(CharNum).Sex = Sex
        Player(Index).Char(CharNum).Class = ClassNum
        
        If Player(Index).Char(CharNum).Sex = SEX_MALE Then
            Player(Index).Char(CharNum).Sprite = Class(ClassNum).Sprite
        Else
            Player(Index).Char(CharNum).Sprite = Class(ClassNum).Sprite
        End If
        
        Player(Index).Char(CharNum).Level = 1
                    
        Player(Index).Char(CharNum).STR = Class(ClassNum).STR
        Player(Index).Char(CharNum).DEF = Class(ClassNum).DEF
        Player(Index).Char(CharNum).SPEED = Class(ClassNum).SPEED
        Player(Index).Char(CharNum).MAGI = Class(ClassNum).MAGI
        
        Player(Index).Char(CharNum).Map = START_MAP
        Player(Index).Char(CharNum).x = START_X
        Player(Index).Char(CharNum).y = START_Y
            
        Player(Index).Char(CharNum).HP = GetPlayerMaxHP(Index)
        Player(Index).Char(CharNum).MP = GetPlayerMaxMP(Index)
        Player(Index).Char(CharNum).SP = GetPlayerMaxSP(Index)
                
        ' Append name to file
        f = FreeFile
        Open App.Path & "\accounts\charlist.txt" For Append As #f
            Print #f, Name
        Close #f
        
        Call SavePlayer(Index)
            
        Exit Sub
    End If
End Sub

Sub DelChar(ByVal Index As Long, ByVal CharNum As Long)
Dim f1 As Long, f2 As Long
Dim s As String

    Call DeleteName(Player(Index).Char(CharNum).Name)
    Call ClearChar(Index, CharNum)
    Call SavePlayer(Index)
End Sub

Function FindChar(ByVal Name As String) As Boolean
Dim f As Long
Dim s As String

    FindChar = False
    
    f = FreeFile
    Open App.Path & "\accounts\charlist.txt" For Input As #f
        Do While Not EOF(f)
            Input #f, s
            
            If Trim(LCase(s)) = Trim(LCase(Name)) Then
                FindChar = True
                Close #f
                Exit Function
            End If
        Loop
    Close #f
End Function

Sub SaveAllPlayersOnline()
Dim i As Long

    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) Then
            Call SavePlayer(i)
        End If
    Next i
End Sub

Sub LoadClasses()
Dim FileName As String
Dim i As Long

    Call CheckClasses
    
    FileName = App.Path & "\classes.ini"
    
    Max_Classes = Val(GetVar(FileName, "INIT", "MaxClasses"))
    
    ReDim Class(0 To Max_Classes) As ClassRec
    
    Call ClearClasses
    
    For i = 0 To Max_Classes
        Class(i).Name = GetVar(FileName, "CLASS" & i, "Name")
        Class(i).Sprite = GetVar(FileName, "CLASS" & i, "Sprite")
        Class(i).STR = Val(GetVar(FileName, "CLASS" & i, "STR"))
        Class(i).DEF = Val(GetVar(FileName, "CLASS" & i, "DEF"))
        Class(i).SPEED = Val(GetVar(FileName, "CLASS" & i, "SPEED"))
        Class(i).MAGI = Val(GetVar(FileName, "CLASS" & i, "MAGI"))
        
        DoEvents
    Next i
End Sub

Sub SaveClasses()
Dim FileName As String
Dim i As Long

    FileName = App.Path & "\classes.ini"
    
    For i = 0 To Max_Classes
        Call PutVar(FileName, "CLASS" & i, "Name", Trim(Class(i).Name))
        Call PutVar(FileName, "CLASS" & i, "Sprite", STR(Class(i).Sprite))
        Call PutVar(FileName, "CLASS" & i, "STR", STR(Class(i).STR))
        Call PutVar(FileName, "CLASS" & i, "DEF", STR(Class(i).DEF))
        Call PutVar(FileName, "CLASS" & i, "SPEED", STR(Class(i).SPEED))
        Call PutVar(FileName, "CLASS" & i, "MAGI", STR(Class(i).MAGI))
    Next i
End Sub

Sub CheckClasses()
    If Not FileExist("classes.ini") Then
        Call SaveClasses
    End If
End Sub

Sub SaveItems()
Dim i As Long
    
    For i = 1 To MAX_ITEMS
        Call SaveItem(i)
    Next i
End Sub

Sub SaveItem(ByVal ItemNum As Long)
Dim FileName As String

    FileName = App.Path & "\items.ini"
    
    Call PutVar(FileName, "ITEM" & ItemNum, "Name", Trim(Item(ItemNum).Name))
    Call PutVar(FileName, "ITEM" & ItemNum, "Pic", Trim(Item(ItemNum).Pic))
    Call PutVar(FileName, "ITEM" & ItemNum, "Type", Trim(Item(ItemNum).Type))
    Call PutVar(FileName, "ITEM" & ItemNum, "Data1", Trim(Item(ItemNum).Data1))
    Call PutVar(FileName, "ITEM" & ItemNum, "Data2", Trim(Item(ItemNum).Data2))
    Call PutVar(FileName, "ITEM" & ItemNum, "Data3", Trim(Item(ItemNum).Data3))
End Sub

Sub LoadItems()
Dim FileName As String
Dim i As Long

    Call CheckItems
    
    FileName = App.Path & "\items.ini"
    
    For i = 1 To MAX_ITEMS
        Item(i).Name = GetVar(FileName, "ITEM" & i, "Name")
        Item(i).Pic = Val(GetVar(FileName, "ITEM" & i, "Pic"))
        Item(i).Type = Val(GetVar(FileName, "ITEM" & i, "Type"))
        Item(i).Data1 = Val(GetVar(FileName, "ITEM" & i, "Data1"))
        Item(i).Data2 = Val(GetVar(FileName, "ITEM" & i, "Data2"))
        Item(i).Data3 = Val(GetVar(FileName, "ITEM" & i, "Data3"))
        
        DoEvents
    Next i
End Sub

Sub CheckItems()
    If Not FileExist("items.ini") Then
        Call SaveItems
    End If
End Sub

Sub SaveShops()
Dim i As Long

    For i = 1 To MAX_SHOPS
        Call SaveShop(i)
    Next i
End Sub

Sub SaveShop(ByVal ShopNum As Long)
Dim FileName As String
Dim i As Long

    FileName = App.Path & "\shops.ini"
    
    Call PutVar(FileName, "SHOP" & ShopNum, "Name", Trim(Shop(ShopNum).Name))
    Call PutVar(FileName, "SHOP" & ShopNum, "JoinSay", Trim(Shop(ShopNum).JoinSay))
    Call PutVar(FileName, "SHOP" & ShopNum, "LeaveSay", Trim(Shop(ShopNum).LeaveSay))
    Call PutVar(FileName, "SHOP" & ShopNum, "FixesItems", Trim(Shop(ShopNum).FixesItems))
    
    For i = 1 To MAX_TRADES
        Call PutVar(FileName, "SHOP" & ShopNum, "GiveItem" & i, Trim(Shop(ShopNum).TradeItem(i).GiveItem))
        Call PutVar(FileName, "SHOP" & ShopNum, "GiveValue" & i, Trim(Shop(ShopNum).TradeItem(i).GiveValue))
        Call PutVar(FileName, "SHOP" & ShopNum, "GetItem" & i, Trim(Shop(ShopNum).TradeItem(i).GetItem))
        Call PutVar(FileName, "SHOP" & ShopNum, "GetValue" & i, Trim(Shop(ShopNum).TradeItem(i).GetValue))
    Next i
End Sub

Sub LoadShops()
On Error Resume Next

Dim FileName As String
Dim x As Long, y As Long

    Call CheckShops
    
    FileName = App.Path & "\shops.ini"
    
    For y = 1 To MAX_SHOPS
        Shop(y).Name = GetVar(FileName, "SHOP" & y, "Name")
        Shop(y).JoinSay = GetVar(FileName, "SHOP" & y, "JoinSay")
        Shop(y).LeaveSay = GetVar(FileName, "SHOP" & y, "LeaveSay")
        Shop(y).FixesItems = GetVar(FileName, "SHOP" & y, "FixesItems")
        
        For x = 1 To MAX_TRADES
            Shop(y).TradeItem(x).GiveItem = GetVar(FileName, "SHOP" & y, "GiveItem" & x)
            Shop(y).TradeItem(x).GiveValue = GetVar(FileName, "SHOP" & y, "GiveValue" & x)
            Shop(y).TradeItem(x).GetItem = GetVar(FileName, "SHOP" & y, "GetItem" & x)
            Shop(y).TradeItem(x).GetValue = GetVar(FileName, "SHOP" & y, "GetValue" & x)
        Next x
    
        DoEvents
    Next y
End Sub

Sub CheckShops()
    If Not FileExist("shops.ini") Then
        Call SaveShops
    End If
End Sub

Sub SaveSpell(ByVal SpellNum As Long)
Dim FileName As String
Dim i As Long

    FileName = App.Path & "\spells.ini"
    
    Call PutVar(FileName, "SPELL" & SpellNum, "Name", Trim(Spell(SpellNum).Name))
    Call PutVar(FileName, "SPELL" & SpellNum, "ClassReq", Trim(Spell(SpellNum).ClassReq))
    Call PutVar(FileName, "SPELL" & SpellNum, "Type", Trim(Spell(SpellNum).Type))
    Call PutVar(FileName, "SPELL" & SpellNum, "Data1", Trim(Spell(SpellNum).Data1))
    Call PutVar(FileName, "SPELL" & SpellNum, "Data2", Trim(Spell(SpellNum).Data2))
    Call PutVar(FileName, "SPELL" & SpellNum, "Data3", Trim(Spell(SpellNum).Data3))
End Sub

Sub SaveSpells()
Dim i As Long

    For i = 1 To MAX_SPELLS
        Call SaveSpell(i)
    Next i
End Sub

Sub LoadSpells()
Dim FileName As String
Dim i As Long

    Call CheckSpells
    
    FileName = App.Path & "\spells.ini"
    
    For i = 1 To MAX_SPELLS
        Spell(i).Name = GetVar(FileName, "SPELL" & i, "Name")
        Spell(i).ClassReq = Val(GetVar(FileName, "SPELL" & i, "ClassReq"))
        Spell(i).Type = Val(GetVar(FileName, "SPELL" & i, "Type"))
        Spell(i).Data1 = Val(GetVar(FileName, "SPELL" & i, "Data1"))
        Spell(i).Data2 = Val(GetVar(FileName, "SPELL" & i, "Data2"))
        Spell(i).Data3 = Val(GetVar(FileName, "SPELL" & i, "Data3"))
        
        DoEvents
    Next i
End Sub

Sub CheckSpells()
    If Not FileExist("spells.ini") Then
        Call SaveSpells
    End If
End Sub

Sub SaveNpcs()
Dim i As Long
    
    For i = 1 To MAX_NPCS
        Call SaveNpc(i)
    Next i
End Sub

Sub SaveNpc(ByVal NpcNum As Long)
Dim FileName As String

    FileName = App.Path & "\npcs.ini"
    
    Call PutVar(FileName, "NPC" & NpcNum, "Name", Trim(Npc(NpcNum).Name))
    Call PutVar(FileName, "NPC" & NpcNum, "AttackSay", Trim(Npc(NpcNum).AttackSay))
    Call PutVar(FileName, "NPC" & NpcNum, "Sprite", Trim(Npc(NpcNum).Sprite))
    Call PutVar(FileName, "NPC" & NpcNum, "SpawnSecs", Trim(Npc(NpcNum).SpawnSecs))
    Call PutVar(FileName, "NPC" & NpcNum, "Behavior", Trim(Npc(NpcNum).Behavior))
    Call PutVar(FileName, "NPC" & NpcNum, "Range", Trim(Npc(NpcNum).Range))
    Call PutVar(FileName, "NPC" & NpcNum, "DropChance", Trim(Npc(NpcNum).DropChance))
    Call PutVar(FileName, "NPC" & NpcNum, "DropItem", Trim(Npc(NpcNum).DropItem))
    Call PutVar(FileName, "NPC" & NpcNum, "DropItemValue", Trim(Npc(NpcNum).DropItemValue))
    Call PutVar(FileName, "NPC" & NpcNum, "STR", Trim(Npc(NpcNum).STR))
    Call PutVar(FileName, "NPC" & NpcNum, "DEF", Trim(Npc(NpcNum).DEF))
    Call PutVar(FileName, "NPC" & NpcNum, "SPEED", Trim(Npc(NpcNum).SPEED))
    Call PutVar(FileName, "NPC" & NpcNum, "MAGI", Trim(Npc(NpcNum).MAGI))
End Sub

Sub LoadNpcs()
On Error Resume Next

Dim FileName As String
Dim i As Long

    Call CheckNpcs
    
    FileName = App.Path & "\npcs.ini"
    
    For i = 1 To MAX_NPCS
        Npc(i).Name = GetVar(FileName, "NPC" & i, "Name")
        Npc(i).AttackSay = GetVar(FileName, "NPC" & i, "AttackSay")
        Npc(i).Sprite = GetVar(FileName, "NPC" & i, "Sprite")
        Npc(i).SpawnSecs = GetVar(FileName, "NPC" & i, "SpawnSecs")
        Npc(i).Behavior = GetVar(FileName, "NPC" & i, "Behavior")
        Npc(i).Range = GetVar(FileName, "NPC" & i, "Range")
        Npc(i).DropChance = GetVar(FileName, "NPC" & i, "DropChance")
        Npc(i).DropItem = GetVar(FileName, "NPC" & i, "DropItem")
        Npc(i).DropItemValue = GetVar(FileName, "NPC" & i, "DropItemValue")
        Npc(i).STR = GetVar(FileName, "NPC" & i, "STR")
        Npc(i).DEF = GetVar(FileName, "NPC" & i, "DEF")
        Npc(i).SPEED = GetVar(FileName, "NPC" & i, "SPEED")
        Npc(i).MAGI = GetVar(FileName, "NPC" & i, "MAGI")
    
        DoEvents
    Next i
End Sub

Sub CheckNpcs()
    If Not FileExist("npcs.ini") Then
        Call SaveNpcs
    End If
End Sub

Sub SaveMap(ByVal MapNum As Long)
Dim FileName As String
Dim f As Long

    FileName = App.Path & "\maps\map" & MapNum & ".dat"
        
    f = FreeFile
    Open FileName For Binary As #f
        Put #f, , Map(MapNum)
    Close #f
End Sub

Sub SaveMaps()
Dim FileName As String
Dim i As Long
Dim f As Long

    For i = 1 To MAX_MAPS
        Call SaveMap(i)
    Next i
End Sub

Sub LoadMaps()
Dim FileName As String
Dim i As Long
Dim f As Long

    Call CheckMaps
    
    For i = 1 To MAX_MAPS
        FileName = App.Path & "\maps\map" & i & ".dat"
        
        f = FreeFile
        Open FileName For Binary As #f
            Get #f, , Map(i)
        Close #f
    
        DoEvents
    Next i
End Sub

Sub ConvertOldMapsToNew()
Dim FileName As String
Dim i As Long
Dim f As Long
Dim x As Long, y As Long
Dim OldMap As OldMapRec
Dim NewMap As MapRec

    For i = 1 To MAX_MAPS
        FileName = App.Path & "\maps\map" & i & ".dat"
        
        ' Get the old file
        f = FreeFile
        Open FileName For Binary As #f
            Get #f, , OldMap
        Close #f
        
        ' Delete the old file
        Call Kill(FileName)
        
        ' Convert
        NewMap.Name = OldMap.Name
        NewMap.Revision = OldMap.Revision + 1
        NewMap.Moral = OldMap.Moral
        NewMap.Up = OldMap.Up
        NewMap.Down = OldMap.Down
        NewMap.Left = OldMap.Left
        NewMap.Right = OldMap.Right
        NewMap.Music = OldMap.Music
        NewMap.BootMap = OldMap.BootMap
        NewMap.BootX = OldMap.BootX
        NewMap.BootY = OldMap.BootY
        NewMap.Shop = OldMap.Shop
        For y = 0 To MAX_MAPY
            For x = 0 To MAX_MAPX
                NewMap.Tile(x, y).Ground = OldMap.Tile(x, y).Ground
                NewMap.Tile(x, y).Mask = OldMap.Tile(x, y).Mask
                NewMap.Tile(x, y).Anim = OldMap.Tile(x, y).Anim
                NewMap.Tile(x, y).Fringe = OldMap.Tile(x, y).Fringe
                NewMap.Tile(x, y).Type = OldMap.Tile(x, y).Type
                NewMap.Tile(x, y).Data1 = OldMap.Tile(x, y).Data1
                NewMap.Tile(x, y).Data2 = OldMap.Tile(x, y).Data2
                NewMap.Tile(x, y).Data3 = OldMap.Tile(x, y).Data3
            Next x
        Next y
        
        For x = 1 To MAX_MAP_NPCS
            NewMap.Npc(x) = OldMap.Npc(x)
        Next x
        
        ' Set new values to 0 or null
        NewMap.Indoors = NO
        
        ' Save the new map
        f = FreeFile
        Open FileName For Binary As #f
            Put #f, , NewMap
        Close #f
    Next i
End Sub

Sub CheckMaps()
Dim FileName As String
Dim x As Long
Dim y As Long
Dim i As Long
Dim n As Long

    Call ClearMaps
        
    For i = 1 To MAX_MAPS
        FileName = "maps\map" & i & ".dat"
        
        ' Check to see if map exists, if it doesn't, create it.
        If Not FileExist(FileName) Then
            Call SaveMap(i)
        End If
    Next i
End Sub

Sub AddLog(ByVal Text As String, ByVal FN As String)
Dim FileName As String
Dim f As Long

    If ServerLog = True Then
        FileName = App.Path & "\" & FN
    
        If Not FileExist(FN) Then
            f = FreeFile
            Open FileName For Output As #f
            Close #f
        End If
    
        f = FreeFile
        Open FileName For Append As #f
            Print #f, Time & ": " & Text
        Close #f
    End If
End Sub

Sub BanIndex(ByVal BanPlayerIndex As Long, ByVal BannedByIndex As Long)
Dim FileName, IP As String
Dim f As Long, i As Long

    FileName = App.Path & "\banlist.txt"
    
    ' Make sure the file exists
    If Not FileExist("banlist.txt") Then
        f = FreeFile
        Open FileName For Output As #f
        Close #f
    End If
    
    ' Cut off last portion of ip
    IP = GetPlayerIP(BanPlayerIndex)
            
    For i = Len(IP) To 1 Step -1
        If Mid(IP, i, 1) = "." Then
            Exit For
        End If
    Next i
    IP = Mid(IP, 1, i)
            
    f = FreeFile
    Open FileName For Append As #f
        Print #f, IP & "," & GetPlayerName(BannedByIndex)
    Close #f
    
    Call GlobalMsg(GetPlayerName(BanPlayerIndex) & " has been banned from " & GAME_NAME & " by " & GetPlayerName(BannedByIndex) & "!", White)
    Call AddLog(GetPlayerName(BannedByIndex) & " has banned " & GetPlayerName(BanPlayerIndex) & ".", ADMIN_LOG)
    Call AlertMsg(BanPlayerIndex, "You have been banned by " & GetPlayerName(BannedByIndex) & "!")
End Sub

Sub DeleteName(ByVal Name As String)
Dim f1 As Long, f2 As Long
Dim s As String

    Call FileCopy(App.Path & "\accounts\charlist.txt", App.Path & "\accounts\chartemp.txt")
    
    ' Destroy name from charlist
    f1 = FreeFile
    Open App.Path & "\accounts\chartemp.txt" For Input As #f1
    f2 = FreeFile
    Open App.Path & "\accounts\charlist.txt" For Output As #f2
        
    Do While Not EOF(f1)
        Input #f1, s
        If Trim(LCase(s)) <> Trim(LCase(Name)) Then
            Print #f2, s
        End If
    Loop
    
    Close #f1
    Close #f2
    
    Call Kill(App.Path & "\accounts\chartemp.txt")
End Sub
