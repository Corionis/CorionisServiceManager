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

; application components
#include "pan.au3"						; must be include first

; functions
#include "logger.au3"

;----------------------------------------------------------------------------
; globals
Global $_servicesRootPath = ""
Global $_servicesDirectories

; status
Global $_servicesMsg = "not loaded"
Global $_servicesStatus = 1

;----------------------------------------------------------------------------
; Dump a formatted "pretty" string of all template content
Func servicesDumpConfig()
	Dim $buff = "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" & @CRLF & _
			"services discovered" & @CRLF
	Dim $i, $j, $k
	Dim $tname, $ttype, $comp, $name
	For $i = 0 To UBound($_winservicesData, 1) - 1
		If $_winservicesData[$i][0][0] <> '' Then
			$tname = $_winservicesData[$i][0][0]
			$buff &= "    " & $tname & " (" & $ttype & ")" & @CRLF
			For $j = 1 To UBound($_winservicesData, 2) - 1
				If $_winservicesData[$i][$j][0] <> '' Then
					$comp = $_winservicesData[$i][$j][0]
					$buff &= "        " & $comp & @CRLF
					For $k = 1 To UBound($_winservicesData, 3) - 1
						If $_winservicesData[$i][$j][$k] <> '' Then
							$name = $_winservicesData[$i][$j][$k]
							$buff &= "            " & $name & @CRLF
						EndIf
					Next
				EndIf
			Next
		EndIf
	Next
	Return $buff
EndFunc   ;==>servicesDumpConfig

;----------------------------------------------------------------------------
; Return an array of all files found at array indices i and j
Func servicesMakeFileList($i, $j)
	Dim $k, $list[100], $lidx = 0
	For $k = 1 To UBound($_winservicesData, 3) - 1
		If $_winservicesData[$i][$j][$k] <> '' Then
			$list[$lidx] = servicesMakePath($i, $j, $k)
			$lidx += 1
		EndIf
	Next
	ReDim $list[$lidx]
	Return $list
EndFunc   ;==>servicesMakeFileList

;----------------------------------------------------------------------------
; Return an array of ALL files from ALL services
Func servicesMakeFileListAll()
	Dim $list[1], $part
	Dim $i, $j
	For $i = 0 To UBound($_winservicesData, 1) - 1
		If $_winservicesData[$i][0][0] <> '' Then
			For $j = 1 To UBound($_winservicesData, 2) - 1
				If $_winservicesData[$i][$j][0] <> '' Then
					$part = servicesMakeFileList($i, $j)
					_ArrayConcatenate($list, $part)
				EndIf
			Next
		EndIf
	Next
	Return $list
EndFunc   ;==>servicesMakeFileListAll

;----------------------------------------------------------------------------
; Return a string of the fully-qualified path to the array indices i, j and k
Func servicesMakePath($i, $j, $k)
	Dim $cd = @ScriptDir
	Dim $buff = $cd & "\services"
	If $_winservicesData[$i][0][0] <> '' Then
		$buff &= "\" & $_winservicesData[$i][0][0]
		If $_winservicesData[$i][$j][0] <> '' Then
			$buff &= "\" & $_winservicesData[$i][$j][0]
			If $_winservicesData[$i][$j][$k] <> '' Then
				$buff &= "\" & $_winservicesData[$i][$j][$k]
			EndIf
		EndIf
	EndIf
	Return $buff
EndFunc   ;==>servicesMakePath

;----------------------------------------------------------------------------
; Read all the Windows Services
Func servicesReadAll()
	Dim $cd = @ScriptDir
	Dim $i, $last, $sRead, $fa
	$_panErrorValue = 0

	Local $iPid = Run(@ComSpec & ' /c ' & 'query', '', @SW_HIDE, 6)
		While 1
			$sRead &= StdoutRead($iPid)
			If @error Then ExitLoop
		WEnd



	loggerAppend(_ArrayToString($fa, @CRLF & "    ") & @CRLF)
EndFunc   ;==>servicesReadAll

;----------------------------------------------------------------------------
; Read the "components" of a template root directory (the subdirectories)
; Called by servicesReadConfig
Func _servicesReadConfigComponents($count)
	Dim $i, $cpath, $j, $num
	Dim $clist
	For $i = 0 To $count
		$cpath = $_servicesRootPath & "\" & $_winservicesData[$i][0][0]
		If FileExists($cpath) Then
			; directories only, exclude any directory leading with an underscore
			;$clist = directoryList($cpath, Default, 2, "_*")
			_ArraySort($clist)
			$num = UBound($clist) - 1
			For $j = 0 To $num
				$_winservicesData[$i][$j + 1][0] = $clist[$j]
			Next
			$num += 1
			_servicesReadConfigFiles($i, $num)
		EndIf
	Next
EndFunc   ;==>_servicesReadConfigComponents

;----------------------------------------------------------------------------
; Read the list of files in a "component"
; Called by _servicesReadConfigComponents
Func _servicesReadConfigFiles($i, $num)
	Dim $j, $fpath, $k, $name, $quan
	Dim $flist
	For $j = 1 To $num
		$name = $_winservicesData[$i][0][0]
		If $name = "<Custom>" Then
			ContinueLoop
		EndIf
		$fpath = $_servicesRootPath & "\" & $name
		$fpath &= "\" & $_winservicesData[$i][$j][0]
		If FileExists($fpath) Then
			; files only, exclude any filename leading with an underscore
			;$flist = directoryList($fpath, Default, 1, "_*")
			_ArraySort($flist)
			$quan = UBound($flist) - 1
			For $k = 0 To $quan
				$_winservicesData[$i][$j][$k + 1] = $flist[$k]
			Next
		EndIf
	Next
EndFunc   ;==>_servicesReadConfigFiles

;----------------------------------------------------------------------------
Func _servicesReadGetType($root)
	Dim $cd = @ScriptDir
	Dim $ttype = "not defined"
	If $root = "<Custom>" Then
		$ttype = "custom"
	Else
		Dim $filepath = $cd & "\services\" & $root & "\_metadata.ini"
		If FileExists($filepath) Then
			$ttype = IniRead($filepath, "bridge", "type", "not defined")
		EndIf
	EndIf
	Return $ttype
EndFunc   ;==>_servicesReadGetType


; end
