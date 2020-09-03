# Display FPS
lol its easy, but hey some people cant get it Razz... so here is a tut on how to show the players FPS!

All Client Side

in ```modGameLogic```

find:

```vba
 ' Blit the text they are putting in
```

right above that add:

```vba
' Blit out there FPS, Submitted By GodSentDeath :D
' To make it easier for people to change where its X and Y is I added the FX and FY :p
Dim FX As Long
Dim FY As Long
FX = 5
FY = 5
Call DrawText(TexthDC, FX, FY, "FPS: " & GameFPS, RGB(255, 255, 255))
```

lol I added the FY and FX so its easier for some people to change where it gets blitted to Razz... well thats about it! Have Fun! 