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
#include "pan.au3" ; must be include first

;----------------------------------------------------------------------------
; globals
Global $_loggerEdit

;----------------------------------------------------------------------------
Func LoggerInit()
	$_loggerEdit = GUICtrlCreateEdit($_logBuffer, 13, 31, $_cfgWidth - 29, $_cfgHeight - 118)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	Local $SaveButton = GUICtrlCreateButton("&Save", 21, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($SaveButton, "loggerSave")
	GUICtrlSetTip($SaveButton, "Save the log to a file")

	Local $ClearButton = GUICtrlCreateButton("&Clear", 91, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($ClearButton, "loggerClear")
	GUICtrlSetTip($ClearButton, "Clear the log")

	LoggerUpdate()
EndFunc   ;==>LoggerInit

;----------------------------------------------------------------------------
Func LoggerAppend($msg)
	$_logBuffer &= $msg
EndFunc   ;==>LoggerAppend

;----------------------------------------------------------------------------
Func loggerClear()
	$_logBuffer = ""
	LoggerUpdate()
EndFunc   ;==>loggerClear

;----------------------------------------------------------------------------
Func loggerSave()
	MsgBox(64, "Save GUI Log", "You requested to Save the log. Sorry, not implemented yet.", $_logTab)
EndFunc   ;==>loggerSave

;----------------------------------------------------------------------------
Func LoggerUpdate()
	GUICtrlSetData($_loggerEdit, $_logBuffer)
EndFunc   ;==>LoggerUpdate


; end
