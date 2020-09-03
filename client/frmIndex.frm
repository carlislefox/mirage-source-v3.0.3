VERSION 5.00
Begin VB.Form frmIndex 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Index"
   ClientHeight    =   4470
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5295
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
   ScaleHeight     =   4470
   ScaleWidth      =   5295
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   495
      Left            =   2760
      TabIndex        =   2
      Top             =   3840
      Width           =   2415
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "Ok"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   3840
      Width           =   2415
   End
   Begin VB.ListBox lstIndex 
      Height          =   3570
      ItemData        =   "frmIndex.frx":0000
      Left            =   120
      List            =   "frmIndex.frx":0002
      TabIndex        =   0
      Top             =   120
      Width           =   5055
   End
End
Attribute VB_Name = "frmIndex"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdOk_Click()
    EditorIndex = lstIndex.ListIndex + 1
    
    If InItemsEditor = True Then
        Call SendData("EDITITEM" & SEP_CHAR & EditorIndex & SEP_CHAR & END_CHAR)
    End If
    If InNpcEditor = True Then
        Call SendData("EDITNPC" & SEP_CHAR & EditorIndex & SEP_CHAR & END_CHAR)
    End If
    If InShopEditor = True Then
        Call SendData("EDITSHOP" & SEP_CHAR & EditorIndex & SEP_CHAR & END_CHAR)
    End If
    If InSpellEditor = True Then
        Call SendData("EDITSPELL" & SEP_CHAR & EditorIndex & SEP_CHAR & END_CHAR)
    End If
    Unload frmIndex
End Sub

Private Sub cmdCancel_Click()
    InItemsEditor = False
    InNpcEditor = False
    InShopEditor = False
    InSpellEditor = False
    Unload frmIndex
End Sub

