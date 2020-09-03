Attribute VB_Name = "modGameLogic"
Option Explicit

Public Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Long) As Integer
Public Declare Function GetKeyState Lib "user32" (ByVal nVirtKey As Long) As Integer
Public Declare Function GetTickCount Lib "kernel32" () As Long
Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Public Const SRCAND = &H8800C6
Public Const SRCCOPY = &HCC0020
Public Const SRCPAINT = &HEE0086

Public Const VK_UP = &H26
Public Const VK_DOWN = &H28
Public Const VK_LEFT = &H25
Public Const VK_RIGHT = &H27
Public Const VK_SHIFT = &H10
Public Const VK_RETURN = &HD
Public Const VK_CONTROL = &H11

' Menu states
Public Const MENU_STATE_NEWACCOUNT = 0
Public Const MENU_STATE_DELACCOUNT = 1
Public Const MENU_STATE_LOGIN = 2
Public Const MENU_STATE_GETCHARS = 3
Public Const MENU_STATE_NEWCHAR = 4
Public Const MENU_STATE_ADDCHAR = 5
Public Const MENU_STATE_DELCHAR = 6
Public Const MENU_STATE_USECHAR = 7
Public Const MENU_STATE_INIT = 8

' Speed moving vars
Public Const WALK_SPEED = 4
Public Const RUN_SPEED = 8

' Game direction vars
Public DirUp As Boolean
Public DirDown As Boolean
Public DirLeft As Boolean
Public DirRight As Boolean
Public ShiftDown As Boolean
Public ControlDown As Boolean

' Game text buffer
Public MyText As String

' Index of actual player
Public MyIndex As Long

' Map animation #, used to keep track of what map animation is currently on
Public MapAnim As Byte
Public MapAnimTimer As Long

' Used to freeze controls when getting a new map
Public GettingMap As Boolean

' Used to check if in editor or not and variables for use in editor
Public InEditor As Boolean
Public EditorTileX As Long
Public EditorTileY As Long
Public EditorWarpMap As Long
Public EditorWarpX As Long
Public EditorWarpY As Long

' Used for map item editor
Public ItemEditorNum As Long
Public ItemEditorValue As Long

' Used for map key editor
Public KeyEditorNum As Long
Public KeyEditorTake As Long

' Used for map key opene ditor
Public KeyOpenEditorX As Long
Public KeyOpenEditorY As Long

' Map for local use
Public SaveMap As MapRec
Public SaveMapItem(1 To MAX_MAP_ITEMS) As MapItemRec
Public SaveMapNpc(1 To MAX_MAP_NPCS) As MapNpcRec

' Used for index based editors
Public InItemsEditor As Boolean
Public InNpcEditor As Boolean
Public InShopEditor As Boolean
Public InSpellEditor As Boolean
Public EditorIndex As Long

' Game fps
Public GameFPS As Long

' Used for atmosphere
Public GameWeather As Long
Public GameTime As Long

Sub Main()
Dim i As Long
    
    ' Check if the maps directory is there, if its not make it
    If LCase(Dir(App.Path & "\maps", vbDirectory)) <> "maps" Then
        Call MkDir(App.Path & "\maps")
    End If
    
    ' Make sure we set that we aren't in the game
    InGame = False
    GettingMap = True
    InEditor = False
    InItemsEditor = False
    InNpcEditor = False
    InShopEditor = False
    
    ' Clear out players
    For i = 1 To MAX_PLAYERS
        Call ClearPlayer(i)
    Next i
    Call ClearTempTile
    
    frmSendGetData.Visible = True
    Call SetStatus("Initializing TCP settings...")
    Call TcpInit
    frmMainMenu.Visible = True
    frmSendGetData.Visible = False
End Sub

Sub SetStatus(ByVal Caption As String)
    frmSendGetData.lblStatus.Caption = Caption
End Sub

Sub MenuState(ByVal State As Long)
    frmSendGetData.Visible = True
    Call SetStatus("Connecting to server...")
    Select Case State
        Case MENU_STATE_NEWACCOUNT
            frmNewAccount.Visible = False
            If ConnectToServer = True Then
                Call SetStatus("Connected, sending new account information...")
                Call SendNewAccount(frmNewAccount.txtName.Text, frmNewAccount.txtPassword.Text)
            End If
            
        Case MENU_STATE_DELACCOUNT
            frmDeleteAccount.Visible = False
            If ConnectToServer = True Then
                Call SetStatus("Connected, sending account deletion request ...")
                Call SendDelAccount(frmDeleteAccount.txtName.Text, frmDeleteAccount.txtPassword.Text)
            End If
        
        Case MENU_STATE_LOGIN
            frmLogin.Visible = False
            If ConnectToServer = True Then
                Call SetStatus("Connected, sending login information...")
                Call SendLogin(frmLogin.txtName.Text, frmLogin.txtPassword.Text)
            End If
        
        Case MENU_STATE_NEWCHAR
            frmChars.Visible = False
            Call SetStatus("Connected, getting available classes...")
            Call SendGetClasses
            
        Case MENU_STATE_ADDCHAR
            frmNewChar.Visible = False
            If ConnectToServer = True Then
                Call SetStatus("Connected, sending character addition data...")
                If frmNewChar.optMale.Value = True Then
                    Call SendAddChar(frmNewChar.txtName, 0, frmNewChar.cmbClass.ListIndex, frmChars.lstChars.ListIndex + 1)
                Else
                    Call SendAddChar(frmNewChar.txtName, 1, frmNewChar.cmbClass.ListIndex, frmChars.lstChars.ListIndex + 1)
                End If
            End If
        
        Case MENU_STATE_DELCHAR
            frmChars.Visible = False
            If ConnectToServer = True Then
                Call SetStatus("Connected, sending character deletion request...")
                Call SendDelChar(frmChars.lstChars.ListIndex + 1)
            End If
            
        Case MENU_STATE_USECHAR
            frmChars.Visible = False
            If ConnectToServer = True Then
                Call SetStatus("Connected, sending char data...")
                Call SendUseChar(frmChars.lstChars.ListIndex + 1)
            End If
    End Select

    If Not IsConnected Then
        frmMainMenu.Visible = True
        frmSendGetData.Visible = False
        Call MsgBox("Sorry, the server seems to be down.  Please try to reconnect in a few minutes or visit http://mirage.katami.com/", vbOKOnly, GAME_NAME)
    End If
End Sub

Sub GameInit()
    frmMirage.Visible = True
    frmSendGetData.Visible = False
    Call ResizeGUI
    Call InitDirectX
End Sub

Sub GameLoop()
Dim Tick As Long
Dim TickFPS As Long
Dim FPS As Long
Dim x As Long
Dim y As Long
Dim i As Long
Dim rec_back As RECT
    
    ' Set the focus
    frmMirage.picScreen.SetFocus
    
    ' Set font
    Call SetFont("Fixedsys", 18)
    
    ' Used for calculating fps
    TickFPS = GetTickCount
    FPS = 0
    
    Do While InGame
        Tick = GetTickCount
        
        ' Check to make sure they aren't trying to auto do anything
        If GetAsyncKeyState(VK_UP) >= 0 And DirUp = True Then DirUp = False
        If GetAsyncKeyState(VK_DOWN) >= 0 And DirDown = True Then DirDown = False
        If GetAsyncKeyState(VK_LEFT) >= 0 And DirLeft = True Then DirLeft = False
        If GetAsyncKeyState(VK_RIGHT) >= 0 And DirRight = True Then DirRight = False
        If GetAsyncKeyState(VK_CONTROL) >= 0 And ControlDown = True Then ControlDown = False
        If GetAsyncKeyState(VK_SHIFT) >= 0 And ShiftDown = True Then ShiftDown = False
        
        ' Check to make sure we are still connected
        If Not IsConnected Then InGame = False
        
        ' Check if we need to restore surfaces
        If NeedToRestoreSurfaces Then
            DD.RestoreAllSurfaces
            Call InitSurfaces
        End If
                
        ' Blit out tiles layers ground/anim1/anim2
        For y = 0 To MAX_MAPY
            For x = 0 To MAX_MAPX
                Call BltTile(x, y)
            Next x
        Next y
                    
        ' Blit out the items
        For i = 1 To MAX_MAP_ITEMS
            If MapItem(i).Num > 0 Then
                Call BltItem(i)
            End If
        Next i
        
        ' Blit out the npcs
        For i = 1 To MAX_MAP_NPCS
            Call BltNpc(i)
        Next i
        
        ' Blit out players
        For i = 1 To MAX_PLAYERS
            If IsPlaying(i) And GetPlayerMap(i) = GetPlayerMap(MyIndex) Then
                Call BltPlayer(i)
            End If
        Next i
                
        ' Blit out tile layer fringe
        For y = 0 To MAX_MAPY
            For x = 0 To MAX_MAPX
                Call BltFringeTile(x, y)
            Next x
        Next y
                
        ' Lock the backbuffer so we can draw text and names
        TexthDC = DD_BackBuffer.GetDC
        For i = 1 To MAX_PLAYERS
            If IsPlaying(i) And GetPlayerMap(i) = GetPlayerMap(MyIndex) Then
                Call BltPlayerName(i)
            End If
        Next i
                
        ' Blit out attribs if in editor
        If InEditor Then
            For y = 0 To MAX_MAPY
                For x = 0 To MAX_MAPX
                    With Map.Tile(x, y)
                        If .Type = TILE_TYPE_BLOCKED Then Call DrawText(TexthDC, x * PIC_X + 8, y * PIC_Y + 8, "B", QBColor(BrightRed))
                        If .Type = TILE_TYPE_WARP Then Call DrawText(TexthDC, x * PIC_X + 8, y * PIC_Y + 8, "W", QBColor(BrightBlue))
                        If .Type = TILE_TYPE_ITEM Then Call DrawText(TexthDC, x * PIC_X + 8, y * PIC_Y + 8, "I", QBColor(White))
                        If .Type = TILE_TYPE_NPCAVOID Then Call DrawText(TexthDC, x * PIC_X + 8, y * PIC_Y + 8, "N", QBColor(White))
                        If .Type = TILE_TYPE_KEY Then Call DrawText(TexthDC, x * PIC_X + 8, y * PIC_Y + 8, "K", QBColor(White))
                        If .Type = TILE_TYPE_KEYOPEN Then Call DrawText(TexthDC, x * PIC_X + 8, y * PIC_Y + 8, "O", QBColor(White))
                    End With
                Next x
            Next y
        End If
        
        ' Blit the text they are putting in
        Call DrawText(TexthDC, 0, (MAX_MAPY + 1) * PIC_Y - 20, MyText, RGB(255, 255, 255))
        
        ' Draw map name
        If Map.Moral = MAP_MORAL_NONE Then
            Call DrawText(TexthDC, Int((MAX_MAPX + 1) * PIC_X / 2) - (Int(Len(Trim(Map.Name)) / 2) * 8), 1, Trim(Map.Name), QBColor(BrightRed))
        Else
            Call DrawText(TexthDC, Int((MAX_MAPX + 1) * PIC_X / 2) - (Int(Len(Trim(Map.Name)) / 2) * 8), 1, Trim(Map.Name), QBColor(White))
        End If
        
        ' Check if we are getting a map, and if we are tell them so
        'If GettingMap = True Then
        '    Call DrawText(TexthDC, 50, 50, "Receiving Map...", QBColor(BrightCyan))
        'End If
                        
        ' Release DC
        Call DD_BackBuffer.ReleaseDC(TexthDC)
        
        ' Get the rect for the back buffer to blit from
        rec.top = 0
        rec.Bottom = (MAX_MAPY + 1) * PIC_Y
        rec.Left = 0
        rec.Right = (MAX_MAPX + 1) * PIC_X
        
        ' Get the rect to blit to
        Call DX.GetWindowRect(frmMirage.picScreen.hWnd, rec_pos)
        rec_pos.Bottom = rec_pos.top + ((MAX_MAPY + 1) * PIC_Y)
        rec_pos.Right = rec_pos.Left + ((MAX_MAPX + 1) * PIC_X)
        
        ' Blit the backbuffer
        Call DD_PrimarySurf.Blt(rec_pos, DD_BackBuffer, rec, DDBLT_WAIT)
        
        ' Check if player is trying to move
        Call CheckMovement
        
        ' Check to see if player is trying to attack
        Call CheckAttack
        
        ' Process player movements (actually move them)
        For i = 1 To MAX_PLAYERS
            If IsPlaying(i) Then
                Call ProcessMovement(i)
            End If
        Next i
        
        ' Process npc movements (actually move them)
        For i = 1 To MAX_MAP_NPCS
            If Map.Npc(i) > 0 Then
                Call ProcessNpcMovement(i)
            End If
        Next i
            
        ' Change map animation every 250 milliseconds
        If GetTickCount > MapAnimTimer + 250 Then
            If MapAnim = 0 Then
                MapAnim = 1
            Else
                MapAnim = 0
            End If
            MapAnimTimer = GetTickCount
        End If
                
        ' Lock fps
        Do While GetTickCount < Tick + 50
            DoEvents
        Loop
        
        ' Calculate fps
        If GetTickCount > TickFPS + 1000 Then
            GameFPS = FPS
            TickFPS = GetTickCount
            FPS = 0
        Else
            FPS = FPS + 1
        End If
        
        DoEvents
        
    Loop
    
    frmMirage.Visible = False
    frmSendGetData.Visible = True
    Call SetStatus("Destroying game data...")
    
    ' Shutdown the game
    Call GameDestroy
    
    ' Report disconnection if server disconnects
    If IsConnected = False Then
        Call MsgBox("Thank you for playing " & GAME_NAME & "!", vbOKOnly, GAME_NAME)
    End If
End Sub

Sub GameDestroy()
    Call DestroyDirectX
    End
End Sub

Sub BltTile(ByVal x As Long, ByVal y As Long)
Dim Ground As Long
Dim Anim1 As Long
Dim Anim2 As Long

    Ground = Map.Tile(x, y).Ground
    Anim1 = Map.Tile(x, y).Mask
    Anim2 = Map.Tile(x, y).Anim
    
    ' Only used if ever want to switch to blt rather then bltfast
    With rec_pos
        .top = y * PIC_Y
        .Bottom = .top + PIC_Y
        .Left = x * PIC_X
        .Right = .Left + PIC_X
    End With
    
    rec.top = Int(Ground / 7) * PIC_Y
    rec.Bottom = rec.top + PIC_Y
    rec.Left = (Ground - Int(Ground / 7) * 7) * PIC_X
    rec.Right = rec.Left + PIC_X
    'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT)
    Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT)
    
    If (MapAnim = 0) Or (Anim2 <= 0) Then
        ' Is there an animation tile to plot?
        If Anim1 > 0 And TempTile(x, y).DoorOpen = NO Then
            rec.top = Int(Anim1 / 7) * PIC_Y
            rec.Bottom = rec.top + PIC_Y
            rec.Left = (Anim1 - Int(Anim1 / 7) * 7) * PIC_X
            rec.Right = rec.Left + PIC_X
            'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
            Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
        End If
    Else
        ' Is there a second animation tile to plot?
        If Anim2 > 0 Then
            rec.top = Int(Anim2 / 7) * PIC_Y
            rec.Bottom = rec.top + PIC_Y
            rec.Left = (Anim2 - Int(Anim2 / 7) * 7) * PIC_X
            rec.Right = rec.Left + PIC_X
            'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
            Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
        End If
    End If
End Sub

Sub BltItem(ByVal ItemNum As Long)
    ' Only used if ever want to switch to blt rather then bltfast
    With rec_pos
        .top = MapItem(ItemNum).y * PIC_Y
        .Bottom = .top + PIC_Y
        .Left = MapItem(ItemNum).x * PIC_X
        .Right = .Left + PIC_X
    End With

    rec.top = Item(MapItem(ItemNum).Num).Pic * PIC_Y
    rec.Bottom = rec.top + PIC_Y
    rec.Left = 0
    rec.Right = rec.Left + PIC_X
    
    'Call DD_BackBuffer.Blt(rec_pos, DD_ItemSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
    Call DD_BackBuffer.BltFast(MapItem(ItemNum).x * PIC_X, MapItem(ItemNum).y * PIC_Y, DD_ItemSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End Sub

Sub BltFringeTile(ByVal x As Long, ByVal y As Long)
Dim Fringe As Long

    ' Only used if ever want to switch to blt rather then bltfast
    With rec_pos
        .top = y * PIC_Y
        .Bottom = .top + PIC_Y
        .Left = x * PIC_X
        .Right = .Left + PIC_X
    End With
    
    Fringe = Map.Tile(x, y).Fringe
        
    If Fringe > 0 Then
        rec.top = Int(Fringe / 7) * PIC_Y
        rec.Bottom = rec.top + PIC_Y
        rec.Left = (Fringe - Int(Fringe / 7) * 7) * PIC_X
        rec.Right = rec.Left + PIC_X
        'Call DD_BackBuffer.Blt(rec_pos, DD_TileSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
        Call DD_BackBuffer.BltFast(x * PIC_X, y * PIC_Y, DD_TileSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
    End If
End Sub

Sub BltPlayer(ByVal Index As Long)
Dim Anim As Byte
Dim x As Long, y As Long

    ' Only used if ever want to switch to blt rather then bltfast
    With rec_pos
        .top = GetPlayerY(Index) * PIC_Y + Player(Index).YOffset
        .Bottom = .top + PIC_Y
        .Left = GetPlayerX(Index) * PIC_X + Player(Index).XOffset
        .Right = .Left + PIC_X
    End With
    
    ' Check for animation
    Anim = 0
    If Player(Index).Attacking = 0 Then
        Select Case GetPlayerDir(Index)
            Case DIR_UP
                If (Player(Index).YOffset < PIC_Y / 2) Then Anim = 1
            Case DIR_DOWN
                If (Player(Index).YOffset < PIC_Y / 2 * -1) Then Anim = 1
            Case DIR_LEFT
                If (Player(Index).XOffset < PIC_Y / 2) Then Anim = 1
            Case DIR_RIGHT
                If (Player(Index).XOffset < PIC_Y / 2 * -1) Then Anim = 1
        End Select
    Else
        If Player(Index).AttackTimer + 500 > GetTickCount Then
            Anim = 2
        End If
    End If
    
    ' Check to see if we want to stop making him attack
    If Player(Index).AttackTimer + 1000 < GetTickCount Then
        Player(Index).Attacking = 0
        Player(Index).AttackTimer = 0
    End If
    
    rec.top = GetPlayerSprite(Index) * PIC_Y
    rec.Bottom = rec.top + PIC_Y
    rec.Left = (GetPlayerDir(Index) * 3 + Anim) * PIC_X
    rec.Right = rec.Left + PIC_X
    
    x = GetPlayerX(Index) * PIC_X + Player(Index).XOffset
    y = GetPlayerY(Index) * PIC_Y + Player(Index).YOffset - 4
    
    ' Check if its out of bounds because of the offset
    If y < 0 Then
        y = 0
        rec.top = rec.top + (y * -1)
    End If
        
    'Call DD_BackBuffer.Blt(rec_pos, DD_SpriteSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
    Call DD_BackBuffer.BltFast(x, y, DD_SpriteSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End Sub

Sub BltPlayerName(ByVal Index As Long)
Dim TextX As Long
Dim TextY As Long
Dim Color As Long
    
    ' Check access level
    If GetPlayerPK(Index) = NO Then
        Select Case GetPlayerAccess(Index)
            Case 0
                Color = QBColor(Brown)
            Case 1
                Color = QBColor(DarkGrey)
            Case 2
                Color = QBColor(Cyan)
            Case 3
                Color = QBColor(Blue)
            Case 4
                Color = QBColor(Pink)
        End Select
    Else
        Color = QBColor(BrightRed)
    End If
    
    ' Draw name
    TextX = GetPlayerX(Index) * PIC_X + Player(Index).XOffset + Int(PIC_X / 2) - ((Len(GetPlayerName(Index)) / 2) * 8)
    TextY = GetPlayerY(Index) * PIC_Y + Player(Index).YOffset - Int(PIC_Y / 2) - 4
    Call DrawText(TexthDC, TextX, TextY, GetPlayerName(Index), Color)
End Sub

Sub BltNpc(ByVal MapNpcNum As Long)
Dim Anim As Byte
Dim x As Long, y As Long

    ' Make sure that theres an npc there, and if not exit the sub
    If MapNpc(MapNpcNum).Num <= 0 Then
        Exit Sub
    End If
    
    ' Only used if ever want to switch to blt rather then bltfast
    With rec_pos
        .top = MapNpc(MapNpcNum).y * PIC_Y + MapNpc(MapNpcNum).YOffset
        .Bottom = .top + PIC_Y
        .Left = MapNpc(MapNpcNum).x * PIC_X + MapNpc(MapNpcNum).XOffset
        .Right = .Left + PIC_X
    End With
    
    ' Check for animation
    Anim = 0
    If MapNpc(MapNpcNum).Attacking = 0 Then
        Select Case MapNpc(MapNpcNum).Dir
            Case DIR_UP
                If (MapNpc(MapNpcNum).YOffset < PIC_Y / 2) Then Anim = 1
            Case DIR_DOWN
                If (MapNpc(MapNpcNum).YOffset < PIC_Y / 2 * -1) Then Anim = 1
            Case DIR_LEFT
                If (MapNpc(MapNpcNum).XOffset < PIC_Y / 2) Then Anim = 1
            Case DIR_RIGHT
                If (MapNpc(MapNpcNum).XOffset < PIC_Y / 2 * -1) Then Anim = 1
        End Select
    Else
        If MapNpc(MapNpcNum).AttackTimer + 500 > GetTickCount Then
            Anim = 2
        End If
    End If
    
    ' Check to see if we want to stop making him attack
    If MapNpc(MapNpcNum).AttackTimer + 1000 < GetTickCount Then
        MapNpc(MapNpcNum).Attacking = 0
        MapNpc(MapNpcNum).AttackTimer = 0
    End If
    
    rec.top = Npc(MapNpc(MapNpcNum).Num).Sprite * PIC_Y
    rec.Bottom = rec.top + PIC_Y
    rec.Left = (MapNpc(MapNpcNum).Dir * 3 + Anim) * PIC_X
    rec.Right = rec.Left + PIC_X
    
    x = MapNpc(MapNpcNum).x * PIC_X + MapNpc(MapNpcNum).XOffset
    y = MapNpc(MapNpcNum).y * PIC_Y + MapNpc(MapNpcNum).YOffset - 4
    
    ' Check if its out of bounds because of the offset
    If y < 0 Then
        y = 0
        rec.top = rec.top + (y * -1)
    End If
        
    'Call DD_BackBuffer.Blt(rec_pos, DD_SpriteSurf, rec, DDBLT_WAIT Or DDBLT_KEYSRC)
    Call DD_BackBuffer.BltFast(x, y, DD_SpriteSurf, rec, DDBLTFAST_WAIT Or DDBLTFAST_SRCCOLORKEY)
End Sub

Sub ProcessMovement(ByVal Index As Long)
    ' Check if player is walking, and if so process moving them over
    If Player(Index).Moving = MOVING_WALKING Then
        Select Case GetPlayerDir(Index)
            Case DIR_UP
                Player(Index).YOffset = Player(Index).YOffset - WALK_SPEED
            Case DIR_DOWN
                Player(Index).YOffset = Player(Index).YOffset + WALK_SPEED
            Case DIR_LEFT
                Player(Index).XOffset = Player(Index).XOffset - WALK_SPEED
            Case DIR_RIGHT
                Player(Index).XOffset = Player(Index).XOffset + WALK_SPEED
        End Select
        
        ' Check if completed walking over to the next tile
        If (Player(Index).XOffset = 0) And (Player(Index).YOffset = 0) Then
            Player(Index).Moving = 0
        End If
    End If

    ' Check if player is running, and if so process moving them over
    If Player(Index).Moving = MOVING_RUNNING Then
        Select Case GetPlayerDir(Index)
            Case DIR_UP
                Player(Index).YOffset = Player(Index).YOffset - RUN_SPEED
            Case DIR_DOWN
                Player(Index).YOffset = Player(Index).YOffset + RUN_SPEED
            Case DIR_LEFT
                Player(Index).XOffset = Player(Index).XOffset - RUN_SPEED
            Case DIR_RIGHT
                Player(Index).XOffset = Player(Index).XOffset + RUN_SPEED
        End Select
        
        ' Check if completed walking over to the next tile
        If (Player(Index).XOffset = 0) And (Player(Index).YOffset = 0) Then
            Player(Index).Moving = 0
        End If
    End If
End Sub

Sub ProcessNpcMovement(ByVal MapNpcNum As Long)
    ' Check if player is walking, and if so process moving them over
    If MapNpc(MapNpcNum).Moving = MOVING_WALKING Then
        Select Case MapNpc(MapNpcNum).Dir
            Case DIR_UP
                MapNpc(MapNpcNum).YOffset = MapNpc(MapNpcNum).YOffset - WALK_SPEED
            Case DIR_DOWN
                MapNpc(MapNpcNum).YOffset = MapNpc(MapNpcNum).YOffset + WALK_SPEED
            Case DIR_LEFT
                MapNpc(MapNpcNum).XOffset = MapNpc(MapNpcNum).XOffset - WALK_SPEED
            Case DIR_RIGHT
                MapNpc(MapNpcNum).XOffset = MapNpc(MapNpcNum).XOffset + WALK_SPEED
        End Select
        
        ' Check if completed walking over to the next tile
        If (MapNpc(MapNpcNum).XOffset = 0) And (MapNpc(MapNpcNum).YOffset = 0) Then
            MapNpc(MapNpcNum).Moving = 0
        End If
    End If
End Sub

Sub HandleKeypresses(ByVal KeyAscii As Integer)
Dim ChatText As String
Dim Name As String
Dim i As Long
Dim n As Long

    ' Handle when the player presses the return key
    If (KeyAscii = vbKeyReturn) Then
        ' Broadcast message
        If Mid(MyText, 1, 1) = "'" Then
            ChatText = Mid(MyText, 2, Len(MyText) - 1)
            If Len(Trim(ChatText)) > 0 Then
                Call BroadcastMsg(ChatText)
            End If
            MyText = ""
            Exit Sub
        End If
        
        ' Emote message
        If Mid(MyText, 1, 1) = "-" Then
            ChatText = Mid(MyText, 2, Len(MyText) - 1)
            If Len(Trim(ChatText)) > 0 Then
                Call EmoteMsg(ChatText)
            End If
            MyText = ""
            Exit Sub
        End If
        
        ' Player message
        If Mid(MyText, 1, 1) = "!" Then
            ChatText = Mid(MyText, 2, Len(MyText) - 1)
            Name = ""
                    
            ' Get the desired player from the user text
            For i = 1 To Len(ChatText)
                If Mid(ChatText, i, 1) <> " " Then
                    Name = Name & Mid(ChatText, i, 1)
                Else
                    Exit For
                End If
            Next i
                    
            ' Make sure they are actually sending something
            If Len(ChatText) - i > 0 Then
                ChatText = Mid(ChatText, i + 1, Len(ChatText) - i)
                    
                ' Send the message to the player
                Call PlayerMsg(ChatText, Name)
            Else
                Call AddText("Usage: !playername msghere", AlertColor)
            End If
            MyText = ""
            Exit Sub
        End If
            
        ' // Commands //
        ' Help
        If LCase(Mid(MyText, 1, 5)) = "/help" Then
            Call AddText("Social Commands:", HelpColor)
            Call AddText("'msghere = Broadcast Message", HelpColor)
            Call AddText("-msghere = Emote Message", HelpColor)
            Call AddText("!namehere msghere = Player Message", HelpColor)
            Call AddText("Available Commands: /help, /info, /who, /fps, /inv, /stats, /train, /trade, /party, /join, /leave", HelpColor)
            MyText = ""
            Exit Sub
        End If
        
        ' Verification User
        If LCase(Mid(MyText, 1, 5)) = "/info" Then
            ChatText = Mid(MyText, 6, Len(MyText) - 5)
            Call SendData("playerinforequest" & SEP_CHAR & ChatText & SEP_CHAR & END_CHAR)
            MyText = ""
            Exit Sub
        End If
        
        ' Whos Online
        If LCase(Mid(MyText, 1, 4)) = "/who" Then
            Call SendWhosOnline
            MyText = ""
            Exit Sub
        End If
                        
        ' Checking fps
        If LCase(Mid(MyText, 1, 4)) = "/fps" Then
            Call AddText("FPS: " & GameFPS, Pink)
            MyText = ""
            Exit Sub
        End If
                
        ' Show inventory
        If LCase(Mid(MyText, 1, 4)) = "/inv" Then
            Call UpdateInventory
            frmMirage.picInv.Visible = True
            MyText = ""
            Exit Sub
        End If
        
        ' Request stats
        If LCase(Mid(MyText, 1, 6)) = "/stats" Then
            Call SendData("getstats" & SEP_CHAR & END_CHAR)
            MyText = ""
            Exit Sub
        End If
    
        ' Show training
        If LCase(Mid(MyText, 1, 6)) = "/train" Then
            frmTraining.Show vbModal
            MyText = ""
            Exit Sub
        End If

        ' Request stats
        If LCase(Mid(MyText, 1, 6)) = "/trade" Then
            Call SendData("trade" & SEP_CHAR & END_CHAR)
            MyText = ""
            Exit Sub
        End If
        
        ' Party request
        If LCase(Mid(MyText, 1, 6)) = "/party" Then
            ' Make sure they are actually sending something
            If Len(MyText) > 7 Then
                ChatText = Mid(MyText, 8, Len(MyText) - 7)
                Call SendPartyRequest(ChatText)
            Else
                Call AddText("Usage: /party playernamehere", AlertColor)
            End If
            MyText = ""
            Exit Sub
        End If
        
        ' Join party
        If LCase(Mid(MyText, 1, 5)) = "/join" Then
            Call SendJoinParty
            MyText = ""
            Exit Sub
        End If
        
        ' Leave party
        If LCase(Mid(MyText, 1, 6)) = "/leave" Then
            Call SendLeaveParty
            MyText = ""
            Exit Sub
        End If
        
        ' // Moniter Admin Commands //
        If GetPlayerAccess(MyIndex) > 0 Then
            ' Admin Help
            If LCase(Mid(MyText, 1, 6)) = "/admin" Then
                Call AddText("Social Commands:", HelpColor)
                Call AddText("""msghere = Global Admin Message", HelpColor)
                Call AddText("=msghere = Private Admin Message", HelpColor)
                Call AddText("Available Commands: /admin, /loc, /mapeditor, /warpmeto, /warptome, /warpto, /setsprite, /mapreport, /kick, /ban, /edititem, /respawn, /editnpc, /motd, /editshop, /ban, /editspell", HelpColor)
                MyText = ""
                Exit Sub
            End If
            
            ' Kicking a player
            If LCase(Mid(MyText, 1, 5)) = "/kick" Then
                If Len(MyText) > 6 Then
                    MyText = Mid(MyText, 7, Len(MyText) - 6)
                    Call SendKick(MyText)
                End If
                MyText = ""
                Exit Sub
            End If
        
            ' Global Message
            If Mid(MyText, 1, 1) = """" Then
                ChatText = Mid(MyText, 2, Len(MyText) - 1)
                If Len(Trim(ChatText)) > 0 Then
                    Call GlobalMsg(ChatText)
                End If
                MyText = ""
                Exit Sub
            End If
        
            ' Admin Message
            If Mid(MyText, 1, 1) = "=" Then
                ChatText = Mid(MyText, 2, Len(MyText) - 1)
                If Len(Trim(ChatText)) > 0 Then
                    Call AdminMsg(ChatText)
                End If
                MyText = ""
                Exit Sub
            End If
        End If
        
        ' // Mapper Admin Commands //
        If GetPlayerAccess(MyIndex) >= ADMIN_MAPPER Then
            ' Location
            If LCase(Mid(MyText, 1, 4)) = "/loc" Then
                Call SendRequestLocation
                MyText = ""
                Exit Sub
            End If
            
            ' Map Editor
            If LCase(Mid(MyText, 1, 10)) = "/mapeditor" Then
                Call SendRequestEditMap
                MyText = ""
                Exit Sub
            End If
            
            ' Warping to a player
            If LCase(Mid(MyText, 1, 9)) = "/warpmeto" Then
                If Len(MyText) > 10 Then
                    MyText = Mid(MyText, 10, Len(MyText) - 9)
                    Call WarpMeTo(MyText)
                End If
                MyText = ""
                Exit Sub
            End If
                        
            ' Warping a player to you
            If LCase(Mid(MyText, 1, 9)) = "/warptome" Then
                If Len(MyText) > 10 Then
                    MyText = Mid(MyText, 10, Len(MyText) - 9)
                    Call WarpToMe(MyText)
                End If
                MyText = ""
                Exit Sub
            End If
                        
            ' Warping to a map
            If LCase(Mid(MyText, 1, 7)) = "/warpto" Then
                If Len(MyText) > 8 Then
                    MyText = Mid(MyText, 8, Len(MyText) - 7)
                    n = Val(MyText)
                
                    ' Check to make sure its a valid map #
                    If n > 0 And n <= MAX_MAPS Then
                        Call WarpTo(n)
                    Else
                        Call AddText("Invalid map number.", Red)
                    End If
                End If
                MyText = ""
                Exit Sub
            End If
            
            ' Setting sprite
            If LCase(Mid(MyText, 1, 10)) = "/setsprite" Then
                If Len(MyText) > 11 Then
                    ' Get sprite #
                    MyText = Mid(MyText, 12, Len(MyText) - 11)
                
                    Call SendSetSprite(Val(MyText))
                End If
                MyText = ""
                Exit Sub
            End If
            
            ' Map report
            If LCase(Mid(MyText, 1, 10)) = "/mapreport" Then
                Call SendData("mapreport" & SEP_CHAR & END_CHAR)
                MyText = ""
                Exit Sub
            End If
        
            ' Respawn request
            If Mid(MyText, 1, 8) = "/respawn" Then
                Call SendMapRespawn
                MyText = ""
                Exit Sub
            End If
        
            ' MOTD change
            If Mid(MyText, 1, 5) = "/motd" Then
                If Len(MyText) > 6 Then
                    MyText = Mid(MyText, 7, Len(MyText) - 6)
                    If Trim(MyText) <> "" Then
                        Call SendMOTDChange(MyText)
                    End If
                End If
                MyText = ""
                Exit Sub
            End If
            
            ' Check the ban list
            If Mid(MyText, 1, 3) = "/banlist" Then
                Call SendBanList
                MyText = ""
                Exit Sub
            End If
            
            ' Banning a player
            If LCase(Mid(MyText, 1, 4)) = "/ban" Then
                If Len(MyText) > 5 Then
                    MyText = Mid(MyText, 6, Len(MyText) - 5)
                    Call SendBan(MyText)
                    MyText = ""
                End If
                Exit Sub
            End If
        End If
            
        ' // Developer Admin Commands //
        If GetPlayerAccess(MyIndex) >= ADMIN_DEVELOPER Then
            ' Editing item request
            If Mid(MyText, 1, 9) = "/edititem" Then
                Call SendRequestEditItem
                MyText = ""
                Exit Sub
            End If
            
            ' Editing npc request
            If Mid(MyText, 1, 8) = "/editnpc" Then
                Call SendRequestEditNpc
                MyText = ""
                Exit Sub
            End If
            
            ' Editing shop request
            If Mid(MyText, 1, 9) = "/editshop" Then
                Call SendRequestEditShop
                MyText = ""
                Exit Sub
            End If
        
            ' Editing spell request
            If Mid(MyText, 1, 10) = "/editspell" Then
                Call SendRequestEditSpell
                MyText = ""
                Exit Sub
            End If
        End If
        
        ' // Creator Admin Commands //
        If GetPlayerAccess(MyIndex) >= ADMIN_CREATOR Then
            ' Giving another player access
            If LCase(Mid(MyText, 1, 10)) = "/setaccess" Then
                ' Get access #
                i = Val(Mid(MyText, 12, 1))
                
                MyText = Mid(MyText, 14, Len(MyText) - 13)
                
                Call SendSetAccess(MyText, i)
                MyText = ""
                Exit Sub
            End If
            
            ' Ban destroy
            If LCase(Mid(MyText, 1, 15)) = "/destroybanlist" Then
                Call SendBanDestroy
                MyText = ""
                Exit Sub
            End If
        End If
        
        ' Say message
        If Len(Trim(MyText)) > 0 Then
            Call SayMsg(MyText)
        End If
        MyText = ""
        Exit Sub
    End If
    
    ' Handle when the user presses the backspace key
    If (KeyAscii = vbKeyBack) Then
        If Len(MyText) > 0 Then
            MyText = Mid(MyText, 1, Len(MyText) - 1)
        End If
    End If
    
    ' And if neither, then add the character to the user's text buffer
    If (KeyAscii <> vbKeyReturn) And (KeyAscii <> vbKeyBack) Then
        ' Make sure they just use standard keys, no gay shitty macro keys
        If KeyAscii >= 32 And KeyAscii <= 126 Then
            MyText = MyText & Chr(KeyAscii)
        End If
    End If
End Sub

Sub CheckMapGetItem()
    If GetTickCount > Player(MyIndex).MapGetTimer + 250 And Trim(MyText) = "" Then
        Player(MyIndex).MapGetTimer = GetTickCount
        Call SendData("mapgetitem" & SEP_CHAR & END_CHAR)
    End If
End Sub

Sub CheckAttack()
    If ControlDown = True And Player(MyIndex).AttackTimer + 1000 < GetTickCount And Player(MyIndex).Attacking = 0 Then
        Player(MyIndex).Attacking = 1
        Player(MyIndex).AttackTimer = GetTickCount
        Call SendData("attack" & SEP_CHAR & END_CHAR)
    End If
End Sub

Sub CheckInput2()
    If GettingMap = False Then
        If GetKeyState(VK_RETURN) < 0 Then
            Call CheckMapGetItem
        End If
        If GetKeyState(VK_CONTROL) < 0 Then
            ControlDown = True
        Else
            ControlDown = False
        End If
        If GetKeyState(VK_UP) < 0 Then
            DirUp = True
            DirDown = False
            DirLeft = False
            DirRight = False
        Else
            DirUp = False
        End If
        If GetKeyState(VK_DOWN) < 0 Then
            DirUp = False
            DirDown = True
            DirLeft = False
            DirRight = False
        Else
            DirDown = False
        End If
        If GetKeyState(VK_LEFT) < 0 Then
            DirUp = False
            DirDown = False
            DirLeft = True
            DirRight = False
        Else
            DirLeft = False
        End If
        If GetKeyState(VK_RIGHT) < 0 Then
            DirUp = False
            DirDown = False
            DirLeft = False
            DirRight = True
        Else
            DirRight = False
        End If
        If GetKeyState(VK_SHIFT) < 0 Then
            ShiftDown = True
        Else
            ShiftDown = False
        End If
    End If
End Sub

Sub CheckInput(ByVal KeyState As Byte, ByVal KeyCode As Integer, ByVal Shift As Integer)
    If GettingMap = False Then
        If KeyState = 1 Then
            If KeyCode = vbKeyReturn Then
                Call CheckMapGetItem
            End If
            If KeyCode = vbKeyControl Then
                ControlDown = True
            End If
            If KeyCode = vbKeyUp Then
                DirUp = True
                DirDown = False
                DirLeft = False
                DirRight = False
            End If
            If KeyCode = vbKeyDown Then
                DirUp = False
                DirDown = True
                DirLeft = False
                DirRight = False
            End If
            If KeyCode = vbKeyLeft Then
                DirUp = False
                DirDown = False
                DirLeft = True
                DirRight = False
            End If
            If KeyCode = vbKeyRight Then
                DirUp = False
                DirDown = False
                DirLeft = False
                DirRight = True
            End If
            If KeyCode = vbKeyShift Then
                ShiftDown = True
            End If
        Else
            If KeyCode = vbKeyUp Then DirUp = False
            If KeyCode = vbKeyDown Then DirDown = False
            If KeyCode = vbKeyLeft Then DirLeft = False
            If KeyCode = vbKeyRight Then DirRight = False
            If KeyCode = vbKeyShift Then ShiftDown = False
            If KeyCode = vbKeyControl Then ControlDown = False
        End If
    End If
End Sub

Function IsTryingToMove() As Boolean
    If (DirUp = True) Or (DirDown = True) Or (DirLeft = True) Or (DirRight = True) Then
        IsTryingToMove = True
    Else
        IsTryingToMove = False
    End If
End Function

Function CanMove() As Boolean
Dim i As Long, d As Long

    CanMove = True
    
    ' Make sure they aren't trying to move when they are already moving
    If Player(MyIndex).Moving <> 0 Then
        CanMove = False
        Exit Function
    End If
    
    ' Make sure they haven't just casted a spell
    If Player(MyIndex).CastedSpell = YES Then
        If GetTickCount > Player(MyIndex).AttackTimer + 1000 Then
            Player(MyIndex).CastedSpell = NO
        Else
            CanMove = False
            Exit Function
        End If
    End If
    
    d = GetPlayerDir(MyIndex)
    If DirUp Then
        Call SetPlayerDir(MyIndex, DIR_UP)
        
        ' Check to see if they are trying to go out of bounds
        If GetPlayerY(MyIndex) > 0 Then
            ' Check to see if the map tile is blocked or not
            If Map.Tile(GetPlayerX(MyIndex), GetPlayerY(MyIndex) - 1).Type = TILE_TYPE_BLOCKED Then
                CanMove = False
                
                ' Set the new direction if they weren't facing that direction
                If d <> DIR_UP Then
                    Call SendPlayerDir
                End If
                Exit Function
            End If
                                        
            ' Check to see if the key door is open or not
            If Map.Tile(GetPlayerX(MyIndex), GetPlayerY(MyIndex) - 1).Type = TILE_TYPE_KEY Then
                ' This actually checks if its open or not
                If TempTile(GetPlayerX(MyIndex), GetPlayerY(MyIndex) - 1).DoorOpen = NO Then
                    CanMove = False
                
                    ' Set the new direction if they weren't facing that direction
                    If d <> DIR_UP Then
                        Call SendPlayerDir
                    End If
                    Exit Function
                End If
            End If
            
            ' Check to see if a player is already on that tile
            For i = 1 To MAX_PLAYERS
                If IsPlaying(i) Then
                    If GetPlayerMap(i) = GetPlayerMap(MyIndex) Then
                        If (GetPlayerX(i) = GetPlayerX(MyIndex)) And (GetPlayerY(i) = GetPlayerY(MyIndex) - 1) Then
                            CanMove = False
                        
                            ' Set the new direction if they weren't facing that direction
                            If d <> DIR_UP Then
                                Call SendPlayerDir
                            End If
                            Exit Function
                        End If
                    End If
                End If
            Next i
        
            ' Check to see if a npc is already on that tile
            For i = 1 To MAX_MAP_NPCS
                If MapNpc(i).Num > 0 Then
                    If (MapNpc(i).x = GetPlayerX(MyIndex)) And (MapNpc(i).y = GetPlayerY(MyIndex) - 1) Then
                        CanMove = False
                        
                        ' Set the new direction if they weren't facing that direction
                        If d <> DIR_UP Then
                            Call SendPlayerDir
                        End If
                        Exit Function
                    End If
                End If
            Next i
        Else
            ' Check if they can warp to a new map
            If Map.Up > 0 Then
                Call SendPlayerRequestNewMap
                GettingMap = True
            End If
            CanMove = False
            Exit Function
        End If
    End If
            
    If DirDown Then
        Call SetPlayerDir(MyIndex, DIR_DOWN)
        
        ' Check to see if they are trying to go out of bounds
        If GetPlayerY(MyIndex) < MAX_MAPY Then
            ' Check to see if the map tile is blocked or not
            If Map.Tile(GetPlayerX(MyIndex), GetPlayerY(MyIndex) + 1).Type = TILE_TYPE_BLOCKED Then
                CanMove = False
                
                ' Set the new direction if they weren't facing that direction
                If d <> DIR_DOWN Then
                    Call SendPlayerDir
                End If
                Exit Function
            End If
                                        
            ' Check to see if the key door is open or not
            If Map.Tile(GetPlayerX(MyIndex), GetPlayerY(MyIndex) + 1).Type = TILE_TYPE_KEY Then
                ' This actually checks if its open or not
                If TempTile(GetPlayerX(MyIndex), GetPlayerY(MyIndex) + 1).DoorOpen = NO Then
                    CanMove = False
                
                    ' Set the new direction if they weren't facing that direction
                    If d <> DIR_DOWN Then
                        Call SendPlayerDir
                    End If
                    Exit Function
                End If
            End If
            
            ' Check to see if a player is already on that tile
            For i = 1 To MAX_PLAYERS
                If IsPlaying(i) And GetPlayerMap(i) = GetPlayerMap(MyIndex) Then
                    If (GetPlayerX(i) = GetPlayerX(MyIndex)) And (GetPlayerY(i) = GetPlayerY(MyIndex) + 1) Then
                        CanMove = False
                        
                        ' Set the new direction if they weren't facing that direction
                        If d <> DIR_DOWN Then
                            Call SendPlayerDir
                        End If
                        Exit Function
                    End If
                End If
            Next i
            
            ' Check to see if a npc is already on that tile
            For i = 1 To MAX_MAP_NPCS
                If MapNpc(i).Num > 0 Then
                    If (MapNpc(i).x = GetPlayerX(MyIndex)) And (MapNpc(i).y = GetPlayerY(MyIndex) + 1) Then
                        CanMove = False
                        
                        ' Set the new direction if they weren't facing that direction
                        If d <> DIR_DOWN Then
                            Call SendPlayerDir
                        End If
                        Exit Function
                    End If
                End If
            Next i
        Else
            ' Check if they can warp to a new map
            If Map.Down > 0 Then
                Call SendPlayerRequestNewMap
                GettingMap = True
            End If
            CanMove = False
            Exit Function
        End If
    End If
                
    If DirLeft Then
        Call SetPlayerDir(MyIndex, DIR_LEFT)
        
        ' Check to see if they are trying to go out of bounds
        If GetPlayerX(MyIndex) > 0 Then
            ' Check to see if the map tile is blocked or not
            If Map.Tile(GetPlayerX(MyIndex) - 1, GetPlayerY(MyIndex)).Type = TILE_TYPE_BLOCKED Then
                CanMove = False
                
                ' Set the new direction if they weren't facing that direction
                If d <> DIR_LEFT Then
                    Call SendPlayerDir
                End If
                Exit Function
            End If
                                        
            ' Check to see if the key door is open or not
            If Map.Tile(GetPlayerX(MyIndex) - 1, GetPlayerY(MyIndex)).Type = TILE_TYPE_KEY Then
                ' This actually checks if its open or not
                If TempTile(GetPlayerX(MyIndex) - 1, GetPlayerY(MyIndex)).DoorOpen = NO Then
                    CanMove = False
                    
                    ' Set the new direction if they weren't facing that direction
                    If d <> DIR_LEFT Then
                        Call SendPlayerDir
                    End If
                    Exit Function
                End If
            End If
            
            ' Check to see if a player is already on that tile
            For i = 1 To MAX_PLAYERS
                If IsPlaying(i) And GetPlayerMap(i) = GetPlayerMap(MyIndex) Then
                    If (GetPlayerX(i) = GetPlayerX(MyIndex) - 1) And (GetPlayerY(i) = GetPlayerY(MyIndex)) Then
                        CanMove = False
                        
                        ' Set the new direction if they weren't facing that direction
                        If d <> DIR_LEFT Then
                            Call SendPlayerDir
                        End If
                        Exit Function
                    End If
                End If
            Next i
        
            ' Check to see if a npc is already on that tile
            For i = 1 To MAX_MAP_NPCS
                If MapNpc(i).Num > 0 Then
                    If (MapNpc(i).x = GetPlayerX(MyIndex) - 1) And (MapNpc(i).y = GetPlayerY(MyIndex)) Then
                        CanMove = False
                        
                        ' Set the new direction if they weren't facing that direction
                        If d <> DIR_LEFT Then
                            Call SendPlayerDir
                        End If
                        Exit Function
                    End If
                End If
            Next i
        Else
            ' Check if they can warp to a new map
            If Map.Left > 0 Then
                Call SendPlayerRequestNewMap
                GettingMap = True
            End If
            CanMove = False
            Exit Function
        End If
    End If
        
    If DirRight Then
        Call SetPlayerDir(MyIndex, DIR_RIGHT)
        
        ' Check to see if they are trying to go out of bounds
        If GetPlayerX(MyIndex) < MAX_MAPX Then
            ' Check to see if the map tile is blocked or not
            If Map.Tile(GetPlayerX(MyIndex) + 1, GetPlayerY(MyIndex)).Type = TILE_TYPE_BLOCKED Then
                CanMove = False
                
                ' Set the new direction if they weren't facing that direction
                If d <> DIR_RIGHT Then
                    Call SendPlayerDir
                End If
                Exit Function
            End If
                                        
            ' Check to see if the key door is open or not
            If Map.Tile(GetPlayerX(MyIndex) + 1, GetPlayerY(MyIndex)).Type = TILE_TYPE_KEY Then
                ' This actually checks if its open or not
                If TempTile(GetPlayerX(MyIndex) + 1, GetPlayerY(MyIndex)).DoorOpen = NO Then
                    CanMove = False
                    
                    ' Set the new direction if they weren't facing that direction
                    If d <> DIR_RIGHT Then
                        Call SendPlayerDir
                    End If
                    Exit Function
                End If
            End If
            
            ' Check to see if a player is already on that tile
            For i = 1 To MAX_PLAYERS
                If IsPlaying(i) And GetPlayerMap(i) = GetPlayerMap(MyIndex) Then
                    If (GetPlayerX(i) = GetPlayerX(MyIndex) + 1) And (GetPlayerY(i) = GetPlayerY(MyIndex)) Then
                        CanMove = False
                        
                        ' Set the new direction if they weren't facing that direction
                        If d <> DIR_RIGHT Then
                            Call SendPlayerDir
                        End If
                        Exit Function
                    End If
                End If
            Next i
        
            ' Check to see if a npc is already on that tile
            For i = 1 To MAX_MAP_NPCS
                If MapNpc(i).Num > 0 Then
                    If (MapNpc(i).x = GetPlayerX(MyIndex) + 1) And (MapNpc(i).y = GetPlayerY(MyIndex)) Then
                        CanMove = False
                        
                        ' Set the new direction if they weren't facing that direction
                        If d <> DIR_RIGHT Then
                            Call SendPlayerDir
                        End If
                        Exit Function
                    End If
                End If
            Next i
        Else
            ' Check if they can warp to a new map
            If Map.Right > 0 Then
                Call SendPlayerRequestNewMap
                GettingMap = True
            End If
            CanMove = False
            Exit Function
        End If
    End If
End Function

Sub CheckMovement()
    If GettingMap = False Then
        If IsTryingToMove Then
            If CanMove Then
                ' Check if player has the shift key down for running
                If ShiftDown Then
                    Player(MyIndex).Moving = MOVING_RUNNING
                Else
                    Player(MyIndex).Moving = MOVING_WALKING
                End If
            
                Select Case GetPlayerDir(MyIndex)
                    Case DIR_UP
                        Call SendPlayerMove
                        Player(MyIndex).YOffset = PIC_Y
                        Call SetPlayerY(MyIndex, GetPlayerY(MyIndex) - 1)
                
                    Case DIR_DOWN
                        Call SendPlayerMove
                        Player(MyIndex).YOffset = PIC_Y * -1
                        Call SetPlayerY(MyIndex, GetPlayerY(MyIndex) + 1)
                
                    Case DIR_LEFT
                        Call SendPlayerMove
                        Player(MyIndex).XOffset = PIC_X
                        Call SetPlayerX(MyIndex, GetPlayerX(MyIndex) - 1)
                
                    Case DIR_RIGHT
                        Call SendPlayerMove
                        Player(MyIndex).XOffset = PIC_X * -1
                        Call SetPlayerX(MyIndex, GetPlayerX(MyIndex) + 1)
                End Select
            
                ' Gotta check :)
                If Map.Tile(GetPlayerX(MyIndex), GetPlayerY(MyIndex)).Type = TILE_TYPE_WARP Then
                    GettingMap = True
                End If
            End If
        End If
    End If
End Sub

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

Public Sub EditorInit()
    SaveMap = Map
    InEditor = True
    frmMirage.picMapEditor.Visible = True
    With frmMirage.picBackSelect
        .Width = 7 * PIC_X
        .Height = 255 * PIC_Y
        .Picture = LoadPicture(App.Path + "\tiles.bmp")
    End With
End Sub

Public Sub EditorMouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
Dim x1, y1 As Long

    If InEditor Then
        x1 = Int(x / PIC_X)
        y1 = Int(y / PIC_Y)
        If (Button = 1) And (x1 >= 0) And (x1 <= MAX_MAPX) And (y1 >= 0) And (y1 <= MAX_MAPY) Then
            If frmMirage.optLayers.Value = True Then
                With Map.Tile(x1, y1)
                    If frmMirage.optGround.Value = True Then .Ground = EditorTileY * 7 + EditorTileX
                    If frmMirage.optMask.Value = True Then .Mask = EditorTileY * 7 + EditorTileX
                    If frmMirage.optAnim.Value = True Then .Anim = EditorTileY * 7 + EditorTileX
                    If frmMirage.optFringe.Value = True Then .Fringe = EditorTileY * 7 + EditorTileX
                End With
            Else
                With Map.Tile(x1, y1)
                    If frmMirage.optBlocked.Value = True Then .Type = TILE_TYPE_BLOCKED
                    If frmMirage.optWarp.Value = True Then
                        .Type = TILE_TYPE_WARP
                        .Data1 = EditorWarpMap
                        .Data2 = EditorWarpX
                        .Data3 = EditorWarpY
                    End If
                    If frmMirage.optItem.Value = True Then
                        .Type = TILE_TYPE_ITEM
                        .Data1 = ItemEditorNum
                        .Data2 = ItemEditorValue
                        .Data3 = 0
                    End If
                    If frmMirage.optNpcAvoid.Value = True Then
                        .Type = TILE_TYPE_NPCAVOID
                        .Data1 = 0
                        .Data2 = 0
                        .Data3 = 0
                    End If
                    If frmMirage.optKey.Value = True Then
                        .Type = TILE_TYPE_KEY
                        .Data1 = KeyEditorNum
                        .Data2 = KeyEditorTake
                        .Data3 = 0
                    End If
                    If frmMirage.optKeyOpen.Value = True Then
                        .Type = TILE_TYPE_KEYOPEN
                        .Data1 = KeyOpenEditorX
                        .Data2 = KeyOpenEditorY
                        .Data3 = 0
                    End If
                End With
            End If
        End If
        
        If (Button = 2) And (x1 >= 0) And (x1 <= MAX_MAPX) And (y1 >= 0) And (y1 <= MAX_MAPY) Then
            If frmMirage.optLayers.Value = True Then
                With Map.Tile(x1, y1)
                    If frmMirage.optGround.Value = True Then .Ground = 0
                    If frmMirage.optMask.Value = True Then .Mask = 0
                    If frmMirage.optAnim.Value = True Then .Anim = 0
                    If frmMirage.optFringe.Value = True Then .Fringe = 0
                End With
            Else
                With Map.Tile(x1, y1)
                    .Type = 0
                    .Data1 = 0
                    .Data2 = 0
                    .Data3 = 0
                End With
            End If
        End If
    End If
End Sub

Public Sub EditorChooseTile(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = 1 Then
        EditorTileX = Int(x / PIC_X)
        EditorTileY = Int(y / PIC_Y)
    End If
    Call BitBlt(frmMirage.picSelect.hdc, 0, 0, PIC_X, PIC_Y, frmMirage.picBackSelect.hdc, EditorTileX * PIC_X, EditorTileY * PIC_Y, SRCCOPY)
End Sub

Public Sub EditorTileScroll()
    frmMirage.picBackSelect.top = (frmMirage.scrlPicture.Value * PIC_Y) * -1
End Sub

Public Sub EditorSend()
    Call SendMap
    Call EditorCancel
End Sub

Public Sub EditorCancel()
    Map = SaveMap
    InEditor = False
    frmMirage.picMapEditor.Visible = False
End Sub

Public Sub EditorClearLayer()
Dim YesNo As Long, x As Long, y As Long

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

    ' Animation layer
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
End Sub

Public Sub EditorClearAttribs()
Dim YesNo As Long, x As Long, y As Long

    YesNo = MsgBox("Are you sure you wish to clear the attributes on this map?", vbYesNo, GAME_NAME)
    
    If YesNo = vbYes Then
        For y = 0 To MAX_MAPY
            For x = 0 To MAX_MAPX
                Map.Tile(x, y).Type = 0
            Next x
        Next y
    End If
End Sub

Public Sub ItemEditorInit()
On Error Resume Next
    
    frmItemEditor.picItems.Picture = LoadPicture(App.Path & "\items.bmp")
    
    frmItemEditor.txtName.Text = Trim(Item(EditorIndex).Name)
    frmItemEditor.scrlPic.Value = Item(EditorIndex).Pic
    frmItemEditor.cmbType.ListIndex = Item(EditorIndex).Type
    
    If (frmItemEditor.cmbType.ListIndex >= ITEM_TYPE_WEAPON) And (frmItemEditor.cmbType.ListIndex <= ITEM_TYPE_SHIELD) Then
        frmItemEditor.fraEquipment.Visible = True
        frmItemEditor.scrlDurability.Value = Item(EditorIndex).Data1
        frmItemEditor.scrlStrength.Value = Item(EditorIndex).Data2
    Else
        frmItemEditor.fraEquipment.Visible = False
    End If
    
    If (frmItemEditor.cmbType.ListIndex >= ITEM_TYPE_POTIONADDHP) And (frmItemEditor.cmbType.ListIndex <= ITEM_TYPE_POTIONSUBSP) Then
        frmItemEditor.fraVitals.Visible = True
        frmItemEditor.scrlVitalMod.Value = Item(EditorIndex).Data1
    Else
        frmItemEditor.fraVitals.Visible = False
    End If
    
    If (frmItemEditor.cmbType.ListIndex = ITEM_TYPE_SPELL) Then
        frmItemEditor.fraSpell.Visible = True
        frmItemEditor.scrlSpell.Value = Item(EditorIndex).Data1
    Else
        frmItemEditor.fraSpell.Visible = False
    End If
    
    frmItemEditor.Show vbModal
End Sub

Public Sub ItemEditorOk()
    Item(EditorIndex).Name = frmItemEditor.txtName.Text
    Item(EditorIndex).Pic = frmItemEditor.scrlPic.Value
    Item(EditorIndex).Type = frmItemEditor.cmbType.ListIndex

    If (frmItemEditor.cmbType.ListIndex >= ITEM_TYPE_WEAPON) And (frmItemEditor.cmbType.ListIndex <= ITEM_TYPE_SHIELD) Then
        Item(EditorIndex).Data1 = frmItemEditor.scrlDurability.Value
        Item(EditorIndex).Data2 = frmItemEditor.scrlStrength.Value
        Item(EditorIndex).Data3 = 0
    End If
    
    If (frmItemEditor.cmbType.ListIndex >= ITEM_TYPE_POTIONADDHP) And (frmItemEditor.cmbType.ListIndex <= ITEM_TYPE_POTIONSUBSP) Then
        Item(EditorIndex).Data1 = frmItemEditor.scrlVitalMod.Value
        Item(EditorIndex).Data2 = 0
        Item(EditorIndex).Data3 = 0
    End If
    
    If (frmItemEditor.cmbType.ListIndex = ITEM_TYPE_SPELL) Then
        Item(EditorIndex).Data1 = frmItemEditor.scrlSpell.Value
        Item(EditorIndex).Data2 = 0
        Item(EditorIndex).Data3 = 0
    End If
    
    Call SendSaveItem(EditorIndex)
    InItemsEditor = False
    Unload frmItemEditor
End Sub

Public Sub ItemEditorCancel()
    InItemsEditor = False
    Unload frmItemEditor
End Sub

Public Sub ItemEditorBltItem()
    Call BitBlt(frmItemEditor.picPic.hdc, 0, 0, PIC_X, PIC_Y, frmItemEditor.picItems.hdc, 0, frmItemEditor.scrlPic.Value * PIC_Y, SRCCOPY)
End Sub

Public Sub NpcEditorInit()
On Error Resume Next
    
    frmNpcEditor.picSprites.Picture = LoadPicture(App.Path & "\sprites.bmp")
    
    frmNpcEditor.txtName.Text = Trim(Npc(EditorIndex).Name)
    frmNpcEditor.txtAttackSay.Text = Trim(Npc(EditorIndex).AttackSay)
    frmNpcEditor.scrlSprite.Value = Npc(EditorIndex).Sprite
    frmNpcEditor.txtSpawnSecs.Text = STR(Npc(EditorIndex).SpawnSecs)
    frmNpcEditor.cmbBehavior.ListIndex = Npc(EditorIndex).Behavior
    frmNpcEditor.scrlRange.Value = Npc(EditorIndex).Range
    frmNpcEditor.txtChance.Text = STR(Npc(EditorIndex).DropChance)
    frmNpcEditor.scrlNum.Value = Npc(EditorIndex).DropItem
    frmNpcEditor.scrlValue.Value = Npc(EditorIndex).DropItemValue
    frmNpcEditor.scrlSTR.Value = Npc(EditorIndex).STR
    frmNpcEditor.scrlDEF.Value = Npc(EditorIndex).DEF
    frmNpcEditor.scrlSPEED.Value = Npc(EditorIndex).SPEED
    frmNpcEditor.scrlMAGI.Value = Npc(EditorIndex).MAGI
    
    frmNpcEditor.Show vbModal
End Sub

Public Sub NpcEditorOk()
    Npc(EditorIndex).Name = frmNpcEditor.txtName.Text
    Npc(EditorIndex).AttackSay = frmNpcEditor.txtAttackSay.Text
    Npc(EditorIndex).Sprite = frmNpcEditor.scrlSprite.Value
    Npc(EditorIndex).SpawnSecs = Val(frmNpcEditor.txtSpawnSecs.Text)
    Npc(EditorIndex).Behavior = frmNpcEditor.cmbBehavior.ListIndex
    Npc(EditorIndex).Range = frmNpcEditor.scrlRange.Value
    Npc(EditorIndex).DropChance = Val(frmNpcEditor.txtChance.Text)
    Npc(EditorIndex).DropItem = frmNpcEditor.scrlNum.Value
    Npc(EditorIndex).DropItemValue = frmNpcEditor.scrlValue.Value
    Npc(EditorIndex).STR = frmNpcEditor.scrlSTR.Value
    Npc(EditorIndex).DEF = frmNpcEditor.scrlDEF.Value
    Npc(EditorIndex).SPEED = frmNpcEditor.scrlSPEED.Value
    Npc(EditorIndex).MAGI = frmNpcEditor.scrlMAGI.Value
    
    Call SendSaveNpc(EditorIndex)
    InNpcEditor = False
    Unload frmNpcEditor
End Sub

Public Sub NpcEditorCancel()
    InNpcEditor = False
    Unload frmNpcEditor
End Sub

Public Sub NpcEditorBltSprite()
    Call BitBlt(frmNpcEditor.picSprite.hdc, 0, 0, PIC_X, PIC_Y, frmNpcEditor.picSprites.hdc, 3 * PIC_X, frmNpcEditor.scrlSprite.Value * PIC_Y, SRCCOPY)
End Sub

Public Sub ShopEditorInit()
On Error Resume Next

Dim i As Long

    frmShopEditor.txtName.Text = Trim(Shop(EditorIndex).Name)
    frmShopEditor.txtJoinSay.Text = Trim(Shop(EditorIndex).JoinSay)
    frmShopEditor.txtLeaveSay.Text = Trim(Shop(EditorIndex).LeaveSay)
    frmShopEditor.chkFixesItems.Value = Shop(EditorIndex).FixesItems
    
    frmShopEditor.cmbItemGive.Clear
    frmShopEditor.cmbItemGive.AddItem "None"
    frmShopEditor.cmbItemGet.Clear
    frmShopEditor.cmbItemGet.AddItem "None"
    For i = 1 To MAX_ITEMS
        frmShopEditor.cmbItemGive.AddItem i & ": " & Trim(Item(i).Name)
        frmShopEditor.cmbItemGet.AddItem i & ": " & Trim(Item(i).Name)
    Next i
    frmShopEditor.cmbItemGive.ListIndex = 0
    frmShopEditor.cmbItemGet.ListIndex = 0
    
    Call UpdateShopTrade
    
    frmShopEditor.Show vbModal
End Sub

Public Sub UpdateShopTrade()
Dim i As Long, GetItem As Long, GetValue As Long, GiveItem As Long, GiveValue As Long
    
    frmShopEditor.lstTradeItem.Clear
    For i = 1 To MAX_TRADES
        GetItem = Shop(EditorIndex).TradeItem(i).GetItem
        GetValue = Shop(EditorIndex).TradeItem(i).GetValue
        GiveItem = Shop(EditorIndex).TradeItem(i).GiveItem
        GiveValue = Shop(EditorIndex).TradeItem(i).GiveValue
        
        If GetItem > 0 And GiveItem > 0 Then
            frmShopEditor.lstTradeItem.AddItem i & ": " & GiveValue & " " & Trim(Item(GiveItem).Name) & " for " & GetValue & " " & Trim(Item(GetItem).Name)
        Else
            frmShopEditor.lstTradeItem.AddItem "Empty Trade Slot"
        End If
    Next i
    frmShopEditor.lstTradeItem.ListIndex = 0
End Sub

Public Sub ShopEditorOk()
    Shop(EditorIndex).Name = frmShopEditor.txtName.Text
    Shop(EditorIndex).JoinSay = frmShopEditor.txtJoinSay.Text
    Shop(EditorIndex).LeaveSay = frmShopEditor.txtLeaveSay.Text
    Shop(EditorIndex).FixesItems = frmShopEditor.chkFixesItems.Value
    
    Call SendSaveShop(EditorIndex)
    InShopEditor = False
    Unload frmShopEditor
End Sub

Public Sub ShopEditorCancel()
    InShopEditor = False
    Unload frmShopEditor
End Sub

Public Sub SpellEditorInit()
On Error Resume Next

Dim i As Long

    frmSpellEditor.cmbClassReq.AddItem "All Classes"
    For i = 0 To Max_Classes
        frmSpellEditor.cmbClassReq.AddItem Trim(Class(i).Name)
    Next i
    
    frmSpellEditor.txtName.Text = Trim(Spell(EditorIndex).Name)
    frmSpellEditor.cmbClassReq.ListIndex = Spell(EditorIndex).ClassReq
    frmSpellEditor.scrlLevelReq.Value = Spell(EditorIndex).LevelReq
        
    frmSpellEditor.cmbType.ListIndex = Spell(EditorIndex).Type
    If Spell(EditorIndex).Type <> SPELL_TYPE_GIVEITEM Then
        frmSpellEditor.fraVitals.Visible = True
        frmSpellEditor.fraGiveItem.Visible = False
        frmSpellEditor.scrlVitalMod.Value = Spell(EditorIndex).Data1
    Else
        frmSpellEditor.fraVitals.Visible = False
        frmSpellEditor.fraGiveItem.Visible = True
        frmSpellEditor.scrlItemNum.Value = Spell(EditorIndex).Data1
        frmSpellEditor.scrlItemValue.Value = Spell(EditorIndex).Data2
    End If
        
    frmSpellEditor.Show vbModal
End Sub

Public Sub SpellEditorOk()
    Spell(EditorIndex).Name = frmSpellEditor.txtName.Text
    Spell(EditorIndex).ClassReq = frmSpellEditor.cmbClassReq.ListIndex
    Spell(EditorIndex).LevelReq = frmSpellEditor.scrlLevelReq.Value
    Spell(EditorIndex).Type = frmSpellEditor.cmbType.ListIndex
    If Spell(EditorIndex).Type <> SPELL_TYPE_GIVEITEM Then
        Spell(EditorIndex).Data1 = frmSpellEditor.scrlVitalMod.Value
    Else
        Spell(EditorIndex).Data1 = frmSpellEditor.scrlItemNum.Value
        Spell(EditorIndex).Data2 = frmSpellEditor.scrlItemValue.Value
    End If
    Spell(EditorIndex).Data3 = 0
    
    Call SendSaveSpell(EditorIndex)
    InSpellEditor = False
    Unload frmSpellEditor
End Sub

Public Sub SpellEditorCancel()
    InSpellEditor = False
    Unload frmSpellEditor
End Sub

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
                End If
            End If
        Else
            frmMirage.lstInv.AddItem "<free inventory slot>"
        End If
    Next i
    
    frmMirage.lstInv.ListIndex = 0
End Sub

Sub ResizeGUI()
    If frmMirage.WindowState <> vbMinimized Then
        frmMirage.txtChat.Height = Int(frmMirage.Height / Screen.TwipsPerPixelY) - frmMirage.txtChat.top - 32
        frmMirage.txtChat.Width = Int(frmMirage.Width / Screen.TwipsPerPixelX) - 8
    End If
End Sub

Sub PlayerSearch(Button As Integer, Shift As Integer, x As Single, y As Single)
Dim x1 As Long, y1 As Long

    x1 = Int(x / PIC_X)
    y1 = Int(y / PIC_Y)
    
    If (x1 >= 0) And (x1 <= MAX_MAPX) And (y1 >= 0) And (y1 <= MAX_MAPY) Then
        Call SendData("search" & SEP_CHAR & x1 & SEP_CHAR & y1 & SEP_CHAR & END_CHAR)
    End If
End Sub

