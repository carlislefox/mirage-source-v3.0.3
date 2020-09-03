VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form frmMirage 
   BackColor       =   &H00000000&
   Caption         =   "Mirage Online"
   ClientHeight    =   7575
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9615
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   9.75
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   505
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   641
   StartUpPosition =   2  'CenterScreen
   Visible         =   0   'False
   WindowState     =   2  'Maximized
   Begin VB.PictureBox picPlayerSpells 
      Appearance      =   0  'Flat
      BackColor       =   &H00400000&
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
      Height          =   3285
      Left            =   7680
      ScaleHeight     =   217
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   255
      TabIndex        =   42
      Top             =   2520
      Visible         =   0   'False
      Width           =   3855
      Begin VB.ListBox lstSpells 
         Appearance      =   0  'Flat
         BackColor       =   &H00000000&
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   1920
         ItemData        =   "frmMirage.frx":0000
         Left            =   0
         List            =   "frmMirage.frx":0002
         TabIndex        =   43
         Top             =   240
         Width           =   3855
      End
      Begin VB.Label Label5 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Spells"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   255
         Left            =   0
         TabIndex        =   46
         Top             =   0
         Width           =   1935
      End
      Begin VB.Label lblCast 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Cast"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   255
         Left            =   0
         TabIndex        =   45
         Top             =   2520
         Width           =   1935
      End
      Begin VB.Label lblSpellsCancel 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Cancel"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   255
         Left            =   0
         TabIndex        =   44
         Top             =   2880
         Width           =   1935
      End
   End
   Begin VB.PictureBox picInv 
      Appearance      =   0  'Flat
      BackColor       =   &H00400000&
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
      Height          =   3285
      Left            =   7680
      ScaleHeight     =   217
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   255
      TabIndex        =   36
      Top             =   2520
      Visible         =   0   'False
      Width           =   3855
      Begin VB.ListBox lstInv 
         Appearance      =   0  'Flat
         BackColor       =   &H00000000&
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   1920
         ItemData        =   "frmMirage.frx":0004
         Left            =   0
         List            =   "frmMirage.frx":0006
         TabIndex        =   38
         Top             =   240
         Width           =   3855
      End
      Begin VB.Label lblCancel 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Cancel"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   255
         Left            =   0
         TabIndex        =   41
         Top             =   2880
         Width           =   1935
      End
      Begin VB.Label lblDropItem 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Drop Item"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   255
         Left            =   0
         TabIndex        =   40
         Top             =   2520
         Width           =   1935
      End
      Begin VB.Label lblUseItem 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Use Item"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   255
         Left            =   0
         TabIndex        =   39
         Top             =   2160
         Width           =   1935
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Inventory"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   255
         Left            =   0
         TabIndex        =   37
         Top             =   0
         Width           =   1935
      End
   End
   Begin VB.PictureBox picMapEditor 
      Appearance      =   0  'Flat
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
      Height          =   6405
      Left            =   7680
      ScaleHeight     =   425
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   255
      TabIndex        =   13
      Top             =   0
      Visible         =   0   'False
      Width           =   3855
      Begin VB.Frame fraLayers 
         Caption         =   "Layers"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2055
         Left            =   120
         TabIndex        =   30
         Top             =   3600
         Width           =   1455
         Begin VB.OptionButton optGround 
            Caption         =   "Ground"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   35
            Top             =   360
            Value           =   -1  'True
            Width           =   1215
         End
         Begin VB.OptionButton optMask 
            Caption         =   "Mask"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   34
            Top             =   600
            Width           =   1215
         End
         Begin VB.OptionButton optAnim 
            Caption         =   "Animation"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   33
            Top             =   840
            Width           =   1215
         End
         Begin VB.OptionButton optFringe 
            Caption         =   "Fringe"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   9.75
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   32
            Top             =   1080
            Width           =   1215
         End
         Begin VB.CommandButton cmdClear 
            Caption         =   "Clear"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   12
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   270
            Left            =   120
            TabIndex        =   31
            Top             =   1440
            Width           =   1215
         End
      End
      Begin VB.Frame fraAttribs 
         Caption         =   "Attributes"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2055
         Left            =   120
         TabIndex        =   23
         Top             =   3600
         Visible         =   0   'False
         Width           =   1455
         Begin VB.OptionButton optKeyOpen 
            Caption         =   "Key Open"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   240
            Left            =   120
            TabIndex        =   47
            Top             =   1440
            Width           =   1215
         End
         Begin VB.OptionButton optBlocked 
            Caption         =   "Blocked"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   29
            Top             =   240
            Value           =   -1  'True
            Width           =   1215
         End
         Begin VB.OptionButton optWarp 
            Caption         =   "Warp"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   120
            TabIndex        =   28
            Top             =   480
            Width           =   1215
         End
         Begin VB.CommandButton cmdClear2 
            Caption         =   "Clear"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   12
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   270
            Left            =   120
            TabIndex        =   27
            Top             =   1680
            Width           =   1215
         End
         Begin VB.OptionButton optItem 
            Caption         =   "Item"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   270
            Left            =   120
            TabIndex        =   26
            Top             =   720
            Width           =   1215
         End
         Begin VB.OptionButton optNpcAvoid 
            Caption         =   "Npc Avoid"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   270
            Left            =   120
            TabIndex        =   25
            Top             =   960
            Width           =   1215
         End
         Begin VB.OptionButton optKey 
            Caption         =   "Key"
            BeginProperty Font 
               Name            =   "Arial"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   270
            Left            =   120
            TabIndex        =   24
            Top             =   1200
            Width           =   1215
         End
      End
      Begin VB.OptionButton optLayers 
         Caption         =   "Layers"
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
         Left            =   1800
         TabIndex        =   22
         Top             =   3720
         Value           =   -1  'True
         Width           =   1575
      End
      Begin VB.OptionButton optAttribs 
         Caption         =   "Attributes"
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
         Left            =   1800
         TabIndex        =   21
         Top             =   3960
         Width           =   1575
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
         Left            =   2040
         TabIndex        =   20
         Top             =   5760
         Width           =   1695
      End
      Begin VB.CommandButton cmdSend 
         Caption         =   "Send"
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
         TabIndex        =   19
         Top             =   5760
         Width           =   1695
      End
      Begin VB.CommandButton cmdProperties 
         Caption         =   "Properties"
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
         Left            =   2400
         TabIndex        =   18
         Top             =   4560
         Width           =   1335
      End
      Begin VB.VScrollBar scrlPicture 
         Height          =   3375
         Left            =   3480
         Max             =   255
         TabIndex        =   17
         Top             =   120
         Width           =   255
      End
      Begin VB.PictureBox picBack 
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
         Height          =   3360
         Left            =   120
         ScaleHeight     =   224
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   224
         TabIndex        =   15
         Top             =   120
         Width           =   3360
         Begin VB.PictureBox picBackSelect 
            AutoRedraw      =   -1  'True
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
            Height          =   960
            Left            =   0
            ScaleHeight     =   64
            ScaleMode       =   3  'Pixel
            ScaleWidth      =   64
            TabIndex        =   16
            Top             =   0
            Width           =   960
         End
      End
      Begin VB.PictureBox picSelect 
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
         Left            =   1800
         ScaleHeight     =   32
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   32
         TabIndex        =   14
         Top             =   4560
         Width           =   480
      End
   End
   Begin VB.PictureBox picGUI 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
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
      Height          =   5790
      Left            =   7680
      Picture         =   "frmMirage.frx":0008
      ScaleHeight     =   384
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   128
      TabIndex        =   2
      Top             =   0
      Width           =   1950
      Begin VB.PictureBox picInventory 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
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
         Height          =   630
         Left            =   240
         Picture         =   "frmMirage.frx":3302
         ScaleHeight     =   600
         ScaleWidth      =   600
         TabIndex        =   8
         ToolTipText     =   "Inventory"
         Top             =   3000
         Width           =   630
      End
      Begin VB.PictureBox picSpells 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
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
         Height          =   630
         Left            =   1080
         Picture         =   "frmMirage.frx":4606
         ScaleHeight     =   600
         ScaleWidth      =   600
         TabIndex        =   7
         ToolTipText     =   "Spells"
         Top             =   3000
         Width           =   630
      End
      Begin VB.PictureBox picStats 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
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
         Height          =   630
         Left            =   240
         Picture         =   "frmMirage.frx":590A
         ScaleHeight     =   600
         ScaleWidth      =   600
         TabIndex        =   6
         ToolTipText     =   "Stats"
         Top             =   3840
         Width           =   630
      End
      Begin VB.PictureBox picTrain 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
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
         Height          =   630
         Left            =   1080
         Picture         =   "frmMirage.frx":6C0E
         ScaleHeight     =   600
         ScaleWidth      =   600
         TabIndex        =   5
         ToolTipText     =   "Train"
         Top             =   3840
         Width           =   630
      End
      Begin VB.PictureBox picTrade 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
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
         Height          =   630
         Left            =   240
         Picture         =   "frmMirage.frx":7F12
         ScaleHeight     =   600
         ScaleWidth      =   600
         TabIndex        =   4
         ToolTipText     =   "Trade"
         Top             =   4680
         Width           =   630
      End
      Begin VB.PictureBox picQuit 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
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
         Height          =   630
         Left            =   1080
         Picture         =   "frmMirage.frx":9216
         ScaleHeight     =   600
         ScaleWidth      =   600
         TabIndex        =   3
         ToolTipText     =   "Quit"
         Top             =   4680
         Width           =   630
      End
      Begin VB.Label lblName 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Mirage Online"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   255
         Left            =   0
         TabIndex        =   12
         Top             =   120
         Width           =   1935
      End
      Begin VB.Label lblHP 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "0%"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   255
         Left            =   360
         TabIndex        =   11
         Top             =   1800
         Width           =   1575
      End
      Begin VB.Label lblMP 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "0%"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   255
         Left            =   360
         TabIndex        =   10
         Top             =   2160
         Width           =   1575
      End
      Begin VB.Label lblSP 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "0%"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   255
         Left            =   360
         TabIndex        =   9
         Top             =   2520
         Width           =   1575
      End
   End
   Begin RichTextLib.RichTextBox txtChat 
      Height          =   1815
      Left            =   0
      TabIndex        =   1
      Top             =   5760
      Width           =   9615
      _ExtentX        =   16960
      _ExtentY        =   3201
      _Version        =   393217
      BackColor       =   0
      ScrollBars      =   2
      Appearance      =   0
      TextRTF         =   $"frmMirage.frx":A51A
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.PictureBox picScreen 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
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
      Height          =   5760
      Left            =   0
      ScaleHeight     =   382
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   510
      TabIndex        =   0
      Top             =   0
      Width           =   7680
   End
   Begin MSWinsockLib.Winsock Socket 
      Left            =   120
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
End
Attribute VB_Name = "frmMirage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Resize()
    Call ResizeGUI
End Sub

Private Sub Form_Terminate()
    Call GameDestroy
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GameDestroy
End Sub

Private Sub picScreen_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    Call EditorMouseDown(Button, Shift, x, y)
    Call PlayerSearch(Button, Shift, x, y)
End Sub

Private Sub picScreen_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    Call EditorMouseDown(Button, Shift, x, y)
End Sub

Private Sub Socket_DataArrival(ByVal bytesTotal As Long)
    If IsConnected Then
        Call IncomingData(bytesTotal)
    End If
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    Call HandleKeypresses(KeyAscii)
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    Call CheckInput(1, KeyCode, Shift)
End Sub

Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)
    Call CheckInput(0, KeyCode, Shift)
End Sub

Private Sub txtChat_GotFocus()
    frmMirage.picScreen.SetFocus
End Sub

Private Sub picInventory_Click()
    Call UpdateInventory
    picInv.Visible = True
End Sub

Private Sub lblUseItem_Click()
    Call SendUseItem(frmMirage.lstInv.ListIndex + 1)
End Sub

Private Sub lblDropItem_Click()
Dim Value As Long
Dim InvNum As Long

    InvNum = frmMirage.lstInv.ListIndex + 1

    If GetPlayerInvItemNum(MyIndex, InvNum) > 0 And GetPlayerInvItemNum(MyIndex, InvNum) <= MAX_ITEMS Then
        If Item(GetPlayerInvItemNum(MyIndex, InvNum)).Type = ITEM_TYPE_CURRENCY Then
            ' Show them the drop dialog
            frmDrop.Show vbModal
        Else
            Call SendDropItem(frmMirage.lstInv.ListIndex + 1, 0)
        End If
    End If
End Sub

Private Sub lblCast_Click()
    If Player(MyIndex).Spell(lstSpells.ListIndex + 1) > 0 Then
        If GetTickCount > Player(MyIndex).AttackTimer + 1000 Then
            If Player(MyIndex).Moving = 0 Then
                Call SendData("cast" & SEP_CHAR & lstSpells.ListIndex + 1 & SEP_CHAR & END_CHAR)
                Player(MyIndex).Attacking = 1
                Player(MyIndex).AttackTimer = GetTickCount
                Player(MyIndex).CastedSpell = YES
            Else
                Call AddText("Cannot cast while walking!", BrightRed)
            End If
        End If
    Else
        Call AddText("No spell here.", BrightRed)
    End If
End Sub

Private Sub lblCancel_Click()
    picInv.Visible = False
End Sub

Private Sub lblSpellsCancel_Click()
    picPlayerSpells.Visible = False
End Sub

Private Sub picSpells_Click()
    Call SendData("spells" & SEP_CHAR & END_CHAR)
End Sub

Private Sub picStats_Click()
    Call SendData("getstats" & SEP_CHAR & END_CHAR)
End Sub

Private Sub picTrain_Click()
    frmTraining.Show vbModal
End Sub

Private Sub picTrade_Click()
    Call SendData("trade" & SEP_CHAR & END_CHAR)
End Sub

Private Sub picQuit_Click()
    Call GameDestroy
End Sub

' // MAP EDITOR STUFF //

Private Sub optLayers_Click()
    If optLayers.Value = True Then
        fraLayers.Visible = True
        fraAttribs.Visible = False
    End If
End Sub

Private Sub optAttribs_Click()
    If optAttribs.Value = True Then
        fraLayers.Visible = False
        fraAttribs.Visible = True
    End If
End Sub

Private Sub picBackSelect_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    Call EditorChooseTile(Button, Shift, x, y)
End Sub

Private Sub picBackSelect_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    Call EditorChooseTile(Button, Shift, x, y)
End Sub

Private Sub cmdSend_Click()
    Call EditorSend
End Sub

Private Sub cmdCancel_Click()
    Call EditorCancel
End Sub

Private Sub cmdProperties_Click()
    frmMapProperties.Show vbModal
End Sub

Private Sub optWarp_Click()
    frmMapWarp.Show vbModal
End Sub

Private Sub optItem_Click()
    frmMapItem.Show vbModal
End Sub

Private Sub optKey_Click()
    frmMapKey.Show vbModal
End Sub

Private Sub optKeyOpen_Click()
    frmKeyOpen.Show vbModal
End Sub

Private Sub scrlPicture_Change()
    Call EditorTileScroll
End Sub

Private Sub cmdClear_Click()
    Call EditorClearLayer
End Sub

Private Sub cmdClear2_Click()
    Call EditorClearAttribs
End Sub


