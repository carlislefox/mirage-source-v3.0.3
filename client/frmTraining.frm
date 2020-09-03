VERSION 5.00
Begin VB.Form frmTraining 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Mirage Online (Training)"
   ClientHeight    =   4560
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8190
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
   ScaleHeight     =   4560
   ScaleWidth      =   8190
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.ComboBox cmbStat 
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
      Height          =   405
      ItemData        =   "frmTraining.frx":0000
      Left            =   3360
      List            =   "frmTraining.frx":0010
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   2160
      Width           =   4575
   End
   Begin VB.PictureBox picCancel 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   4080
      Picture         =   "frmTraining.frx":0035
      ScaleHeight     =   510
      ScaleWidth      =   3000
      TabIndex        =   3
      Top             =   3960
      Width           =   3000
   End
   Begin VB.PictureBox picTrain 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   4080
      Picture         =   "frmTraining.frx":0CB6
      ScaleHeight     =   510
      ScaleWidth      =   3000
      TabIndex        =   2
      Top             =   3480
      Width           =   3000
   End
   Begin VB.PictureBox picTraining 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   825
      Left            =   3240
      Picture         =   "frmTraining.frx":18AE
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
      Picture         =   "frmTraining.frx":3363
      ScaleHeight     =   4635
      ScaleWidth      =   3015
      TabIndex        =   0
      Top             =   0
      Width           =   3015
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "What stat would you like to train?"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   975
      Left            =   3360
      TabIndex        =   4
      Top             =   1080
      Width           =   4575
   End
End
Attribute VB_Name = "frmTraining"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
    cmbStat.ListIndex = 0
End Sub

Private Sub picTrain_Click()
    Call SendData("usestatpoint" & SEP_CHAR & cmbStat.ListIndex & SEP_CHAR & END_CHAR)
End Sub

Private Sub picCancel_Click()
    Unload Me
End Sub

