# Custom title bar

Add a label, put where needed.

```vba
Option Explicit

' API functions
Private Declare Function ReleaseCapture Lib "user32" () As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Declare Function SetWindowText Lib "user32" Alias "SetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String) As Long

' Constants for above API calls
Private Const HTCAPTION = 2
Private Const WM_NCLBUTTONDOWN = &HA1

Private Sub Form_Load()
Dim retVal As Long

retVal = SetWindowText(Me.hwnd, Label1)
End Sub

Private Sub Label1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
ReleaseCapture
SendMessage hwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0&
End Sub
```

This makes a simple label able to move the form.