# Custom Experience Values

Difficulty: 1/5 - This is a fairly easy tutorial, and is entirely Copy and Paste!

Alright, so there used to be a tutorial for this on the old forums, but I beleive it is gone, so I decided to write my own. What this does is let's you set the experience required for every level. Alright so first things first, create a file called experience.ini and place it in the Data folder of the server side. The format of the .ini file should be like so :

```
[EXP]
MaxLevel=100
Exp1=1500
Exp2=2000
Exp3=2500
....
Exp99=1000000
Exp100=100500
```

It is basically saying that to level up at level 1, you need 1500 experience points. Note however that once you have reached the last level, even if you get the required ammount of experience points, you will not level up.

Now for the code itself!

### Server Side

#### modTypes
Look for the following line :

```vba
Public Spell(1 To MAX_SPELLS) As SpellRec
```

and under it add :

```vba
Public ExpReq() As Long
```

#### modGeneral

In sub LoadGameData, under the line :

```vba
    Call SetStatus("Loading spells...")
    Call LoadSpells
```

Add the following :

```vba
    Call SetStatus("Loading experience values...")
    Call LoadExperience
```

#### modDatabase

Anywhere in the module, add the following sub :

```vba
Public Sub LoadExperience()
    Dim FileName As String
    Dim I As Long
   
    FileName = App.Path & "\data\experience.ini"
   
    ReDim ExpReq(1 To (Val(GetVar(FileName, "EXP", "MaxLevel")) - 1)) As Long
   
    For I = 1 To UBound(ExpReq)
        ExpReq(I) = Val(GetVar(FileName, "EXP", "EXP" & I))
    Next I
End Sub
```

Next up, look for the `GetPlayerNextLevel` function and replace it with the following :

```vba
Public Function GetPlayerNextLevel(ByVal Index As Long) As Long
    GetPlayerNextLevel = ExpReq(GetPlayerLevel(Index))
End Function
```

#### modGameLogic

Lastly, find the sub `CheckPlayerLevelUp`. Right under the line :

```vba
    If GetPlayerExp(Index) >= GetPlayerNextLevel(Index) Then
```

Add the following code snippet, this will prevent players from leveling over the max level:

```vba
        If GetPlayerLevel(Index) = UBound(ExpReq) Then
            Call SetPlayerExp(Index, GetPlayerNextLevel(Index))
            Exit Sub
        End If
```

And there you go! You can now place your own custom experience values! Another simple way to do this is through the GetPlayerNextLevel function, if you replace it with your own formula, thus eliminating the need for a file :). Enjoy! Try it out, and if you have any questions or need any help, feel free to ask! :)
