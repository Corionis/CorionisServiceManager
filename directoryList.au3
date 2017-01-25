#include-once
#cs -------------------------------------------------------------------------
Description:    Lists all or preferred files and or folders in a specified path
				Similar to using Dir with the /B switch.

Syntax:         directoryList($sPath, $sFilter = '*.*', $iFlag = 0, $sExclude = '')

Parameter(s):   $sPath = Path to generate filelist for
                $sFilter = The filter to use. Search the Autoit3 manual for the word "WildCards" For details, support now for multiple searches
					Example *.exe; *.txt will find all .exe and .txt files
				$iFlag = determines weather to return file or folders or both.
					$iFlag = 0(Default) Return both files and folders
					$iFlag = 1 Return files Only
					$iFlag = 2 Return folders Only
                $sExclude = exclude a file from the list by all or part of its name
					Example: Unins* will remove all files/folders that start with Unins

Return Value:  	On Success - Returns an array containing the list of files and folders in the specified path
                On Failure - Returns the an empty string "" if no files are found and sets @Error on errors
                @Error or @extended = 1 Path not found or invalid
                @Error or @extended = 2 Invalid $sFilter or Invalid $sExclude
                @Error or @extended = 3 Invalid $iFlag
                @Error or @extended = 4 No File(s) Found

Note(s):        The array returned is one-dimensional and is made up as follows:
                $array[0] = 1st File\Folder
                $array[1] = 2nd File\Folder
                $array[2] = 3rd File\Folder
                $array[n] = nth File\Folder

                All files are written to a "reserved" .tmp file (Thanks to gafrost) for the example
                The Reserved file is then read into an array, then deleted

Modified for Selective Service Manager.
#ce -------------------------------------------------------------------------

Func directoryList($sPath, $sFilter = '*.*', $iFlag = 0, $sExclude = '')
	If Not FileExists($sPath) Then Return SetError(1, 1, '')
	If $sFilter = -1 Or $sFilter = Default Then $sFilter = '*.*'
	If $iFlag = -1 Or $iFlag = Default Then $iFlag = 0
	If $sExclude = -1 Or $sExclude = Default Then $sExclude = ''
	Local $aBadChar[6] = ['\', '/', ':', '>', '<', '|']
	For $iCC = 0 To 5
		If StringInStr($sFilter, $aBadChar[$iCC]) Or _
				StringInStr($sExclude, $aBadChar[$iCC]) Then Return SetError(2, 2, '')
	Next
	If StringStripWS($sFilter, 8) = '' Then Return SetError(2, 2, '')
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 3, '')
	If Not StringInStr($sFilter, ';') Then $sFilter &= ';'
	Local $aSplit = StringSplit(StringStripWS($sFilter, 8), ';'), $sRead
	For $iCC = 1 To $aSplit[0]
		If StringStripWS($aSplit[$iCC], 8) = '' Then ContinueLoop
		If StringLeft($aSplit[$iCC], 1) = '.' And _
				UBound(StringSplit($aSplit[$iCC], '.')) - 2 = 1 Then $aSplit[$iCC] = '*' & $aSplit[$iCC]
		Local $iPid = Run(@ComSpec & ' /c ' & 'dir "' & $sPath & '\' & $aSplit[$iCC] & '" /b /o-e /od', '', @SW_HIDE, 6)
		While 1
			$sRead &= StdoutRead($iPid)
			If @error Then ExitLoop
		WEnd
	Next
	If StringStripWS($sRead, 8) = '' Then SetError(4, 4, '')
	Local $aFSplit = StringSplit(StringTrimRight(StringStripCR($sRead), 1), @LF)
	Local $sHold
	For $iCC = 1 To $aFSplit[0]
		If $sExclude And StringLeft($aFSplit[$iCC], _
				StringLen(StringReplace($sExclude, '*', ''))) = StringReplace($sExclude, '*', '') Then ContinueLoop
		Switch $iFlag
			Case 0
				$sHold &= $aFSplit[$iCC] & Chr(1)
			Case 1
				If StringInStr(FileGetAttrib($sPath & '\' & $aFSplit[$iCC]), 'd') Then ContinueLoop
				$sHold &= $aFSplit[$iCC] & Chr(1)
			Case 2
				If Not StringInStr(FileGetAttrib($sPath & '\' & $aFSplit[$iCC]), 'd') Then ContinueLoop
				$sHold &= $aFSplit[$iCC] & Chr(1)
		EndSwitch
	Next
	If StringTrimRight($sHold, 1) Then Return StringSplit(StringTrimRight($sHold, 1), Chr(1), 2)
	Return SetError(4, 4, '')
EndFunc
