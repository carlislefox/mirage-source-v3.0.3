VERSION 5.00
Begin VB.Form frmNpcEditor 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Npc Editor"
   ClientHeight    =   8910
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5175
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   12
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8910
   ScaleWidth      =   5175
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtSpawnSecs 
      Alignment       =   1  'Right Justify
      Height          =   390
      Left            =   3240
      TabIndex        =   43
      Text            =   "0"
      Top             =   5280
      Width           =   1815
   End
   Begin VB.TextBox txtAttackSay 
      Height          =   390
      Left            =   960
      TabIndex        =   41
      Top             =   600
      Width           =   3975
   End
   Begin VB.Timer tmrSprite 
      Interval        =   50
      Left            =   0
      Top             =   0
   End
   Begin VB.PictureBox picSprites 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   480
      Left            =   120
      ScaleHeight     =   32
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   32
      TabIndex        =   35
      Top             =   9360
      Width           =   480
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   615
      Left            =   2640
      TabIndex        =   34
      Top             =   8160
      Width           =   2415
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "Ok"
      Height          =   615
      Left            =   120
      TabIndex        =   33
      Top             =   8160
      Width           =   2415
   End
   Begin VB.HScrollBar scrlValue 
      Height          =   375
      Left            =   1080
      Max             =   255
      TabIndex        =   31
      Top             =   6960
      Value           =   1
      Width           =   3375
   End
   Begin VB.HScrollBar scrlNum 
      Height          =   375
      Left            =   1080
      Max             =   255
      TabIndex        =   25
      Top             =   6480
      Value           =   1
      Width           =   3375
   End
   Begin VB.TextBox txtChance 
      Alignment       =   1  'Right Justify
      Height          =   390
      Left            =   3240
      TabIndex        =   24
      Text            =   "0"
      Top             =   4800
      Width           =   1815
   End
   Begin VB.HScrollBar scrlMAGI 
      Height          =   375
      Left            =   1080
      Max             =   255
      TabIndex        =   20
      Top             =   3600
      Width           =   2895
   End
   Begin VB.HScrollBar scrlSPEED 
      Height          =   375
      Left            =   1080
      Max             =   255
      TabIndex        =   17
      Top             =   3120
      Width           =   2895
   End
   Begin VB.HScrollBar scrlDEF 
      Height          =   375
      Left            =   1080
      Max             =   255
      TabIndex        =   14
      Top             =   2640
      Width           =   2895
   End
   Begin VB.HScrollBar scrlSTR 
      Height          =   375
      Left            =   1080
      Max             =   255
      TabIndex        =   11
      Top             =   2160
      Width           =   2895
   End
   Begin VB.HScrollBar scrlRange 
      Height          =   375
      Left            =   1080
      Max             =   255
      TabIndex        =   8
      Top             =   1680
      Value           =   1
      Width           =   2895
   End
   Begin VB.ComboBox cmbBehavior 
      Height          =   390
      ItemData        =   "frmNpcEditor.frx":0000
      Left            =   1440
      List            =   "frmNpcEditor.frx":0013
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   4200
      Width           =   3615
   End
   Begin VB.TextBox txtName 
      Height          =   390
      Left            =   960
      TabIndex        =   2
      Top             =   120
      Width           =   3975
   End
   Begin VB.HScrollBar scrlSprite 
      Height          =   375
      Left            =   1080
      Max             =   255
      TabIndex        =   1
      Top             =   1200
      Width           =   2895
   End
   Begin VB.PictureBox picSprite 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   480
      Left            =   4560
      ScaleHeight     =   32
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   32
      TabIndex        =   0
      Top             =   1200
      Width           =   480
   End
   Begin VB.Label Label16 
      Caption         =   "Spawn Rate (in seconds)"
      Height          =   375
      Left            =   240
      TabIndex        =   42
      Top             =   5280
      Width           =   2895
   End
   Begin VB.Label Label14 
      Caption         =   "Say"
      Height          =   375
      Left            =   120
      TabIndex        =   40
      Top             =   600
      Width           =   735
   End
   Begin VB.Label lblExpGiven 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   375
      Left            =   3960
      TabIndex        =   39
      Top             =   7560
      Width           =   1095
   End
   Begin VB.Label Label15 
      Caption         =   "Exp Given"
      Height          =   375
      Left            =   2640
      TabIndex        =   38
      Top             =   7560
      Width           =   1215
   End
   Begin VB.Label lblStartHP 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   375
      Left            =   1320
      TabIndex        =   37
      Top             =   7560
      Width           =   1095
   End
   Begin VB.Label Label13 
      Caption         =   "Start HP"
      Height          =   375
      Left            =   240
      TabIndex        =   36
      Top             =   7560
      Width           =   975
   End
   Begin VB.Label lblValue 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   375
      Left            =   4560
      TabIndex        =   32
      Top             =   6960
      Width           =   495
   End
   Begin VB.Label Label7 
      Caption         =   "Value"
      Height          =   375
      Left            =   240
      TabIndex        =   30
      Top             =   6960
      Width           =   735
   End
   Begin VB.Label lblItemName 
      Height          =   375
      Left            =   960
      TabIndex        =   29
      Top             =   6000
      Width           =   4095
   End
   Begin VB.Label Label11 
      Caption         =   "Item"
      Height          =   375
      Left            =   240
      TabIndex        =   28
      Top             =   6000
      Width           =   615
   End
   Begin VB.Label Label9 
      Caption         =   "Num"
      Height          =   375
      Left            =   240
      TabIndex        =   27
      Top             =   6480
      Width           =   855
   End
   Begin VB.Label lblNum 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   375
      Left            =   4560
      TabIndex        =   26
      Top             =   6480
      Width           =   495
   End
   Begin VB.Label Label3 
      Caption         =   "Drop Item Chance 1 out of"
      Height          =   375
      Left            =   240
      TabIndex        =   23
      Top             =   4800
      Width           =   2895
   End
   Begin VB.Label Label12 
      Caption         =   "MAGI"
      Height          =   375
      Left            =   240
      TabIndex        =   22
      Top             =   3600
      Width           =   855
   End
   Begin VB.Label lblMAGI 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   375
      Left            =   3960
      TabIndex        =   21
      Top             =   3600
      Width           =   495
   End
   Begin VB.Label Label10 
      Caption         =   "SPD"
      Height          =   375
      Left            =   240
      TabIndex        =   19
      Top             =   3120
      Width           =   855
   End
   Begin VB.Label lblSPEED 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   375
      Left            =   3960
      TabIndex        =   18
      Top             =   3120
      Width           =   495
   End
   Begin VB.Label Label8 
      Caption         =   "DEF"
      Height          =   375
      Left            =   240
      TabIndex        =   16
      Top             =   2640
      Width           =   855
   End
   Begin VB.Label lblDEF 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   375
      Left            =   3960
      TabIndex        =   15
      Top             =   2640
      Width           =   495
   End
   Begin VB.Label Label6 
      Caption         =   "STR"
      Height          =   375
      Left            =   240
      TabIndex        =   13
      Top             =   2160
      Width           =   855
   End
   Begin VB.Label lblSTR 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   375
      Left            =   3960
      TabIndex        =   12
      Top             =   2160
      Width           =   495
   End
   Begin VB.Label Label4 
      Caption         =   "Range"
      Height          =   375
      Left            =   240
      TabIndex        =   10
      Top             =   1680
      Width           =   855
   End
   Begin VB.Label lblRange 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   375
      Left            =   3960
      TabIndex        =   9
      Top             =   1680
      Width           =   495
   End
   Begin VB.Label Label2 
      Caption         =   "Behavior"
      Height          =   375
      Left            =   240
      TabIndex        =   6
      Top             =   4200
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Name"
      Height          =   375
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   735
   End
   Begin VB.Label Label5 
      Caption         =   "Sprite"
      Height          =   375
      Left            =   240
      TabIndex        =   4
      Top             =   1200
      Width           =   855
   End
   Begin VB.Label lblSprite 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   375
      Left            =   3960
      TabIndex        =   3
      Top             =   1200
      Width           =   495
   End
End
Attribute VB_Name = "frmNpcEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub scrlSprite_Change()
    lblSprite.Caption = STR(scrlSprite.Value)
End Sub

Private Sub scrlRange_Change()
    lblRange.Caption = STR(scrlRange.Value)
End Sub

Private Sub scrlSTR_Change()
    lblSTR.Caption = STR(scrlSTR.Value)
    lblStartHP.Caption = STR(scrlSTR.Value * scrlDEF.Value)
    lblExpGiven.Caption = STR(scrlSTR.Value * scrlDEF.Value * 2)
End Sub

Private Sub scrlDEF_Change()
    lblDEF.Caption = STR(scrlDEF.Value)
    lblStartHP.Caption = STR(scrlSTR.Value * scrlDEF.Value)
    lblExpGiven.Caption = STR(scrlSTR.Value * scrlDEF.Value * 2)
End Sub

Private Sub scrlSPEED_Change()
    lblSPEED.Caption = STR(scrlSPEED.Value)
    lblExpGiven.Caption = STR(scrlSTR.Value * scrlDEF.Value * 2)
End Sub

Private Sub scrlMAGI_Change()
    lblMAGI.Caption = STR(scrlMAGI.Value)
End Sub

Private Sub scrlNum_Change()
    lblNum.Caption = STR(scrlNum.Value)
    If scrlNum.Value > 0 Then
        lblItemName.Caption = Trim(Item(scrlNum.Value).Name)
    End If
End Sub

Private Sub scrlValue_Change()
    lblValue.Caption = STR(scrlValue.Value)
End Sub

Private Sub cmdOk_Click()
    Call NpcEditorOk
End Sub

Private Sub cmdCancel_Click()
    Call NpcEditorCancel
End Sub

Private Sub tmrSprite_Timer()
    Call NpcEditorBltSprite
End Sub
