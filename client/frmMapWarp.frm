VERSION 5.00
Begin VB.Form frmMapWarp 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Map Warp"
   ClientHeight    =   2070
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4710
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2070
   ScaleWidth      =   4710
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.HScrollBar scrlX 
      Height          =   255
      Left            =   720
      Max             =   15
      TabIndex        =   4
      Top             =   600
      Width           =   3255
   End
   Begin VB.HScrollBar scrlY 
      Height          =   255
      Left            =   720
      Max             =   11
      TabIndex        =   3
      Top             =   960
      Width           =   3255
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "Ok"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   1440
      Width           =   2055
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   2520
      TabIndex        =   1
      Top             =   1440
      Width           =   2055
   End
   Begin VB.TextBox txtMap 
      Alignment       =   1  'Right Justify
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   390
      Left            =   720
      TabIndex        =   0
      Text            =   "1"
      Top             =   120
      Width           =   3855
   End
   Begin VB.Label Label1 
      Caption         =   "Map"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   120
      Width           =   495
   End
   Begin VB.Label Label2 
      Caption         =   "X"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   600
      Width           =   495
   End
   Begin VB.Label Label3 
      Caption         =   "Y"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   960
      Width           =   495
   End
   Begin VB.Label lblX 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   4080
      TabIndex        =   6
      Top             =   600
      Width           =   495
   End
   Begin VB.Label lblY 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   4080
      TabIndex        =   5
      Top             =   960
      Width           =   495
   End
End
Attribute VB_Name = "frmMapWarp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdOk_Click()
    EditorWarpMap = Val(txtMap.Text)
    EditorWarpX = scrlX.Value
    EditorWarpY = scrlY.Value
    Unload Me
End Sub

Private Sub cmdCancel_Click()
    Unload Me
End Sub

Private Sub scrlX_Change()
    lblX.Caption = STR(scrlX.Value)
End Sub

Private Sub scrlY_Change()
    lblY.Caption = STR(scrlY.Value)
End Sub

Private Sub txtMap_Change()
    If Val(txtMap.Text) <= 0 Or Val(txtMap.Text) > MAX_MAPS Then
        txtMap.Text = "1"
    End If
End Sub

