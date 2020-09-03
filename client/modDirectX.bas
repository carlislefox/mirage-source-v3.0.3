Attribute VB_Name = "modDirectX"
Option Explicit

Public DX As New DirectX7
Public DD As DirectDraw7
Public DD_PrimarySurf As DirectDrawSurface7
Public DD_SpriteSurf As DirectDrawSurface7
Public DD_TileSurf As DirectDrawSurface7
Public DD_ItemSurf As DirectDrawSurface7
Public DD_BackBuffer As DirectDrawSurface7
Public DD_Clip As DirectDrawClipper

Public DDSD_Primary As DDSURFACEDESC2
Public DDSD_Sprite As DDSURFACEDESC2
Public DDSD_Tile As DDSURFACEDESC2
Public DDSD_Item As DDSURFACEDESC2
Public DDSD_BackBuffer As DDSURFACEDESC2

Public rec As RECT
Public rec_pos As RECT

Sub InitDirectX()

    ' Initialize direct draw
    Set DD = DX.DirectDrawCreate("")
    frmMirage.Show
    
    ' Indicate windows mode application
    Call DD.SetCooperativeLevel(frmMirage.hWnd, DDSCL_NORMAL)
    
    ' Init type and get the primary surface
    DDSD_Primary.lFlags = DDSD_CAPS
    DDSD_Primary.ddsCaps.lCaps = DDSCAPS_PRIMARYSURFACE
    Set DD_PrimarySurf = DD.CreateSurface(DDSD_Primary)
    
    ' Create the clipper
    Set DD_Clip = DD.CreateClipper(0)
    
    ' Associate the picture hwnd with the clipper
    DD_Clip.SetHWnd frmMirage.picScreen.hWnd
        
    ' Have the blits to the screen clipped to the picture box
    DD_PrimarySurf.SetClipper DD_Clip
        
    ' Initialize all surfaces
    Call InitSurfaces
End Sub

Sub InitSurfaces()
Dim key As DDCOLORKEY

    ' Check for files existing
    If FileExist("sprites.bmp") = False Or FileExist("tiles.bmp") = False Or FileExist("items.bmp") = False Then
        Call MsgBox("You dont have the graphics files in the same directory as this executable!", vbOKOnly, GAME_NAME)
        Call GameDestroy
    End If
    
    ' Set the key for masks
    key.low = 0
    key.high = 0
    
    ' Initialize back buffer
    DDSD_BackBuffer.lFlags = DDSD_CAPS Or DDSD_HEIGHT Or DDSD_WIDTH
    DDSD_BackBuffer.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
    DDSD_BackBuffer.lWidth = (MAX_MAPX + 1) * PIC_X
    DDSD_BackBuffer.lHeight = (MAX_MAPY + 1) * PIC_Y
    Set DD_BackBuffer = DD.CreateSurface(DDSD_BackBuffer)
    
    ' Init sprite ddsd type and load the bitmap
    DDSD_Sprite.lFlags = DDSD_CAPS
    DDSD_Sprite.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
    Set DD_SpriteSurf = DD.CreateSurfaceFromFile(App.Path & "\sprites.bmp", DDSD_Sprite)
    DD_SpriteSurf.SetColorKey DDCKEY_SRCBLT, key
    
    ' Init tiles ddsd type and load the bitmap
    DDSD_Tile.lFlags = DDSD_CAPS
    DDSD_Tile.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
    Set DD_TileSurf = DD.CreateSurfaceFromFile(App.Path & "\tiles.bmp", DDSD_Tile)
    DD_TileSurf.SetColorKey DDCKEY_SRCBLT, key
    
    ' Init items ddsd type and load the bitmap
    DDSD_Item.lFlags = DDSD_CAPS
    DDSD_Item.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_SYSTEMMEMORY
    Set DD_ItemSurf = DD.CreateSurfaceFromFile(App.Path & "\items.bmp", DDSD_Item)
    DD_ItemSurf.SetColorKey DDCKEY_SRCBLT, key
End Sub

Sub DestroyDirectX()
    Set DX = Nothing
    Set DD = Nothing
    Set DD_PrimarySurf = Nothing
    Set DD_SpriteSurf = Nothing
    Set DD_TileSurf = Nothing
    Set DD_ItemSurf = Nothing
End Sub

Function NeedToRestoreSurfaces() As Boolean
    Dim TestCoopRes As Long
    
    TestCoopRes = DD.TestCooperativeLevel
    
    If (TestCoopRes = DD_OK) Then
        NeedToRestoreSurfaces = False
    Else
        NeedToRestoreSurfaces = True
    End If
End Function
