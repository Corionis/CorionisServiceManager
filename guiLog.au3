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
#include "build.au3"

;----------------------------------------------------------------------------
; globals
global $_guiLogEdit

;----------------------------------------------------------------------------
Func guiLogInit()
	Dim $cd = @ScriptDir
	guiLogAppend("Corionis Service Manager " & $_build & @CRLF & _
		"    Started " & _NowDate() & " " & _NowTime() & @CRLF & _
		"    Running from " & $cd & @CRLF )
	$_guiLogEdit = GUICtrlCreateEdit($_logBuffer, 13, 31, 611, 305)
	Local $ClearButton = GUICtrlCreateButton("Clear", 466, 342, 50, 25)
	GUICtrlSetOnEvent($ClearButton, "guiLogClear")
	GUICtrlSetTip($ClearButton, "Clear the log")
	Local $SaveButton = GUICtrlCreateButton("Save", 526, 342, 50, 25)
	GUICtrlSetOnEvent($SaveButton, "guiLogSave")
	GUICtrlSetTip($SaveButton, "Save the log to a file")
	guiLogUpdate()
EndFunc

;----------------------------------------------------------------------------
Func guiLogAppend($msg)
	$_logBuffer &= $msg
EndFunc

;----------------------------------------------------------------------------
Func guiLogClear()
	$_logBuffer = ""
	guiLogUpdate()
EndFunc

;----------------------------------------------------------------------------
Func guiLogSave()
	MsgBox(64, "Save GUI Log", "You requested to Save the log. Sorry, not implemented yet.", $_logTab)
EndFunc

;----------------------------------------------------------------------------
Func guiLogUpdate()
	GUICtrlSetData($_guiLogEdit, $_logBuffer)
EndFunc


; end
