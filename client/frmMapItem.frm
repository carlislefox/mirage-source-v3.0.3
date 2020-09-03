VERSION 5.00
Begin VB.Form frmMapItem 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Map Item"
   ClientHeight    =   2085
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5070
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
   ScaleHeight     =   2085
   ScaleWidth      =   5070
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   495
      Left            =   2640
      TabIndex        =   3
      Top             =   1440
      Width           =   2295
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "Ok"
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   1440
      Width           =   2295
   End
   Begin VB.HScrollBar scrlValue 
      Height          =   255
      Left            =   840
      TabIndex        =   1
      Top             =   960
      Value           =   1
      Width           =   3255
   End
   Begin VB.HScrollBar scrlItem 
      Height          =   255
      Left            =   840
      Max             =   255
      Min             =   1
      TabIndex        =   0
      Top             =   600
      Value           =   1
      Width           =   3255
   End
   Begin VB.Label lblName 
      BackStyle       =   0  'Transparent
      Height          =   375
      Left            =   840
      TabIndex        =   9
      Top             =   120
      Width           =   3735
   End
   Begin VB.Label Label1 
      Caption         =   "Item"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   120
      Width           =   615
   End
   Begin VB.Label lblValue 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   255
      Left            =   4080
      TabIndex        =   7
      Top             =   960
      Width           =   855
   End
   Begin VB.Label lblItem 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   255
      Left            =   4080
      TabIndex        =   6
      Top             =   600
      Width           =   855
   End
   Begin VB.Label Label3 
      Caption         =   "Value"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   960
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "Item"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   600
      Width           =   615
   End
End
Attribute VB_Name = "frmMapItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    lblName.Caption = Trim(Item(scrlItem.Value).Name)
End Sub

Private Sub cmdOk_Click()
    ItemEditorNum = scrlItem.Value
    ItemEditorValue = scrlValue.Value
    Unload Me
End Sub

Private Sub cmdCancel_Click()
    Unload Me
End Sub

Private Sub scrlItem_Change()
    lblItem.Caption = STR(scrlItem.Value)
    lblName.Caption = Trim(Item(scrlItem.Value).Name)
End Sub

Private Sub scrlValue_Change()
    lblValue.Caption = STR(scrlValue.Value)
End Sub
