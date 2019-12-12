# Poe Carpal Tunnel Preventer

It's 3 days into the league and both of your wrists hurt? Worry no more, PoeCPT is here. Automates several 
aspects of the game from flasks to inventory management.


## Features

+ Poe flask macro, this is straight from https://github.com/JoelStanford/PoEAutoFlask autoflask and there 
are no additios here so all power to him.
+ Move all the items from your inventory to stash.
+ Move items from your stashtab to inventory.
+ Identify all the items from dump stash tab.
+ Automatically roll prophecies, requires you to have one slot you are rolling at.
+ Get all currency, maps and divination cards from your stashtab. You need to either play at 2560x1440 or 1920x1080 for the templates to work.

## Setting up 

### Installing python:
Download python 3.73 from: https://www.python.org/downloads/release/python-373/
use pip to install: 
```
pip install opencv-python
```
```
pip install pyautogui
```

### Setting up global variables:
```
nx  := 1730
ny :=  818
delta :=  70
dx = 40
dy = 230
dumpStashDelta := 35
```
nx, ny are the coordinates for the first slot of your normal inventory.
dx, dy are the coordinates for the first slot of your 24x24 dumptab.
You get the delta by substracting the second slot coordinates from the first slot one.

```
textBoxX := 575
textBoxY := 1190
textBoxFullHD := 450
textBoxYFullHD := 890
```

Coordinates for the search box for 2560x1440 and 1920x1080

### Setting up your python and folder locations.

You need to replace:

```
Run C:\Users\Anssikka\AppData\Local\Programs\Python\Python37\python.exe A:\poe\PoeCarpalTunnelPreventer\templateCurrency.py,, Hide
```

With your own python installation location and the folder location where you have put your poeCTP in three places.

### Setting up prophecy rolling coordinates

You need 3 coordinates for this to work.
1. Is the location of the "seal" button of the prophecy slot you are rerolling.
2. Is the "Do you want to seal this prophecy" ok button location.
3. Is the seek prophecy button. 

```
!v::
Random, Delay, 225, 250
Loop, 9 {
	col := nx + (A_Index - 1) * delta
	Loop, 5 {
		row := ny + (A_Index - 1) * delta
1.	Send {Click, 686, 598}
2.	Send {Click, 1113, 737}
	Send {Click, %col%, %row%}
3.	Send {Click, 445, 1040}
    Sleep, %Delay%
	}
}
return
```


## Hotkeys:
F12 activate/deactivate flaskmacro
alt + o Initialize empty inventory slots to only click non-empty slots.
alt + p Initialize empty 24x24 dumptab inventory slots to only click non-empty slots.
alt + a Move items from dumptab to inventory untill full.
alt + j Get all the currency from 24x24 tab.
alt + k Get all the maps from 24x24 tab.
alt + p 
alt + p
alt + p 

