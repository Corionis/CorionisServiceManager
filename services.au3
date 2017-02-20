#include-once
#cs -------------------------------------------------------------------------

	Windows Services data and handling

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

;----------------------------------------------------------------------------
; Includes
#include "Array.au3"
#include "AutoItConstants.au3"
#include "StringConstants.au3"

; application components
#include "pan.au3" ; must be include first

; functions
#include "logger.au3"

;----------------------------------------------------------------------------
; globals

; status
Global $_servicesMsg = "not loaded"
Global $_servicesStatus = 1

;----------------------------------------------------------------------------
; Read all the Windows Services
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
				$t = "unknown"
				$_servicesArray[$_servicesCount] = $id & "|" & $n & "|" & $t & "|" & $s
				;MsgBox(64, "A service entry", $_servicesArray[$_servicesCount])
				$_servicesCount = $_servicesCount + 1
				$s = ""
			EndIf
		EndIf
	Next
	ReDim $_servicesArray[$_servicesCount]
	LoggerAppend("Discovered " & $_servicesCount & " Windows services:" & @CRLF & "    ")
	LoggerAppend(_ArrayToString($_servicesArray, @CRLF & "    ") & @CRLF)
EndFunc   ;==>servicesReadAll



; end
