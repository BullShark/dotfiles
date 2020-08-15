; ---------------------------------------------------- ;
;                    TabsOnWheels                      ;
; ---------------------------------------------------- ;
; Switch browser tabs with your mouse wheel when hovering over the tab bar (and optionally address bar).
; Press Right Mouse Click to switch tabs from anywhere in the program.
; If the target window is inactive when starting to scroll, it will be activated.
; Should work with any program that uses Control+Tab if you add it to enabledPrograms.
;
; Install https://www.autohotkey.com/ (Windows only) to run.
; To auto-start, copy the script or a shortcut to your
; Start Menu\Programs\Startup directory
; (%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup)

;; Wheel Scroll Tabs for Google Chrome 

#NoEnv
#SingleInstance, Force
CoordMode, Mouse, Screen

~$WheelDown::
~$WheelUp::
	MouseGetPos, mouseX, mouseY, hoveredWin
	WinGetPos, winX, winY, winW, , ahk_id %hoveredWin%
	WinGetClass, hoveredClass, ahk_id %hoveredWin%
	if (mouseX >= winX and mouseX < winX + winW and mouseY >= winY and mouseY < winY + 34 and hoveredClass = "Chrome_WidgetWin_1") {
		ControlFocus, , ahk_id %hoveredWin%
		if (A_ThisHotkey = "~$WheelDown") {
			ControlSend, , {Ctrl down}{PgDn}{Ctrl up}, ahk_id %hoveredWin%
		} else {
			ControlSend, , {Ctrl down}{PgUp}{Ctrl up}, ahk_id %hoveredWin%
		}
	}