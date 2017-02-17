#include-once
#cs -------------------------------------------------------------------------

	Options tab

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

;----------------------------------------------------------------------------
; Includes
#include <ButtonConstants.au3>
#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <GuiScrollBars.au3>
#include <StructureConstants.au3>
#include <WindowsConstants.au3>

; application components
#include "pan.au3" ; must be include first

;----------------------------------------------------------------------------
; globals

;----------------------------------------------------------------------------
Func OptionsInit()
	Local $obj
	; cbox to field   29
	; field to field  26

	$obj = GUICtrlCreateGroup("", 13, 25, $_cfgWidth - 29, $_cfgHeight - 112)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	; LEFTOFF  See https://www.autoitscript.com/forum/topic/136504-scrolling-a-tab-on-a-gui-possible/
	;      and https://www.autoitscript.com/forum/topic/113723-scrollbars-made-easy-new-version-22-nov-14/

	$obj = GUICtrlCreateLabel("Hostname for this configuration: ", 21, 43)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$obj = GUICtrlCreateInput($_cfgHostname, 237, 40, 250)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsHostname")
	GUICtrlSetTip($obj, "CAUTION! Any hostname except localhost requires special Windows security configuration")

	$obj = GUICtrlCreateLabel("Friendly name of configuration: ", 21, 69)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$obj = GUICtrlCreateInput($_cfgFriendlyName, 237, 66, 250)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsFriendlyName")
	GUICtrlSetTip($obj, "A friendly name for this configuration")

	$obj = GUICtrlCreateCheckbox("Display the Friendly name in the title", 21, 91, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsFriendlyInTitle")
	GUICtrlSetTip($obj, "Display the Friendly name in the program title")

	$obj = GUICtrlCreateCheckbox("Escape key closes the window", 237, 91, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsEscapeCloses")
	GUICtrlSetTip($obj, "Pressing the Escape (ESC) key will close the window")

	$obj = GUICtrlCreateCheckbox("Start when you login to Windows", 21, 113, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsStartAtLogin")
	GUICtrlSetTip($obj, "Start this program when you login")

	$obj = GUICtrlCreateCheckbox("Minimize on close", 237, 113, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsMinimizeOnClose")
	GUICtrlSetTip($obj, "Minimize the windows on close instead of exiting")

	$obj = GUICtrlCreateCheckbox("Display tray notifications", 21, 135, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsDisplayNotifications")
	GUICtrlSetTip($obj, "Display tray notifications when selected services stop or start")

	$obj = GUICtrlCreateCheckbox("Hide When Minimized", 237, 135, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsHideWhenMinimized")
	GUICtrlSetTip($obj, "Hide the taskbar button when the window is minimized")

	$obj = GUICtrlCreateCheckbox("Write To Log File", 21, 157, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsWriteToLogFile")
	GUICtrlSetTip($obj, "Write runtime log entries to the .log file")

	$obj = GUICtrlCreateLabel("Running text color: ", 21, 183)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$obj = GUICtrlCreateInput($_cfgRunningTextColor, 126, 180, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsRunningTextColor")
	GUICtrlSetTip($obj, "Standard hex 6-character color code")

	$obj = GUICtrlCreateLabel("Background color: ", 237, 183)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$obj = GUICtrlCreateInput($_cfgRunningBackColor, 342, 180, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsRunningBackColor")
	GUICtrlSetTip($obj, "Standard hex 6-character color code")

	$obj = GUICtrlCreateLabel("Stopped text color: ", 21, 209)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$obj = GUICtrlCreateInput($_cfgStoppedBackColor, 126, 206, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsStoppedTextColor")
	GUICtrlSetTip($obj, "Standard hex 6-character color code")

	$obj = GUICtrlCreateLabel("Background color: ", 237, 209)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$obj = GUICtrlCreateInput($_cfgStoppedBackColor, 342, 206, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsStoppedBackColor")
	GUICtrlSetTip($obj, "Standard hex 6-character color code")

	$obj = GUICtrlCreateLabel("Refresh interval: ", 21, 235)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$obj = GUICtrlCreateInput($_cfgRefreshInterval, 126, 232, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsRefreshInterval")
	GUICtrlSetTip($obj, "The time between monitor updates in milliseconds")

	$obj = GUICtrlCreateLabel("Icon index: ", 237, 235)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$obj = GUICtrlCreateInput($_cfgIconIndex, 342, 232, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;~ 	GUICtrlSetOnEvent($obj, "optionsIconIndex")
	GUICtrlSetTip($obj, "The index number of the desired icon in this program")


	$obj = GUICtrlCreateButton("&Save", 21, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($obj, "optionsSave")
	GUICtrlSetTip($obj, "Save options to " & $_configurationFilePath)
	;
	$obj = GUICtrlCreateButton("&Cancel", 91, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($obj, "optionsCancel")
	GUICtrlSetTip($obj, "Cancel any changes")

EndFunc   ;==>OptionsInit

;~ ;----------------------------------------------------------------------------
;~ Func optionsHostname()
;~ EndFunc   ;==>optionsHostname

;~ ;----------------------------------------------------------------------------
;~ Func optionsFriendlyName()
;~ EndFunc   ;==>optionsFriendlyName

;~ ;----------------------------------------------------------------------------
;~ Func optionsFriendlyInTitle()
;~ EndFunc   ;==>optionsFriendlyInTitle

;~ ;----------------------------------------------------------------------------
;~ Func optionsEscapeCloses()
;~ EndFunc   ;==>optionsEscapeCloses

;~ ;----------------------------------------------------------------------------
;~ Func optionsStartAtLogin()
;~ EndFunc   ;==>optionsStartAtLogin

;~ ;----------------------------------------------------------------------------
;~ Func optionsMinimizeOnClose()
;~ EndFunc   ;==>optionsMinimizeOnClose

;~ ;----------------------------------------------------------------------------
;~ Func optionsDisplayNotifications()
;~ EndFunc   ;==>optionsDisplayNotifications

;~ ;----------------------------------------------------------------------------
;~ Func optionsHideWhenMinimized()
;~ EndFunc   ;==>optionsHideWhenMinimized

;~ ;----------------------------------------------------------------------------
;~ Func optionsWriteToLogFile()
;~ EndFunc   ;==>optionsWriteToLogFile

;----------------------------------------------------------------------------
Func optionsSave()
EndFunc   ;==>optionsSave

;----------------------------------------------------------------------------
Func optionsCancel()
EndFunc   ;==>optionsCancel




; end
