#IfWinActive Path of Exile
#NoEnv
#Warn
#Persistent
SetBatchLines -1
ListLines Off
SetMouseDelay, 10

;---------------------------------------------------
; GLOBAL VARIABLES
; Setting up: nx, ny is the position of the first slot of your inventory. delta is the nx - the first value of the next slot.
; dx, dy is the first slot of your dump stash tab. DumpStashDelta is the difference between dx and the next slot right to it.
; Find the StopLoadingToStashColor color and coordinates by putting mouse to the empty inventory slot where you want to stop and press alt+g. Input those into StopLoadingToStashColor and StopLoadingX, StopLoadingY
; Instructions to set the flask macro are below.
;-------------------------------------------

nx  := 1730
ny :=  818
delta :=  70
dx = 40
dy = 230
dumpStashDelta := 35

stopLoadingToStashColor = 0x080808
stopLoadingX = 2360
stopLoadingY = 1031

invColor := []
dumpStashInvColor := []

FlaskDurationInit := []
textBoxX := 575
textBoxY := 1190
textBoxFullHD := 450
textBoxYFullHD := 890


;---------------------------------------------------
; INIT Empty inventoryslot colors.
;---------------------------------------------------


if (FileExist("invColors.csv"))
{
	Loop, Read, A:\poe\PoeCarpalTunnelPreventer\invColors.csv 
	{
		invColor.Push(A_LoopReadLine)
	}
	MsgBox, loaded stash coords.
}

if (FileExist("dumpStashinvColors.csv"))
{
	Loop, Read, A:\poe\PoeCarpalTunnelPreventer\dumpStashInvColors.csv 
	{
		dumpStashinvColor.Push(A_LoopReadLine)
	}
	MsgBox, loaded dumpstash coords.
}

;----------------------------------------------------------------------
; Set the duration of each flask, in ms, below.  For example, if the 
; flask in slot 3 has a duration of "Lasts 4.80 Seconds", then use:
;		FlaskDurationInit[3] := 4800
;
; To disable a particular flask, set it's duration to 0
;
; Note: e r q for steelskin, brand recall etc.
;----------------------------------------------------------------------
FlaskDurationInit[1] := 0
FlaskDurationInit[2] := 0
FlaskDurationInit[3] := 3500
FlaskDurationInit[4] := 4500
FlaskDurationInit[5] := 5700
FlaskDurationInit["e"] := 0	; 
FlaskDurationInit["r"] := 0	
FlaskDurationInit["q"] := 0	

FlaskDuration := []
FlaskLastUsed := []
UseFlasks := false
HoldRightClick := false
LastRightClick := 0


;----------------------------------------------------------------------
; Main program loop - basics are that we use flasks whenever flask
; usage is enabled via hotkey (default is F12), and we've attacked
; within the last 0.5 second (or are channeling/continuous attacking.
;----------------------------------------------------------------------
Loop {
	if (UseFlasks) {
		; have we attacked in the last 0.5 seconds?
		if ((A_TickCount - LastRightClick) < 500) {
			Gosub, CycleAllFlasksWhenReady
		} else {
			; We haven't attacked recently, but are we channeling/continuous?
			if (HoldRightClick) {
				Gosub, CycleAllFlasksWhenReady
			}
		}
	}
}

!F12::
	UseFlasks := not UseFlasks
	if UseFlasks {
		; reset usage timers for all flasks
		for i in FlaskDurationInit {
			FlaskLastUsed[i] := 0
			FlaskDuration[i] := FlaskDurationInit[i]
		}
	} 
	return

;----------------------------------------------------------------------
; To use a different mouse button (default is right click), change the
; "RButton" to:
;		RButton - to use the {default} right mouse button
;		MButton - to use the {default} middle mouse button (wheel)
;		LButton - to use the {default} Left mouse button
;
; Make the change in both places, below (the first is click,
; 2nd is release of button}
;----------------------------------------------------------------------
~RButton::
	; pass-thru and capture when the last attack (Right click) was done
	; we also track if the mouse button is being held down for continuous attack(s) and/or channelling skills
	HoldRightClick := true
	LastRightClick := A_TickCount
	return

~RButton up::
	; pass-thru and release the right mouse button
	HoldRightClick := false
	return


;----------------------------------------------------------------------
; The following 5 hotkeys allow for manual use of flasks while still
; tracking optimal recast times.
;----------------------------------------------------------------------
~1::
	; pass-thru and start timer for flask 1
	FlaskLastUsed[1] := A_TickCount
	Random, VariableDelay, -99, 99
	FlaskDuration[1] := FlaskDurationInit[1] + VariableDelay ; randomize duration to simulate human
	return

~2::
	; pass-thru and start timer for flask 2
	FlaskLastUsed[2] := A_TickCount
	Random, VariableDelay, -99, 99
	FlaskDuration[2] := FlaskDurationInit[2] + VariableDelay ; randomize duration to simulate human
	return

~3::
	; pass-thru and start timer for flask 3
	FlaskLastUsed[3] := A_TickCount
	Random, VariableDelay, -99, 99
	FlaskDuration[3] := FlaskDurationInit[3] + VariableDelay ; randomize duration to simulate human
	return

~4::
	; pass-thru and start timer for flask 4
	FlaskLastUsed[4] := A_TickCount
	Random, VariableDelay, -99, 99
	FlaskDuration[4] := FlaskDurationInit[4] + VariableDelay ; randomize duration to simulate human
	return

~5::
	; pass-thru and start timer for flask 5
	FlaskLastUsed[5] := A_TickCount
	Random, VariableDelay, -99, 99
	FlaskDuration[5] := FlaskDurationInit[5] + VariableDelay ; randomize duration to simulate human
	return

~r::
	; pass-thru and start timer for r
	FlaskLastUsed["r"] := A_TickCount
	Random, VariableDelay, -99, 99
	FlaskDuration[5] := FlaskDurationInit[5] + VariableDelay ; randomize duration to simulate human
	return

~e::
	; pass-thru and start timer for e
	FlaskLastUsed["e"] := A_TickCount
	Random, VariableDelay, -99, 99
	FlaskDuration[5] := FlaskDurationInit[5] + VariableDelay ; randomize duration to simulate human
	return

~q::
	; pass-thru and start timer for q
	FlaskLastUsed["q"] := A_TickCount
	Random, VariableDelay, -99, 99
	FlaskDuration[5] := FlaskDurationInit[5] + VariableDelay ; randomize duration to simulate human
	return

;----------------------------------------------------------------------
; Use all flasks, now.  A variable delay is included between flasks
; NOTE: this will use all flasks, even those with a FlaskDurationInit of 0
;----------------------------------------------------------------------
`::
	if UseFlasks {
		Send 1
		Random, VariableDelay, -99, 99
		Sleep, %VariableDelay%
		Send 2
		Random, VariableDelay, -99, 99
		Sleep, %VariableDelay%
		Send 3
		Random, VariableDelay, -99, 99
		Sleep, %VariableDelay%
		Send 4
		Random, VariableDelay, -99, 99
		Sleep, %VariableDelay%
		Send 5
		Random, VariableDelay, -99, 99
		Sleep, %VariableDelay%
		Send e
		Random, VariableDelay, -99, 99
		Sleep, %VariableDelay%
		Send r
		Random, VariableDelay, -99, 99
		Sleep, %VariableDelay%
		send q
	}
	return

CycleAllFlasksWhenReady:
	for flask, duration in FlaskDuration {
		; skip flasks with 0 duration and skip flasks that are still active
		if ((duration > 0) & (duration < A_TickCount - FlaskLastUsed[flask])) {
			Send %flask%
			FlaskLastUsed[flask] := A_TickCount
			Random, VariableDelay, -99, 99
			FlaskDuration[flask] := FlaskDurationInit[flask] + VariableDelay ; randomize duration to simulate human
			sleep, %VariableDelay%
		}
	}
	return


;----------------------------------------------------------------------
; The following are used for fast ctrl-click from the Inventory screen
; using alt-c.  The coordinates for ix,iy come from MouseGetPos (Alt+g)
; of the top left location in the inventory screen.  The delta is the
; pixel change to the next box, either down or right.
; 
; To get the correct values for use below, do the following:
;	1. Load the macro into AutoHotKey
;	2. open Inventory screen (I) and place the mouse cursor in the
;	   middle of the top left inventory box.
;	3. Press Alt+g and note the coordinates displayed by the mouse.
;   4. Replace the coordinates below.
;	5. To get the "delta", do the same for the next inventory box down
;	   and note the difference
;----------------------------------------------------------------------

;----------------------------------------------------------------------
; NOTE: You have to initialize the color of empty slots with alt + o
; Alt+z to click on non empty slots of your inventory. Im ignoring the last two columns but you can just change the first loop number to 12.
;----------------------------------------------------------------------
!z::
	index := 1
	Loop, 10 {
		col := nx + (A_Index - 1) * delta
		Loop, 5 {
			row := ny + (A_Index - 1) * delta
			PixelGetColor, color, %col%, %row%
			if (color != invColor[index])
			{
				Send ^{Click, %col%, %row%}
			}
			index += 1
		}
	}
	return


;----------------------------------------------------------------------
; Alt+m to identify the whole dump tab. Ignores empty slots. You need to put identify scrolls on the first slot of your inventory. Change the loop numbers to ignore parts of the inventory.
;----------------------------------------------------------------------

!m::
index := 1
x := nx
y := ny
Random, Delay, -99, 99 
Send {Click, right, %x%, %y%}
Send {Shift down}
	Loop, 24 {
		col := dx + (A_Index - 1 ) * dumpStashDelta
		Loop, 24 {
			row := dy + (A_Index - 1) * dumpStashDelta
			PixelGetColor, color, %col%, %row%
			if (color != dumpStashInvColor[index]) 
			{
				Send {Click, %col%, %row%}
				Sleep %Delay%
			}
			index += 1
		}
	}
Send {Shift up}
return


;----------------------------------------------------------------------
; Alt+v to roll prophecies in one slot.
; You need 3 coordinates for this to work.
; 1. Is the location of the "seal" button of the prophecy slot you are rerolling.
; 2. Is the "Do you want to seal this prophecy" ok button location.
; 3. Is the seek prophecy button. 
;
;----------------------------------------------------------------------

!v::
Random, Delay, 225, 250
Loop, 9 {
	col := nx + (A_Index - 1) * delta
	Loop, 5 {
		row := ny + (A_Index - 1) * delta
		Send {Click, 686, 598}
		Send {Click, 1113, 737}
		Send {Click, %col%, %row%}
		Send {Click, 445, 1040}
    Sleep, %Delay%
	}
}
return


;----------------------------------------------------------------------
; Alt+g - Get the current screen coordinates of the mouse pointer.
;----------------------------------------------------------------------
!g::
	MouseGetPos, x, y
	MsgBox, %x% %y%
	return


;----------------------------------------------------------------------
; Alt+g - Get the color of the pixel at current mouse location.
;----------------------------------------------------------------------

!h::
	MouseGetPos, x, y
	PixelGetColor, color, %x%, %y%
	MsgBox, %color% %x% %y%
	return

;----------------------------------------------------------------------
; Get all the currency from 24x24 tab.
;----------------------------------------------------------------------

!j::
	Send {Click, %textBoxX%, %textBoxY%}
	Send currency
	Sleep, 250
	Run C:\Users\Anssikka\AppData\Local\Programs\Python\Python37\python.exe A:\poe\PoeCarpalTunnelPreventer\templateCurrency.py,, Hide
	Sleep, 1000
	Lista := []
	Loop, Read, A:\poe\PoeCarpalTunnelPreventer\koordinaatitCurrency.csv
	{
		coordinates := StrSplit(A_LoopReadLine, ",")
		x := coordinates[1]
		y := coordinates[2]
		Send ^{Click, %x%, %y%}
	}
	return


;----------------------------------------------------------------------
; Get all the maps from 24x24 tab.
;----------------------------------------------------------------------

!k::
	Send {Click, %textBoxX%, %textBoxY%}
	Send map
	Sleep, 250
	Run C:\Users\Anssikka\AppData\Local\Programs\Python\Python37\python.exe A:\poe\PoeCarpalTunnelPreventer\templateMap.py,, Hide
	Sleep, 1000
	Lista := []
	Loop, Read, A:\poe\PoeCarpalTunnelPreventer\koordinaatitMap.csv
	{
		coordinates := StrSplit(A_LoopReadLine, ",")
		x := coordinates[1]
		y := coordinates[2]
		Send ^{Click, %x%, %y%}
	}
	return


;----------------------------------------------------------------------
; Get all the divination cards from 24x24 tab.
;----------------------------------------------------------------------

!l::
	Send {Click, %textBoxX%, %textBoxY%}
	Send divination
	Sleep, 250
	Run C:\Users\Anssikka\AppData\Local\Programs\Python\Python37\python.exe A:\poe\PoeCarpalTunnelPreventer\templateDiv.py,, Hide
	Sleep, 1000
	Lista := []
	Loop, Read, A:\poe\PoeCarpalTunnelPreventer\koordinaatitDiv.csv
	{
		coordinates := StrSplit(A_LoopReadLine, ",")
		x := coordinates[1]
		y := coordinates[2]
		Send ^{Click, %x%, %y%}
	}
	return

	;-----------------------------------------------------
	; Initialize empty inventory slots to only click non-empty slots.
	;-----------------------------------------------------

	!o::
	if (FileExist("invColors.csv")) {
		MsgBox, File already exists
	} else {
	Loop, 12 {
		col := nx + (A_Index - 1) * delta
		Loop, 5 {
			row := ny + (A_Index - 1) * delta
			PixelGetColor, color, %col%, %row%
			invColor.Push(color)
			;MsgBox, %color%
			FileAppend, %color% `n, invColors.csv
		}
	}
	MsgBox, Got the colors of empty inventory slots.
	}
	return


	;-----------------------------------------------------
	; Initialize empty 24x24 dumptab inventory slots to only click non-empty slots.
	;-----------------------------------------------------


	!p::
	if (FileExist("dumpStashInvColors.csv")) 
	{
		MsgBox, File already exists.
	} else 
	{
	Loop, 24 {
		col := dx + (A_Index - 1) * dumpStashDelta
		Loop, 24 {
			row := dy + (A_Index - 1) * dumpStashDelta
			PixelGetColor, color, %col%, %row%
			dumpStashInvColor.Push(color)
			FileAppend, %color% `n, dumpStashInvColors.csv
		}
	}
	MsgBox, Got the colors of empty dumpstash inventory slots.
	}
	return



;-----------------------------------------------------
; Move items from dumptab to inventory untill full.
;-----------------------------------------------------

!a::
index := 1
x := nx
y := ny
	Loop, 24 {
		col := dx + (A_Index - 1 ) * dumpStashDelta
		Loop, 24 {
			row := dy + (A_Index - 1) * dumpStashDelta
			PixelGetColor, color, %col%, %row%
			if (color != dumpStashInvColor[index]) 
			{
				Send ^{Click, %col%, %row%}
				
				PixelGetColor, isEmpty, %stopLoadingX%, %stopLoadingY%
				if (isEmpty != stopLoadingToStashColor)
				{
					break
				}

			}
			index += 1
		}
	}
return