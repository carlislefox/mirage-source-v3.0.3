VERSION 5.00
Begin VB.Form frmDrop 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Mirage Online (Drop Item)"
   ClientHeight    =   2910
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5415
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
   ScaleHeight     =   2910
   ScaleWidth      =   5415
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdMinus1 
      Caption         =   "-1"
      Height          =   375
      Left            =   120
      TabIndex        =   13
      Top             =   1560
      Width           =   1215
   End
   Begin VB.CommandButton cmdMinus10 
      Caption         =   "-10"
      Height          =   375
      Left            =   1440
      TabIndex        =   12
      Top             =   1560
      Width           =   1215
   End
   Begin VB.CommandButton cmdMinus100 
      Caption         =   "-100"
      Height          =   375
      Left            =   2880
      TabIndex        =   11
      Top             =   1560
      Width           =   1215
   End
   Begin VB.CommandButton cmdMinus1000 
      Caption         =   "-1000"
      Height          =   375
      Left            =   4200
      TabIndex        =   10
      Top             =   1560
      Width           =   1095
   End
   Begin VB.CommandButton cmdPlus1000 
      Caption         =   "+1000"
      Height          =   375
      Left            =   4200
      TabIndex        =   9
      Top             =   1200
      Width           =   1095
   End
   Begin VB.CommandButton cmdPlus100 
      Caption         =   "+100"
      Height          =   375
      Left            =   2880
      TabIndex        =   8
      Top             =   1200
      Width           =   1215
   End
   Begin VB.CommandButton cmdPlus10 
      Caption         =   "+10"
      Height          =   375
      Left            =   1440
      TabIndex        =   7
      Top             =   1200
      Width           =   1215
   End
   Begin VB.CommandButton cmdPlus1 
      Caption         =   "+1"
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   1200
      Width           =   1215
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "Ok"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   2280
      Width           =   2535
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   495
      Left            =   2760
      TabIndex        =   0
      Top             =   2280
      Width           =   2535
   End
   Begin VB.Label lblAmmount 
      Caption         =   "1"
      Height          =   375
      Left            =   1320
      TabIndex        =   5
      Top             =   600
      Width           =   3855
   End
   Begin VB.Label Label2 
      Caption         =   "Ammount"
      Height          =   375
      Left            =   120
      TabIndex        =   4
      Top             =   600
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Item"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   1095
   End
   Begin VB.Label lblName 
      Height          =   375
      Left            =   1320
      TabIndex        =   2
      Top             =   120
      Width           =   3855
   End
End
Attribute VB_Name = "frmDrop"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Ammount As Long

Private Sub Form_Load()
Dim InvNum As Long

    Ammount = 1
    InvNum = frmMirage.lstInv.ListIndex + 1
    
    frmDrop.lblName = Trim(Item(GetPlayerInvItemNum(MyIndex, InvNum)).Name)
    Call ProcessAmmount
End Sub

Private Sub cmdOk_Click()
Dim InvNum As Long

    InvNum = frmMirage.lstInv.ListIndex + 1
    
    Call SendDropItem(InvNum, Ammount)
    Unload Me
End Sub

Private Sub cmdCancel_Click()
    Unload Me
End Sub

Private Sub cmdPlus1_Click()
    Ammount = Ammount + 1
    Call ProcessAmmount
End Sub

Private Sub cmdMinus1_Click()
    Ammount = Ammount - 1
    Call ProcessAmmount
End Sub

Private Sub cmdPlus10_Click()
    Ammount = Ammount + 10
    Call ProcessAmmount
End Sub

Private Sub cmdMinus10_Click()
    Ammount = Ammount - 10
    Call ProcessAmmount
End Sub

Private Sub cmdPlus100_Click()
    Ammount = Ammount + 100
    Call ProcessAmmount
End Sub

Private Sub cmdMinus100_Click()
    Ammount = Ammount - 100
    Call ProcessAmmount
End Sub

Private Sub cmdPlus1000_Click()
    Ammount = Ammount + 1000
    Call ProcessAmmount
End Sub

Private Sub cmdMinus1000_Click()
    Ammount = Ammount - 1000
    Call ProcessAmmount
End Sub

Private Sub ProcessAmmount()
Dim InvNum As Long

    InvNum = frmMirage.lstInv.ListIndex + 1
        
    ' Check if more then max and set back to max if so
    If Ammount > GetPlayerInvItemValue(MyIndex, InvNum) Then
        Ammount = GetPlayerInvItemValue(MyIndex, InvNum)
    End If
    
    ' Make sure its not 0
    If Ammount <= 0 Then
        Ammount = 1
    End If

    frmDrop.lblAmmount.Caption = Ammount & "/" & GetPlayerInvItemValue(MyIndex, InvNum)
End Sub
