#include-once
#cs -------------------------------------------------------------------------

	New Bridge tab

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

;----------------------------------------------------------------------------
; Includes
#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <ListViewConstants.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>

; application components
#include "pan.au3" ; must be include first

;----------------------------------------------------------------------------
; globals
Global $_optionsCreateButton
Global $_optionsCurrentRoot = -1
Global $_optionsLevelArray[9999]
Global $_optionsOldRoot = 0
Global $_optionsTreeArray[9999]
Global $_optionsTreeSize = 0
Global $_optionsTreeView
Global $_optionsTreeViewHandle
Global $_optionsType = "stamdard"

;----------------------------------------------------------------------------
Func _optionsCreate()
	Dim $button, $isOk
	$isOk = _optionsValidate()
	If $isOk <> True Then
		Return
	EndIf
	$button = MsgBox(1 + 32 + 256, "Create Selected Items", "Create selected items and run selected SQL?")
	If $button = 1 Then
		; do the work
		MsgBox(0, "Debug", "Do the work here ...")
	EndIf
EndFunc   ;==>_optionsCreate

;----------------------------------------------------------------------------
Func _optionsGetRootIndex($index)
	Local $i, $name, $tname, $x
	For $i = $index To 0 Step -1
		If $_optionsLevelArray[$i] = 1 Then
			$name = GUICtrlRead($_optionsTreeArray[$i], 1)
			For $x = 0 To UBound($_winservicesData, 1) - 1
				If $_winservicesData[$x][0][0] <> '' Then
					$tname = $_winservicesData[$x][0][0]
					If $tname == $name Then
						Return $x
					EndIf
				EndIf
			Next
		EndIf
	Next
	Return -1
EndFunc   ;==>_optionsGetRootIndex

;----------------------------------------------------------------------------
Func optionsInit()
	$_optionsTreeView = GUICtrlCreateTreeView(13, 31, 250, 305, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_CHECKBOXES, $TVS_SHOWSELALWAYS, $TVS_DISABLEDRAGDROP), $WS_EX_CLIENTEDGE)
	$_optionsTreeViewHandle = ControlGetHandle("", "", $_optionsTreeView)
	$_optionsCreateButton = GUICtrlCreateButton("Create", 526, 342, 50, 25)
	GUICtrlSetOnEvent($_optionsCreateButton, "_optionsCreate")
	GUICtrlSetTip($_optionsCreateButton, "Create the selected items")
EndFunc   ;==>optionsInit

;----------------------------------------------------------------------------
Func optionsMakeTree()
	Dim $i, $j, $k, $tmi, $cmi, $fmi
	Dim $tname, $comp, $name

	For $i = 0 To UBound($_winservicesData, 1) - 1
		If $_winservicesData[$i][0][0] <> '' Then
			$tname = $_winservicesData[$i][0][0]
			$tmi = GUICtrlCreateTreeViewItem($tname, $_optionsTreeView)
			GUICtrlSetOnEvent($tmi, "_optionsItemClicked")
			$_optionsTreeArray[$_optionsTreeSize] = $tmi
			$_optionsLevelArray[$_optionsTreeSize] = 1
			$_optionsTreeSize += 1
			For $j = 1 To UBound($_winservicesData, 2) - 1
				If $_winservicesData[$i][$j][0] <> '' Then
					$comp = $_winservicesData[$i][$j][0]
					$cmi = GUICtrlCreateTreeViewItem($comp, $tmi)
					GUICtrlSetOnEvent($cmi, "_optionsItemClicked")
					$_optionsTreeArray[$_optionsTreeSize] = $cmi
					$_optionsLevelArray[$_optionsTreeSize] = 2
					$_optionsTreeSize += 1
					For $k = 1 To UBound($_winservicesData, 3) - 1
						If $_winservicesData[$i][$j][$k] <> '' Then
							$name = $_winservicesData[$i][$j][$k]
							$fmi = GUICtrlCreateTreeViewItem($name, $cmi)
							GUICtrlSetOnEvent($fmi, "_optionsItemClicked")
							$_optionsTreeArray[$_optionsTreeSize] = $fmi
							$_optionsLevelArray[$_optionsTreeSize] = 3
							$_optionsTreeSize += 1
						EndIf
					Next
				EndIf
			Next
		EndIf
	Next
	If $_optionsTreeSize > 0 Then
		ReDim $_optionsTreeArray[$_optionsTreeSize]
		ReDim $_optionsLevelArray[$_optionsTreeSize]
	EndIf
EndFunc   ;==>optionsMakeTree

;----------------------------------------------------------------------------
Func _optionsItemClicked()
	Local $msg = @GUI_CtrlId
	Local $i, $name, $ischecked, $lvl, $x
	For $i = 0 To $_optionsTreeSize - 1
		If $msg = $_optionsTreeArray[$i] Then
			$name = GUICtrlRead($_optionsTreeArray[$i], 1)
			$ischecked = BitAND(GUICtrlRead($_optionsTreeArray[$i]), $GUI_CHECKED)
			$lvl = $_optionsLevelArray[$i]
			$_optionsCurrentRoot = _optionsGetRootIndex($i)
			If $_optionsCurrentRoot <> $_optionsOldRoot Then
				_optionsResetClicked()
			EndIf
			If $lvl < 3 Then
				For $x = $i + 1 To $_optionsTreeSize - 1
					If $_optionsLevelArray[$x] > $lvl Then
						_GUICtrlTreeView_SetChecked($_optionsTreeView, $_optionsTreeArray[$x], $ischecked)
					Else
						ExitLoop
					EndIf
				Next
			EndIf
			_GUICtrlTreeView_SetChecked($_optionsTreeView, $_optionsTreeArray[$i], $ischecked)
			$_optionsOldRoot = _optionsGetRootIndex($i)
		EndIf
	Next
EndFunc   ;==>_optionsItemClicked

;----------------------------------------------------------------------------
Func _optionsResetClicked()
	Local $i
	For $i = 0 To $_optionsTreeSize - 1
		_GUICtrlTreeView_SetChecked($_optionsTreeView, $_optionsTreeArray[$i], 0)
	Next
EndFunc   ;==>_optionsResetClicked

;----------------------------------------------------------------------------
Func _optionsSetForm($type)
	Local $i
EndFunc   ;==>_optionsSetForm

;----------------------------------------------------------------------------
Func _optionsValidate()
	Dim $isOk = 1
	Return $isOk
EndFunc   ;==>_optionsValidate

; end
