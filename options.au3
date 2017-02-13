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
	;-------;
	$obj = GUICtrlCreateInput($_cfgHostname, 237, 40, 250)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($obj, "optionsHostname")
	GUICtrlSetTip($obj, "CAUTION! Any hostname except localhost requires special Windows security configuration")

	$obj = GUICtrlCreateLabel("Friendly name of configuration: ", 21, 69)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	;-------;
	$obj = GUICtrlCreateInput($_cfgFriendlyName, 237, 66, 250)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($obj, "optionsFriendlyName")
	GUICtrlSetTip($obj, "A friendly name for this configuration")

	$obj = GUICtrlCreateCheckbox("Display the Friendly namw in the title", 237, 91, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($obj, "optionsFriendlyInTitle")
	GUICtrlSetTip($obj, "Display the Friendly name in the program title")

	$obj = GUICtrlCreateCheckbox("Start when you login to Windows", 237, 113, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($obj, "optionsStartAtLogin")
	GUICtrlSetTip($obj, "Start " & $_progTitle & " when you login")

;~ 	LoggerAppend("    Display Notifications:  " & $_cfgDisplayNotifications & @CRLF)
	$obj = GUICtrlCreateCheckbox("Display tray notifications", 237, 135, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($obj, "optionsDisplayNotifications")
	GUICtrlSetTip($obj, "Display tray notifications when selected services stop or start")


;~ 	LoggerAppend("    Write To Log File:  " & $_cfgWriteToLogFile & @CRLF)
;~ 	LoggerAppend("    Escape Closes:  " & $_cfgEscapeCloses & @CRLF)
;~ 	LoggerAppend("    Minimize On Close:  " & $_cfgMinimizeOnClose & @CRLF)
;~ 	LoggerAppend("    Hide When Minimized:  " & $_cfgHideWhenMinimized & @CRLF)
;~ 	LoggerAppend("    Refresh Interval:  " & $_cfgRefreshInterval & " (milliseconds)" & @CRLF)
;~ 	LoggerAppend("    Running Text Color:  " & $_cfgRunningTextColor & @CRLF)
;~ 	LoggerAppend("    Running Back Color:  " & $_cfgRunningBackColor & @CRLF)
;~ 	LoggerAppend("    Stopped Text Color:  " & $_cfgStoppedTextColor & @CRLF)
;~ 	LoggerAppend("    Stopped Back Color:  " & $_cfgStoppedBackColor & @CRLF)
;~ 	LoggerAppend("    Icon Index:  " & $_cfgIconIndex & @CRLF)



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

;----------------------------------------------------------------------------
Func optionsHostname()
EndFunc   ;==>optionsHostname

;----------------------------------------------------------------------------
Func optionsFriendlyName()
EndFunc   ;==>optionsFriendlyName

;----------------------------------------------------------------------------
Func optionsFriendlyInTitle()
EndFunc   ;==>optionsFriendlyInTitle

;----------------------------------------------------------------------------
Func optionsStartAtLogin()
EndFunc   ;==>optionsStartAtLogin

;----------------------------------------------------------------------------
Func optionsDisplayNotifications()
EndFunc   ;==>optionsDisplayNotifications

;----------------------------------------------------------------------------
Func optionsSave()
EndFunc   ;==>optionsSave

;----------------------------------------------------------------------------
Func optionsCancel()
EndFunc   ;==>optionsCancel




; end
