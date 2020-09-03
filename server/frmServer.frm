VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form frmServer 
   Caption         =   "Mirage Server"
   ClientHeight    =   3015
   ClientLeft      =   60
   ClientTop       =   630
   ClientWidth     =   7695
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   3015
   ScaleWidth      =   7695
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer tmrShutdown 
      Enabled         =   0   'False
      Interval        =   5000
      Left            =   1680
      Top             =   240
   End
   Begin VB.Timer tmrGameAI 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   1200
      Top             =   240
   End
   Begin VB.Timer tmrSpawnMapItems 
      Interval        =   1000
      Left            =   720
      Top             =   240
   End
   Begin VB.Timer tmrPlayerSave 
      Interval        =   60000
      Left            =   240
      Top             =   240
   End
   Begin VB.TextBox txtChat 
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   2520
      Width           =   7455
   End
   Begin VB.TextBox txtText 
      Height          =   2295
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   120
      Width           =   7455
   End
   Begin MSWinsockLib.Winsock Socket 
      Index           =   0
      Left            =   0
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuShutdown 
         Caption         =   "Shutdown"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "&Exit"
      End
   End
   Begin VB.Menu mnuDatabase 
      Caption         =   "&Database"
      Begin VB.Menu mnuReloadClasses 
         Caption         =   "Reload Classes"
      End
   End
   Begin VB.Menu mnuLog 
      Caption         =   "&Log"
      Begin VB.Menu mnuServerLog 
         Caption         =   "Server Log"
      End
   End
End
Attribute VB_Name = "frmServer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
Dim lmsg As Long
    
    lmsg = x / Screen.TwipsPerPixelX
    Select Case lmsg
        Case WM_LBUTTONDBLCLK
            frmServer.WindowState = vbNormal
            frmServer.Show
    End Select
End Sub

Private Sub Form_Resize()
    If frmServer.WindowState = vbMinimized Then
        frmServer.Hide
    End If
End Sub

Private Sub Form_Terminate()
    Call DestroyServer
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call DestroyServer
End Sub

Private Sub mnuServerLog_Click()
    If mnuServerLog.Checked = True Then
        mnuServerLog.Checked = False
        ServerLog = False
    Else
        mnuServerLog.Checked = True
        ServerLog = True
    End If
End Sub

Private Sub tmrGameAI_Timer()
    Call ServerLogic
End Sub

Private Sub tmrPlayerSave_Timer()
    Call PlayerSaveTimer
End Sub

Private Sub tmrSpawnMapItems_Timer()
    Call CheckSpawnMapItems
End Sub

Private Sub txtText_GotFocus()
    txtChat.SetFocus
End Sub

Private Sub txtChat_KeyPress(KeyAscii As Integer)
    If KeyAscii = vbKeyReturn And Trim(txtChat.Text) <> "" Then
        Call GlobalMsg(txtChat.Text, White)
        Call TextAdd(frmServer.txtText, "Server: " & txtChat.Text, True)
        txtChat.Text = ""
    End If
End Sub

Private Sub tmrShutdown_Timer()
Static Secs As Long

    If Secs <= 0 Then Secs = 30
    Call GlobalMsg("Server Shutdown in " & Secs & " seconds.", BrightBlue)
    Call TextAdd(frmServer.txtText, "Automated Server Shutdown in " & Secs & " seconds.", True)
    Secs = Secs - 2
    If Secs <= 0 Then
        tmrShutdown.Enabled = False
        Call DestroyServer
    End If
End Sub

Private Sub mnuShutdown_Click()
    tmrShutdown.Enabled = True
End Sub

Private Sub mnuExit_Click()
    Call DestroyServer
End Sub

Private Sub mnuReloadClasses_Click()
    Call LoadClasses
    Call TextAdd(frmServer.txtText, "All classes reloaded.", True)
End Sub

Private Sub Socket_ConnectionRequest(Index As Integer, ByVal requestID As Long)
    Call AcceptConnection(Index, requestID)
End Sub

Private Sub Socket_Accept(Index As Integer, SocketId As Integer)
    Call AcceptConnection(Index, SocketId)
End Sub

Private Sub Socket_DataArrival(Index As Integer, ByVal bytesTotal As Long)
    If IsConnected(Index) Then
        Call IncomingData(Index, bytesTotal)
    End If
End Sub

Private Sub Socket_Close(Index As Integer)
    Call CloseSocket(Index)
End Sub


