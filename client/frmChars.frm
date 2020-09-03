VERSION 5.00
Begin VB.Form frmChars 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Mirage Online (Characters)"
   ClientHeight    =   4560
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8190
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4560
   ScaleWidth      =   8190
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox picDelChar 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   4080
      Picture         =   "frmChars.frx":0000
      ScaleHeight     =   510
      ScaleWidth      =   3000
      TabIndex        =   6
      Top             =   3480
      Width           =   3000
   End
   Begin VB.PictureBox picUseChar 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   4080
      Picture         =   "frmChars.frx":0E35
      ScaleHeight     =   510
      ScaleWidth      =   3000
      TabIndex        =   5
      Top             =   2520
      Width           =   3000
   End
   Begin VB.PictureBox picNewChar 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   4080
      Picture         =   "frmChars.frx":1B8D
      ScaleHeight     =   510
      ScaleWidth      =   3000
      TabIndex        =   4
      Top             =   3000
      Width           =   3000
   End
   Begin VB.PictureBox picCancel 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   4080
      Picture         =   "frmChars.frx":2949
      ScaleHeight     =   510
      ScaleWidth      =   3000
      TabIndex        =   3
      Top             =   3960
      Width           =   3000
   End
   Begin VB.ListBox lstChars 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFC0C0&
      Height          =   1170
      ItemData        =   "frmChars.frx":35CA
      Left            =   3120
      List            =   "frmChars.frx":35CC
      TabIndex        =   2
      Top             =   1080
      Width           =   4575
   End
   Begin VB.PictureBox picNewAccount 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   825
      Left            =   3240
      Picture         =   "frmChars.frx":35CE
      ScaleHeight     =   825
      ScaleWidth      =   4800
      TabIndex        =   1
      Top             =   120
      Width           =   4800
   End
   Begin VB.PictureBox Picture1 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   4635
      Left            =   0
      Picture         =   "frmChars.frx":694E
      ScaleHeight     =   4635
      ScaleWidth      =   3015
      TabIndex        =   0
      Top             =   0
      Width           =   3015
   End
End
Attribute VB_Name = "frmChars"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub picCancel_Click()
    Call TcpDestroy
    frmLogin.Visible = True
    Me.Visible = False
End Sub

Private Sub picNewChar_Click()
    Call MenuState(MENU_STATE_NEWCHAR)
End Sub

Private Sub picUseChar_Click()
    Call MenuState(MENU_STATE_USECHAR)
End Sub

Private Sub picDelChar_Click()
Dim Value As Long

    Value = MsgBox("Are you sure you wish to delete this character?", vbYesNo, GAME_NAME)
    If Value = vbYes Then
        Call MenuState(MENU_STATE_DELCHAR)
    End If
End Sub

