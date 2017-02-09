#include-once
#cs -------------------------------------------------------------------------

 Application Log tab

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

;----------------------------------------------------------------------------
; Includes
#include <Date.au3>

; application components
#include "pan.au3"						; must be include first

;----------------------------------------------------------------------------
; globals
global $_loggerEdit

;----------------------------------------------------------------------------
Func loggerInit()
	Dim $cd = @ScriptDir
	loggerAppend("Corionis Service Manager " & $_build & @CRLF & _
		"    Started " & _NowDate() & " " & _NowTime() & @CRLF & _
		"    Running from " & $cd & @CRLF )
	$_loggerEdit = GUICtrlCreateEdit($_logBuffer, 13, 31, 611, 305)
	Local $ClearButton = GUICtrlCreateButton("Clear", 466, 342, 50, 25)
	GUICtrlSetOnEvent($ClearButton, "loggerClear")
	GUICtrlSetTip($ClearButton, "Clear the log")
	Local $SaveButton = GUICtrlCreateButton("Save", 526, 342, 50, 25)
	GUICtrlSetOnEvent($SaveButton, "loggerSave")
	GUICtrlSetTip($SaveButton, "Save the log to a file")
	loggerUpdate()
EndFunc

;----------------------------------------------------------------------------
Func loggerAppend($msg)
	$_logBuffer &= $msg
EndFunc

;----------------------------------------------------------------------------
Func loggerClear()
	$_logBuffer = ""
	loggerUpdate()
EndFunc

;----------------------------------------------------------------------------
Func loggerSave()
	MsgBox(64, "Save GUI Log", "You requested to Save the log. Sorry, not implemented yet.", $_logTab)
EndFunc

;----------------------------------------------------------------------------
Func loggerUpdate()
	GUICtrlSetData($_loggerEdit, $_logBuffer)
EndFunc


; end
