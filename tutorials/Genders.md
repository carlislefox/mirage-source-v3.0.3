# Genders

BTW.. this is all SERVER side.

Ok Find ```sub LoadClasses() ```

There should be something that looks like this

```vba
Class(i).Sprite = GetVar(FileName, "CLASS" & i, "Sprite")
```

You need to change this one and add another..

```vba
Class(i).MaleSprite = GetVar(FileName, "CLASS" & i, "MaleSprite")
Class(i).FemaleSprite = GetVar(FileName, "CLASS" & i, "FemaleSprite")
```

Ok now you gotta do it for saving the classes if they don't exist..

Find this sub ```sub SaveClasses()```

Look for

```vba
Call PutVar(FileName, "CLASS" & i, "Sprite", STR(Class(i).Sprite))
```

now we gotta get it to save both ```MaleSprite``` and ```FemaleSprite``` so... change one and add another...

```vba
Call PutVar(FileName, "CLASS" & i, "MaleSprite", STR(Class(i).MaleSprite))
Call PutVar(FileName, "CLASS" & i, "FemaleSprite", STR(Class(i).FemaleSprite))
```

Alrite... moving on to the next sub

now find ```Type ClassRec```

Now in here it will say.. 

```vbaSprite As Integer```

You need to change this and add another one (hmm heard that before...)

```vba
MaleSprite As Integer
FemaleSprite As Integer
```

OK now.. heheheh.

Find this sub ```Sub AddChar```

You will see this code

```vba
If Player(Index).Char(CharNum).Sex = SEX_MALE Then
Player(Index).Char(CharNum).Sprite = Class(ClassNum).Sprite
Else
Player(Index).Char(CharNum).Sprite = Class(ClassNum).Sprite
End If
```

Now... this isn't what we want.. we don't want both genders to be the same sprite...

Change the code to this..

```vba
If Player(Index).Char(CharNum).Sex = SEX_MALE Then
Player(Index).Char(CharNum).Sprite = Class(ClassNum).MaleSprite
Else
Player(Index).Char(CharNum).Sprite = Class(ClassNum).FemaleSprite
End If
```

Ok, Now last but NOT least, this is the most important.. heh

open ```classes.ini```

now you will see your classes.. like this

```vba
[CLASS1]
Name=Romeoisgod
Sprite= 9
STR= 1
DEF= 3
SPEED= 3
MAGI= 13
```

Hmm, this won't work... there is no ```MaleSprite``` and ```FemaleSprite```... we'll have to change that.

```vba
[CLASS0]
Name=Romeoisgod
MaleSprite= 30
FemaleSprite= 28
STR= 8
DEF= 7
SPEED= 5
MAGI= 0
```

now by simply changing what ```MaleSprite``` and ```FemaleSprite``` equal you can change the sprite of the gender Razz

hehe, I know I'm awesome, alrite, this finishes my FIRST tutorial.. I hope it helps alot...

heh, works alot better than the one that +1 to the sprite

If you have ANY problems, please PM me, or reply here and I'll help you out!

good luck =)