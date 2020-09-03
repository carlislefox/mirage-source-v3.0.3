Attribute VB_Name = "modServerTCP"
Option Explicit

Sub UpdateCaption()
    frmServer.Caption = "Mirage Server <IP " & frmServer.Socket(0).LocalIP & " Port " & STR(frmServer.Socket(0).LocalPort) & "> (" & TotalOnlinePlayers & ")"
End Sub

Function IsConnected(ByVal Index As Long) As Boolean
    If frmServer.Socket(Index).State = sckConnected Then
        IsConnected = True
    Else
        IsConnected = False
    End If
End Function

Function IsPlaying(ByVal Index As Long) As Boolean
    If IsConnected(Index) And Player(Index).InGame = True Then
        IsPlaying = True
    Else
        IsPlaying = False
    End If
End Function

Function IsLoggedIn(ByVal Index As Long) As Boolean
    If IsConnected(Index) And Trim(Player(Index).Login) <> "" Then
        IsLoggedIn = True
    Else
        IsLoggedIn = False
    End If
End Function

Function IsMultiAccounts(ByVal Login As String) As Boolean
Dim i As Long

    IsMultiAccounts = False
    For i = 1 To MAX_PLAYERS
        If IsConnected(i) And LCase(Trim(Player(i).Login)) = LCase(Trim(Login)) Then
            IsMultiAccounts = True
            Exit Function
        End If
    Next i
End Function

Function IsMultiIPOnline(ByVal IP As String) As Boolean
Dim i As Long
Dim n As Long

    n = 0
    IsMultiIPOnline = False
    For i = 1 To MAX_PLAYERS
        If IsConnected(i) And Trim(GetPlayerIP(i)) = Trim(IP) Then
            n = n + 1
            
            If (n > 1) Then
                IsMultiIPOnline = True
                Exit Function
            End If
        End If
    Next i
End Function

Function IsBanned(ByVal IP As String) As Boolean
Dim FileName As String, fIP As String, fName As String
Dim f As Long

    IsBanned = False
    
    FileName = App.Path & "\banlist.txt"
    
    ' Check if file exists
    If Not FileExist("banlist.txt") Then
        f = FreeFile
        Open FileName For Output As #f
        Close #f
    End If
    
    f = FreeFile
    Open FileName For Input As #f
    
    Do While Not EOF(f)
        Input #f, fIP
        Input #f, fName
    
        ' Is banned?
        If Trim(LCase(fIP)) = Trim(LCase(Mid(IP, 1, Len(fIP)))) Then
            IsBanned = True
            Close #f
            Exit Function
        End If
    Loop
    
    Close #f
End Function

Sub SendDataTo(ByVal Index As Long, ByVal Data As String)
Dim i As Long, n As Long, startc As Long

    If IsConnected(Index) Then
        frmServer.Socket(Index).SendData Data
        DoEvents
    End If
End Sub

Sub SendDataToAll(ByVal Data As String)
Dim i As Long

    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) Then
            Call SendDataTo(i, Data)
        End If
    Next i
End Sub

Sub SendDataToAllBut(ByVal Index As Long, ByVal Data As String)
Dim i As Long

    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) And i <> Index Then
            Call SendDataTo(i, Data)
        End If
    Next i
End Sub

Sub SendDataToMap(ByVal MapNum As Long, ByVal Data As String)
Dim i As Long

    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) Then
            If GetPlayerMap(i) = MapNum Then
                Call SendDataTo(i, Data)
            End If
        End If
    Next i
End Sub

Sub SendDataToMapBut(ByVal Index As Long, ByVal MapNum As Long, ByVal Data As String)
Dim i As Long

    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) Then
            If GetPlayerMap(i) = MapNum And i <> Index Then
                Call SendDataTo(i, Data)
            End If
        End If
    Next i
End Sub

Sub GlobalMsg(ByVal Msg As String, ByVal Color As Byte)
Dim Packet As String

    Packet = "GLOBALMSG" & SEP_CHAR & Msg & SEP_CHAR & Color & SEP_CHAR & END_CHAR
    
    Call SendDataToAll(Packet)
End Sub

Sub AdminMsg(ByVal Msg As String, ByVal Color As Byte)
Dim Packet As String
Dim i As Long

    Packet = "ADMINMSG" & SEP_CHAR & Msg & SEP_CHAR & Color & SEP_CHAR & END_CHAR
    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) And GetPlayerAccess(i) > 0 Then
            Call SendDataTo(i, Packet)
        End If
    Next i
End Sub

Sub PlayerMsg(ByVal Index As Long, ByVal Msg As String, ByVal Color As Byte)
Dim Packet As String

    Packet = "PLAYERMSG" & SEP_CHAR & Msg & SEP_CHAR & Color & SEP_CHAR & END_CHAR
    
    Call SendDataTo(Index, Packet)
End Sub

Sub MapMsg(ByVal MapNum As Long, ByVal Msg As String, ByVal Color As Byte)
Dim Packet As String
Dim Text As String

    Packet = "MAPMSG" & SEP_CHAR & Msg & SEP_CHAR & Color & SEP_CHAR & END_CHAR
    
    Call SendDataToMap(MapNum, Packet)
End Sub

Sub AlertMsg(ByVal Index As Long, ByVal Msg As String)
Dim Packet As String

    Packet = "ALERTMSG" & SEP_CHAR & Msg & SEP_CHAR & END_CHAR
    
    Call SendDataTo(Index, Packet)
    Call CloseSocket(Index)
End Sub

Sub HackingAttempt(ByVal Index As Long, ByVal Reason As String)
    If Index > 0 Then
        If IsPlaying(Index) Then
            Call GlobalMsg(GetPlayerLogin(Index) & "/" & GetPlayerName(Index) & " has been booted for (" & Reason & ")", White)
        End If
    
        Call AlertMsg(Index, "You have lost your connection with " & GAME_NAME & ".")
    End If
End Sub

Sub AcceptConnection(ByVal Index As Long, ByVal SocketId As Long)
Dim i As Long

    If (Index = 0) Then
        i = FindOpenPlayerSlot
        
        If i <> 0 Then
            ' Whoho, we can connect them
            frmServer.Socket(i).Close
            frmServer.Socket(i).Accept SocketId
            Call SocketConnected(i)
        End If
    End If
End Sub

Sub SocketConnected(ByVal Index As Long)
    If Index <> 0 Then
        ' Are they trying to connect more then one connection?
        'If Not IsMultiIPOnline(GetPlayerIP(Index)) Then
            If Not IsBanned(GetPlayerIP(Index)) Then
                Call TextAdd(frmServer.txtText, "Received connection from " & GetPlayerIP(Index) & ".", True)
            Else
                Call AlertMsg(Index, "You have been banned from " & GAME_NAME & ", and can no longer play.")
            End If
        'Else
           ' Tried multiple connections
        '    Call AlertMsg(Index, GAME_NAME & " does not allow multiple IP's anymore.")
        'End If
    End If
End Sub

Sub IncomingData(ByVal Index As Long, ByVal DataLength As Long)
On Error Resume Next

Dim Buffer As String
Dim Packet As String
Dim top As String * 3
Dim Start As Integer

    If Index > 0 Then
        frmServer.Socket(Index).GetData Buffer, vbString, DataLength
        
        If Buffer = "top" Then
            top = STR(TotalOnlinePlayers)
            Call SendDataTo(Index, top)
            Call CloseSocket(Index)
        End If
            
        Player(Index).Buffer = Player(Index).Buffer & Buffer
        
        Start = InStr(Player(Index).Buffer, END_CHAR)
        Do While Start > 0
            Packet = Mid(Player(Index).Buffer, 1, Start - 1)
            Player(Index).Buffer = Mid(Player(Index).Buffer, Start + 1, Len(Player(Index).Buffer))
            Player(Index).DataPackets = Player(Index).DataPackets + 1
            Start = InStr(Player(Index).Buffer, END_CHAR)
            If Len(Packet) > 0 Then
                Call HandleData(Index, Packet)
            End If
        Loop
                
        ' Check if elapsed time has passed
        Player(Index).DataBytes = Player(Index).DataBytes + DataLength
        If GetTickCount >= Player(Index).DataTimer + 1000 Then
            Player(Index).DataTimer = GetTickCount
            Player(Index).DataBytes = 0
            Player(Index).DataPackets = 0
            Exit Sub
        End If
        
        ' Check for data flooding
        If Player(Index).DataBytes > 1000 And GetPlayerAccess(Index) <= 0 Then
            Call HackingAttempt(Index, "Data Flooding")
            Exit Sub
        End If
        
        ' Check for packet flooding
        If Player(Index).DataPackets > 25 And GetPlayerAccess(Index) <= 0 Then
            Call HackingAttempt(Index, "Packet Flooding")
            Exit Sub
        End If
    End If
End Sub

Sub HandleData(ByVal Index As Long, ByVal Data As String)
On Error Resume Next

Dim Parse() As String
Dim Name As String
Dim Password As String
Dim Sex As Long
Dim Class As Long
Dim CharNum As Long
Dim Msg As String
Dim IPMask As String
Dim BanSlot As Long
Dim MsgTo As Long
Dim Dir As Long
Dim InvNum As Long
Dim Ammount As Long
Dim Damage As Long
Dim PointType As Long
Dim BanPlayer As Long
Dim Movement As Long
Dim i As Long, n As Long, x As Long, y As Long, f As Long
Dim MapNum As Long
Dim s As String
Dim tMapStart As Long, tMapEnd As Long
Dim ShopNum As Long, ItemNum As Long
Dim DurNeeded As Long, GoldNeeded As Long
        
    ' Handle Data
    Parse = Split(Data, SEP_CHAR)
        
    ' :::::::::::::::::::::::::::::::::::::::::::::::
    ' :: Requesting classes for making a character ::
    ' :::::::::::::::::::::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "getclasses" Then
        If Not IsPlaying(Index) Then
            Call SendNewCharClasses(Index)
        End If
        Exit Sub
    End If
        
    ' ::::::::::::::::::::::::
    ' :: New account packet ::
    ' ::::::::::::::::::::::::
    If LCase(Parse(0)) = "newaccount" Then
        If Not IsPlaying(Index) And Not IsLoggedIn(Index) Then
            ' Get the data
            Name = Parse(1)
            Password = Parse(2)
        
            ' Prevent hacking
            If Len(Trim(Name)) < 3 Or Len(Trim(Password)) < 3 Then
                Call AlertMsg(Index, "Your name and password must be at least three characters in length")
                Exit Sub
            End If
            
            ' Prevent hacking
            For i = 1 To Len(Name)
                n = Asc(Mid(Name, i, 1))
                
                If (n >= 65 And n <= 90) Or (n >= 97 And n <= 122) Or (n = 95) Or (n = 32) Or (n >= 48 And n <= 57) Then
                Else
                    Call AlertMsg(Index, "Invalid name, only letters, numbers, spaces, and _ allowed in names.")
                    Exit Sub
                End If
            Next i
            
            ' Check to see if account already exists
            If Not AccountExist(Name) Then
                Call AddAccount(Index, Name, Password)
                Call TextAdd(frmServer.txtText, "Account " & Name & " has been created.", True)
                Call AddLog("Account " & Name & " has been created.", PLAYER_LOG)
                Call AlertMsg(Index, "Your account has been created!")
            Else
                Call AlertMsg(Index, "Sorry, that account name is already taken!")
            End If
        End If
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::::::
    ' :: Delete account packet ::
    ' :::::::::::::::::::::::::::
    If LCase(Parse(0)) = "delaccount" Then
        If Not IsPlaying(Index) And Not IsLoggedIn(Index) Then
            ' Get the data
            Name = Parse(1)
            Password = Parse(2)
            
            ' Prevent hacking
            If Len(Trim(Name)) < 3 Or Len(Trim(Password)) < 3 Then
                Call AlertMsg(Index, "The name and password must be at least three characters in length")
                Exit Sub
            End If
            
            If Not AccountExist(Name) Then
                Call AlertMsg(Index, "That account name does not exist.")
                Exit Sub
            End If
            
            If Not PasswordOK(Name, Password) Then
                Call AlertMsg(Index, "Incorrect password.")
                Exit Sub
            End If
                        
            ' Delete names from master name file
            Call LoadPlayer(Index, Name)
            For i = 1 To MAX_CHARS
                If Trim(Player(Index).Char(i).Name) <> "" Then
                    Call DeleteName(Player(Index).Char(i).Name)
                End If
            Next i
            Call ClearPlayer(Index)
            
            ' Everything went ok
            Call Kill(App.Path & "\accounts\" & Trim(Name) & ".ini")
            Call AddLog("Account " & Trim(Name) & " has been deleted.", PLAYER_LOG)
            Call AlertMsg(Index, "Your account has been deleted.")
        End If
        Exit Sub
    End If
        
    ' ::::::::::::::::::
    ' :: Login packet ::
    ' ::::::::::::::::::
    If LCase(Parse(0)) = "login" Then
        If Not IsPlaying(Index) And Not IsLoggedIn(Index) Then
            ' Get the data
            Name = Parse(1)
            Password = Parse(2)
        
            ' Check versions
            If Val(Parse(3)) < CLIENT_MAJOR Or Val(Parse(4)) < CLIENT_MINOR Or Val(Parse(5)) < CLIENT_REVISION Then
                Call AlertMsg(Index, "Version outdated, please visit http://mirage.katami.com")
                Exit Sub
            End If
            
            If Len(Trim(Name)) < 3 Or Len(Trim(Password)) < 3 Then
                Call AlertMsg(Index, "Your name and password must be at least three characters in length")
                Exit Sub
            End If
            
            If Not AccountExist(Name) Then
                Call AlertMsg(Index, "That account name does not exist.")
                Exit Sub
            End If
        
            If Not PasswordOK(Name, Password) Then
                Call AlertMsg(Index, "Incorrect password.")
                Exit Sub
            End If
        
            If IsMultiAccounts(Name) Then
                Call AlertMsg(Index, "Multiple account logins is not authorized.")
                Exit Sub
            End If
                
            ' Everything went ok
    
            ' Load the player
            Call LoadPlayer(Index, Name)
            Call SendChars(Index)
    
            ' Show the player up on the socket status
            Call AddLog(GetPlayerLogin(Index) & " has logged in from " & GetPlayerIP(Index) & ".", PLAYER_LOG)
            Call TextAdd(frmServer.txtText, GetPlayerLogin(Index) & " has logged in from " & GetPlayerIP(Index) & ".", True)
        End If
        Exit Sub
    End If

    ' ::::::::::::::::::::::::::
    ' :: Add character packet ::
    ' ::::::::::::::::::::::::::
    If LCase(Parse(0)) = "addchar" Then
        If Not IsPlaying(Index) Then
            Name = Parse(1)
            Sex = Val(Parse(2))
            Class = Val(Parse(3))
            CharNum = Val(Parse(4))
        
            ' Prevent hacking
            If Len(Trim(Name)) < 3 Then
                Call AlertMsg(Index, "Character name must be at least three characters in length.")
                Exit Sub
            End If
            
            ' Prevent being me
            If LCase(Trim(Name)) = "consty" Then
                Call AlertMsg(Index, "Lets get one thing straight, you are not me, ok? :)")
                Exit Sub
            End If
            
            ' Prevent hacking
            For i = 1 To Len(Name)
                n = Asc(Mid(Name, i, 1))
                
                If (n >= 65 And n <= 90) Or (n >= 97 And n <= 122) Or (n = 95) Or (n = 32) Or (n >= 48 And n <= 57) Then
                Else
                    Call AlertMsg(Index, "Invalid name, only letters, numbers, spaces, and _ allowed in names.")
                    Exit Sub
                End If
            Next i
                                    
            ' Prevent hacking
            If CharNum < 1 Or CharNum > MAX_CHARS Then
                Call HackingAttempt(Index, "Invalid CharNum")
                Exit Sub
            End If
        
            ' Prevent hacking
            If (Sex < SEX_MALE) Or (Sex > SEX_FEMALE) Then
                Call HackingAttempt(Index, "Invalid Sex (dont laugh)")
                Exit Sub
            End If
            
            ' Prevent hacking
            If Class < 0 Or Class > Max_Classes Then
                Call HackingAttempt(Index, "Invalid Class")
                Exit Sub
            End If
        
            ' Check if char already exists in slot
            If CharExist(Index, CharNum) Then
                Call AlertMsg(Index, "Character already exists!")
                Exit Sub
            End If
            
            ' Check if name is already in use
            If FindChar(Name) Then
                Call AlertMsg(Index, "Sorry, but that name is in use!")
                Exit Sub
            End If
        
            ' Everything went ok, add the character
            Call AddChar(Index, Name, Sex, Class, CharNum)
            Call SavePlayer(Index)
            Call AddLog("Character " & Name & " added to " & GetPlayerLogin(Index) & "'s account.", PLAYER_LOG)
            Call AlertMsg(Index, "Character has been created!")
        End If
        Exit Sub
    End If
        
    ' :::::::::::::::::::::::::::::::
    ' :: Deleting character packet ::
    ' :::::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "delchar" Then
        If Not IsPlaying(Index) Then
            CharNum = Val(Parse(1))
        
            ' Prevent hacking
            If CharNum < 1 Or CharNum > MAX_CHARS Then
                Call HackingAttempt(Index, "Invalid CharNum")
                Exit Sub
            End If
            
            Call DelChar(Index, CharNum)
            Call AddLog("Character deleted on " & GetPlayerLogin(Index) & "'s account.", PLAYER_LOG)
            Call AlertMsg(Index, "Character has been deleted!")
        End If
        Exit Sub
    End If
    
    ' ::::::::::::::::::::::::::::
    ' :: Using character packet ::
    ' ::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "usechar" Then
        If Not IsPlaying(Index) Then
            CharNum = Val(Parse(1))
        
            ' Prevent hacking
            If CharNum < 1 Or CharNum > MAX_CHARS Then
                Call HackingAttempt(Index, "Invalid CharNum")
                Exit Sub
            End If
        
            ' Check to make sure the character exists and if so, set it as its current char
            If CharExist(Index, CharNum) Then
                Player(Index).CharNum = CharNum
                Call JoinGame(Index)
            
                CharNum = Player(Index).CharNum
                Call AddLog(GetPlayerLogin(Index) & "/" & GetPlayerName(Index) & " has began playing " & GAME_NAME & ".", PLAYER_LOG)
                Call TextAdd(frmServer.txtText, GetPlayerLogin(Index) & "/" & GetPlayerName(Index) & " has began playing " & GAME_NAME & ".", True)
                Call UpdateCaption
                
                ' Now we want to check if they are already on the master list (this makes it add the user if they already haven't been added to the master list for older accounts)
                If Not FindChar(GetPlayerName(Index)) Then
                    f = FreeFile
                    Open App.Path & "\accounts\charlist.txt" For Append As #f
                        Print #f, GetPlayerName(Index)
                    Close #f
                End If
            Else
                Call AlertMsg(Index, "Character does not exist!")
            End If
        End If
        Exit Sub
    End If
        
    ' ::::::::::::::::::::
    ' :: Social packets ::
    ' ::::::::::::::::::::
    If LCase(Parse(0)) = "saymsg" Then
        Msg = Parse(1)
        
        ' Prevent hacking
        For i = 1 To Len(Msg)
            If Asc(Mid(Msg, i, 1)) < 32 Or Asc(Mid(Msg, i, 1)) > 126 Then
                Call HackingAttempt(Index, "Say Text Modification")
                Exit Sub
            End If
        Next i
        
        Call AddLog("Map #" & GetPlayerMap(Index) & ": " & GetPlayerName(Index) & " says, '" & Msg & "'", PLAYER_LOG)
        Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " says, '" & Msg & "'", SayColor)
        Exit Sub
    End If
    
    If LCase(Parse(0)) = "emotemsg" Then
        Msg = Parse(1)
        
        ' Prevent hacking
        For i = 1 To Len(Msg)
            If Asc(Mid(Msg, i, 1)) < 32 Or Asc(Mid(Msg, i, 1)) > 126 Then
                Call HackingAttempt(Index, "Emote Text Modification")
                Exit Sub
            End If
        Next i
        
        Call AddLog("Map #" & GetPlayerMap(Index) & ": " & GetPlayerName(Index) & " " & Msg, PLAYER_LOG)
        Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " " & Msg, EmoteColor)
        Exit Sub
    End If
    
    If LCase(Parse(0)) = "broadcastmsg" Then
        Msg = Parse(1)
        
        ' Prevent hacking
        For i = 1 To Len(Msg)
            If Asc(Mid(Msg, i, 1)) < 32 Or Asc(Mid(Msg, i, 1)) > 126 Then
                Call HackingAttempt(Index, "Broadcast Text Modification")
                Exit Sub
            End If
        Next i
        
        s = GetPlayerName(Index) & ": " & Msg
        Call AddLog(s, PLAYER_LOG)
        Call GlobalMsg(s, BroadcastColor)
        Call TextAdd(frmServer.txtText, s, True)
        Exit Sub
    End If
    
    If LCase(Parse(0)) = "globalmsg" Then
        Msg = Parse(1)
        
        ' Prevent hacking
        For i = 1 To Len(Msg)
            If Asc(Mid(Msg, i, 1)) < 32 Or Asc(Mid(Msg, i, 1)) > 126 Then
                Call HackingAttempt(Index, "Global Text Modification")
                Exit Sub
            End If
        Next i
        
        If GetPlayerAccess(Index) > 0 Then
            s = "(global) " & GetPlayerName(Index) & ": " & Msg
            Call AddLog(s, ADMIN_LOG)
            Call GlobalMsg(s, GlobalColor)
            Call TextAdd(frmServer.txtText, s, True)
        End If
        Exit Sub
    End If
    
    If LCase(Parse(0)) = "adminmsg" Then
        Msg = Parse(1)
        
        ' Prevent hacking
        For i = 1 To Len(Msg)
            If Asc(Mid(Msg, i, 1)) < 32 Or Asc(Mid(Msg, i, 1)) > 126 Then
                Call HackingAttempt(Index, "Admin Text Modification")
                Exit Sub
            End If
        Next i
        
        If GetPlayerAccess(Index) > 0 Then
            Call AddLog("(admin " & GetPlayerName(Index) & ") " & Msg, ADMIN_LOG)
            Call AdminMsg("(admin " & GetPlayerName(Index) & ") " & Msg, AdminColor)
        End If
        Exit Sub
    End If
    
    If LCase(Parse(0)) = "playermsg" Then
        MsgTo = FindPlayer(Parse(1))
        Msg = Parse(2)
        
        ' Prevent hacking
        For i = 1 To Len(Msg)
            If Asc(Mid(Msg, i, 1)) < 32 Or Asc(Mid(Msg, i, 1)) > 126 Then
                Call HackingAttempt(Index, "Player Msg Text Modification")
                Exit Sub
            End If
        Next i
        
        ' Check if they are trying to talk to themselves
        If MsgTo <> Index Then
            If MsgTo > 0 Then
                Call AddLog(GetPlayerName(Index) & " tells " & GetPlayerName(MsgTo) & ", " & Msg & "'", PLAYER_LOG)
                Call PlayerMsg(MsgTo, GetPlayerName(Index) & " tells you, '" & Msg & "'", TellColor)
                Call PlayerMsg(Index, "You tell " & GetPlayerName(MsgTo) & ", '" & Msg & "'", TellColor)
            Else
                Call PlayerMsg(Index, "Player is not online.", White)
            End If
        Else
            Call AddLog("Map #" & GetPlayerMap(Index) & ": " & GetPlayerName(Index) & " begins to mumble to himself, what a wierdo...", PLAYER_LOG)
            Call MapMsg(GetPlayerMap(Index), GetPlayerName(Index) & " begins to mumble to himself, what a wierdo...", Green)
        End If
        
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::::::::
    ' :: Moving character packet ::
    ' :::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "playermove" And Player(Index).GettingMap = NO Then
        Dir = Val(Parse(1))
        Movement = Val(Parse(2))
        
        ' Prevent hacking
        If Dir < DIR_UP Or Dir > DIR_RIGHT Then
            Call HackingAttempt(Index, "Invalid Direction")
            Exit Sub
        End If
        
        ' Prevent hacking
        If Movement < 1 Or Movement > 2 Then
            Call HackingAttempt(Index, "Invalid Movement")
            Exit Sub
        End If
        
        ' Prevent player from moving if they have casted a spell
        If Player(Index).CastedSpell = YES Then
            ' Check if they have already casted a spell, and if so we can't let them move
            If GetTickCount > Player(Index).AttackTimer + 1000 Then
                Player(Index).CastedSpell = NO
            Else
                Call SendPlayerXY(Index)
                Exit Sub
            End If
        End If
        
        Call PlayerMove(Index, Dir, Movement)
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::::::::
    ' :: Moving character packet ::
    ' :::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "playerdir" And Player(Index).GettingMap = NO Then
        Dir = Val(Parse(1))
        
        ' Prevent hacking
        If Dir < DIR_UP Or Dir > DIR_RIGHT Then
            Call HackingAttempt(Index, "Invalid Direction")
            Exit Sub
        End If
        
        Call SetPlayerDir(Index, Dir)
        Call SendDataToMapBut(Index, GetPlayerMap(Index), "PLAYERDIR" & SEP_CHAR & Index & SEP_CHAR & GetPlayerDir(Index) & SEP_CHAR & END_CHAR)
        Exit Sub
    End If
        
    ' :::::::::::::::::::::
    ' :: Use item packet ::
    ' :::::::::::::::::::::
    If LCase(Parse(0)) = "useitem" Then
        InvNum = Val(Parse(1))
        CharNum = Player(Index).CharNum
        
        ' Prevent hacking
        If InvNum < 1 Or InvNum > MAX_ITEMS Then
            Call HackingAttempt(Index, "Invalid InvNum")
            Exit Sub
        End If
        
        ' Prevent hacking
        If CharNum < 1 Or CharNum > MAX_CHARS Then
            Call HackingAttempt(Index, "Invalid CharNum")
            Exit Sub
        End If
        
        If (GetPlayerInvItemNum(Index, InvNum) > 0) And (GetPlayerInvItemNum(Index, InvNum) <= MAX_ITEMS) Then
            n = Item(GetPlayerInvItemNum(Index, InvNum)).Data2
            
            ' Find out what kind of item it is
            Select Case Item(GetPlayerInvItemNum(Index, InvNum)).Type
                Case ITEM_TYPE_ARMOR
                    If InvNum <> GetPlayerArmorSlot(Index) Then
                        If Int(GetPlayerDEF(Index)) < n Then
                            Call PlayerMsg(Index, "Your defense is to low to wear this armor!  Required DEF (" & n * 2 & ")", BrightRed)
                            Exit Sub
                        End If
                        Call SetPlayerArmorSlot(Index, InvNum)
                    Else
                        Call SetPlayerArmorSlot(Index, 0)
                    End If
                    Call SendWornEquipment(Index)
                
                Case ITEM_TYPE_WEAPON
                    If InvNum <> GetPlayerWeaponSlot(Index) Then
                        If Int(GetPlayerSTR(Index)) < n Then
                            Call PlayerMsg(Index, "Your strength is to low to hold this weapon!  Required STR (" & n * 2 & ")", BrightRed)
                            Exit Sub
                        End If
                        Call SetPlayerWeaponSlot(Index, InvNum)
                    Else
                        Call SetPlayerWeaponSlot(Index, 0)
                    End If
                    Call SendWornEquipment(Index)
                        
                Case ITEM_TYPE_HELMET
                    If InvNum <> GetPlayerHelmetSlot(Index) Then
                        If Int(GetPlayerSPEED(Index)) < n Then
                            Call PlayerMsg(Index, "Your speed coordination is to low to wear this helmet!  Required SPEED (" & n * 2 & ")", BrightRed)
                            Exit Sub
                        End If
                        Call SetPlayerHelmetSlot(Index, InvNum)
                    Else
                        Call SetPlayerHelmetSlot(Index, 0)
                    End If
                    Call SendWornEquipment(Index)
            
                Case ITEM_TYPE_SHIELD
                    If InvNum <> GetPlayerShieldSlot(Index) Then
                        Call SetPlayerShieldSlot(Index, InvNum)
                    Else
                        Call SetPlayerShieldSlot(Index, 0)
                    End If
                    Call SendWornEquipment(Index)
            
                Case ITEM_TYPE_POTIONADDHP
                    Call SetPlayerHP(Index, GetPlayerHP(Index) + Item(Player(Index).Char(CharNum).Inv(InvNum).Num).Data1)
                    Call TakeItem(Index, Player(Index).Char(CharNum).Inv(InvNum).Num, 0)
                    Call SendHP(Index)
                
                Case ITEM_TYPE_POTIONADDMP
                    Call SetPlayerMP(Index, GetPlayerMP(Index) + Item(Player(Index).Char(CharNum).Inv(InvNum).Num).Data1)
                    Call TakeItem(Index, Player(Index).Char(CharNum).Inv(InvNum).Num, 0)
                    Call SendMP(Index)
        
                Case ITEM_TYPE_POTIONADDSP
                    Call SetPlayerSP(Index, GetPlayerSP(Index) + Item(Player(Index).Char(CharNum).Inv(InvNum).Num).Data1)
                    Call TakeItem(Index, Player(Index).Char(CharNum).Inv(InvNum).Num, 0)
                    Call SendSP(Index)

                Case ITEM_TYPE_POTIONSUBHP
                    Call SetPlayerHP(Index, GetPlayerHP(Index) - Item(Player(Index).Char(CharNum).Inv(InvNum).Num).Data1)
                    Call TakeItem(Index, Player(Index).Char(CharNum).Inv(InvNum).Num, 0)
                    Call SendHP(Index)
                
                Case ITEM_TYPE_POTIONSUBMP
                    Call SetPlayerMP(Index, GetPlayerMP(Index) - Item(Player(Index).Char(CharNum).Inv(InvNum).Num).Data1)
                    Call TakeItem(Index, Player(Index).Char(CharNum).Inv(InvNum).Num, 0)
                    Call SendMP(Index)
        
                Case ITEM_TYPE_POTIONSUBSP
                    Call SetPlayerSP(Index, GetPlayerSP(Index) - Item(Player(Index).Char(CharNum).Inv(InvNum).Num).Data1)
                    Call TakeItem(Index, Player(Index).Char(CharNum).Inv(InvNum).Num, 0)
                    Call SendSP(Index)
                    
                Case ITEM_TYPE_KEY
                    Select Case GetPlayerDir(Index)
                        Case DIR_UP
                            If GetPlayerY(Index) > 0 Then
                                x = GetPlayerX(Index)
                                y = GetPlayerY(Index) - 1
                            Else
                                Exit Sub
                            End If
                            
                        Case DIR_DOWN
                            If GetPlayerY(Index) < MAX_MAPY Then
                                x = GetPlayerX(Index)
                                y = GetPlayerY(Index) + 1
                            Else
                                Exit Sub
                            End If
                                
                        Case DIR_LEFT
                            If GetPlayerX(Index) > 0 Then
                                x = GetPlayerX(Index) - 1
                                y = GetPlayerY(Index)
                            Else
                                Exit Sub
                            End If
                                
                        Case DIR_RIGHT
                            If GetPlayerX(Index) < MAX_MAPY Then
                                x = GetPlayerX(Index) + 1
                                y = GetPlayerY(Index)
                            Else
                                Exit Sub
                            End If
                    End Select
                    
                    ' Check if a key exists
                    If Map(GetPlayerMap(Index)).Tile(x, y).Type = TILE_TYPE_KEY Then
                        ' Check if the key they are using matches the map key
                        If GetPlayerInvItemNum(Index, InvNum) = Map(GetPlayerMap(Index)).Tile(x, y).Data1 Then
                            TempTile(GetPlayerMap(Index)).DoorOpen(x, y) = YES
                            TempTile(GetPlayerMap(Index)).DoorTimer = GetTickCount
                            
                            Call SendDataToMap(GetPlayerMap(Index), "MAPKEY" & SEP_CHAR & x & SEP_CHAR & y & SEP_CHAR & 1 & SEP_CHAR & END_CHAR)
                            Call MapMsg(GetPlayerMap(Index), "A door has been unlocked.", White)
                            
                            ' Check if we are supposed to take away the item
                            If Map(GetPlayerMap(Index)).Tile(x, y).Data2 = 1 Then
                                Call TakeItem(Index, GetPlayerInvItemNum(Index, InvNum), 0)
                                Call PlayerMsg(Index, "The key disolves.", Yellow)
                            End If
                        End If
                    End If
                    
                Case ITEM_TYPE_SPELL
                    ' Get the spell num
                    n = Item(GetPlayerInvItemNum(Index, InvNum)).Data1
                    
                    If n > 0 Then
                        ' Make sure they are the right class
                        If Spell(n).ClassReq - 1 = GetPlayerClass(Index) Or Spell(n).ClassReq = 0 Then
                            ' Make sure they are the right level
                            i = GetSpellReqLevel(Index, n)
                            If i <= GetPlayerLevel(Index) Then
                                i = FindOpenSpellSlot(Index)
                                
                                ' Make sure they have an open spell slot
                                If i > 0 Then
                                    ' Make sure they dont already have the spell
                                    If Not HasSpell(Index, n) Then
                                        Call SetPlayerSpell(Index, i, n)
                                        Call TakeItem(Index, GetPlayerInvItemNum(Index, InvNum), 0)
                                        Call PlayerMsg(Index, "You study the spell carefully...", Yellow)
                                        Call PlayerMsg(Index, "You have learned a new spell!", White)
                                    Else
                                        Call TakeItem(Index, GetPlayerInvItemNum(Index, InvNum), 0)
                                        Call PlayerMsg(Index, "You have already learned this spell!  The spells crumbles into dust.", BrightRed)
                                    End If
                                Else
                                    Call PlayerMsg(Index, "You have learned all that you can learn!", BrightRed)
                                End If
                            Else
                                Call PlayerMsg(Index, "You must be level " & i & " to learn this spell.", White)
                            End If
                        Else
                            Call PlayerMsg(Index, "This spell can only be learned by a " & GetClassName(Spell(n).ClassReq - 1) & ".", White)
                        End If
                    Else
                        Call PlayerMsg(Index, "This scroll is not connected to a spell, please inform an admin!", White)
                    End If
                    
            End Select
        End If
        Exit Sub
    End If
        
    ' ::::::::::::::::::::::::::
    ' :: Player attack packet ::
    ' ::::::::::::::::::::::::::
    If LCase(Parse(0)) = "attack" Then
        ' Try to attack a player
        For i = 1 To MAX_PLAYERS
            ' Make sure we dont try to attack ourselves
            If i <> Index Then
                ' Can we attack the player?
                If CanAttackPlayer(Index, i) Then
                    If Not CanPlayerBlockHit(i) Then
                        ' Get the damage we can do
                        If Not CanPlayerCriticalHit(Index) Then
                            Damage = GetPlayerDamage(Index) - GetPlayerProtection(i)
                        Else
                            n = GetPlayerDamage(Index)
                            Damage = n + Int(Rnd * Int(n / 2)) + 1 - GetPlayerProtection(i)
                            Call PlayerMsg(Index, "You feel a surge of energy upon swinging!", BrightCyan)
                            Call PlayerMsg(i, GetPlayerName(Index) & " swings with enormous might!", BrightCyan)
                        End If
                        
                        If Damage > 0 Then
                            Call AttackPlayer(Index, i, Damage)
                        Else
                            Call PlayerMsg(Index, "Your attack does nothing.", BrightRed)
                        End If
                    Else
                        Call PlayerMsg(Index, GetPlayerName(i) & "'s " & Trim(Item(GetPlayerInvItemNum(i, GetPlayerShieldSlot(i))).Name) & " has blocked your hit!", BrightCyan)
                        Call PlayerMsg(i, "Your " & Trim(Item(GetPlayerInvItemNum(i, GetPlayerShieldSlot(i))).Name) & " has blocked " & GetPlayerName(Index) & "'s hit!", BrightCyan)
                    End If
                    
                    Exit Sub
                End If
            End If
        Next i
        
        ' Try to attack a npc
        For i = 1 To MAX_MAP_NPCS
            ' Can we attack the npc?
            If CanAttackNpc(Index, i) Then
                ' Get the damage we can do
                If Not CanPlayerCriticalHit(Index) Then
                    Damage = GetPlayerDamage(Index) - Int(Npc(MapNpc(GetPlayerMap(Index), i).Num).DEF / 2)
                Else
                    n = GetPlayerDamage(Index)
                    Damage = n + Int(Rnd * Int(n / 2)) + 1 - Int(Npc(MapNpc(GetPlayerMap(Index), i).Num).DEF / 2)
                    Call PlayerMsg(Index, "You feel a surge of energy upon swinging!", BrightCyan)
                End If
                
                If Damage > 0 Then
                    Call AttackNpc(Index, i, Damage)
                Else
                    Call PlayerMsg(Index, "Your attack does nothing.", BrightRed)
                End If
                Exit Sub
            End If
        Next i
        
        Exit Sub
    End If
    
    ' ::::::::::::::::::::::
    ' :: Use stats packet ::
    ' ::::::::::::::::::::::
    If LCase(Parse(0)) = "usestatpoint" Then
        PointType = Val(Parse(1))
        
        ' Prevent hacking
        If (PointType < 0) Or (PointType > 3) Then
            Call HackingAttempt(Index, "Invalid Point Type")
            Exit Sub
        End If
                
        ' Make sure they have points
        If GetPlayerPOINTS(Index) > 0 Then
            ' Take away a stat point
            Call SetPlayerPOINTS(Index, GetPlayerPOINTS(Index) - 1)
            
            ' Everything is ok
            Select Case PointType
                Case 0
                    Call SetPlayerSTR(Index, GetPlayerSTR(Index) + 1)
                    Call PlayerMsg(Index, "You have gained more strength!", White)
                Case 1
                    Call SetPlayerDEF(Index, GetPlayerDEF(Index) + 1)
                    Call PlayerMsg(Index, "You have gained more defense!", White)
                Case 2
                    Call SetPlayerMAGI(Index, GetPlayerMAGI(Index) + 1)
                    Call PlayerMsg(Index, "You have gained more magic abilities!", White)
                Case 3
                    Call SetPlayerSPEED(Index, GetPlayerSPEED(Index) + 1)
                    Call PlayerMsg(Index, "You have gained more speed!", White)
            End Select
        Else
            Call PlayerMsg(Index, "You have no skill points to train with!", BrightRed)
        End If
        
        ' Send the update
        Call SendStats(Index)
        Exit Sub
    End If
    
    ' ::::::::::::::::::::::::::::::::
    ' :: Player info request packet ::
    ' ::::::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "playerinforequest" Then
        Name = Parse(1)
        
        i = FindPlayer(Name)
        If i > 0 Then
            Call PlayerMsg(Index, "Account: " & Trim(Player(i).Login) & ", Name: " & GetPlayerName(i), BrightGreen)
            If GetPlayerAccess(Index) > ADMIN_MONITER Then
                Call PlayerMsg(Index, "-=- Stats for " & GetPlayerName(i) & " -=-", BrightGreen)
                Call PlayerMsg(Index, "Level: " & GetPlayerLevel(i) & "  Exp: " & GetPlayerExp(i) & "/" & GetPlayerNextLevel(i), BrightGreen)
                Call PlayerMsg(Index, "HP: " & GetPlayerHP(i) & "/" & GetPlayerMaxHP(i) & "  MP: " & GetPlayerMP(i) & "/" & GetPlayerMaxMP(i) & "  SP: " & GetPlayerSP(i) & "/" & GetPlayerMaxSP(i), BrightGreen)
                Call PlayerMsg(Index, "STR: " & GetPlayerSTR(i) & "  DEF: " & GetPlayerDEF(i) & "  MAGI: " & GetPlayerMAGI(i) & "  SPEED: " & GetPlayerSPEED(i), BrightGreen)
                n = Int(GetPlayerSTR(i) / 2) + Int(GetPlayerLevel(i) / 2)
                i = Int(GetPlayerDEF(i) / 2) + Int(GetPlayerLevel(i) / 2)
                If n > 100 Then n = 100
                If i > 100 Then i = 100
                Call PlayerMsg(Index, "Critical Hit Chance: " & n & "%, Block Chance: " & i & "%", BrightGreen)
            End If
        Else
            Call PlayerMsg(Index, "Player is not online.", White)
        End If
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::
    ' :: Warp me to packet ::
    ' :::::::::::::::::::::::
    If LCase(Parse(0)) = "warpmeto" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' The player
        n = FindPlayer(Parse(1))
        
        If n <> Index Then
            If n > 0 Then
                Call PlayerWarp(Index, GetPlayerMap(n), GetPlayerX(n), GetPlayerY(n))
                Call PlayerMsg(n, GetPlayerName(Index) & " has warped to you.", BrightBlue)
                Call PlayerMsg(Index, "You have been warped to " & GetPlayerName(n) & ".", BrightBlue)
                Call AddLog(GetPlayerName(Index) & " has warped to " & GetPlayerName(n) & ", map #" & GetPlayerMap(n) & ".", ADMIN_LOG)
            Else
                Call PlayerMsg(Index, "Player is not online.", White)
            End If
        Else
            Call PlayerMsg(Index, "You cannot warp to yourself!", White)
        End If
                
        Exit Sub
    End If
        
    ' :::::::::::::::::::::::
    ' :: Warp to me packet ::
    ' :::::::::::::::::::::::
    If LCase(Parse(0)) = "warptome" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' The player
        n = FindPlayer(Parse(1))
        
        If n <> Index Then
            If n > 0 Then
                Call PlayerWarp(n, GetPlayerMap(Index), GetPlayerX(Index), GetPlayerY(Index))
                Call PlayerMsg(n, "You have been summoned by " & GetPlayerName(Index) & ".", BrightBlue)
                Call PlayerMsg(Index, GetPlayerName(n) & " has been summoned.", BrightBlue)
                Call AddLog(GetPlayerName(Index) & " has warped " & GetPlayerName(n) & " to self, map #" & GetPlayerMap(Index) & ".", ADMIN_LOG)
            Else
                Call PlayerMsg(Index, "Player is not online.", White)
            End If
        Else
            Call PlayerMsg(Index, "You cannot warp yourself to yourself!", White)
        End If
        
        Exit Sub
    End If


    ' ::::::::::::::::::::::::
    ' :: Warp to map packet ::
    ' ::::::::::::::::::::::::
    If LCase(Parse(0)) = "warpto" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' The map
        n = Val(Parse(1))
        
        ' Prevent hacking
        If n < 0 Or n > MAX_MAPS Then
            Call HackingAttempt(Index, "Invalid map")
            Exit Sub
        End If
        
        Call PlayerWarp(Index, n, GetPlayerX(Index), GetPlayerY(Index))
        Call PlayerMsg(Index, "You have been warped to map #" & n, BrightBlue)
        Call AddLog(GetPlayerName(Index) & " warped to map #" & n & ".", ADMIN_LOG)
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::
    ' :: Set sprite packet ::
    ' :::::::::::::::::::::::
    If LCase(Parse(0)) = "setsprite" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' The sprite
        n = Val(Parse(1))
        
        Call SetPlayerSprite(Index, n)
        Call SendPlayerData(Index)
        Exit Sub
    End If
                
    ' ::::::::::::::::::::::::::
    ' :: Stats request packet ::
    ' ::::::::::::::::::::::::::
    If LCase(Parse(0)) = "getstats" Then
        Call PlayerMsg(Index, "-=- Stats for " & GetPlayerName(Index) & " -=-", White)
        Call PlayerMsg(Index, "Level: " & GetPlayerLevel(Index) & "  Exp: " & GetPlayerExp(Index) & "/" & GetPlayerNextLevel(Index), White)
        Call PlayerMsg(Index, "HP: " & GetPlayerHP(Index) & "/" & GetPlayerMaxHP(Index) & "  MP: " & GetPlayerMP(Index) & "/" & GetPlayerMaxMP(Index) & "  SP: " & GetPlayerSP(Index) & "/" & GetPlayerMaxSP(Index), White)
        Call PlayerMsg(Index, "STR: " & GetPlayerSTR(Index) & "  DEF: " & GetPlayerDEF(Index) & "  MAGI: " & GetPlayerMAGI(Index) & "  SPEED: " & GetPlayerSPEED(Index), White)
        n = Int(GetPlayerSTR(Index) / 2) + Int(GetPlayerLevel(Index) / 2)
        i = Int(GetPlayerDEF(Index) / 2) + Int(GetPlayerLevel(Index) / 2)
        If n > 100 Then n = 100
        If i > 100 Then i = 100
        Call PlayerMsg(Index, "Critical Hit Chance: " & n & "%, Block Chance: " & i & "%", White)
        Exit Sub
    End If
    
    ' ::::::::::::::::::::::::::::::::::
    ' :: Player request for a new map ::
    ' ::::::::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "requestnewmap" Then
        Dir = Val(Parse(1))
        
        ' Prevent hacking
        If Dir < DIR_UP Or Dir > DIR_RIGHT Then
            Call HackingAttempt(Index, "Invalid Direction")
            Exit Sub
        End If
                
        Call PlayerMove(Index, Dir, 1)
        Exit Sub
    End If
    
    ' :::::::::::::::::::::
    ' :: Map data packet ::
    ' :::::::::::::::::::::
    If LCase(Parse(0)) = "mapdata" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        n = 1
        
        MapNum = GetPlayerMap(Index)
        Map(MapNum).Name = Parse(n + 1)
        Map(MapNum).Revision = Map(MapNum).Revision + 1
        Map(MapNum).Moral = Val(Parse(n + 3))
        Map(MapNum).Up = Val(Parse(n + 4))
        Map(MapNum).Down = Val(Parse(n + 5))
        Map(MapNum).Left = Val(Parse(n + 6))
        Map(MapNum).Right = Val(Parse(n + 7))
        Map(MapNum).Music = Val(Parse(n + 8))
        Map(MapNum).BootMap = Val(Parse(n + 9))
        Map(MapNum).BootX = Val(Parse(n + 10))
        Map(MapNum).BootY = Val(Parse(n + 11))
        Map(MapNum).Shop = Val(Parse(n + 12))
        
        n = n + 13
        
        For y = 0 To MAX_MAPY
            For x = 0 To MAX_MAPX
                Map(MapNum).Tile(x, y).Ground = Val(Parse(n))
                Map(MapNum).Tile(x, y).Mask = Val(Parse(n + 1))
                Map(MapNum).Tile(x, y).Anim = Val(Parse(n + 2))
                Map(MapNum).Tile(x, y).Fringe = Val(Parse(n + 3))
                Map(MapNum).Tile(x, y).Type = Val(Parse(n + 4))
                Map(MapNum).Tile(x, y).Data1 = Val(Parse(n + 5))
                Map(MapNum).Tile(x, y).Data2 = Val(Parse(n + 6))
                Map(MapNum).Tile(x, y).Data3 = Val(Parse(n + 7))
                
                n = n + 8
            Next x
        Next y
        
        For x = 1 To MAX_MAP_NPCS
            Map(MapNum).Npc(x) = Val(Parse(n))
            n = n + 1
            Call ClearMapNpc(x, MapNum)
        Next x
        Call SendMapNpcsToMap(MapNum)
        Call SpawnMapNpcs(MapNum)
        
        ' Save the map
        Call SaveMap(MapNum)
        
        ' Refresh map for everyone online
        For i = 1 To MAX_PLAYERS
            If IsPlaying(i) And GetPlayerMap(i) = MapNum Then
                Call PlayerWarp(i, MapNum, GetPlayerX(i), GetPlayerY(i))
            End If
        Next i
        
        Exit Sub
    End If

    ' ::::::::::::::::::::::::::::
    ' :: Need map yes/no packet ::
    ' ::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "needmap" Then
        ' Get yes/no value
        s = LCase(Parse(1))
                
        If s = "yes" Then
            Call SendMap(Index, GetPlayerMap(Index))
            Call SendMapItemsTo(Index, GetPlayerMap(Index))
            Call SendMapNpcsTo(Index, GetPlayerMap(Index))
            Call SendJoinMap(Index)
            Player(Index).GettingMap = NO
            Call SendDataTo(Index, "MAPDONE" & SEP_CHAR & END_CHAR)
        Else
            Call SendMapItemsTo(Index, GetPlayerMap(Index))
            Call SendMapNpcsTo(Index, GetPlayerMap(Index))
            Call SendJoinMap(Index)
            Player(Index).GettingMap = NO
            Call SendDataTo(Index, "MAPDONE" & SEP_CHAR & END_CHAR)
        End If
        
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::::::::::::::::::::::::::
    ' :: Player trying to pick up something packet ::
    ' :::::::::::::::::::::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "mapgetitem" Then
        Call PlayerMapGetItem(Index)
        Exit Sub
    End If
    
    ' ::::::::::::::::::::::::::::::::::::::::::::
    ' :: Player trying to drop something packet ::
    ' ::::::::::::::::::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "mapdropitem" Then
        InvNum = Val(Parse(1))
        Ammount = Val(Parse(2))
        
        ' Prevent hacking
        If InvNum < 1 Or InvNum > MAX_INV Then
            Call HackingAttempt(Index, "Invalid InvNum")
            Exit Sub
        End If
        
        ' Prevent hacking
        If Ammount > GetPlayerInvItemValue(Index, InvNum) Then
            Call HackingAttempt(Index, "Item ammount modification")
            Exit Sub
        End If
        
        ' Prevent hacking
        If Item(GetPlayerInvItemNum(Index, InvNum)).Type = ITEM_TYPE_CURRENCY Then
            ' Check if money and if it is we want to make sure that they aren't trying to drop 0 value
            If Ammount <= 0 Then
                Call HackingAttempt(Index, "Trying to drop 0 ammount of currency")
                Exit Sub
            End If
        End If
            
        Call PlayerMapDropItem(Index, InvNum, Ammount)
        Exit Sub
    End If
    
    ' ::::::::::::::::::::::::
    ' :: Respawn map packet ::
    ' ::::::::::::::::::::::::
    If LCase(Parse(0)) = "maprespawn" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' Clear out it all
        For i = 1 To MAX_MAP_ITEMS
            Call SpawnItemSlot(i, 0, 0, 0, GetPlayerMap(Index), MapItem(GetPlayerMap(Index), i).x, MapItem(GetPlayerMap(Index), i).y)
            Call ClearMapItem(i, GetPlayerMap(Index))
        Next i
        
        ' Respawn
        Call SpawnMapItems(GetPlayerMap(Index))
        
        ' Respawn NPCS
        For i = 1 To MAX_MAP_NPCS
            Call SpawnNpc(i, GetPlayerMap(Index))
        Next i
        
        Call PlayerMsg(Index, "Map respawned.", Blue)
        Call AddLog(GetPlayerName(Index) & " has respawned map #" & GetPlayerMap(Index), ADMIN_LOG)
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::
    ' :: Map report packet ::
    ' :::::::::::::::::::::::
    If LCase(Parse(0)) = "mapreport" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If

        s = "Free Maps: "
        tMapStart = 1
        tMapEnd = 1
        
        For i = 1 To MAX_MAPS
            If Trim(Map(i).Name) = "" Then
                tMapEnd = tMapEnd + 1
            Else
                If tMapEnd - tMapStart > 0 Then
                    s = s & Trim(STR(tMapStart)) & "-" & Trim(STR(tMapEnd - 1)) & ", "
                End If
                tMapStart = i + 1
                tMapEnd = i + 1
            End If
        Next i
        
        s = s & Trim(STR(tMapStart)) & "-" & Trim(STR(tMapEnd - 1)) & ", "
        s = Mid(s, 1, Len(s) - 2)
        s = s & "."
        
        Call PlayerMsg(Index, s, Brown)
        Exit Sub
    End If
    
    ' ::::::::::::::::::::::::
    ' :: Kick player packet ::
    ' ::::::::::::::::::::::::
    If LCase(Parse(0)) = "kickplayer" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) <= 0 Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' The player index
        n = FindPlayer(Parse(1))
        
        If n <> Index Then
            If n > 0 Then
                If GetPlayerAccess(n) <= GetPlayerAccess(Index) Then
                    Call GlobalMsg(GetPlayerName(n) & " has been kicked from " & GAME_NAME & " by " & GetPlayerName(Index) & "!", White)
                    Call AddLog(GetPlayerName(Index) & " has kicked " & GetPlayerName(n) & ".", ADMIN_LOG)
                    Call AlertMsg(n, "You have been kicked by " & GetPlayerName(Index) & "!")
                Else
                    Call PlayerMsg(Index, "That is a higher access admin then you!", White)
                End If
            Else
                Call PlayerMsg(Index, "Player is not online.", White)
            End If
        Else
            Call PlayerMsg(Index, "You cannot kick yourself!", White)
        End If
                
        Exit Sub
    End If
        
    ' :::::::::::::::::::::
    ' :: Ban list packet ::
    ' :::::::::::::::::::::
    If LCase(Parse(0)) = "banlist" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        n = 1
        f = FreeFile
        Open App.Path & "\banlist.txt" For Input As #f
        Do While Not EOF(f)
            Input #f, s
            Input #f, Name
            
            Call PlayerMsg(Index, n & ": Banned IP " & s & " by " & Name, White)
            n = n + 1
        Loop
        Close #f
        Exit Sub
    End If
    
    ' ::::::::::::::::::::::::
    ' :: Ban destroy packet ::
    ' ::::::::::::::::::::::::
    If LCase(Parse(0)) = "bandestroy" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_CREATOR Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        Call Kill(App.Path & "\banlist.txt")
        Call PlayerMsg(Index, "Ban list destroyed.", White)
        Exit Sub
    End If
        
    ' :::::::::::::::::::::::
    ' :: Ban player packet ::
    ' :::::::::::::::::::::::
    If LCase(Parse(0)) = "banplayer" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' The player index
        n = FindPlayer(Parse(1))
        
        If n <> Index Then
            If n > 0 Then
                If GetPlayerAccess(n) <= GetPlayerAccess(Index) Then
                    Call BanIndex(n, Index)
                Else
                    Call PlayerMsg(Index, "That is a higher access admin then you!", White)
                End If
            Else
                Call PlayerMsg(Index, "Player is not online.", White)
            End If
        Else
            Call PlayerMsg(Index, "You cannot ban yourself!", White)
        End If
                
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::::::::
    ' :: Request edit map packet ::
    ' :::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "requesteditmap" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        Call SendDataTo(Index, "EDITMAP" & SEP_CHAR & END_CHAR)
        Exit Sub
    End If
    
    ' ::::::::::::::::::::::::::::::
    ' :: Request edit item packet ::
    ' ::::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "requestedititem" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        Call SendDataTo(Index, "ITEMEDITOR" & SEP_CHAR & END_CHAR)
        Exit Sub
    End If

    ' ::::::::::::::::::::::
    ' :: Edit item packet ::
    ' ::::::::::::::::::::::
    If LCase(Parse(0)) = "edititem" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' The item #
        n = Val(Parse(1))
        
        ' Prevent hacking
        If n < 0 Or n > MAX_ITEMS Then
            Call HackingAttempt(Index, "Invalid Item Index")
            Exit Sub
        End If
        
        Call AddLog(GetPlayerName(Index) & " editing item #" & n & ".", ADMIN_LOG)
        Call SendEditItemTo(Index, n)
    End If
    
    ' ::::::::::::::::::::::
    ' :: Save item packet ::
    ' ::::::::::::::::::::::
    If LCase(Parse(0)) = "saveitem" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        n = Val(Parse(1))
        If n < 0 Or n > MAX_ITEMS Then
            Call HackingAttempt(Index, "Invalid Item Index")
            Exit Sub
        End If
        
        ' Update the item
        Item(n).Name = Parse(2)
        Item(n).Pic = Val(Parse(3))
        Item(n).Type = Val(Parse(4))
        Item(n).Data1 = Val(Parse(5))
        Item(n).Data2 = Val(Parse(6))
        Item(n).Data3 = Val(Parse(7))
        
        ' Save it
        Call SendUpdateItemToAll(n)
        Call SaveItem(n)
        Call AddLog(GetPlayerName(Index) & " saved item #" & n & ".", ADMIN_LOG)
        Exit Sub
    End If

    ' :::::::::::::::::::::::::::::
    ' :: Request edit npc packet ::
    ' :::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "requesteditnpc" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        Call SendDataTo(Index, "NPCEDITOR" & SEP_CHAR & END_CHAR)
        Exit Sub
    End If
    
    ' :::::::::::::::::::::
    ' :: Edit npc packet ::
    ' :::::::::::::::::::::
    If LCase(Parse(0)) = "editnpc" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' The npc #
        n = Val(Parse(1))
        
        ' Prevent hacking
        If n < 0 Or n > MAX_NPCS Then
            Call HackingAttempt(Index, "Invalid NPC Index")
            Exit Sub
        End If
        
        Call AddLog(GetPlayerName(Index) & " editing npc #" & n & ".", ADMIN_LOG)
        Call SendEditNpcTo(Index, n)
    End If
    
    ' :::::::::::::::::::::
    ' :: Save npc packet ::
    ' :::::::::::::::::::::
    If LCase(Parse(0)) = "savenpc" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        n = Val(Parse(1))
        
        ' Prevent hacking
        If n < 0 Or n > MAX_NPCS Then
            Call HackingAttempt(Index, "Invalid NPC Index")
            Exit Sub
        End If
        
        ' Update the npc
        Npc(n).Name = Parse(2)
        Npc(n).AttackSay = Parse(3)
        Npc(n).Sprite = Val(Parse(4))
        Npc(n).SpawnSecs = Val(Parse(5))
        Npc(n).Behavior = Val(Parse(6))
        Npc(n).Range = Val(Parse(7))
        Npc(n).DropChance = Val(Parse(8))
        Npc(n).DropItem = Val(Parse(9))
        Npc(n).DropItemValue = Val(Parse(10))
        Npc(n).STR = Val(Parse(11))
        Npc(n).DEF = Val(Parse(12))
        Npc(n).SPEED = Val(Parse(13))
        Npc(n).MAGI = Val(Parse(14))
        
        ' Save it
        Call SendUpdateNpcToAll(n)
        Call SaveNpc(n)
        Call AddLog(GetPlayerName(Index) & " saved npc #" & n & ".", ADMIN_LOG)
        Exit Sub
    End If
            
    ' ::::::::::::::::::::::::::::::
    ' :: Request edit shop packet ::
    ' ::::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "requesteditshop" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        Call SendDataTo(Index, "SHOPEDITOR" & SEP_CHAR & END_CHAR)
        Exit Sub
    End If
    
    ' ::::::::::::::::::::::
    ' :: Edit shop packet ::
    ' ::::::::::::::::::::::
    If LCase(Parse(0)) = "editshop" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' The shop #
        n = Val(Parse(1))
        
        ' Prevent hacking
        If n < 0 Or n > MAX_SHOPS Then
            Call HackingAttempt(Index, "Invalid Shop Index")
            Exit Sub
        End If
        
        Call AddLog(GetPlayerName(Index) & " editing shop #" & n & ".", ADMIN_LOG)
        Call SendEditShopTo(Index, n)
    End If
    
    ' ::::::::::::::::::::::
    ' :: Save shop packet ::
    ' ::::::::::::::::::::::
    If (LCase(Parse(0)) = "saveshop") Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ShopNum = Val(Parse(1))
        
        ' Prevent hacking
        If ShopNum < 0 Or ShopNum > MAX_SHOPS Then
            Call HackingAttempt(Index, "Invalid Shop Index")
            Exit Sub
        End If
        
        ' Update the shop
        Shop(ShopNum).Name = Parse(2)
        Shop(ShopNum).JoinSay = Parse(3)
        Shop(ShopNum).LeaveSay = Parse(4)
        Shop(ShopNum).FixesItems = Val(Parse(5))
        
        n = 6
        For i = 1 To MAX_TRADES
            Shop(ShopNum).TradeItem(i).GiveItem = Val(Parse(n))
            Shop(ShopNum).TradeItem(i).GiveValue = Val(Parse(n + 1))
            Shop(ShopNum).TradeItem(i).GetItem = Val(Parse(n + 2))
            Shop(ShopNum).TradeItem(i).GetValue = Val(Parse(n + 3))
            n = n + 4
        Next i
        
        ' Save it
        Call SendUpdateShopToAll(ShopNum)
        Call SaveShop(ShopNum)
        Call AddLog(GetPlayerName(Index) & " saving shop #" & ShopNum & ".", ADMIN_LOG)
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::::::::::
    ' :: Request edit spell packet ::
    ' :::::::::::::::::::::::::::::::
    If LCase(Parse(0)) = "requesteditspell" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        Call SendDataTo(Index, "SPELLEDITOR" & SEP_CHAR & END_CHAR)
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::
    ' :: Edit spell packet ::
    ' :::::::::::::::::::::::
    If LCase(Parse(0)) = "editspell" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' The spell #
        n = Val(Parse(1))
        
        ' Prevent hacking
        If n < 0 Or n > MAX_SPELLS Then
            Call HackingAttempt(Index, "Invalid Spell Index")
            Exit Sub
        End If
        
        Call AddLog(GetPlayerName(Index) & " editing spell #" & n & ".", ADMIN_LOG)
        Call SendEditSpellTo(Index, n)
    End If
    
    ' :::::::::::::::::::::::
    ' :: Save spell packet ::
    ' :::::::::::::::::::::::
    If (LCase(Parse(0)) = "savespell") Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_DEVELOPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        ' Spell #
        n = Val(Parse(1))
        
        ' Prevent hacking
        If n < 0 Or n > MAX_SPELLS Then
            Call HackingAttempt(Index, "Invalid Spell Index")
            Exit Sub
        End If
        
        ' Update the spell
        Spell(n).Name = Parse(2)
        Spell(n).ClassReq = Val(Parse(3))
        Spell(n).LevelReq = Val(Parse(4))
        Spell(n).Type = Val(Parse(5))
        Spell(n).Data1 = Val(Parse(6))
        Spell(n).Data2 = Val(Parse(7))
        Spell(n).Data3 = Val(Parse(8))
                
        ' Save it
        Call SendUpdateSpellToAll(n)
        Call SaveSpell(n)
        Call AddLog(GetPlayerName(Index) & " saving spell #" & n & ".", ADMIN_LOG)
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::
    ' :: Set access packet ::
    ' :::::::::::::::::::::::
    If LCase(Parse(0)) = "setaccess" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_CREATOR Then
            Call HackingAttempt(Index, "Trying to use powers not available")
            Exit Sub
        End If
        
        ' The index
        n = FindPlayer(Parse(1))
        ' The access
        i = Val(Parse(2))
        
        
        ' Check for invalid access level
        If i >= 0 Or i <= 3 Then
            ' Check if player is on
            If n > 0 Then
                If GetPlayerAccess(n) <= 0 Then
                    Call GlobalMsg(GetPlayerName(n) & " has been blessed with administrative access.", BrightBlue)
                End If
                
                Call SetPlayerAccess(n, i)
                Call SendPlayerData(n)
                Call AddLog(GetPlayerName(Index) & " has modified " & GetPlayerName(n) & "'s access.", ADMIN_LOG)
            Else
                Call PlayerMsg(Index, "Player is not online.", White)
            End If
        Else
            Call PlayerMsg(Index, "Invalid access level.", Red)
        End If
                
        Exit Sub
    End If
    
    ' :::::::::::::::::::::::
    ' :: Who online packet ::
    ' :::::::::::::::::::::::
    If LCase(Parse(0)) = "whosonline" Then
        Call SendWhosOnline(Index)
        Exit Sub
    End If
    
    ' :::::::::::::::::::::
    ' :: Set MOTD packet ::
    ' :::::::::::::::::::::
    If LCase(Parse(0)) = "setmotd" Then
        ' Prevent hacking
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        Call PutVar(App.Path & "\motd.ini", "MOTD", "Msg", Parse(1))
        Call GlobalMsg("MOTD changed to: " & Parse(1), BrightCyan)
        Call AddLog(GetPlayerName(Index) & " changed MOTD to: " & Parse(1), ADMIN_LOG)
        Exit Sub
    End If
    
    ' ::::::::::::::::::
    ' :: Trade packet ::
    ' ::::::::::::::::::
    If LCase(Parse(0)) = "trade" Then
        If Map(GetPlayerMap(Index)).Shop > 0 Then
            Call SendTrade(Index, Map(GetPlayerMap(Index)).Shop)
        Else
            Call PlayerMsg(Index, "There is no shop here.", BrightRed)
        End If
        Exit Sub
    End If

    ' ::::::::::::::::::::::::::
    ' :: Trade request packet ::
    ' ::::::::::::::::::::::::::
    If LCase(Parse(0)) = "traderequest" Then
        ' Trade num
        n = Val(Parse(1))
        
        ' Prevent hacking
        If (n <= 0) Or (n > MAX_TRADES) Then
            Call HackingAttempt(Index, "Trade Request Modification")
            Exit Sub
        End If
        
        ' Index for shop
        i = Map(GetPlayerMap(Index)).Shop
        
        ' Check if inv full
        x = FindOpenInvSlot(Index, Shop(i).TradeItem(n).GetItem)
        If x = 0 Then
            Call PlayerMsg(Index, "Trade unsuccessful, inventory full.", BrightRed)
            Exit Sub
        End If
        
        ' Check if they have the item
        If HasItem(Index, Shop(i).TradeItem(n).GiveItem) >= Shop(i).TradeItem(n).GiveValue Then
            Call TakeItem(Index, Shop(i).TradeItem(n).GiveItem, Shop(i).TradeItem(n).GiveValue)
            Call GiveItem(Index, Shop(i).TradeItem(n).GetItem, Shop(i).TradeItem(n).GetValue)
            Call PlayerMsg(Index, "The trade was successful!", Yellow)
        Else
            Call PlayerMsg(Index, "Trade unsuccessful.", BrightRed)
        End If
        Exit Sub
    End If

    ' :::::::::::::::::::::
    ' :: Fix item packet ::
    ' :::::::::::::::::::::
    If LCase(Parse(0)) = "fixitem" Then
        ' Inv num
        n = Val(Parse(1))
        
        ' Make sure its a equipable item
        If Item(GetPlayerInvItemNum(Index, n)).Type < ITEM_TYPE_WEAPON Or Item(GetPlayerInvItemNum(Index, n)).Type > ITEM_TYPE_SHIELD Then
            Call PlayerMsg(Index, "You can only fix weapons, armors, helmets, and shields.", BrightRed)
            Exit Sub
        End If
        
        ' Check if they have a full inventory
        If FindOpenInvSlot(Index, GetPlayerInvItemNum(Index, n)) <= 0 Then
            Call PlayerMsg(Index, "You have no inventory space left!", BrightRed)
            Exit Sub
        End If
        
        ' Now check the rate of pay
        ItemNum = GetPlayerInvItemNum(Index, n)
        i = Int(Item(GetPlayerInvItemNum(Index, n)).Data2 / 5)
        If i <= 0 Then i = 1
        
        DurNeeded = Item(ItemNum).Data1 - GetPlayerInvItemDur(Index, n)
        GoldNeeded = Int(DurNeeded * i / 2)
        If GoldNeeded <= 0 Then GoldNeeded = 1
        
        ' Check if they even need it repaired
        If DurNeeded <= 0 Then
            Call PlayerMsg(Index, "This item is in perfect condition!", White)
            Exit Sub
        End If
        
        ' Check if they have enough for at least one point
        If HasItem(Index, 1) >= i Then
            ' Check if they have enough for a total restoration
            If HasItem(Index, 1) >= GoldNeeded Then
                Call TakeItem(Index, 1, GoldNeeded)
                Call SetPlayerInvItemDur(Index, n, Item(ItemNum).Data1)
                Call PlayerMsg(Index, "Item has been totally restored for " & GoldNeeded & " gold!", BrightBlue)
            Else
                ' They dont so restore as much as we can
                DurNeeded = (HasItem(Index, 1) / i)
                GoldNeeded = Int(DurNeeded * i / 2)
                If GoldNeeded <= 0 Then GoldNeeded = 1
                
                Call TakeItem(Index, 1, GoldNeeded)
                Call SetPlayerInvItemDur(Index, n, GetPlayerInvItemDur(Index, n) + DurNeeded)
                Call PlayerMsg(Index, "Item has been partially fixed for " & GoldNeeded & " gold!", BrightBlue)
            End If
        Else
            Call PlayerMsg(Index, "Insufficient gold to fix this item!", BrightRed)
        End If
        Exit Sub
    End If

    ' :::::::::::::::::::
    ' :: Search packet ::
    ' :::::::::::::::::::
    If LCase(Parse(0)) = "search" Then
        x = Val(Parse(1))
        y = Val(Parse(2))
        
        ' Prevent subscript out of range
        If x < 0 Or x > MAX_MAPX Or y < 0 Or y > MAX_MAPY Then
            Exit Sub
        End If
        
        ' Check for a player
        For i = 1 To MAX_PLAYERS
            If IsPlaying(i) And GetPlayerMap(Index) = GetPlayerMap(i) And GetPlayerX(i) = x And GetPlayerY(i) = y Then
                
                ' Consider the player
                If GetPlayerLevel(i) >= GetPlayerLevel(Index) + 5 Then
                    Call PlayerMsg(Index, "You wouldn't stand a chance.", BrightRed)
                Else
                    If GetPlayerLevel(i) > GetPlayerLevel(Index) Then
                        Call PlayerMsg(Index, "This one seems to have an advantage over you.", Yellow)
                    Else
                        If GetPlayerLevel(i) = GetPlayerLevel(Index) Then
                            Call PlayerMsg(Index, "This would be an even fight.", White)
                        Else
                            If GetPlayerLevel(Index) >= GetPlayerLevel(i) + 5 Then
                                Call PlayerMsg(Index, "You could slaughter that player.", BrightBlue)
                            Else
                                If GetPlayerLevel(Index) > GetPlayerLevel(i) Then
                                    Call PlayerMsg(Index, "You would have an advantage over that player.", Yellow)
                                End If
                            End If
                        End If
                    End If
                End If
            
                ' Change target
                Player(Index).Target = i
                Player(Index).TargetType = TARGET_TYPE_PLAYER
                Call PlayerMsg(Index, "Your target is now " & GetPlayerName(i) & ".", Yellow)
                Exit Sub
            End If
        Next i
        
        ' Check for an item
        For i = 1 To MAX_MAP_ITEMS
            If MapItem(GetPlayerMap(Index), i).Num > 0 Then
                If MapItem(GetPlayerMap(Index), i).x = x And MapItem(GetPlayerMap(Index), i).y = y Then
                    Call PlayerMsg(Index, "You see a " & Trim(Item(MapItem(GetPlayerMap(Index), i).Num).Name) & ".", Yellow)
                    Exit Sub
                End If
            End If
        Next i
        
        ' Check for an npc
        For i = 1 To MAX_MAP_NPCS
            If MapNpc(GetPlayerMap(Index), i).Num > 0 Then
                If MapNpc(GetPlayerMap(Index), i).x = x And MapNpc(GetPlayerMap(Index), i).y = y Then
                    ' Change target
                    Player(Index).Target = i
                    Player(Index).TargetType = TARGET_TYPE_NPC
                    Call PlayerMsg(Index, "Your target is now a " & Trim(Npc(MapNpc(GetPlayerMap(Index), i).Num).Name) & ".", Yellow)
                    Exit Sub
                End If
            End If
        Next i
        
        Exit Sub
    End If

    ' ::::::::::::::::::
    ' :: Party packet ::
    ' ::::::::::::::::::
    If LCase(Parse(0)) = "party" Then
        n = FindPlayer(Parse(1))
        
        ' Prevent partying with self
        If n = Index Then
            Exit Sub
        End If
                
        ' Check for a previous party and if so drop it
        If Player(Index).InParty = YES Then
            Call PlayerMsg(Index, "You are already in a party!", Pink)
            Exit Sub
        End If
        
        If n > 0 Then
            ' Check if its an admin
            If GetPlayerAccess(Index) > ADMIN_MONITER Then
                Call PlayerMsg(Index, "You can't join a party, you are an admin!", BrightBlue)
                Exit Sub
            End If
        
            If GetPlayerAccess(n) > ADMIN_MONITER Then
                Call PlayerMsg(Index, "Admins cannot join parties!", BrightBlue)
                Exit Sub
            End If
            
            ' Make sure they are in right level range
            If GetPlayerLevel(Index) + 5 < GetPlayerLevel(n) Or GetPlayerLevel(Index) - 5 > GetPlayerLevel(n) Then
                Call PlayerMsg(Index, "There is more then a 5 level gap between you two, party failed.", Pink)
                Exit Sub
            End If
            
            ' Check to see if player is already in a party
            If Player(n).InParty = NO Then
                Call PlayerMsg(Index, "Party request has been sent to " & GetPlayerName(n) & ".", Pink)
                Call PlayerMsg(n, GetPlayerName(Index) & " wants you to join their party.  Type /join to join, or /leave to decline.", Pink)
            
                Player(Index).PartyStarter = YES
                Player(Index).PartyPlayer = n
                Player(n).PartyPlayer = Index
            Else
                Call PlayerMsg(Index, "Player is already in a party!", Pink)
            End If
        Else
            Call PlayerMsg(Index, "Player is not online.", White)
        End If
        Exit Sub
    End If

    ' :::::::::::::::::::::::
    ' :: Join party packet ::
    ' :::::::::::::::::::::::
    If LCase(Parse(0)) = "joinparty" Then
        n = Player(Index).PartyPlayer
        
        If n > 0 Then
            ' Check to make sure they aren't the starter
            If Player(Index).PartyStarter = NO Then
                ' Check to make sure that each of there party players match
                If Player(n).PartyPlayer = Index Then
                    Call PlayerMsg(Index, "You have joined " & GetPlayerName(n) & "'s party!", Pink)
                    Call PlayerMsg(n, GetPlayerName(Index) & " has joined your party!", Pink)
                    
                    Player(Index).InParty = YES
                    Player(n).InParty = YES
                Else
                    Call PlayerMsg(Index, "Party failed.", Pink)
                End If
            Else
                Call PlayerMsg(Index, "You have not been invited to join a party!", Pink)
            End If
        Else
            Call PlayerMsg(Index, "You have not been invited into a party!", Pink)
        End If
        Exit Sub
    End If

    ' ::::::::::::::::::::::::
    ' :: Leave party packet ::
    ' ::::::::::::::::::::::::
    If LCase(Parse(0)) = "leaveparty" Then
        n = Player(Index).PartyPlayer
        
        If n > 0 Then
            If Player(Index).InParty = YES Then
                Call PlayerMsg(Index, "You have left the party.", Pink)
                Call PlayerMsg(n, GetPlayerName(Index) & " has left the party.", Pink)
                
                Player(Index).PartyPlayer = 0
                Player(Index).PartyStarter = NO
                Player(Index).InParty = NO
                Player(n).PartyPlayer = 0
                Player(n).PartyStarter = NO
                Player(n).InParty = NO
            Else
                Call PlayerMsg(Index, "Declined party request.", Pink)
                Call PlayerMsg(n, GetPlayerName(Index) & " declined your request.", Pink)
                
                Player(Index).PartyPlayer = 0
                Player(Index).PartyStarter = NO
                Player(Index).InParty = NO
                Player(n).PartyPlayer = 0
                Player(n).PartyStarter = NO
                Player(n).InParty = NO
            End If
        Else
            Call PlayerMsg(Index, "You are not in a party!", Pink)
        End If
        Exit Sub
    End If
    
    ' :::::::::::::::::::
    ' :: Spells packet ::
    ' :::::::::::::::::::
    If LCase(Parse(0)) = "spells" Then
        Call SendPlayerSpells(Index)
        Exit Sub
    End If
    
    ' :::::::::::::::::
    ' :: Cast packet ::
    ' :::::::::::::::::
    If LCase(Parse(0)) = "cast" Then
        ' Spell slot
        n = Val(Parse(1))
        
        Call CastSpell(Index, n)
        
        Exit Sub
    End If

    ' :::::::::::::::::::::
    ' :: Location packet ::
    ' :::::::::::::::::::::
    If LCase(Parse(0)) = "requestlocation" Then
        If GetPlayerAccess(Index) < ADMIN_MAPPER Then
            Call HackingAttempt(Index, "Admin Cloning")
            Exit Sub
        End If
        
        Call PlayerMsg(Index, "Map: " & GetPlayerMap(Index) & ", X: " & GetPlayerX(Index) & ", Y: " & GetPlayerY(Index), Pink)
        Exit Sub
    End If
End Sub

Sub CloseSocket(ByVal Index As Long)
    ' Make sure player was/is playing the game, and if so, save'm.
    If Index > 0 Then
        Call LeftGame(Index)
    
        Call TextAdd(frmServer.txtText, "Connection from " & GetPlayerIP(Index) & " has been terminated.", True)
        
        frmServer.Socket(Index).Close
            
        Call UpdateCaption
        Call ClearPlayer(Index)
    End If
End Sub

Sub SendWhosOnline(ByVal Index As Long)
Dim s As String
Dim n As Long, i As Long

    s = ""
    n = 0
    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) And i <> Index Then
            s = s & GetPlayerName(i) & ", "
            n = n + 1
        End If
    Next i
            
    If n = 0 Then
        s = "There are no other players online."
    Else
        s = Mid(s, 1, Len(s) - 2)
        s = "There are " & n & " other players online: " & s & "."
    End If
        
    Call PlayerMsg(Index, s, WhoColor)
End Sub

Sub SendChars(ByVal Index As Long)
Dim Packet As String
Dim i As Long
    
    Packet = "ALLCHARS" & SEP_CHAR
    For i = 1 To MAX_CHARS
        Packet = Packet & Trim(Player(Index).Char(i).Name) & SEP_CHAR & Trim(Class(Player(Index).Char(i).Class).Name) & SEP_CHAR & Player(Index).Char(i).Level & SEP_CHAR
    Next i
    Packet = Packet & END_CHAR
    
    Call SendDataTo(Index, Packet)
End Sub

Sub SendJoinMap(ByVal Index As Long)
Dim Packet As String
Dim i As Long

    Packet = ""
    
    ' Send all players on current map to index
    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) And i <> Index And GetPlayerMap(i) = GetPlayerMap(Index) Then
            Packet = Packet & "PLAYERDATA" & SEP_CHAR & i & SEP_CHAR & GetPlayerName(i) & SEP_CHAR & GetPlayerSprite(i) & SEP_CHAR & GetPlayerMap(i) & SEP_CHAR & GetPlayerX(i) & SEP_CHAR & GetPlayerY(i) & SEP_CHAR & GetPlayerDir(i) & SEP_CHAR & GetPlayerAccess(i) & SEP_CHAR & GetPlayerPK(i) & SEP_CHAR & END_CHAR
            Call SendDataTo(Index, Packet)
        End If
    Next i
    
    ' Send index's player data to everyone on the map including himself
    Packet = "PLAYERDATA" & SEP_CHAR & Index & SEP_CHAR & GetPlayerName(Index) & SEP_CHAR & GetPlayerSprite(Index) & SEP_CHAR & GetPlayerMap(Index) & SEP_CHAR & GetPlayerX(Index) & SEP_CHAR & GetPlayerY(Index) & SEP_CHAR & GetPlayerDir(Index) & SEP_CHAR & GetPlayerAccess(Index) & SEP_CHAR & GetPlayerPK(Index) & SEP_CHAR & END_CHAR
    Call SendDataToMap(GetPlayerMap(Index), Packet)
End Sub

Sub SendLeaveMap(ByVal Index As Long, ByVal MapNum As Long)
Dim Packet As String

    Packet = "PLAYERDATA" & SEP_CHAR & Index & SEP_CHAR & GetPlayerName(Index) & SEP_CHAR & GetPlayerSprite(Index) & SEP_CHAR & 0 & SEP_CHAR & GetPlayerX(Index) & SEP_CHAR & GetPlayerY(Index) & SEP_CHAR & GetPlayerDir(Index) & SEP_CHAR & GetPlayerAccess(Index) & SEP_CHAR & GetPlayerPK(Index) & SEP_CHAR & END_CHAR
    Call SendDataToMapBut(Index, MapNum, Packet)
End Sub

Sub SendPlayerData(ByVal Index As Long)
Dim Packet As String

    ' Send index's player data to everyone including himself on th emap
    Packet = "PLAYERDATA" & SEP_CHAR & Index & SEP_CHAR & GetPlayerName(Index) & SEP_CHAR & GetPlayerSprite(Index) & SEP_CHAR & GetPlayerMap(Index) & SEP_CHAR & GetPlayerX(Index) & SEP_CHAR & GetPlayerY(Index) & SEP_CHAR & GetPlayerDir(Index) & SEP_CHAR & GetPlayerAccess(Index) & SEP_CHAR & GetPlayerPK(Index) & SEP_CHAR & END_CHAR
    Call SendDataToMap(GetPlayerMap(Index), Packet)
End Sub

Sub SendMap(ByVal Index As Long, ByVal MapNum As Long)
Dim Packet As String, P1 As String, P2 As String
Dim x As Long
Dim y As Long

    Packet = "MAPDATA" & SEP_CHAR & MapNum & SEP_CHAR & Trim(Map(MapNum).Name) & SEP_CHAR & Map(MapNum).Revision & SEP_CHAR & Map(MapNum).Moral & SEP_CHAR & Map(MapNum).Up & SEP_CHAR & Map(MapNum).Down & SEP_CHAR & Map(MapNum).Left & SEP_CHAR & Map(MapNum).Right & SEP_CHAR & Map(MapNum).Music & SEP_CHAR & Map(MapNum).BootMap & SEP_CHAR & Map(MapNum).BootX & SEP_CHAR & Map(MapNum).BootY & SEP_CHAR & Map(MapNum).Shop & SEP_CHAR
    
    For y = 0 To MAX_MAPY
        For x = 0 To MAX_MAPX
            With Map(MapNum).Tile(x, y)
                Packet = Packet & .Ground & SEP_CHAR & .Mask & SEP_CHAR & .Anim & SEP_CHAR & .Fringe & SEP_CHAR & .Type & SEP_CHAR & .Data1 & SEP_CHAR & .Data2 & SEP_CHAR & .Data3 & SEP_CHAR
            End With
        Next x
    Next y
    
    For x = 1 To MAX_MAP_NPCS
        Packet = Packet & Map(MapNum).Npc(x) & SEP_CHAR
    Next x
    
    Packet = Packet & END_CHAR
    
    x = Int(Len(Packet) / 2)
    P1 = Mid(Packet, 1, x)
    P2 = Mid(Packet, x + 1, Len(Packet) - x)
    Call SendDataTo(Index, Packet)
End Sub

Sub SendMapItemsTo(ByVal Index As Long, ByVal MapNum As Long)
Dim Packet As String
Dim i As Long

    Packet = "MAPITEMDATA" & SEP_CHAR
    For i = 1 To MAX_MAP_ITEMS
        Packet = Packet & MapItem(MapNum, i).Num & SEP_CHAR & MapItem(MapNum, i).Value & SEP_CHAR & MapItem(MapNum, i).Dur & SEP_CHAR & MapItem(MapNum, i).x & SEP_CHAR & MapItem(MapNum, i).y & SEP_CHAR
    Next i
    Packet = Packet & END_CHAR
    
    Call SendDataTo(Index, Packet)
End Sub

Sub SendMapItemsToAll(ByVal MapNum As Long)
Dim Packet As String
Dim i As Long

    Packet = "MAPITEMDATA" & SEP_CHAR
    For i = 1 To MAX_MAP_ITEMS
        Packet = Packet & MapItem(MapNum, i).Num & SEP_CHAR & MapItem(MapNum, i).Value & SEP_CHAR & MapItem(MapNum, i).Dur & SEP_CHAR & MapItem(MapNum, i).x & SEP_CHAR & MapItem(MapNum, i).y & SEP_CHAR
    Next i
    Packet = Packet & END_CHAR
    
    Call SendDataToMap(MapNum, Packet)
End Sub

Sub SendMapNpcsTo(ByVal Index As Long, ByVal MapNum As Long)
Dim Packet As String
Dim i As Long

    Packet = "MAPNPCDATA" & SEP_CHAR
    For i = 1 To MAX_MAP_NPCS
        Packet = Packet & MapNpc(MapNum, i).Num & SEP_CHAR & MapNpc(MapNum, i).x & SEP_CHAR & MapNpc(MapNum, i).y & SEP_CHAR & MapNpc(MapNum, i).Dir & SEP_CHAR
    Next i
    Packet = Packet & END_CHAR
    
    Call SendDataTo(Index, Packet)
End Sub

Sub SendMapNpcsToMap(ByVal MapNum As Long)
Dim Packet As String
Dim i As Long

    Packet = "MAPNPCDATA" & SEP_CHAR
    For i = 1 To MAX_MAP_NPCS
        Packet = Packet & MapNpc(MapNum, i).Num & SEP_CHAR & MapNpc(MapNum, i).x & SEP_CHAR & MapNpc(MapNum, i).y & SEP_CHAR & MapNpc(MapNum, i).Dir & SEP_CHAR
    Next i
    Packet = Packet & END_CHAR
    
    Call SendDataToMap(MapNum, Packet)
End Sub

Sub SendItems(ByVal Index As Long)
Dim Packet As String
Dim i As Long

    For i = 1 To MAX_ITEMS
        If Trim(Item(i).Name) <> "" Then
            Call SendUpdateItemTo(Index, i)
        End If
    Next i
End Sub

Sub SendNpcs(ByVal Index As Long)
Dim Packet As String
Dim i As Long

    For i = 1 To MAX_NPCS
        If Trim(Npc(i).Name) <> "" Then
            Call SendUpdateNpcTo(Index, i)
        End If
    Next i
End Sub

Sub SendInventory(ByVal Index As Long)
Dim Packet As String
Dim i As Long

    Packet = "PLAYERINV" & SEP_CHAR
    For i = 1 To MAX_INV
        Packet = Packet & GetPlayerInvItemNum(Index, i) & SEP_CHAR & GetPlayerInvItemValue(Index, i) & SEP_CHAR & GetPlayerInvItemDur(Index, i) & SEP_CHAR
    Next i
    Packet = Packet & END_CHAR
    
    Call SendDataTo(Index, Packet)
End Sub

Sub SendInventoryUpdate(ByVal Index As Long, ByVal InvSlot As Long)
Dim Packet As String
    
    Packet = "PLAYERINVUPDATE" & SEP_CHAR & InvSlot & SEP_CHAR & GetPlayerInvItemNum(Index, InvSlot) & SEP_CHAR & GetPlayerInvItemValue(Index, InvSlot) & SEP_CHAR & GetPlayerInvItemDur(Index, InvSlot) & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendWornEquipment(ByVal Index As Long)
Dim Packet As String
    
    Packet = "PLAYERWORNEQ" & SEP_CHAR & GetPlayerArmorSlot(Index) & SEP_CHAR & GetPlayerWeaponSlot(Index) & SEP_CHAR & GetPlayerHelmetSlot(Index) & SEP_CHAR & GetPlayerShieldSlot(Index) & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendHP(ByVal Index As Long)
Dim Packet As String

    Packet = "PLAYERHP" & SEP_CHAR & GetPlayerMaxHP(Index) & SEP_CHAR & GetPlayerHP(Index) & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendMP(ByVal Index As Long)
Dim Packet As String

    Packet = "PLAYERMP" & SEP_CHAR & GetPlayerMaxMP(Index) & SEP_CHAR & GetPlayerMP(Index) & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendSP(ByVal Index As Long)
Dim Packet As String

    Packet = "PLAYERSP" & SEP_CHAR & GetPlayerMaxSP(Index) & SEP_CHAR & GetPlayerSP(Index) & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendStats(ByVal Index As Long)
Dim Packet As String
    
    Packet = "PLAYERSTATS" & SEP_CHAR & GetPlayerSTR(Index) & SEP_CHAR & GetPlayerDEF(Index) & SEP_CHAR & GetPlayerSPEED(Index) & SEP_CHAR & GetPlayerMAGI(Index) & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendWelcome(ByVal Index As Long)
Dim MOTD As String
Dim f As Long

    ' Send them welcome
    Call PlayerMsg(Index, "Welcome to " & GAME_NAME & "!  Programmed from scratch by yours truely Consty!  Version " & CLIENT_MAJOR & "." & CLIENT_MINOR & "." & CLIENT_REVISION, BrightBlue)
    Call PlayerMsg(Index, "Type /help for help on commands.  Use arrow keys to move, hold down shift to run, and use ctrl to attack.", Cyan)
    ' Send them MOTD
    MOTD = GetVar(App.Path & "\motd.ini", "MOTD", "Msg")
    If Trim(MOTD) <> "" Then
        Call PlayerMsg(Index, "MOTD: " & MOTD, BrightCyan)
    End If
    
    ' Send whos online
    Call SendWhosOnline(Index)
End Sub

Sub SendClasses(ByVal Index As Long)
Dim Packet As String
Dim i As Long

    Packet = "CLASSESDATA" & SEP_CHAR & Max_Classes & SEP_CHAR
    For i = 0 To Max_Classes
        Packet = Packet & GetClassName(i) & SEP_CHAR & GetClassMaxHP(i) & SEP_CHAR & GetClassMaxMP(i) & SEP_CHAR & GetClassMaxSP(i) & SEP_CHAR & Class(i).STR & SEP_CHAR & Class(i).DEF & SEP_CHAR & Class(i).SPEED & SEP_CHAR & Class(i).MAGI & SEP_CHAR
    Next i
    Packet = Packet & END_CHAR
    
    Call SendDataTo(Index, Packet)
End Sub

Sub SendNewCharClasses(ByVal Index As Long)
Dim Packet As String
Dim i As Long

    Packet = "NEWCHARCLASSES" & SEP_CHAR & Max_Classes & SEP_CHAR
    For i = 0 To Max_Classes
        Packet = Packet & GetClassName(i) & SEP_CHAR & GetClassMaxHP(i) & SEP_CHAR & GetClassMaxMP(i) & SEP_CHAR & GetClassMaxSP(i) & SEP_CHAR & Class(i).STR & SEP_CHAR & Class(i).DEF & SEP_CHAR & Class(i).SPEED & SEP_CHAR & Class(i).MAGI & SEP_CHAR
    Next i
    Packet = Packet & END_CHAR
    
    Call SendDataTo(Index, Packet)
End Sub

Sub SendLeftGame(ByVal Index As Long)
Dim Packet As String

    Packet = "PLAYERDATA" & SEP_CHAR & Index & SEP_CHAR & "" & SEP_CHAR & 0 & SEP_CHAR & 0 & SEP_CHAR & 0 & SEP_CHAR & 0 & SEP_CHAR & 0 & SEP_CHAR & 0 & SEP_CHAR & 0 & END_CHAR
    Call SendDataToAllBut(Index, Packet)
End Sub

Sub SendPlayerXY(ByVal Index As Long)
Dim Packet As String

    Packet = "PLAYERXY" & SEP_CHAR & GetPlayerX(Index) & SEP_CHAR & GetPlayerY(Index) & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendUpdateItemToAll(ByVal ItemNum As Long)
Dim Packet As String

    Packet = "UPDATEITEM" & SEP_CHAR & ItemNum & SEP_CHAR & Trim(Item(ItemNum).Name) & SEP_CHAR & Item(ItemNum).Pic & SEP_CHAR & Item(ItemNum).Type & SEP_CHAR & Item(ItemNum).Data1 & SEP_CHAR & Item(ItemNum).Data2 & SEP_CHAR & Item(ItemNum).Data3 & SEP_CHAR & END_CHAR
    Call SendDataToAll(Packet)
End Sub

Sub SendUpdateItemTo(ByVal Index As Long, ByVal ItemNum As Long)
Dim Packet As String

    Packet = "UPDATEITEM" & SEP_CHAR & ItemNum & SEP_CHAR & Trim(Item(ItemNum).Name) & SEP_CHAR & Item(ItemNum).Pic & SEP_CHAR & Item(ItemNum).Type & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendEditItemTo(ByVal Index As Long, ByVal ItemNum As Long)
Dim Packet As String

    Packet = "EDITITEM" & SEP_CHAR & ItemNum & SEP_CHAR & Trim(Item(ItemNum).Name) & SEP_CHAR & Item(ItemNum).Pic & SEP_CHAR & Item(ItemNum).Type & SEP_CHAR & Item(ItemNum).Data1 & SEP_CHAR & Item(ItemNum).Data2 & SEP_CHAR & Item(ItemNum).Data3 & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendUpdateNpcToAll(ByVal NpcNum As Long)
Dim Packet As String

    Packet = "UPDATENPC" & SEP_CHAR & NpcNum & SEP_CHAR & Trim(Npc(NpcNum).Name) & SEP_CHAR & Npc(NpcNum).Sprite & SEP_CHAR & END_CHAR
    Call SendDataToAll(Packet)
End Sub

Sub SendUpdateNpcTo(ByVal Index As Long, ByVal NpcNum As Long)
Dim Packet As String

    Packet = "UPDATENPC" & SEP_CHAR & NpcNum & SEP_CHAR & Trim(Npc(NpcNum).Name) & SEP_CHAR & Npc(NpcNum).Sprite & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendEditNpcTo(ByVal Index As Long, ByVal NpcNum As Long)
Dim Packet As String

    Packet = "EDITNPC" & SEP_CHAR & NpcNum & SEP_CHAR & Trim(Npc(NpcNum).Name) & SEP_CHAR & Trim(Npc(NpcNum).AttackSay) & SEP_CHAR & Npc(NpcNum).Sprite & SEP_CHAR & Npc(NpcNum).SpawnSecs & SEP_CHAR & Npc(NpcNum).Behavior & SEP_CHAR & Npc(NpcNum).Range & SEP_CHAR & Npc(NpcNum).DropChance & SEP_CHAR & Npc(NpcNum).DropItem & SEP_CHAR & Npc(NpcNum).DropItemValue & SEP_CHAR & Npc(NpcNum).STR & SEP_CHAR & Npc(NpcNum).DEF & SEP_CHAR & Npc(NpcNum).SPEED & SEP_CHAR & Npc(NpcNum).MAGI & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendShops(ByVal Index As Long)
Dim i As Long

    For i = 1 To MAX_SHOPS
        If Trim(Shop(i).Name) <> "" Then
            Call SendUpdateShopTo(Index, i)
        End If
    Next i
End Sub

Sub SendUpdateShopToAll(ByVal ShopNum As Long)
Dim Packet As String

    Packet = "UPDATESHOP" & SEP_CHAR & ShopNum & SEP_CHAR & Trim(Shop(ShopNum).Name) & SEP_CHAR & END_CHAR
    Call SendDataToAll(Packet)
End Sub

Sub SendUpdateShopTo(ByVal Index As Long, ByVal ShopNum)
Dim Packet As String

    Packet = "UPDATESHOP" & SEP_CHAR & ShopNum & SEP_CHAR & Trim(Shop(ShopNum).Name) & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendEditShopTo(ByVal Index As Long, ByVal ShopNum As Long)
Dim Packet As String
Dim i As Long

    Packet = "EDITSHOP" & SEP_CHAR & ShopNum & SEP_CHAR & Trim(Shop(ShopNum).Name) & SEP_CHAR & Trim(Shop(ShopNum).JoinSay) & SEP_CHAR & Trim(Shop(ShopNum).LeaveSay) & SEP_CHAR & Shop(ShopNum).FixesItems & SEP_CHAR
    For i = 1 To MAX_TRADES
        Packet = Packet & Shop(ShopNum).TradeItem(i).GiveItem & SEP_CHAR & Shop(ShopNum).TradeItem(i).GiveValue & SEP_CHAR & Shop(ShopNum).TradeItem(i).GetItem & SEP_CHAR & Shop(ShopNum).TradeItem(i).GetValue & SEP_CHAR
    Next i
    Packet = Packet & END_CHAR

    Call SendDataTo(Index, Packet)
End Sub

Sub SendSpells(ByVal Index As Long)
Dim i As Long

    For i = 1 To MAX_SPELLS
        If Trim(Spell(i).Name) <> "" Then
            Call SendUpdateSpellTo(Index, i)
        End If
    Next i
End Sub

Sub SendUpdateSpellToAll(ByVal SpellNum As Long)
Dim Packet As String

    Packet = "UPDATESPELL" & SEP_CHAR & SpellNum & SEP_CHAR & Trim(Spell(SpellNum).Name) & SEP_CHAR & END_CHAR
    Call SendDataToAll(Packet)
End Sub

Sub SendUpdateSpellTo(ByVal Index As Long, ByVal SpellNum As Long)
Dim Packet As String

    Packet = "UPDATESPELL" & SEP_CHAR & SpellNum & SEP_CHAR & Trim(Spell(SpellNum).Name) & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendEditSpellTo(ByVal Index As Long, ByVal SpellNum As Long)
Dim Packet As String

    Packet = "EDITSPELL" & SEP_CHAR & SpellNum & SEP_CHAR & Trim(Spell(SpellNum).Name) & SEP_CHAR & Spell(SpellNum).ClassReq & SEP_CHAR & Spell(SpellNum).LevelReq & SEP_CHAR & Spell(SpellNum).Type & SEP_CHAR & Spell(SpellNum).Data1 & SEP_CHAR & Spell(SpellNum).Data2 & SEP_CHAR & Spell(SpellNum).Data3 & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendTrade(ByVal Index As Long, ByVal ShopNum As Long)
Dim Packet As String
Dim i As Long, x As Long, y As Long

    Packet = "TRADE" & SEP_CHAR & ShopNum & SEP_CHAR & Shop(ShopNum).FixesItems & SEP_CHAR
    For i = 1 To MAX_TRADES
        Packet = Packet & Shop(ShopNum).TradeItem(i).GiveItem & SEP_CHAR & Shop(ShopNum).TradeItem(i).GiveValue & SEP_CHAR & Shop(ShopNum).TradeItem(i).GetItem & SEP_CHAR & Shop(ShopNum).TradeItem(i).GetValue & SEP_CHAR
        
        ' Item #
        x = Shop(ShopNum).TradeItem(i).GetItem
        
        If Item(x).Type = ITEM_TYPE_SPELL Then
            ' Spell class requirement
            y = Spell(Item(x).Data1).ClassReq
            
            If y = 0 Then
                Call PlayerMsg(Index, Trim(Item(x).Name) & " can be used by all classes.", Yellow)
            Else
                Call PlayerMsg(Index, Trim(Item(x).Name) & " can only be used by a " & GetClassName(y - 1) & ".", Yellow)
            End If
        End If
    Next i
    Packet = Packet & END_CHAR
    
    Call SendDataTo(Index, Packet)
End Sub

Sub SendPlayerSpells(ByVal Index As Long)
Dim Packet As String
Dim i As Long

    Packet = "SPELLS" & SEP_CHAR
    For i = 1 To MAX_PLAYER_SPELLS
        Packet = Packet & GetPlayerSpell(Index, i) & SEP_CHAR
    Next i
    Packet = Packet & END_CHAR
    
    Call SendDataTo(Index, Packet)
End Sub

Sub SendWeatherTo(ByVal Index As Long)
Dim Packet As String

    Packet = "WEATHER" & SEP_CHAR & GameWeather & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendWeatherToAll()
Dim i As Long

    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) Then
            Call SendWeatherTo(i)
        End If
    Next i
End Sub

Sub SendTimeTo(ByVal Index As Long)
Dim Packet As String

    Packet = "TIME" & SEP_CHAR & GameTime & SEP_CHAR & END_CHAR
    Call SendDataTo(Index, Packet)
End Sub

Sub SendTimeToAll()
Dim i As Long

    For i = 1 To MAX_PLAYERS
        If IsPlaying(i) Then
            Call SendTimeTo(i)
        End If
    Next i
End Sub

