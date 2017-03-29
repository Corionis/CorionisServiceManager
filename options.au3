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
#include "globals.au3" ; must be include first

;----------------------------------------------------------------------------
; globals
Global $_cfgHostnameCtrl
Global $_cfgFriendlyNameCtrl
Global $_cfgFriendlyInTitleCtrl
Global $_cfgEscapeClosesCtrl
Global $_cfgStartAtLoginCtrl
Global $_cfgStartMinimizedCtrl
Global $_cfgMinimizeOnCloseCtrl
Global $_cfgDisplayNotificationsCtrl
Global $_cfgHideWhenMinimizedCtrl
Global $_cfgWriteToLogFileCtrl
Global $_cfgRunningTextColorCtrl
Global $_cfgRunningBackColorCtrl
Global $_cfgStoppedTextColorCtrl
Global $_cfgStoppedBackColorCtrl
Global $_cfgRefreshIntervalCtrl
Global $_cfgIconIndexCtrl

Global $_optionsSaveCtrl
Global $_optionsCancelCtrl

;----------------------------------------------------------------------------
Func OptionsInit()
	Local $obj

	$obj = GUICtrlCreateGroup("", 13, 25, $_cfgWidth - 29, $_cfgHeight - 112)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	$obj = GUICtrlCreateLabel("Hostname for this configuration: ", 21, 43)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$_cfgHostnameCtrl = GUICtrlCreateInput($_cfgHostname, 237, 40, 250)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgHostnameCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgHostnameCtrl, "CAUTION! Any hostname except localhost requires special Windows security configuration")

	$obj = GUICtrlCreateLabel("Friendly name of configuration: ", 21, 69)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$_cfgFriendlyNameCtrl = GUICtrlCreateInput($_cfgFriendlyName, 237, 66, 250)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgFriendlyNameCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgFriendlyNameCtrl, "A friendly name for this configuration")

	$_cfgFriendlyInTitleCtrl = GUICtrlCreateCheckbox("Display the Friendly name in the title", 21, 91, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgFriendlyInTitleCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgFriendlyInTitleCtrl, "Display the Friendly name in the program title")

	$_cfgEscapeClosesCtrl = GUICtrlCreateCheckbox("Escape key closes the window", 237, 91, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgEscapeClosesCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgEscapeClosesCtrl, "Pressing the Escape (ESC) key will close the window")

	$_cfgDisplayNotificationsCtrl = GUICtrlCreateCheckbox("Display notifications", 21, 113, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgDisplayNotificationsCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgDisplayNotificationsCtrl, "Display notifications when selected services stop or start")

	$_cfgMinimizeOnCloseCtrl = GUICtrlCreateCheckbox("Minimize on close", 237, 113, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgMinimizeOnCloseCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgMinimizeOnCloseCtrl, "Minimize the windows on close instead of exiting")

	$_cfgWriteToLogFileCtrl = GUICtrlCreateCheckbox("Write To Log File", 21, 135, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgWriteToLogFileCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgWriteToLogFileCtrl, "Write runtime log entries to the .log file")

	$_cfgHideWhenMinimizedCtrl = GUICtrlCreateCheckbox("Hide When Minimized", 237, 135, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgHideWhenMinimizedCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgHideWhenMinimizedCtrl, "Hide the taskbar button when the window is minimized")

	$_cfgStartAtLoginCtrl = GUICtrlCreateCheckbox("Start when you login to Windows", 21, 157, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgStartAtLoginCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgStartAtLoginCtrl, "Start this program when you login")

	$_cfgStartMinimizedCtrl = GUICtrlCreateCheckbox("Start minimized", 237, 157, Default, Default)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgStartMinimizedCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgStartMinimizedCtrl, "Minimized the window when the program is started")

	$obj = GUICtrlCreateLabel("Running text color: ", 21, 183)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$_cfgRunningTextColorCtrl = GUICtrlCreateInput($_cfgRunningTextColor, 126, 180, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgRunningTextColorCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgRunningTextColorCtrl, "Standard hex 6-character color code")

	$obj = GUICtrlCreateLabel("Background color: ", 237, 183)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$_cfgRunningBackColorCtrl = GUICtrlCreateInput($_cfgRunningBackColor, 342, 180, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgRunningBackColorCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgRunningBackColorCtrl, "Standard hex 6-character color code")

	$obj = GUICtrlCreateLabel("Stopped text color: ", 21, 209)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$_cfgStoppedTextColorCtrl = GUICtrlCreateInput($_cfgStoppedBackColor, 126, 206, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgStoppedTextColorCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgStoppedTextColorCtrl, "Standard hex 6-character color code")

	$obj = GUICtrlCreateLabel("Background color: ", 237, 209)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$_cfgStoppedBackColorCtrl = GUICtrlCreateInput($_cfgStoppedBackColor, 342, 206, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgStoppedBackColorCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgStoppedBackColorCtrl, "Standard hex 6-character color code")

	$obj = GUICtrlCreateLabel("Refresh interval: ", 21, 235)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$_cfgRefreshIntervalCtrl = GUICtrlCreateInput($_cfgRefreshInterval, 126, 232, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgRefreshIntervalCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgRefreshIntervalCtrl, "The time between monitor updates in milliseconds")

	$obj = GUICtrlCreateLabel("Icon index: ", 237, 235)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	; +
	$_cfgIconIndexCtrl = GUICtrlCreateInput($_cfgIconIndex, 342, 232, 70)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_cfgIconIndexCtrl, "optionsEvent")
	GUICtrlSetTip($_cfgIconIndexCtrl, "The index number of the desired icon in this program")


	$_optionsSaveCtrl = GUICtrlCreateButton("&Save", 21, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_optionsSaveCtrl, "optionsSave")
	GUICtrlSetTip($_optionsSaveCtrl, "Save options to " & $_configurationFilePath)
	;
	$_optionsCancelCtrl = GUICtrlCreateButton("&Cancel", 91, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($_optionsCancelCtrl, "optionsCancel")
	GUICtrlSetTip($_optionsCancelCtrl, "Cancel any changes")

	optionsCancel() ; set the data in the controls and disable the save and cancel buttons
EndFunc   ;==>OptionsInit

;----------------------------------------------------------------------------
Func optionsEvent()
	GUICtrlSetState($_optionsSaveCtrl, $GUI_ENABLE)
	GUICtrlSetState($_optionsCancelCtrl, $GUI_ENABLE)
EndFunc   ;==>optionsEvent

;----------------------------------------------------------------------------
Func optionsSave()
	; get and save the options
	optionsGetCtrls()
	ConfigurationWritePreferences()

	; handle any shortcut
	Local $a = StringSplit($_configurationFilePath, "\")
	Local $nam = $a[$a[0]];
	$nam = StringReplace($nam, ".ini", "")
	Local $dir = @StartupDir
	Local $shortcut = $dir & "\CSM+" & $nam & ".lnk"
	If $_cfgStartAtLogin == True Then
		Local $state
		If $_cfgStartMinimized == True Then
			$state = @SW_SHOWMINIMIZED
		Else
			$state = @SW_SHOWNORMAL
		EndIf
		If FileCreateShortcut("""" & @AutoItExe & """", $shortcut, @ScriptDir, "-c """ & $_configurationFilePath & """", _
				"Corionis Service Manager for " & $nam, @AutoItExe, Default, $_cfgIconIndex, $state) <> 1 Then
			MsgBox($MB_OK + $MB_ICONERROR, "Creae Shortcut Error", "Error " & @error & " occurred. Shortcut " & $shortcut & " could not be created.")
		Else
			GUICtrlSetState($_optionsSaveCtrl, $GUI_DISABLE)
			GUICtrlSetState($_optionsCancelCtrl, $GUI_DISABLE)
		EndIf
	Else
		If FileExists($shortcut) Then
			FileDelete($shortcut)
		EndIf
		GUICtrlSetState($_optionsSaveCtrl, $GUI_DISABLE)
		GUICtrlSetState($_optionsCancelCtrl, $GUI_DISABLE)
	EndIf
EndFunc   ;==>optionsSave

;----------------------------------------------------------------------------
Func optionsCancel()
	optionsSetCtrls()
	GUICtrlSetState($_optionsSaveCtrl, $GUI_DISABLE)
	GUICtrlSetState($_optionsCancelCtrl, $GUI_DISABLE)
EndFunc   ;==>optionsCancel

;----------------------------------------------------------------------------
Func optionsIsChecked($id)
	Return BitAND(GUICtrlRead($id), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>optionsIsChecked

;----------------------------------------------------------------------------
Func optionsGetCtrls()
	$_cfgHostname = GUICtrlRead($_cfgHostnameCtrl)
	$_cfgFriendlyName = GUICtrlRead($_cfgFriendlyNameCtrl)
	$_cfgFriendlyInTitle = optionsIsChecked($_cfgFriendlyInTitleCtrl)
	$_cfgEscapeCloses = optionsIsChecked($_cfgEscapeClosesCtrl)
	$_cfgStartAtLogin = optionsIsChecked($_cfgStartAtLoginCtrl)
	$_cfgStartMinimized = optionsIsChecked($_cfgStartMinimizedCtrl)
	$_cfgMinimizeOnClose = optionsIsChecked($_cfgMinimizeOnCloseCtrl)
	$_cfgDisplayNotifications = optionsIsChecked($_cfgDisplayNotificationsCtrl)
	$_cfgHideWhenMinimized = optionsIsChecked($_cfgHideWhenMinimizedCtrl)
	$_cfgWriteToLogFile = optionsIsChecked($_cfgWriteToLogFileCtrl)
	$_cfgRunningTextColor = GUICtrlRead($_cfgRunningTextColorCtrl)
	$_cfgRunningBackColor = GUICtrlRead($_cfgRunningBackColorCtrl)
	$_cfgStoppedTextColor = GUICtrlRead($_cfgStoppedTextColorCtrl)
	$_cfgStoppedBackColor = GUICtrlRead($_cfgStoppedBackColorCtrl)
	$_cfgRefreshInterval = GUICtrlRead($_cfgRefreshIntervalCtrl)
	$_cfgIconIndex = GUICtrlRead($_cfgIconIndexCtrl)

	If $_cfgFriendlyInTitle == True Then
		$_progTitle = $_cfgFriendlyName & " - " & $_progShort
		WinSetTitle($_mainWindow, "", $_progTitle)
		TraySetToolTip($_progTitle)
	Else
		$_progTitle = $_progName & $_build
		WinSetTitle($_mainWindow, "", $_progTitle)
		TraySetToolTip($_progTitle)
	EndIf
	If $_cfgEscapeCloses == True Then
		Opt("GUICloseOnESC", 1)
	Else
		Opt("GUICloseOnESC", 0)
	EndIf
	GUISetIcon(@ScriptFullPath, $_cfgIconIndex, $_mainWindow)
	TraySetIcon(@ScriptFullPath, $_cfgIconIndex)
EndFunc   ;==>optionsGetCtrls

;----------------------------------------------------------------------------
Func optionsGuiCheck($sense)
	If $sense == True Then
		Return $GUI_CHECKED
	Else
		Return $GUI_UNCHECKED
	EndIf
EndFunc   ;==>optionsGuiCheck

;----------------------------------------------------------------------------
Func optionsSetCtrls()
	GUICtrlSetData($_cfgHostnameCtrl, $_cfgHostname)
	GUICtrlSetData($_cfgFriendlyNameCtrl, $_cfgFriendlyName)
	GUICtrlSetState($_cfgFriendlyInTitleCtrl, optionsGuiCheck($_cfgFriendlyInTitle))
	GUICtrlSetState($_cfgEscapeClosesCtrl, optionsGuiCheck($_cfgEscapeCloses))
	GUICtrlSetState($_cfgStartAtLoginCtrl, optionsGuiCheck($_cfgStartAtLogin))
	GUICtrlSetState($_cfgStartMinimizedCtrl, optionsGuiCheck($_cfgStartMinimized))
	GUICtrlSetState($_cfgMinimizeOnCloseCtrl, optionsGuiCheck($_cfgMinimizeOnClose))
	GUICtrlSetState($_cfgDisplayNotificationsCtrl, optionsGuiCheck($_cfgDisplayNotifications))
	GUICtrlSetState($_cfgHideWhenMinimizedCtrl, optionsGuiCheck($_cfgHideWhenMinimized))
	GUICtrlSetState($_cfgWriteToLogFileCtrl, optionsGuiCheck($_cfgWriteToLogFile))
	GUICtrlSetData($_cfgRunningTextColorCtrl, $_cfgRunningTextColor)
	GUICtrlSetData($_cfgRunningBackColorCtrl, $_cfgRunningBackColor)
	GUICtrlSetData($_cfgStoppedTextColorCtrl, $_cfgStoppedTextColor)
	GUICtrlSetData($_cfgStoppedBackColorCtrl, $_cfgStoppedBackColor)
	GUICtrlSetData($_cfgRefreshIntervalCtrl, $_cfgRefreshInterval)
	GUICtrlSetData($_cfgIconIndexCtrl, $_cfgIconIndex)
EndFunc   ;==>optionsSetCtrls


; end
