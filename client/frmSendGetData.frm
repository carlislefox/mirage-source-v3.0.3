VERSION 5.00
Begin VB.Form frmSendGetData 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Mirage Online"
   ClientHeight    =   825
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4785
   ControlBox      =   0   'False
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   825
   ScaleWidth      =   4785
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox picDeleteAccount 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   825
      Left            =   0
      Picture         =   "frmSendGetData.frx":0000
      ScaleHeight     =   825
      ScaleWidth      =   4800
      TabIndex        =   0
      Top             =   0
      Width           =   4800
      Begin VB.Label lblStatus 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
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
         Height          =   375
         Left            =   0
         TabIndex        =   1
         Top             =   240
         Width           =   4815
      End
   End
End
Attribute VB_Name = "frmSendGetData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_KeyPress(KeyAscii As Integer)
    If (KeyAscii = vbKeyEscape) Then
        Call GameDestroy
        End
    End If
End Sub

