#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance, Force
#NoTrayIcon

; Initialize variables
curTime := 0
countRate := 1
pauseState := 0 ; Timer starts in an unpaused state

; GUI position
width := A_ScreenWidth/2
height := A_ScreenHeight - 40

SetTimer, UpdateTime, 1000 ; Call UpdateTime every 1 second

; GUI
Gui, Font, s8, Lucida Console
Gui, +AlwaysOnTop +ToolWindow -Caption
Gui, Add, Text, x5 y5 vDisplay, +00:00 ; Note: we do this to set number of characters at start

; Widen display to accomodate the extra negative
if (curTime <= -600)
  Gui, Show, x%width% y%height% w50 h20, Timer
else
  Gui, Show, x%width% y%height% w45 h20, Timer

UpdateTime:
; Always put the timer on top
WinSet, Top,, Timer

if (pauseState = 0) {
	; Timer active
	curTime += countRate ; Counting up or down
}

; Formatting time to minutes and seconds
sign := (curTime < 0) ? "-" : ""
mins := Abs(curTime) // 60, sec := Mod(Abs(curTime), 60)
if (sec < 10)
	sec := "0" sec
GuiControl, Text, Display, % sign mins ":" sec
return

ShowStateToolTip:
; Up or down depending on positive or negative
if (pauseState = 1)
  ToolTip, Paused
else if (countRate >= 0)
  ToolTip, Up: %countRate%
else
  ToolTip % "Down: " -1 * countRate

; Remove tooltip once done
Sleep, 1000
ToolTip
return

; Hotkeys
!k:: ; Alt + K
	countRate++
  Gosub, ShowStateToolTip
return

!j:: ; Alt + J
	countRate--
  Gosub, ShowStateToolTip
return

!p:: ; Alt + P
	pauseState := !pauseState
  Gosub, ShowStateToolTip
return