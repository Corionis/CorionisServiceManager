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
Global $_loggerSaveButton
Global $_loggerClearButton

;----------------------------------------------------------------------------
Func LoggerInit()
	$_loggerEdit = GUICtrlCreateEdit($_logBuffer, 13, 31, $_cfgWidth - 29, $_cfgHeight - 118)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	$_loggerSaveButton = GUICtrlCreateButton("&Save", 21, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_loggerSaveButton, "loggerSave")
	GUICtrlSetTip($_loggerSaveButton, "Save the log to a file")

	$_loggerClearButton = GUICtrlCreateButton("&Clear", 91, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_loggerClearButton, "loggerClear")
	GUICtrlSetTip($_loggerClearButton, "Clear the log")

	LoggerUpdate()
EndFunc   ;==>LoggerInit

;----------------------------------------------------------------------------
Func LoggerAppend($msg)
	$_logBuffer &= $msg
	GUICtrlSetState($_loggerSaveButton, $GUI_ENABLE)
	GUICtrlSetState($_loggerClearButton, $GUI_ENABLE)
EndFunc   ;==>LoggerAppend

;----------------------------------------------------------------------------
Func loggerClear()
	$_logBuffer = ""
	LoggerUpdate()
	GUICtrlSetState($_loggerSaveButton, $GUI_DISABLE)
	GUICtrlSetState($_loggerClearButton, $GUI_DISABLE)
EndFunc   ;==>loggerClear

;----------------------------------------------------------------------------
Func loggerSave()
	Local $logFile = StringReplace($_configurationFilePath, ".ini", ".log")
	Local $a = StringSplit($logFile, "\")
	Local $nam = $a[$a[0]];
	Local $dir = StringReplace($logFile, $nam, "")
	$logFile = FileOpenDialog("Save Runtime Log", $dir, "Log files (*.log)|All files (*.*)", 0, $nam, $_mainWindow)
	If @error == 0 Then
		Local $fh = FileOpen($logFile, BitOR($FO_APPEND, $FO_CREATEPATH, $FO_ANSI))
		FileWrite($fh, $_logBuffer)
		FileClose($fh)
	EndIf
EndFunc   ;==>loggerSave

;----------------------------------------------------------------------------
Func LoggerUpdate()
	GUICtrlSetData($_loggerEdit, $_logBuffer)
EndFunc   ;==>LoggerUpdate


; end
