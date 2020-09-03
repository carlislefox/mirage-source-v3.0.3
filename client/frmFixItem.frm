VERSION 5.00
Begin VB.Form frmFixItem 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Mirage Online (Fix Item)"
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
   Begin VB.ComboBox cmbItem 
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
      Left            =   4200
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   1800
      Width           =   3735
   End
   Begin VB.PictureBox picCancel 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   4080
      Picture         =   "frmFixItem.frx":0000
      ScaleHeight     =   510
      ScaleWidth      =   3000
      TabIndex        =   3
      Top             =   3960
      Width           =   3000
   End
   Begin VB.PictureBox chkFix 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   4080
      Picture         =   "frmFixItem.frx":0C81
      ScaleHeight     =   510
      ScaleWidth      =   3000
      TabIndex        =   2
      Top             =   3480
      Width           =   3000
   End
   Begin VB.PictureBox picNewAccount 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
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
      ForeColor       =   &H80000008&
      Height          =   825
      Left            =   3240
      Picture         =   "frmFixItem.frx":1793
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
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   4635
      Left            =   0
      Picture         =   "frmFixItem.frx":3204
      ScaleHeight     =   4635
      ScaleWidth      =   3015
      TabIndex        =   0
      Top             =   0
      Width           =   3015
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Please select the item you wish to fix."
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
      Height          =   375
      Left            =   3360
      TabIndex        =   6
      Top             =   1200
      Width           =   4575
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Item"
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
      Height          =   375
      Left            =   3360
      TabIndex        =   5
      Top             =   1800
      Width           =   855
   End
End
Attribute VB_Name = "frmFixItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub chkFix_Click()
    Call SendData("fixitem" & SEP_CHAR & cmbItem.ListIndex + 1 & SEP_CHAR & END_CHAR)
End Sub

Private Sub picCancel_Click()
    Unload Me
End Sub
