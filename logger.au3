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
	$_loggerEdit = GUICtrlCreateEdit($_logBuffer, 13, 31, $_cfgWidth - 47,  $_cfgHeight - 195)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)

;~ 	Local $ClearButton = GUICtrlCreateButton("Clear", 466, 342, 50, 25)
;~ 	GUICtrlSetOnEvent($ClearButton, "loggerClear")
;~ 	GUICtrlSetTip($ClearButton, "Clear the log")
;~ 	Local $SaveButton = GUICtrlCreateButton("Save", 526, 342, 50, 25)
;~ 	GUICtrlSetOnEvent($SaveButton, "loggerSave")
;~ 	GUICtrlSetTip($SaveButton, "Save the log to a file")
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
