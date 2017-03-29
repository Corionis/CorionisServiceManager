#include-once
#cs -------------------------------------------------------------------------

	Windows Services data and handling

	There are functions here that are not used by the Corionis Service Manager
	but are left fo possibly changes later.

	Thank You to "GEOSoft" on the AutoIt forums who wrote the original.

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

;----------------------------------------------------------------------------
; Includes
#include <Array.au3>
#include <AutoItConstants.au3>
#include <StringConstants.au3>
#include <SecurityConstants.au3>

; application components
#include "globals.au3" ; must be include first

; functions
#include "logger.au3"

;----------------------------------------------------------------------------
; globals
;
; Search: "MSDN Service Control Manager" and "MSDN ControlService" for more details.

; status
Global $_servicesMsg = "not loaded"
Global $_servicesStatus = 1

;===============================================================================
; Description:   Creates a service on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to create
;                $sDisplayName - display name of the service
;                $sBinaryPath - fully qualified path to the service binary file
;                               The path can also include arguments for an auto-start service
;                $sServiceUser - [optional] default is LocalSystem
;                                name of the account under which the service should run
;                $sPassword - [optional] default is empty
;                             password to the account name specified by $sServiceUser
;                             Specify an empty string if the account has no password or if the service
;                             runs in the LocalService, NetworkService, or LocalSystem account
;                 $nServiceType - [optional] default is $SERVICE_WIN32_OWN_PROCESS
;                 $nStartType - [optional] default is $SERVICE_AUTO_START
;                 $nErrorType - [optional] default is $SERVICE_ERROR_NORMAL
;                 $nDesiredAccess - [optional] default is $SERVICE_ALL_ACCESS
;                 $sLoadOrderGroup - [optional] default is empty
;                                    names the load ordering group of which this service is a member
; Requirements:  Administrative rights on the computer
; Return Values: On Success - 1
;                On Failure - 0 and @error is set to extended Windows error code
; Note:          Dependencies cannot be specified using this function
;                Refer to the CreateService page on MSDN for more information
;===============================================================================
Func servicesCreateService($sComputerName, _
		$sServiceName, _
		$sDisplayName, _
		$sBinaryPath, _
		$sServiceUser = "LocalSystem", _
		$sPassword = "", _
		$nServiceType = 0x00000010, _
		$nStartType = 0x00000002, _
		$nErrorType = 0x00000001, _
		$nDesiredAccess = 0x000f01ff, _
		$sLoadOrderGroup = "")
	Local $hAdvapi32
	Local $hKernel32
	Local $arRet
	Local $hSC
	Local $lError = -1

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$hKernel32 = DllOpen("kernel32.dll")
	If $hKernel32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", _
			"str", $sComputerName, _
			"str", "ServicesActive", _
			"long", $SC_MANAGER_ALL_ACCESS)
	If $arRet[0] = 0 Then
		$arRet = DllCall($hKernel32, "long", "GetLastError")
		$lError = $arRet[0]
	Else
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", _
				"long", $hSC, _
				"str", $sServiceName, _
				"long", $SERVICE_INTERROGATE)
		If $arRet[0] = 0 Then
			$arRet = DllCall($hAdvapi32, "long", "CreateService", _
					"long", $hSC, _
					"str", $sServiceName, _
					"str", $sDisplayName, _
					"long", $nDesiredAccess, _
					"long", $nServiceType, _
					"long", $nStartType, _
					"long", $nErrorType, _
					"str", $sBinaryPath, _
					"str", $sLoadOrderGroup, _
					"ptr", 0, _
					"str", "", _
					"str", $sServiceUser, _
					"str", $sPassword)
			If $arRet[0] = 0 Then
				$arRet = DllCall($hKernel32, "long", "GetLastError")
				$lError = $arRet[0]
			Else
				DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $arRet[0])
			EndIf
		Else
			DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $arRet[0])
		EndIf
		DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hSC)
	EndIf
	DllClose($hAdvapi32)
	DllClose($hKernel32)
	If $lError <> -1 Then
		SetError($lError)
		Return 0
	EndIf
	Return 1
EndFunc   ;==>servicesCreateService

;===============================================================================
; Description:   Deletes a service on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to delete
; Requirements:  Administrative rights on the computer
; Return Values: On Success - 1
;                On Failure - 0 and @error is set to extended Windows error code
;===============================================================================
Func servicesDeleteService($sComputerName, $sServiceName)
	Local $hAdvapi32
	Local $hKernel32
	Local $arRet
	Local $hSC
	Local $hService
	Local $lError = -1

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$hKernel32 = DllOpen("kernel32.dll")
	If $hKernel32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", _
			"str", $sComputerName, _
			"str", "ServicesActive", _
			"long", $SC_MANAGER_ALL_ACCESS)
	If $arRet[0] = 0 Then
		$arRet = DllCall($hKernel32, "long", "GetLastError")
		$lError = $arRet[0]
	Else
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", _
				"long", $hSC, _
				"str", $sServiceName, _
				"long", $SERVICE_ALL_ACCESS)
		If $arRet[0] = 0 Then
			$arRet = DllCall($hKernel32, "long", "GetLastError")
			$lError = $arRet[0]
		Else
			$hService = $arRet[0]
			$arRet = DllCall($hAdvapi32, "int", "DeleteService", _
					"long", $hService)
			If $arRet[0] = 0 Then
				$arRet = DllCall($hKernel32, "long", "GetLastError")
				$lError = $arRet[0]
			EndIf
			DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hService)
		EndIf
		DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hSC)
	EndIf
	DllClose($hAdvapi32)
	DllClose($hKernel32)
	If $lError <> -1 Then
		SetError($lError)
		Return 0
	EndIf
	Return 1
EndFunc   ;==>servicesDeleteService

; #FUNCTION# ====================================================================================================================
; Name ..........: servicesGetStartTypeString
; Description ...: Translate service start type code and return a descriptive string
; Syntax ........: servicesGetStartTypeString($type)
; Parameters ....: $type - Service type
; ===============================================================================================================================
Func servicesGetStartTypeString($type)
	Select
		Case $type == $SERVICE_BOOT_START
			Return "Boot"
		Case $type == $SERVICE_SYSTEM_START
			Return "System"
		Case $type == $SERVICE_AUTO_START
			Return "Automatic"
		Case $type == $SERVICE_DEMAND_START
			Return "Manual"
		Case $type == $SERVICE_DISABLED
			Return "Disabled"
	EndSelect
	Return "unknown"
EndFunc   ;==>servicesGetStartTypeString

;===============================================================================
; Description:   Checks if a service is running on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to check
; Requirements:  None
; Return Values: On Success - 1
;                On Failure - 0
; Note:          This function relies on the fact that only a running service responds
;                to a SERVICE_CONTROL_INTERROGATE control code. Check the ControlService
;                page on MSDN for limitations with using this method.
;===============================================================================
Func servicesIsRunning($sComputerName, $sServiceName)
	Local $hAdvapi32
	Local $arRet
	Local $hSC
	Local $hService
	Local $bRunning = 0

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", _
			"str", $sComputerName, _
			"str", "ServicesActive", _
			"long", $SC_MANAGER_CONNECT)
	If $arRet[0] <> 0 Then
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", _
				"long", $hSC, _
				"str", $sServiceName, _
				"long", $SERVICE_INTERROGATE)
		If $arRet[0] <> 0 Then
			$hService = $arRet[0]
			$arRet = DllCall($hAdvapi32, "int", "ControlService", _
					"long", $hService, _
					"long", $SERVICE_CONTROL_INTERROGATE, _
					"str", "")
			$bRunning = $arRet[0]
			DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hService)
		EndIf
		DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hSC)
	EndIf
	DllClose($hAdvapi32)
	Return $bRunning
EndFunc   ;==>servicesIsRunning

; #FUNCTION# ====================================================================================================================
; Name ..........: servicesReadAll
; Description ...: Read Windows Services
; Syntax ........: servicesReadAll()
; Parameters ....: None
; Return values .: None
; Remarks .......: Populates global $_servicesArray[]
; ===============================================================================================================================
Func servicesReadAll()
	Dim $ar, $i, $id, $l, $n, $s, $t, $sr, $sRead
	$_panErrorValue = 0
	$_servicesCount = 0

	; query and read list of Windows services
	Local $iPid = Run(@ComSpec & ' /c ' & 'sc query type= service state= all', '', @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
	While 1
		$sRead &= StdoutRead($iPid)
		If @error Then ExitLoop
	WEnd

	; parse the output
	$s = ""
	$ar = StringSplit($sRead, @CRLF, $STR_ENTIRESPLIT)
	For $i = 1 To $ar[0]
		$l = StringStripWS($ar[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		If StringLen($l) > 0 Then
			;MsgBox(64, "A line", $l)
			$sr = StringSplit($l, ":")
			If $sr[0] > 1 Then
				$t = StringStripWS($sr[1], $STR_STRIPLEADING + $STR_STRIPTRAILING)
				Select
					Case $t == "SERVICE_NAME"
						$id = StringStripWS($sr[2], $STR_STRIPLEADING + $STR_STRIPTRAILING)
					Case $t == "DISPLAY_NAME"
						$n = StringStripWS($sr[2], $STR_STRIPLEADING + $STR_STRIPTRAILING)
					Case $t == "STATE"
						$t = StringStripWS($sr[2], $STR_STRIPLEADING + $STR_STRIPTRAILING)
						$s = (StringRight($t, 7) == "RUNNING") ? "Running" : "Stopped"
				EndSelect
			EndIf
		Else
			If StringLen($s) > 0 Then
				$t = servicesGetStartTypeString(RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $id, "Start"));
				$_servicesArray[$_servicesCount] = servicesFormatServiceLine($n, $id, $t, $s)
				;MsgBox(64, "A service entry", $_servicesArray[$_servicesCount])
				$_servicesCount = $_servicesCount + 1
				$s = ""
			EndIf
		EndIf
	Next
	ReDim $_servicesArray[$_servicesCount]
	LoggerAppend("Discovered " & $_servicesCount & " Windows services:" & @CRLF & "    ")
	LoggerAppend(_ArrayToString($_servicesArray, @CRLF & "    ") & @CRLF)
	$_servicesMsg = "loaded"
	$_servicesStatus = 2
EndFunc   ;==>servicesReadAll

; #FUNCTION# ====================================================================================================================
; Name ..........: servicesFormatServiceLine
; Description ...: Format a service line.
;                  This is the one place where the format and order of the listview columns are assembled.
; Syntax ........: servicesFormatServiceLine($n, $id, $t, $s)
; Parameters ....: $n                   - the service description.
;                  $id                  - the service identifier.
;                  $t                   - the service start type.
;                  $s                   - the service running status.
; Return values .: Formatted service entry line
; ===============================================================================================================================
Func servicesFormatServiceLine($n, $id, $t, $s)
	; this is where the format (order) of the columns is defined
	return $n & "|" & $id & "|" & $t & "|" & $s
EndFunc

;===============================================================================
; Description:   Checks if a service exists on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to check
; Requirements:  None
; Return Values: On Success - 1
;                On Failure - 0
;===============================================================================
Func servicesServiceExists($sComputerName, $sServiceName)
	Local $hAdvapi32
	Local $arRet
	Local $hSC
	Local $bExist = 0

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", _
			"str", $sComputerName, _
			"str", "ServicesActive", _
			"long", $SC_MANAGER_CONNECT)
	If $arRet[0] <> 0 Then
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", _
				"long", $hSC, _
				"str", $sServiceName, _
				"long", $SERVICE_INTERROGATE)
		If $arRet[0] <> 0 Then
			$bExist = 1
			DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $arRet[0])
		EndIf
		DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hSC)
	EndIf
	DllClose($hAdvapi32)
	Return $bExist
EndFunc   ;==>servicesServiceExists

;===============================================================================
; Description:   Starts a service on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to start
; Requirements:  None
; Return Values: On Success - 1
;                On Failure - 0 and @error is set to extended Windows error code
; Note:          This function does not check to see if the service has started successfully
;===============================================================================
Func servicesStartService($sComputerName, $sServiceName)
	Local $hAdvapi32
	Local $hKernel32
	Local $arRet
	Local $hSC
	Local $hService
	Local $lError = -1

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$hKernel32 = DllOpen("kernel32.dll")
	If $hKernel32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", _
			"str", $sComputerName, _
			"str", "ServicesActive", _
			"long", $SC_MANAGER_CONNECT)
	If $arRet[0] = 0 Then
		$arRet = DllCall($hKernel32, "long", "GetLastError")
		$lError = $arRet[0]
	Else
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", _
				"long", $hSC, _
				"str", $sServiceName, _
				"long", $SERVICE_START)
		If $arRet[0] = 0 Then
			$arRet = DllCall($hKernel32, "long", "GetLastError")
			$lError = $arRet[0]
		Else
			$hService = $arRet[0]
			$arRet = DllCall($hAdvapi32, "int", "StartService", _
					"long", $hService, _
					"long", 0, _
					"str", "")
			If $arRet[0] = 0 Then
				$arRet = DllCall($hKernel32, "long", "GetLastError")
				$lError = $arRet[0]
			EndIf
			DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hService)
		EndIf
		DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hSC)
	EndIf
	DllClose($hAdvapi32)
	DllClose($hKernel32)
	If $lError <> -1 Then
		SetError($lError)
		Return 0
	EndIf
	Return 1
EndFunc   ;==>servicesStartService

;===============================================================================
; Description:   Stops a service on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to stop
; Requirements:  None
; Return Values: On Success - 1
;                On Failure - 0 and @error is set to extended Windows error code
; Note:          This function does not check to see if the service has stopped successfully
;===============================================================================
Func servicesStopService($sComputerName, $sServiceName)
	Local $hAdvapi32
	Local $hKernel32
	Local $arRet
	Local $hSC
	Local $hService
	Local $lError = -1

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$hKernel32 = DllOpen("kernel32.dll")
	If $hKernel32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", _
			"str", $sComputerName, _
			"str", "ServicesActive", _
			"long", $SC_MANAGER_CONNECT)
	If $arRet[0] = 0 Then
		$arRet = DllCall($hKernel32, "long", "GetLastError")
		$lError = $arRet[0]
	Else
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", _
				"long", $hSC, _
				"str", $sServiceName, _
				"long", $SERVICE_STOP)
		If $arRet[0] = 0 Then
			$arRet = DllCall($hKernel32, "long", "GetLastError")
			$lError = $arRet[0]
		Else
			$hService = $arRet[0]
			$arRet = DllCall($hAdvapi32, "int", "ControlService", _
					"long", $hService, _
					"long", $SERVICE_CONTROL_STOP, _
					"str", "")
			If $arRet[0] = 0 Then
				$arRet = DllCall($hKernel32, "long", "GetLastError")
				$lError = $arRet[0]
			EndIf
			DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hService)
		EndIf
		DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hSC)
	EndIf
	DllClose($hAdvapi32)
	DllClose($hKernel32)
	If $lError <> -1 Then
		SetError($lError)
		Return 0
	EndIf
	Return 1
EndFunc   ;==>servicesStopService


; end
