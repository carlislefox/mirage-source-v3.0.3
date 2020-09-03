Attribute VB_Name = "modTypes"
Option Explicit

' Winsock globals
Public Const GAME_PORT = 4000

' General constants
Public Const GAME_NAME = "Mirage Online"
Public Const MAX_PLAYERS = 70
Public Const MAX_ITEMS = 255
Public Const MAX_NPCS = 255
Public Const MAX_INV = 50
Public Const MAX_MAP_ITEMS = 20
Public Const MAX_MAP_NPCS = 5
Public Const MAX_SHOPS = 255
Public Const MAX_PLAYER_SPELLS = 20
Public Const MAX_SPELLS = 255
Public Const MAX_TRADES = 8
Public Const MAX_GUILDS = 20
Public Const MAX_GUILD_MEMBERS = 10

Public Const NO = 0
Public Const YES = 1

' Account constants
Public Const NAME_LENGTH = 20
Public Const MAX_CHARS = 3

' Sex constants
Public Const SEX_MALE = 0
Public Const SEX_FEMALE = 1

' Map constants
Public Const MAX_MAPS = 1000
Public Const MAX_MAPX = 15
Public Const MAX_MAPY = 11
Public Const MAP_MORAL_NONE = 0
Public Const MAP_MORAL_SAFE = 1

' Image constants
Public Const PIC_X = 32
Public Const PIC_Y = 32

' Tile consants
Public Const TILE_TYPE_WALKABLE = 0
Public Const TILE_TYPE_BLOCKED = 1
Public Const TILE_TYPE_WARP = 2
Public Const TILE_TYPE_ITEM = 3
Public Const TILE_TYPE_NPCAVOID = 4
Public Const TILE_TYPE_KEY = 5
Public Const TILE_TYPE_KEYOPEN = 6

' Item constants
Public Const ITEM_TYPE_NONE = 0
Public Const ITEM_TYPE_WEAPON = 1
Public Const ITEM_TYPE_ARMOR = 2
Public Const ITEM_TYPE_HELMET = 3
Public Const ITEM_TYPE_SHIELD = 4
Public Const ITEM_TYPE_POTIONADDHP = 5
Public Const ITEM_TYPE_POTIONADDMP = 6
Public Const ITEM_TYPE_POTIONADDSP = 7
Public Const ITEM_TYPE_POTIONSUBHP = 8
Public Const ITEM_TYPE_POTIONSUBMP = 9
Public Const ITEM_TYPE_POTIONSUBSP = 10
Public Const ITEM_TYPE_KEY = 11
Public Const ITEM_TYPE_CURRENCY = 12
Public Const ITEM_TYPE_SPELL = 13

' Direction constants
Public Const DIR_UP = 0
Public Const DIR_DOWN = 1
Public Const DIR_LEFT = 2
Public Const DIR_RIGHT = 3

' Constants for player movement
Public Const MOVING_WALKING = 1
Public Const MOVING_RUNNING = 2

' Weather constants
Public Const WEATHER_NONE = 0
Public Const WEATHER_RAINING = 1
Public Const WEATHER_SNOWING = 2

' Time constants
Public Const TIME_DAY = 0
Public Const TIME_NIGHT = 1

' Admin constants
Public Const ADMIN_MONITER = 1
Public Const ADMIN_MAPPER = 2
Public Const ADMIN_DEVELOPER = 3
Public Const ADMIN_CREATOR = 4

' NPC constants
Public Const NPC_BEHAVIOR_ATTACKONSIGHT = 0
Public Const NPC_BEHAVIOR_ATTACKWHENATTACKED = 1
Public Const NPC_BEHAVIOR_FRIENDLY = 2
Public Const NPC_BEHAVIOR_SHOPKEEPER = 3
Public Const NPC_BEHAVIOR_GUARD = 4

' Spell constants
Public Const SPELL_TYPE_ADDHP = 0
Public Const SPELL_TYPE_ADDMP = 1
Public Const SPELL_TYPE_ADDSP = 2
Public Const SPELL_TYPE_SUBHP = 3
Public Const SPELL_TYPE_SUBMP = 4
Public Const SPELL_TYPE_SUBSP = 5
Public Const SPELL_TYPE_GIVEITEM = 6

' Target type constants
Public Const TARGET_TYPE_PLAYER = 0
Public Const TARGET_TYPE_NPC = 1

Type PlayerInvRec
    Num As Byte
    Value As Long
    Dur As Integer
End Type

Type PlayerRec
    ' General
    Name As String * NAME_LENGTH
    Sex As Byte
    Class As Byte
    Sprite As Integer
    Level As Byte
    Exp As Long
    Access As Byte
    PK As Byte
    Guild As Byte
    
    ' Vitals
    HP As Long
    MP As Long
    SP As Long
    
    ' Stats
    STR As Byte
    DEF As Byte
    SPEED As Byte
    MAGI As Byte
    POINTS As Byte
    
    ' Worn equipment
    ArmorSlot As Byte
    WeaponSlot As Byte
    HelmetSlot As Byte
    ShieldSlot As Byte
    
    ' Inventory
    Inv(1 To MAX_INV) As PlayerInvRec
    Spell(1 To MAX_PLAYER_SPELLS) As Byte
    
    ' Position
    Map As Integer
    x As Byte
    y As Byte
    Dir As Byte
End Type
    
Type AccountRec
    ' Account
    Login As String * NAME_LENGTH
    Password As String * NAME_LENGTH
       
    ' Characters (we use 0 to prevent a crash that still needs to be figured out)
    Char(0 To MAX_CHARS) As PlayerRec
    
    ' None saved local vars
    Buffer As String
    IncBuffer As String
    CharNum As Byte
    InGame As Boolean
    AttackTimer As Long
    DataTimer As Long
    DataBytes As Long
    DataPackets As Long
    PartyPlayer As Long
    InParty As Byte
    TargetType As Byte
    Target As Byte
    CastedSpell As Byte
    PartyStarter As Byte
    GettingMap As Byte
End Type

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

Type OldMapRec
    Name As String * NAME_LENGTH
    Revision As Long
    Moral As Byte
    Up As Integer
    Down As Integer
    Left As Integer
    Right As Integer
    Music As Byte
    BootMap As Integer
    BootX As Byte
    BootY As Byte
    Shop As Byte
    Tile(0 To MAX_MAPX, 0 To MAX_MAPY) As TileRec
    Npc(1 To MAX_MAP_NPCS) As Byte
End Type

Type MapRec
    Name As String * NAME_LENGTH
    Revision As Long
    Moral As Byte
    Up As Integer
    Down As Integer
    Left As Integer
    Right As Integer
    Music As Byte
    BootMap As Integer
    BootX As Byte
    BootY As Byte
    Shop As Byte
    Indoors As Byte
    Tile(0 To MAX_MAPX, 0 To MAX_MAPY) As TileRec
    Npc(1 To MAX_MAP_NPCS) As Byte
End Type

Type ClassRec
    Name As String * NAME_LENGTH
    
    Sprite As Integer
    
    STR As Byte
    DEF As Byte
    SPEED As Byte
    MAGI As Byte
End Type

Type ItemRec
    Name As String * NAME_LENGTH
    
    Pic As Integer
    Type As Byte
    Data1 As Integer
    Data2 As Integer
    Data3 As Integer
End Type

Type MapItemRec
    Num As Byte
    Value As Long
    Dur As Integer
    
    x As Byte
    y As Byte
End Type

Type NpcRec
    Name As String * NAME_LENGTH
    AttackSay As String * 255
    
    Sprite As Integer
    SpawnSecs As Long
    Behavior As Byte
    Range As Byte
    
    DropChance As Integer
    DropItem As Byte
    DropItemValue As Integer
    
    STR  As Byte
    DEF As Byte
    SPEED As Byte
    MAGI As Byte
End Type

Type MapNpcRec
    Num As Integer
    
    Target As Integer
    
    HP As Long
    MP As Long
    SP As Long
        
    x As Byte
    y As Byte
    Dir As Integer
    
    ' For server use only
    SpawnWait As Long
    AttackTimer As Long
End Type

Type TradeItemRec
    GiveItem As Long
    GiveValue As Long
    GetItem As Long
    GetValue As Long
End Type

Type ShopRec
    Name As String * NAME_LENGTH
    JoinSay As String * 255
    LeaveSay As String * 255
    FixesItems As Byte
    TradeItem(1 To MAX_TRADES) As TradeItemRec
End Type
    
Type SpellRec
    Name As String * NAME_LENGTH
    ClassReq As Byte
    LevelReq As Byte
    Type As Byte
    Data1 As Integer
    Data2 As Integer
    Data3 As Integer
End Type

Type TempTileRec
    DoorOpen(0 To MAX_MAPX, 0 To MAX_MAPY)  As Byte
    DoorTimer As Long
End Type

Type GuildRec
    Name As String * NAME_LENGTH
    Founder As String * NAME_LENGTH
    Member(1 To MAX_GUILD_MEMBERS) As String * NAME_LENGTH
End Type

' Used for parsing
Public SEP_CHAR As String * 1
Public END_CHAR As String * 1

' Maximum classes
Public Max_Classes As Byte

Public Map(1 To MAX_MAPS) As MapRec
Public TempTile(1 To MAX_MAPS) As TempTileRec
Public PlayersOnMap(1 To MAX_MAPS) As Long
Public Player(1 To MAX_PLAYERS) As AccountRec
Public Class() As ClassRec
Public Item(0 To MAX_ITEMS) As ItemRec
Public Npc(0 To MAX_NPCS) As NpcRec
Public MapItem(1 To MAX_MAPS, 1 To MAX_MAP_ITEMS) As MapItemRec
Public MapNpc(1 To MAX_MAPS, 1 To MAX_MAP_NPCS) As MapNpcRec
Public Shop(1 To MAX_SHOPS) As ShopRec
Public Spell(1 To MAX_SPELLS) As SpellRec
Public Guild(1 To MAX_GUILDS) As GuildRec

Sub ClearTempTile()
Dim i As Long, y As Long, x As Long

    For i = 1 To MAX_MAPS
        TempTile(i).DoorTimer = 0
        
        For y = 0 To MAX_MAPY
            For x = 0 To MAX_MAPX
                TempTile(i).DoorOpen(x, y) = NO
            Next x
        Next y
    Next i
End Sub

Sub ClearClasses()
Dim i As Long

    For i = 0 To Max_Classes
        Class(i).Name = ""
        Class(i).STR = 0
        Class(i).DEF = 0
        Class(i).SPEED = 0
        Class(i).MAGI = 0
    Next i
End Sub

Sub ClearPlayer(ByVal Index As Long)
Dim i As Long
Dim n As Long

    Player(Index).Login = ""
    Player(Index).Password = ""
    
    For i = 1 To MAX_CHARS
        Player(Index).Char(i).Name = ""
        Player(Index).Char(i).Class = 0
        Player(Index).Char(i).Level = 0
        Player(Index).Char(i).Sprite = 0
        Player(Index).Char(i).Exp = 0
        Player(Index).Char(i).Access = 0
        Player(Index).Char(i).PK = NO
        Player(Index).Char(i).POINTS = 0
        Player(Index).Char(i).Guild = 0
        
        Player(Index).Char(i).HP = 0
        Player(Index).Char(i).MP = 0
        Player(Index).Char(i).SP = 0
        
        Player(Index).Char(i).STR = 0
        Player(Index).Char(i).DEF = 0
        Player(Index).Char(i).SPEED = 0
        Player(Index).Char(i).MAGI = 0
        
        For n = 1 To MAX_INV
            Player(Index).Char(i).Inv(n).Num = 0
            Player(Index).Char(i).Inv(n).Value = 0
            Player(Index).Char(i).Inv(n).Dur = 0
        Next n
        
        For n = 1 To MAX_PLAYER_SPELLS
            Player(Index).Char(i).Spell(n) = 0
        Next n
        
        Player(Index).Char(i).ArmorSlot = 0
        Player(Index).Char(i).WeaponSlot = 0
        Player(Index).Char(i).HelmetSlot = 0
        Player(Index).Char(i).ShieldSlot = 0
        
        Player(Index).Char(i).Map = 0
        Player(Index).Char(i).x = 0
        Player(Index).Char(i).y = 0
        Player(Index).Char(i).Dir = 0
        
        ' Temporary vars
        Player(Index).Buffer = ""
        Player(Index).IncBuffer = ""
        Player(Index).CharNum = 0
        Player(Index).InGame = False
        Player(Index).AttackTimer = 0
        Player(Index).DataTimer = 0
        Player(Index).DataBytes = 0
        Player(Index).DataPackets = 0
        Player(Index).PartyPlayer = 0
        Player(Index).InParty = 0
        Player(Index).Target = 0
        Player(Index).TargetType = 0
        Player(Index).CastedSpell = NO
        Player(Index).PartyStarter = NO
        Player(Index).GettingMap = NO
    Next i
End Sub

Sub ClearChar(ByVal Index As Long, ByVal CharNum As Long)
Dim n As Long
    
    Player(Index).Char(CharNum).Name = ""
    Player(Index).Char(CharNum).Class = 0
    Player(Index).Char(CharNum).Sprite = 0
    Player(Index).Char(CharNum).Level = 0
    Player(Index).Char(CharNum).Exp = 0
    Player(Index).Char(CharNum).Access = 0
    Player(Index).Char(CharNum).PK = NO
    Player(Index).Char(CharNum).POINTS = 0
    Player(Index).Char(CharNum).Guild = 0
    
    Player(Index).Char(CharNum).HP = 0
    Player(Index).Char(CharNum).MP = 0
    Player(Index).Char(CharNum).SP = 0
    
    Player(Index).Char(CharNum).STR = 0
    Player(Index).Char(CharNum).DEF = 0
    Player(Index).Char(CharNum).SPEED = 0
    Player(Index).Char(CharNum).MAGI = 0
    
    For n = 1 To MAX_INV
        Player(Index).Char(CharNum).Inv(n).Num = 0
        Player(Index).Char(CharNum).Inv(n).Value = 0
        Player(Index).Char(CharNum).Inv(n).Dur = 0
    Next n
    
    For n = 1 To MAX_PLAYER_SPELLS
        Player(Index).Char(CharNum).Spell(n) = 0
    Next n
    
    Player(Index).Char(CharNum).ArmorSlot = 0
    Player(Index).Char(CharNum).WeaponSlot = 0
    Player(Index).Char(CharNum).HelmetSlot = 0
    Player(Index).Char(CharNum).ShieldSlot = 0
    
    Player(Index).Char(CharNum).Map = 0
    Player(Index).Char(CharNum).x = 0
    Player(Index).Char(CharNum).y = 0
    Player(Index).Char(CharNum).Dir = 0
End Sub
    
Sub ClearItem(ByVal Index As Long)
    Item(Index).Name = ""
    
    Item(Index).Type = 0
    Item(Index).Data1 = 0
    Item(Index).Data2 = 0
    Item(Index).Data3 = 0
End Sub

Sub ClearItems()
Dim i As Long

    For i = 1 To MAX_ITEMS
        Call ClearItem(i)
    Next i
End Sub

Sub ClearNpc(ByVal Index As Long)
    Npc(Index).Name = ""
    Npc(Index).AttackSay = ""
    Npc(Index).Sprite = 0
    Npc(Index).SpawnSecs = 0
    Npc(Index).Behavior = 0
    Npc(Index).Range = 0
    Npc(Index).DropChance = 0
    Npc(Index).DropItem = 0
    Npc(Index).DropItemValue = 0
    Npc(Index).STR = 0
    Npc(Index).DEF = 0
    Npc(Index).SPEED = 0
    Npc(Index).MAGI = 0
End Sub

Sub ClearNpcs()
Dim i As Long

    For i = 1 To MAX_NPCS
        Call ClearNpc(i)
    Next i
End Sub

Sub ClearMapItem(ByVal Index As Long, ByVal MapNum As Long)
    MapItem(MapNum, Index).Num = 0
    MapItem(MapNum, Index).Value = 0
    MapItem(MapNum, Index).Dur = 0
    MapItem(MapNum, Index).x = 0
    MapItem(MapNum, Index).y = 0
End Sub

Sub ClearMapItems()
Dim x As Long
Dim y As Long

    For y = 1 To MAX_MAPS
        For x = 1 To MAX_MAP_ITEMS
            Call ClearMapItem(x, y)
        Next x
    Next y
End Sub

Sub ClearMapNpc(ByVal Index As Long, ByVal MapNum As Long)
    MapNpc(MapNum, Index).Num = 0
    MapNpc(MapNum, Index).Target = 0
    MapNpc(MapNum, Index).HP = 0
    MapNpc(MapNum, Index).MP = 0
    MapNpc(MapNum, Index).SP = 0
    MapNpc(MapNum, Index).x = 0
    MapNpc(MapNum, Index).y = 0
    MapNpc(MapNum, Index).Dir = 0
    
    ' Server use only
    MapNpc(MapNum, Index).SpawnWait = 0
    MapNpc(MapNum, Index).AttackTimer = 0
End Sub

Sub ClearMapNpcs()
Dim x As Long
Dim y As Long

    For y = 1 To MAX_MAPS
        For x = 1 To MAX_MAP_NPCS
            Call ClearMapNpc(x, y)
        Next x
    Next y
End Sub

Sub ClearMap(ByVal MapNum As Long)
Dim i As Long
Dim x As Long
Dim y As Long

    Map(MapNum).Name = ""
    Map(MapNum).Revision = 0
    Map(MapNum).Moral = 0
    Map(MapNum).Up = 0
    Map(MapNum).Down = 0
    Map(MapNum).Left = 0
    Map(MapNum).Right = 0
        
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
    
    ' Reset the values for if a player is on the map or not
    PlayersOnMap(MapNum) = NO
End Sub

Sub ClearMaps()
Dim i As Long

    For i = 1 To MAX_MAPS
        Call ClearMap(i)
    Next i
End Sub

Sub ClearShop(ByVal Index As Long)
Dim i As Long

    Shop(Index).Name = ""
    Shop(Index).JoinSay = ""
    Shop(Index).LeaveSay = ""
    
    For i = 1 To MAX_TRADES
        Shop(Index).TradeItem(i).GiveItem = 0
        Shop(Index).TradeItem(i).GiveValue = 0
        Shop(Index).TradeItem(i).GetItem = 0
        Shop(Index).TradeItem(i).GetValue = 0
    Next i
End Sub

Sub ClearShops()
Dim i As Long

    For i = 1 To MAX_SHOPS
        Call ClearShop(i)
    Next i
End Sub

Sub ClearSpell(ByVal Index As Long)
    Spell(Index).Name = ""
    Spell(Index).ClassReq = 0
    Spell(Index).LevelReq = 0
    Spell(Index).Type = 0
    Spell(Index).Data1 = 0
    Spell(Index).Data2 = 0
    Spell(Index).Data3 = 0
End Sub

Sub ClearSpells()
Dim i As Long

    For i = 1 To MAX_SPELLS
        Call ClearSpell(i)
    Next i
End Sub




' //////////////////////
' // PLAYER FUNCTIONS //
' //////////////////////

Function GetPlayerLogin(ByVal Index As Long) As String
    GetPlayerLogin = Trim(Player(Index).Login)
End Function

Sub SetPlayerLogin(ByVal Index As Long, ByVal Login As String)
    Player(Index).Login = Login
End Sub

Function GetPlayerPassword(ByVal Index As Long) As String
    GetPlayerPassword = Trim(Player(Index).Password)
End Function

Sub SetPlayerPassword(ByVal Index As Long, ByVal Password As String)
    Player(Index).Password = Password
End Sub

Function GetPlayerName(ByVal Index As Long) As String
    GetPlayerName = Trim(Player(Index).Char(Player(Index).CharNum).Name)
End Function

Sub SetPlayerName(ByVal Index As Long, ByVal Name As String)
    Player(Index).Char(Player(Index).CharNum).Name = Name
End Sub

Function GetPlayerClass(ByVal Index As Long) As Long
    GetPlayerClass = Player(Index).Char(Player(Index).CharNum).Class
End Function

Sub SetPlayerClass(ByVal Index As Long, ByVal ClassNum As Long)
    Player(Index).Char(Player(Index).CharNum).Class = ClassNum
End Sub

Function GetPlayerSprite(ByVal Index As Long) As Long
    GetPlayerSprite = Player(Index).Char(Player(Index).CharNum).Sprite
End Function

Sub SetPlayerSprite(ByVal Index As Long, ByVal Sprite As Long)
    Player(Index).Char(Player(Index).CharNum).Sprite = Sprite
End Sub

Function GetPlayerLevel(ByVal Index As Long) As Long
    GetPlayerLevel = Player(Index).Char(Player(Index).CharNum).Level
End Function

Sub SetPlayerLevel(ByVal Index As Long, ByVal Level As Long)
    Player(Index).Char(Player(Index).CharNum).Level = Level
End Sub

Function GetPlayerNextLevel(ByVal Index As Long) As Long
    GetPlayerNextLevel = (GetPlayerLevel(Index) + 1) * (GetPlayerSTR(Index) + GetPlayerDEF(Index) + GetPlayerMAGI(Index) + GetPlayerSPEED(Index) + GetPlayerPOINTS(Index)) * 25
End Function

Function GetPlayerExp(ByVal Index As Long) As Long
    GetPlayerExp = Player(Index).Char(Player(Index).CharNum).Exp
End Function

Sub SetPlayerExp(ByVal Index As Long, ByVal Exp As Long)
    Player(Index).Char(Player(Index).CharNum).Exp = Exp
End Sub

Function GetPlayerAccess(ByVal Index As Long) As Long
    GetPlayerAccess = Player(Index).Char(Player(Index).CharNum).Access
End Function

Sub SetPlayerAccess(ByVal Index As Long, ByVal Access As Long)
    Player(Index).Char(Player(Index).CharNum).Access = Access
End Sub

Function GetPlayerPK(ByVal Index As Long) As Long
    GetPlayerPK = Player(Index).Char(Player(Index).CharNum).PK
End Function

Sub SetPlayerPK(ByVal Index As Long, ByVal PK As Long)
    Player(Index).Char(Player(Index).CharNum).PK = PK
End Sub

Function GetPlayerHP(ByVal Index As Long) As Long
    GetPlayerHP = Player(Index).Char(Player(Index).CharNum).HP
End Function

Sub SetPlayerHP(ByVal Index As Long, ByVal HP As Long)
    Player(Index).Char(Player(Index).CharNum).HP = HP
    
    If GetPlayerHP(Index) > GetPlayerMaxHP(Index) Then
        Player(Index).Char(Player(Index).CharNum).HP = GetPlayerMaxHP(Index)
    End If
    If GetPlayerHP(Index) < 0 Then
        Player(Index).Char(Player(Index).CharNum).HP = 0
    End If
End Sub

Function GetPlayerMP(ByVal Index As Long) As Long
    GetPlayerMP = Player(Index).Char(Player(Index).CharNum).MP
End Function

Sub SetPlayerMP(ByVal Index As Long, ByVal MP As Long)
    Player(Index).Char(Player(Index).CharNum).MP = MP

    If GetPlayerMP(Index) > GetPlayerMaxMP(Index) Then
        Player(Index).Char(Player(Index).CharNum).MP = GetPlayerMaxMP(Index)
    End If
    If GetPlayerMP(Index) < 0 Then
        Player(Index).Char(Player(Index).CharNum).MP = 0
    End If
End Sub

Function GetPlayerSP(ByVal Index As Long) As Long
    GetPlayerSP = Player(Index).Char(Player(Index).CharNum).SP
End Function

Sub SetPlayerSP(ByVal Index As Long, ByVal SP As Long)
    Player(Index).Char(Player(Index).CharNum).SP = SP

    If GetPlayerSP(Index) > GetPlayerMaxSP(Index) Then
        Player(Index).Char(Player(Index).CharNum).SP = GetPlayerMaxSP(Index)
    End If
    If GetPlayerSP(Index) < 0 Then
        Player(Index).Char(Player(Index).CharNum).SP = 0
    End If
End Sub

Function GetPlayerMaxHP(ByVal Index As Long) As Long
Dim CharNum As Long
Dim i As Long

    CharNum = Player(Index).CharNum
    GetPlayerMaxHP = (Player(Index).Char(CharNum).Level + Int(GetPlayerSTR(Index) / 2) + Class(Player(Index).Char(CharNum).Class).STR) * 2
End Function

Function GetPlayerMaxMP(ByVal Index As Long) As Long
Dim CharNum As Long

    CharNum = Player(Index).CharNum
    GetPlayerMaxMP = (Player(Index).Char(CharNum).Level + Int(GetPlayerMAGI(Index) / 2) + Class(Player(Index).Char(CharNum).Class).MAGI) * 2
End Function

Function GetPlayerMaxSP(ByVal Index As Long) As Long
Dim CharNum As Long

    CharNum = Player(Index).CharNum
    GetPlayerMaxSP = (Player(Index).Char(CharNum).Level + Int(GetPlayerSPEED(Index) / 2) + Class(Player(Index).Char(CharNum).Class).SPEED) * 2
End Function

Function GetClassName(ByVal ClassNum As Long) As String
    GetClassName = Trim(Class(ClassNum).Name)
End Function

Function GetClassMaxHP(ByVal ClassNum As Long) As Long
    GetClassMaxHP = (1 + Int(Class(ClassNum).STR / 2) + Class(ClassNum).STR) * 2
End Function

Function GetClassMaxMP(ByVal ClassNum As Long) As Long
    GetClassMaxMP = (1 + Int(Class(ClassNum).MAGI / 2) + Class(ClassNum).MAGI) * 2
End Function

Function GetClassMaxSP(ByVal ClassNum As Long) As Long
    GetClassMaxSP = (1 + Int(Class(ClassNum).SPEED / 2) + Class(ClassNum).SPEED) * 2
End Function

Function GetClassSTR(ByVal ClassNum As Long) As Long
    GetClassSTR = Class(ClassNum).STR
End Function

Function GetClassDEF(ByVal ClassNum As Long) As Long
    GetClassDEF = Class(ClassNum).DEF
End Function

Function GetClassSPEED(ByVal ClassNum As Long) As Long
    GetClassSPEED = Class(ClassNum).SPEED
End Function

Function GetClassMAGI(ByVal ClassNum As Long) As Long
    GetClassMAGI = Class(ClassNum).MAGI
End Function

Function GetPlayerSTR(ByVal Index As Long) As Long
    GetPlayerSTR = Player(Index).Char(Player(Index).CharNum).STR
End Function

Sub SetPlayerSTR(ByVal Index As Long, ByVal STR As Long)
    Player(Index).Char(Player(Index).CharNum).STR = STR
End Sub

Function GetPlayerDEF(ByVal Index As Long) As Long
    GetPlayerDEF = Player(Index).Char(Player(Index).CharNum).DEF
End Function

Sub SetPlayerDEF(ByVal Index As Long, ByVal DEF As Long)
    Player(Index).Char(Player(Index).CharNum).DEF = DEF
End Sub

Function GetPlayerSPEED(ByVal Index As Long) As Long
    GetPlayerSPEED = Player(Index).Char(Player(Index).CharNum).SPEED
End Function

Sub SetPlayerSPEED(ByVal Index As Long, ByVal SPEED As Long)
    Player(Index).Char(Player(Index).CharNum).SPEED = SPEED
End Sub

Function GetPlayerMAGI(ByVal Index As Long) As Long
    GetPlayerMAGI = Player(Index).Char(Player(Index).CharNum).MAGI
End Function

Sub SetPlayerMAGI(ByVal Index As Long, ByVal MAGI As Long)
    Player(Index).Char(Player(Index).CharNum).MAGI = MAGI
End Sub

Function GetPlayerPOINTS(ByVal Index As Long) As Long
    GetPlayerPOINTS = Player(Index).Char(Player(Index).CharNum).POINTS
End Function

Sub SetPlayerPOINTS(ByVal Index As Long, ByVal POINTS As Long)
    Player(Index).Char(Player(Index).CharNum).POINTS = POINTS
End Sub

Function GetPlayerMap(ByVal Index As Long) As Long
    GetPlayerMap = Player(Index).Char(Player(Index).CharNum).Map
End Function

Sub SetPlayerMap(ByVal Index As Long, ByVal MapNum As Long)
    If MapNum > 0 And MapNum <= MAX_MAPS Then
        Player(Index).Char(Player(Index).CharNum).Map = MapNum
    End If
End Sub

Function GetPlayerX(ByVal Index As Long) As Long
    GetPlayerX = Player(Index).Char(Player(Index).CharNum).x
End Function

Sub SetPlayerX(ByVal Index As Long, ByVal x As Long)
    Player(Index).Char(Player(Index).CharNum).x = x
End Sub

Function GetPlayerY(ByVal Index As Long) As Long
    GetPlayerY = Player(Index).Char(Player(Index).CharNum).y
End Function

Sub SetPlayerY(ByVal Index As Long, ByVal y As Long)
    Player(Index).Char(Player(Index).CharNum).y = y
End Sub

Function GetPlayerDir(ByVal Index As Long) As Long
    GetPlayerDir = Player(Index).Char(Player(Index).CharNum).Dir
End Function

Sub SetPlayerDir(ByVal Index As Long, ByVal Dir As Long)
    Player(Index).Char(Player(Index).CharNum).Dir = Dir
End Sub

Function GetPlayerIP(ByVal Index As Long) As String
    GetPlayerIP = frmServer.Socket(Index).RemoteHostIP
End Function

Function GetPlayerInvItemNum(ByVal Index As Long, ByVal InvSlot As Long) As Long
    GetPlayerInvItemNum = Player(Index).Char(Player(Index).CharNum).Inv(InvSlot).Num
End Function

Sub SetPlayerInvItemNum(ByVal Index As Long, ByVal InvSlot As Long, ByVal ItemNum As Long)
    Player(Index).Char(Player(Index).CharNum).Inv(InvSlot).Num = ItemNum
End Sub

Function GetPlayerInvItemValue(ByVal Index As Long, ByVal InvSlot As Long) As Long
    GetPlayerInvItemValue = Player(Index).Char(Player(Index).CharNum).Inv(InvSlot).Value
End Function

Sub SetPlayerInvItemValue(ByVal Index As Long, ByVal InvSlot As Long, ByVal ItemValue As Long)
    Player(Index).Char(Player(Index).CharNum).Inv(InvSlot).Value = ItemValue
End Sub

Function GetPlayerInvItemDur(ByVal Index As Long, ByVal InvSlot As Long) As Long
    GetPlayerInvItemDur = Player(Index).Char(Player(Index).CharNum).Inv(InvSlot).Dur
End Function

Sub SetPlayerInvItemDur(ByVal Index As Long, ByVal InvSlot As Long, ByVal ItemDur As Long)
    Player(Index).Char(Player(Index).CharNum).Inv(InvSlot).Dur = ItemDur
End Sub

Function GetPlayerSpell(ByVal Index As Long, ByVal SpellSlot As Long) As Long
    GetPlayerSpell = Player(Index).Char(Player(Index).CharNum).Spell(SpellSlot)
End Function

Sub SetPlayerSpell(ByVal Index As Long, ByVal SpellSlot As Long, ByVal SpellNum As Long)
    Player(Index).Char(Player(Index).CharNum).Spell(SpellSlot) = SpellNum
End Sub

Function GetPlayerArmorSlot(ByVal Index As Long) As Long
    GetPlayerArmorSlot = Player(Index).Char(Player(Index).CharNum).ArmorSlot
End Function

Sub SetPlayerArmorSlot(ByVal Index As Long, InvNum As Long)
    Player(Index).Char(Player(Index).CharNum).ArmorSlot = InvNum
End Sub

Function GetPlayerWeaponSlot(ByVal Index As Long) As Long
    GetPlayerWeaponSlot = Player(Index).Char(Player(Index).CharNum).WeaponSlot
End Function

Sub SetPlayerWeaponSlot(ByVal Index As Long, InvNum As Long)
    Player(Index).Char(Player(Index).CharNum).WeaponSlot = InvNum
End Sub

Function GetPlayerHelmetSlot(ByVal Index As Long) As Long
    GetPlayerHelmetSlot = Player(Index).Char(Player(Index).CharNum).HelmetSlot
End Function

Sub SetPlayerHelmetSlot(ByVal Index As Long, InvNum As Long)
    Player(Index).Char(Player(Index).CharNum).HelmetSlot = InvNum
End Sub

Function GetPlayerShieldSlot(ByVal Index As Long) As Long
    GetPlayerShieldSlot = Player(Index).Char(Player(Index).CharNum).ShieldSlot
End Function

Sub SetPlayerShieldSlot(ByVal Index As Long, InvNum As Long)
    Player(Index).Char(Player(Index).CharNum).ShieldSlot = InvNum
End Sub

