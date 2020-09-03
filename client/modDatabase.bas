Attribute VB_Name = "modDatabase"
Option Explicit

Function FileExist(ByVal FileName As String) As Boolean
    If Dir(App.Path & "\" & FileName) = "" Then
        FileExist = False
    Else
        FileExist = True
    End If
End Function

Sub AddLog(ByVal Text As String)
Dim FileName As String
Dim f As Long

    If Trim(Command) = "-debug" Then
        If frmDebug.Visible = False Then
            frmDebug.Visible = True
        End If
        
        FileName = App.Path & "\debug.txt"
    
        If Not FileExist("debug.txt") Then
            f = FreeFile
            Open FileName For Output As #f
            Close #f
        End If
    
        f = FreeFile
        Open FileName For Append As #f
            Print #f, Time & ": " & Text
        Close #f
    End If
End Sub

Sub SaveLocalMap(ByVal MapNum As Long)
Dim FileName As String
Dim f As Long

    FileName = App.Path & "\maps\map" & MapNum & ".dat"
            
    f = FreeFile
    Open FileName For Binary As #f
        Put #f, , SaveMap
    Close #f
End Sub

Sub LoadMap(ByVal MapNum As Long)
Dim FileName As String
Dim f As Long

    FileName = App.Path & "\maps\map" & MapNum & ".dat"
        
    f = FreeFile
    Open FileName For Binary As #f
        Get #f, , SaveMap
    Close #f
End Sub

Function GetMapRevision(ByVal MapNum As Long) As Long
Dim FileName As String
Dim f As Long
Dim TmpMap As MapRec

    FileName = App.Path & "\maps\map" & MapNum & ".dat"
        
    f = FreeFile
    Open FileName For Binary As #f
        Get #f, , TmpMap
    Close #f
        
    GetMapRevision = TmpMap.Revision
End Function
