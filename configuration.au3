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

; application components
#include "pan.au3" ; must be include first
#include "logger.au3"

;----------------------------------------------------------------------------
; globals

; configuration - preferences
Global $_cfgHostname = "localhost"
Global $_cfgFriendlyName = "My Computer"
Global $_cfgFriendlyInTitle = False
Global $_cfgEscapeCloses = False
Global $_cfgMinimizeOnClose = True
Global $_cfgHideWhenMinimized = False
Global $_cfgRefreshInterval = 5000
Global $_cfgRunningColor = 0x00FF00
Global $_cfgStoppedColor = 0xFF0000

;----------------------------------------------------------------------------
Func configurationReadConfig()
	Local $cd = @ScriptDir
	Local $s

	; if the -c configuration file option was specified
	If StringLen($_configurationFilePath) > 0 Then
	Else
		; otherwise use the default; will be created if it does not exist
		$_configurationFilePath = $cd & "\localhost.ini"
	EndIf

	loggerAppend("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" & @CRLF & _
			"Application configuration: " & $_configurationFilePath & @CRLF)

	$_cfgHostname = IniRead($_configurationFilePath, "preferences", "Hostname", $_cfgHostname);
	$_cfgFriendlyName = IniRead($_configurationFilePath, "preferences", "FriendlyName", $_cfgFriendlyName);
	$_cfgFriendlyInTitle = IniRead($_configurationFilePath, "preferences", "FriendlyInTitle", $_cfgFriendlyInTitle);
	$_cfgEscapeCloses = IniRead($_configurationFilePath, "preferences", "EscapeCloses", $_cfgEscapeCloses);
	$_cfgMinimizeOnClose = IniRead($_configurationFilePath, "preferences", "MinimizeOnClose", $_cfgMinimizeOnClose);
	$_cfgHideWhenMinimized = IniRead($_configurationFilePath, "preferences", "HideWhenMinimized", $_cfgHideWhenMinimized);
	$_cfgRefreshInterval = IniRead($_configurationFilePath, "preferences", "RefreshInterval", $_cfgRefreshInterval);
	$_cfgRunningColor = IniRead($_configurationFilePath, "preferences", "RunningColor", $_cfgRunningColor);
	$_cfgStoppedColor = IniRead($_configurationFilePath, "preferences", "StoppedColor", $_cfgStoppedColor);

	loggerAppend("    Hostname:  " & $_cfgHostname & @CRLF)
	loggerAppend("    Friendly Name:  " & $_cfgFriendlyName & @CRLF)
	loggerAppend("    Friendly In Title:  " & $_cfgFriendlyInTitle & @CRLF)
	loggerAppend("    Escape Closes:  " & $_cfgEscapeCloses & @CRLF)
	loggerAppend("    Minimize On Close:  " & $_cfgMinimizeOnClose & @CRLF)
	loggerAppend("    Hide When Minimized:  " & $_cfgHideWhenMinimized & @CRLF)
	loggerAppend("    Refresh Interval:  " & $_cfgRefreshInterval & " (milliseconds)" & @CRLF)
	loggerAppend("    Running Color:  " & $_cfgRunningColor & @CRLF)
	loggerAppend("    Stopped Color:  " & $_cfgStoppedColor & @CRLF)

	; normalize true/false values to make comparisons consistent
	$_cfgFriendlyInTitle = configurationTrueFalse($_cfgFriendlyInTitle)
	$_cfgEscapeCloses = configurationTrueFalse($_cfgEscapeCloses)
	$_cfgMinimizeOnClose = configurationTrueFalse($_cfgMinimizeOnClose)
	$_cfgHideWhenMinimized = configurationTrueFalse($_cfgHideWhenMinimized)

	If $_cfgFriendlyInTitle == True Then
		$_progTitle = $_progShort & ": " & $_cfgFriendlyName
	EndIf

	$_returnValue = $STAT_OK
EndFunc   ;==>configurationReadConfig

; private func used by configurationReadConfig
Func configurationTrueFalse($sense)
	If StringCompare($sense, "true", $STR_NOCASESENSE) == 0 Then
		$sense = True
	Else
		$sense = False
	EndIf
	Return $sense
EndFunc   ;==>configurationTrueFalse

; end
