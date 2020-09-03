# Arena map morale

This adds an Arena type moral to your game. In an arena, you fight for the sport of it, just to see if you can beat your opponent. You lose no items or EXP if you lose.

Server Side, ```modGameLogic```

Find code (this code appears four times in ```modGameLogic```, make sure you replace each one):

```vba
If Map(GetPlayerMap(Attacker)).Moral = MAP_MORAL_NONE Or GetPlayerPK(Victim) = YES Then
```

And Replace it with:

```vba
If Map(GetPlayerMap(Attacker)).Moral = MAP_MORAL_NONE Or Map(GetPlayerMap(Attacker)).Moral = MAP_MORAL_ARENA Or GetPlayerPK(Victim) = YES Then
```

Still in ```modGameLogic```, find:

```vba
' Drop all worn items by victim
If GetPlayerWeaponSlot(Victim) > 0 Then
Call PlayerMapDropItem(Victim, GetPlayerWeaponSlot(Victim), 0)
End If
If GetPlayerArmorSlot(Victim) > 0 Then
Call PlayerMapDropItem(Victim, GetPlayerArmorSlot(Victim), 0)
End If
If GetPlayerHelmetSlot(Victim) > 0 Then
Call PlayerMapDropItem(Victim, GetPlayerHelmetSlot(Victim), 0)
End If
If GetPlayerShieldSlot(Victim) > 0 Then
Call PlayerMapDropItem(Victim, GetPlayerShieldSlot(Victim), 0)
End If

' Calculate exp to give attacker
Exp = Int(GetPlayerExp(Victim) / 10)

' Make sure we dont get less then 0
If Exp < 0 Then
Exp = 0
End If

If Exp = 0 Then
Call PlayerMsg(Victim, "You lost no experience points.", BrightRed)
Call PlayerMsg(Attacker, "You received no experience points from that weak insignificant player.", BrightBlue)
Else
Call SetPlayerExp(Victim, GetPlayerExp(Victim) - Exp)
Call PlayerMsg(Victim, "You lost " & Exp & " experience points.", BrightRed)
Call SetPlayerExp(Attacker, GetPlayerExp(Attacker) + Exp)
Call PlayerMsg(Attacker, "You got " & Exp & " experience points for killing " & GetPlayerName(Victim) & ".", BrightBlue)
End If
```

And replace it with:

```vba
'If map is an arena then don't drop items or lose exp
If Map(GetPlayerMap(Attacker)).Moral <> MAP_MORAL_ARENA Then

' Drop all worn items by victim
If GetPlayerWeaponSlot(Victim) > 0 Then
Call PlayerMapDropItem(Victim, GetPlayerWeaponSlot(Victim), 0)
End If
If GetPlayerArmorSlot(Victim) > 0 Then
Call PlayerMapDropItem(Victim, GetPlayerArmorSlot(Victim), 0)
End If
If GetPlayerHelmetSlot(Victim) > 0 Then
Call PlayerMapDropItem(Victim, GetPlayerHelmetSlot(Victim), 0)
End If
If GetPlayerShieldSlot(Victim) > 0 Then
Call PlayerMapDropItem(Victim, GetPlayerShieldSlot(Victim), 0)
End If

' Calculate exp to give attacker
Exp = Int(GetPlayerExp(Victim) / 10)

' Make sure we dont get less then 0
If Exp < 0 Then
Exp = 0
End If

If Exp = 0 Then
Call PlayerMsg(Victim, "You lost no experience points.", BrightRed)
Call PlayerMsg(Attacker, "You received no experience points from that weak insignificant player.", BrightBlue)
Else
Call SetPlayerExp(Victim, GetPlayerExp(Victim) - Exp)
Call PlayerMsg(Victim, "You lost " & Exp & " experience points.", BrightRed)
Call SetPlayerExp(Attacker, GetPlayerExp(Attacker) + Exp)
Call PlayerMsg(Attacker, "You got " & Exp & " experience points for killing " & GetPlayerName(Victim) & ".", BrightBlue)
End If
End If
```

Then find (still in ```modGameLogic```):

```vba
' Check if target is player who died and if so set target to 0
If Player(Attacker).TargetType = TARGET_TYPE_PLAYER And Player(Attacker).Target = Victim Then
Player(Attacker).Target = 0
Player(Attacker).TargetType = 0
End If

If GetPlayerPK(Victim) = NO Then
If GetPlayerPK(Attacker) = NO Then
Call SetPlayerPK(Attacker, YES)
Call SendPlayerData(Attacker)
Call GlobalMsg(GetPlayerName(Attacker) & " has been deemed a Player Killer!!!", BrightRed)
End If
Else
Call SetPlayerPK(Victim, NO)
Call SendPlayerData(Victim)
Call GlobalMsg(GetPlayerName(Victim) & " has paid the price for being a Player Killer!!!", BrightRed)
End If
Else
```

And replace it with this:

```vba
' Check if target is player who died and if so set target to 0
If Player(Attacker).TargetType = TARGET_TYPE_PLAYER And Player(Attacker).Target = Victim Then
Player(Attacker).Target = 0
Player(Attacker).TargetType = 0
End If

'Don't deam a PKer if it's an arena
If Map(GetPlayerMap(Attacker)).Moral <> MAP_MORAL_ARENA Then
If GetPlayerPK(Victim) = NO Then
If GetPlayerPK(Attacker) = NO Then
Call SetPlayerPK(Attacker, YES)
Call SendPlayerData(Attacker)
Call GlobalMsg(GetPlayerName(Attacker) & " has been deemed a Player Killer!!!", BrightRed)
End If
Else
Call SetPlayerPK(Victim, NO)
Call SendPlayerData(Victim)
Call GlobalMsg(GetPlayerName(Victim) & " has paid the price for being a Player Killer!!!", BrightRed)
End If
End If
Else
```

Now find (```modGameLogic``` still):

```vba
' Player is dead
Call GlobalMsg(GetPlayerName(Victim) & " has been killed by " & GetPlayerName(Attacker), BrightRed)
```

And replace it with:

```vba
' Player is dead
If Map(GetPlayerMap(Attacker)).Moral = MAP_MORAL_ARENA Then
Call GlobalMsg(GetPlayerName(Victim) & " was defeated in an arena by " & GetPlayerName(Attacker) & "." & (GetPlayerName(Victim) & " lost no EXP.", Yellow)
Else
Call GlobalMsg(GetPlayerName(Victim) & " has been killed by " & GetPlayerName(Attacker), BrightRed)
End If
```

Moving on to ```modTypes```, find:

```vba
Public Const MAP_MORAL_SAFE = 1
```

Right underneath that, add:

```vba
Public Const MAP_MORAL_ARENA = 2
```

You're done with the server side. Now open up your client.

First go to modTypes and Find:

```vba
Public Const MAP_MORAL_SAFE = 1
```

And right underneath it add:

```vba
Public Const MAP_MORAL_ARENA = 2
```

Now, open up ```frmMapProperties```. Click on ```cmbMorals```. Now in the properties for ```cmbMorals```, find ```Item data```. Add a third 0 (zero) after the first two 0's.

Now find ```List```. It should say ```None``` and ```Safe```. Add ```Arena``` underneath those two.

You're finished! This works for me, I hope it works for you too. You may have to remap. I'm not sure because I didn't have any maps made when I tested it. Enjoy.