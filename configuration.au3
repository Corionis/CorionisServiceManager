#include-once
#cs -------------------------------------------------------------------------

	Configuration data and handling

	These data describe the site-specific parameters used by
	the Corionis Service Manager program.

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

;----------------------------------------------------------------------------
; Includes
#include <WinAPI.au3>

; application components
#include "pan.au3" ; must be include first
#include "logger.au3"

;----------------------------------------------------------------------------
; globals

; configuration - preferences
Global $_cfgHostname = "localhost"
Global $_cfgFriendlyName = "My Computer"
Global $_cfgFriendlyInTitle = False
Global $_cfgStartAtLogin = False
Global $_cfgDisplayNotifications = True
Global $_cfgWriteToLogFile = False
Global $_cfgEscapeCloses = False
Global $_cfgMinimizeOnClose = False
Global $_cfgHideWhenMinimized = False
Global $_cfgRefreshInterval = 5000
Global $_cfgRunningTextColor = 0x000000
Global $_cfgRunningBackColor = 0x8eff9e
Global $_cfgStoppedTextColor = 0x0000
Global $_cfgStoppedBackColor = 0xff9b8e
Global $_cfgIconIndex = -1

;----------------------------------------------------------------------------
Func ConfigurationReadConfig()
	Local $cd = @ScriptDir
	Local $newCfg = False
	Local $s

	; if the -c configuration file option was specified
	If StringLen($_configurationFilePath) > 0 Then
	Else
		; otherwise use the default; will be created if it does not exist
		$_configurationFilePath = $cd & "\localhost.ini"
	EndIf

	If FileExists($_configurationFilePath) == 0 Then
		$newCfg = True
		Local $f = FileOpen($_configurationFilePath, $FO_CREATEPATH + $FO_OVERWRITE)
		FileWriteLine($f, ";")
		FileWriteLine($f, "; Parameters for the Corionis Service Manager")
		FileWriteLine($f, ";")
		FileWriteLine($f, "; WARNING:")
		FileWriteLine($f, "; This file is maintained automatically by the program.")
		FileWriteLine($f, "; Any changes made WILL BE OVERWRITTEN.")
		FileWriteLine($f, ";")
		FileWriteLine($f, "; To specify a configuration file use:  -c [path][filename]")
		FileWriteLine($f, "; If [path] is not specified the directory containing the program is assumed.")
		FileWriteLine($f, ";")
		FileWriteLine($f, "; Default if -c is not specified: localhost.ini")
		FileWriteLine($f, ";")
		FileWriteLine($f, "; This file will be created automatically with defaults if it does not exist.")
		FileWriteLine($f, ";")
		FileWriteLine($f, "")
		FileWriteLine($f, "[preferences]")
		FileWriteLine($f, "")
		FileWriteLine($f, "[running]")
		FileWriteLine($f, "")
		FileWriteLine($f, "[services]")
		FileWriteLine($f, "")
	EndIf

	LoggerAppend("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" & @CRLF & _
			"Application configuration: " & $_configurationFilePath & @CRLF)

	$_cfgHostname = StringStripWS(IniRead($_configurationFilePath, "preferences", "Hostname", $_cfgHostname), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgFriendlyName = StringStripWS(IniRead($_configurationFilePath, "preferences", "FriendlyName", $_cfgFriendlyName), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgFriendlyInTitle = StringStripWS(IniRead($_configurationFilePath, "preferences", "FriendlyInTitle", $_cfgFriendlyInTitle), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgStartAtLogin = StringStripWS(IniRead($_configurationFilePath, "preferences", "StartAtLogin", $_cfgStartAtLogin), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgDisplayNotifications = StringStripWS(IniRead($_configurationFilePath, "preferences", "DisplayNotifications", $_cfgDisplayNotifications), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgWriteToLogFile = StringStripWS(IniRead($_configurationFilePath, "preferences", "WriteToLogFile", $_cfgWriteToLogFile), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgEscapeCloses = StringStripWS(IniRead($_configurationFilePath, "preferences", "EscapeCloses", $_cfgEscapeCloses), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgMinimizeOnClose = StringStripWS(IniRead($_configurationFilePath, "preferences", "MinimizeOnClose", $_cfgMinimizeOnClose), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgHideWhenMinimized = StringStripWS(IniRead($_configurationFilePath, "preferences", "HideWhenMinimized", $_cfgHideWhenMinimized), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgRefreshInterval = StringStripWS(IniRead($_configurationFilePath, "preferences", "RefreshInterval", $_cfgRefreshInterval), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgRunningTextColor = StringStripWS(IniRead($_configurationFilePath, "preferences", "RunningTextColor", $_cfgRunningTextColor), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgRunningBackColor = StringStripWS(IniRead($_configurationFilePath, "preferences", "RunningBackColor", $_cfgRunningBackColor), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgStoppedTextColor = StringStripWS(IniRead($_configurationFilePath, "preferences", "StoppedTextColor", $_cfgStoppedTextColor), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgStoppedBackColor = StringStripWS(IniRead($_configurationFilePath, "preferences", "StoppedBackColor", $_cfgStoppedBackColor), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgIconIndex = StringStripWS(IniRead($_configurationFilePath, "preferences", "IconIndex", $_cfgIconIndex), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;

	LoggerAppend("    Hostname:  " & $_cfgHostname & @CRLF)
	LoggerAppend("    Friendly Name:  " & $_cfgFriendlyName & @CRLF)
	LoggerAppend("    Friendly In Title:  " & $_cfgFriendlyInTitle & @CRLF)
	LoggerAppend("    Start At Login:  " & $_cfgStartAtLogin & @CRLF)
	LoggerAppend("    Display Notifications:  " & $_cfgDisplayNotifications & @CRLF)
	LoggerAppend("    Write To Log File:  " & $_cfgWriteToLogFile & @CRLF)
	LoggerAppend("    Escape Closes:  " & $_cfgEscapeCloses & @CRLF)
	LoggerAppend("    Minimize On Close:  " & $_cfgMinimizeOnClose & @CRLF)
	LoggerAppend("    Hide When Minimized:  " & $_cfgHideWhenMinimized & @CRLF)
	LoggerAppend("    Refresh Interval:  " & $_cfgRefreshInterval & " (milliseconds)" & @CRLF)
	LoggerAppend("    Running Text Color:  " & $_cfgRunningTextColor & @CRLF)
	LoggerAppend("    Running Back Color:  " & $_cfgRunningBackColor & @CRLF)
	LoggerAppend("    Stopped Text Color:  " & $_cfgStoppedTextColor & @CRLF)
	LoggerAppend("    Stopped Back Color:  " & $_cfgStoppedBackColor & @CRLF)
	LoggerAppend("    Icon Index:  " & $_cfgIconIndex & @CRLF)

	; normalize true/false values to make comparisons consistent
	$_cfgFriendlyInTitle = configurationTrueFalse($_cfgFriendlyInTitle)
	$_cfgStartAtLogin = configurationTrueFalse($_cfgStartAtLogin)
	$_cfgDisplayNotifications = configurationTrueFalse($_cfgDisplayNotifications)
	$_cfgWriteToLogFile = configurationTrueFalse($_cfgWriteToLogFile)
	$_cfgEscapeCloses = configurationTrueFalse($_cfgEscapeCloses)
	$_cfgMinimizeOnClose = configurationTrueFalse($_cfgMinimizeOnClose)
	$_cfgHideWhenMinimized = configurationTrueFalse($_cfgHideWhenMinimized)

	; normalize to a negative numeric index value
	If $_cfgIconIndex > 0 Then
		$_cfgIconIndex = $_cfgIconIndex * -1
	Else
		$_cfgIconIndex = $_cfgIconIndex * 1
	EndIf

	If $_cfgFriendlyInTitle == True Then
		$_progTitle = $_progShort & ": " & $_cfgFriendlyName
	EndIf

	$_cfgLeft = StringStripWS(IniRead($_configurationFilePath, "running", "Left", $_cfgLeft), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgTop = StringStripWS(IniRead($_configurationFilePath, "running", "Top", $_cfgTop), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgWidth = StringStripWS(IniRead($_configurationFilePath, "running", "Width", $_cfgWidth), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgHeight = StringStripWS(IniRead($_configurationFilePath, "running", "Height", $_cfgHeight), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;
	$_cfgMonitoring = StringStripWS(IniRead($_configurationFilePath, "running", "Monitoring", $_cfgMonitoring), $STR_STRIPLEADING + $STR_STRIPTRAILING) ;

	; ########### Read services here ###########

	If $newCfg == True Then
		ConfigurationWritePreferences()
		ConfigurationWriteRunning($newCfg)
	EndIf

	$_returnValue = $STAT_OK
EndFunc   ;==>ConfigurationReadConfig

;----------------------------------------------------------------------------
; private func used by ConfigurationReadConfig
Func configurationTrueFalse($sense)
	If StringCompare($sense, "true", $STR_NOCASESENSE) == 0 Then
		$sense = True
	Else
		$sense = False
	EndIf
	Return $sense
EndFunc   ;==>configurationTrueFalse

;----------------------------------------------------------------------------
Func ConfigurationWritePreferences()
	IniWrite($_configurationFilePath, "preferences", "Hostname", $_cfgHostname)
	IniWrite($_configurationFilePath, "preferences", "FriendlyName", $_cfgFriendlyName)
	IniWrite($_configurationFilePath, "preferences", "FriendlyInTitle", $_cfgFriendlyInTitle)
	IniWrite($_configurationFilePath, "preferences", "StartAtLogin", $_cfgStartAtLogin)
	IniWrite($_configurationFilePath, "preferences", "DisplayNotifications", $_cfgDisplayNotifications)
	IniWrite($_configurationFilePath, "preferences", "WriteToLogFile", $_cfgWriteToLogFile)
	IniWrite($_configurationFilePath, "preferences", "EscapeCloses", $_cfgEscapeCloses)
	IniWrite($_configurationFilePath, "preferences", "MinimizeOnClose", $_cfgMinimizeOnClose)
	IniWrite($_configurationFilePath, "preferences", "HideWhenMinimized", $_cfgHideWhenMinimized)
	IniWrite($_configurationFilePath, "preferences", "RefreshInterval", $_cfgRefreshInterval)
	IniWrite($_configurationFilePath, "preferences", "RunningTextColor", "0x" & Hex($_cfgRunningTextColor, 6))
	IniWrite($_configurationFilePath, "preferences", "RunningBackColor", "0x" & Hex($_cfgRunningBackColor, 6))
	IniWrite($_configurationFilePath, "preferences", "StoppedTextColor", "0x" & Hex($_cfgStoppedTextColor, 6))
	IniWrite($_configurationFilePath, "preferences", "StoppedBackColor", "0x" & Hex($_cfgStoppedBackColor, 6))
	IniWrite($_configurationFilePath, "preferences", "IconIndex", $_cfgIconIndex)
EndFunc   ;==>ConfigurationWritePreferences

;----------------------------------------------------------------------------
Func ConfigurationWriteRunning($newCfg)
	Local $info = WinGetPos($_mainWindow)
	Local $cSize = WinGetClientSize($_mainWindow)
	If $newCfg == True Then
		$info[0] = $_cfgLeft
		$info[1] = $_cfgTop
		$info[2] = $_cfgWidth
		$info[3] = $_cfgHeight
	Else
		$info[2] = $info[2] - (_WinAPI_GetSystemMetrics(32) * 2) + 2			; 5   45   7   32
		$info[3] = $info[3] - (_WinAPI_GetSystemMetrics(33) * 2) + 2			; 6   46   8   33
	EndIf
	IniWrite($_configurationFilePath, "running", "Left", $info[0])
	IniWrite($_configurationFilePath, "running", "Top", $info[1])
	IniWrite($_configurationFilePath, "running", "Width", $info[2])
	IniWrite($_configurationFilePath, "running", "Height", $info[3])
	IniWrite($_configurationFilePath, "running", "Monitoring", $_cfgMonitoring)
EndFunc   ;==>ConfigurationWriteRunning


; end
