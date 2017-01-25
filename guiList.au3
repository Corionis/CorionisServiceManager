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
#include "pan.au3"						; must be include first

;----------------------------------------------------------------------------
; globals
Global $_guiListCreateButton
Global $_guiListCurrentRoot = -1
Global $_guiListLevelArray[9999]
Global $_guiListOldRoot = 0
Global $_guiListTreeArray[9999]
Global $_guiListTreeSize = 0
Global $_guiListTreeView
Global $_guiListTreeViewHandle
Global $_guiListType = "stamdard"

;----------------------------------------------------------------------------
Func _guiListCreate()
	Dim $button, $isOk
	$isOk = _guiListValidate()
	If $isOk <> True Then
		Return
	EndIf
	$button = MsgBox(1 + 32 + 256, "Create Selected Items", "Create selected items and run selected SQL?")
	If $button = 1 Then
		; do the work
		MsgBox(0, "Debug", "Do the work here ...")
	EndIf
EndFunc   ;==>_guiListCreate

;----------------------------------------------------------------------------
Func _guiListGetRootIndex($index)
	Local $i, $name, $tname, $x
	For $i = $index To 0 Step -1
		If $_guiListLevelArray[$i] = 1 Then
			$name = GUICtrlRead($_guiListTreeArray[$i], 1)
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
EndFunc   ;==>_guiListGetRootIndex

;----------------------------------------------------------------------------
Func guiListInit()
	$_guiListTreeView = GUICtrlCreateTreeView(13, 31, 250, 305, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_CHECKBOXES, $TVS_SHOWSELALWAYS, $TVS_DISABLEDRAGDROP), $WS_EX_CLIENTEDGE)
	$_guiListTreeViewHandle = ControlGetHandle("", "", $_guiListTreeView)
	$_guiListCreateButton = GUICtrlCreateButton("Create", 526, 342, 50, 25)
	GUICtrlSetOnEvent($_guiListCreateButton, "_guiListCreate")
	GUICtrlSetTip($_guiListCreateButton, "Create the selected items")
EndFunc   ;==>guiListInit

;----------------------------------------------------------------------------
Func guiListMakeTree()
	Dim $i, $j, $k, $tmi, $cmi, $fmi
	Dim $tname, $comp, $name

	For $i = 0 To UBound($_winservicesData, 1) - 1
		If $_winservicesData[$i][0][0] <> '' Then
			$tname = $_winservicesData[$i][0][0]
			$tmi = GUICtrlCreateTreeViewItem($tname, $_guiListTreeView)
			GUICtrlSetOnEvent($tmi, "_guiListItemClicked")
			$_guiListTreeArray[$_guiListTreeSize] = $tmi
			$_guiListLevelArray[$_guiListTreeSize] = 1
			$_guiListTreeSize += 1
			For $j = 1 To UBound($_winservicesData, 2) - 1
				If $_winservicesData[$i][$j][0] <> '' Then
					$comp = $_winservicesData[$i][$j][0]
					$cmi = GUICtrlCreateTreeViewItem($comp, $tmi)
					GUICtrlSetOnEvent($cmi, "_guiListItemClicked")
					$_guiListTreeArray[$_guiListTreeSize] = $cmi
					$_guiListLevelArray[$_guiListTreeSize] = 2
					$_guiListTreeSize += 1
					For $k = 1 To UBound($_winservicesData, 3) - 1
						If $_winservicesData[$i][$j][$k] <> '' Then
							$name = $_winservicesData[$i][$j][$k]
							$fmi = GUICtrlCreateTreeViewItem($name, $cmi)
							GUICtrlSetOnEvent($fmi, "_guiListItemClicked")
							$_guiListTreeArray[$_guiListTreeSize] = $fmi
							$_guiListLevelArray[$_guiListTreeSize] = 3
							$_guiListTreeSize += 1
						EndIf
					Next
				EndIf
			Next
		EndIf
	Next
	If $_guiListTreeSize > 0 Then
		ReDim $_guiListTreeArray[$_guiListTreeSize]
		ReDim $_guiListLevelArray[$_guiListTreeSize]
	EndIf
EndFunc   ;==>guiListMakeTree

;----------------------------------------------------------------------------
Func _guiListItemClicked()
	Local $msg = @GUI_CtrlId
	Local $i, $name, $ischecked, $lvl, $x
	For $i = 0 To $_guiListTreeSize - 1
		If $msg = $_guiListTreeArray[$i] Then
			$name = GUICtrlRead($_guiListTreeArray[$i], 1)
			$ischecked = BitAND(GUICtrlRead($_guiListTreeArray[$i]), $GUI_CHECKED)
			$lvl = $_guiListLevelArray[$i]
			$_guiListCurrentRoot = _guiListGetRootIndex($i)
			If $_guiListCurrentRoot <> $_guiListOldRoot Then
				_guiListResetClicked()
			EndIf
			If $lvl < 3 Then
				For $x = $i + 1 To $_guiListTreeSize - 1
					If $_guiListLevelArray[$x] > $lvl Then
						_GUICtrlTreeView_SetChecked($_guiListTreeView, $_guiListTreeArray[$x], $ischecked)
					Else
						ExitLoop
					EndIf
				Next
			EndIf
			_GUICtrlTreeView_SetChecked($_guiListTreeView, $_guiListTreeArray[$i], $ischecked)
			$_guiListOldRoot = _guiListGetRootIndex($i)
		EndIf
	Next
EndFunc   ;==>_guiListItemClicked

;----------------------------------------------------------------------------
Func _guiListResetClicked()
	Local $i
	For $i = 0 To $_guiListTreeSize - 1
		_GUICtrlTreeView_SetChecked($_guiListTreeView, $_guiListTreeArray[$i], 0)
	Next
EndFunc   ;==>_guiListResetClicked

;----------------------------------------------------------------------------
Func _guiListSetForm($type)
	Local $i
EndFunc   ;==>_guiListSetForm

;----------------------------------------------------------------------------
Func _guiListValidate()
	Dim $isOk = 1
	Return $isOk
EndFunc   ;==>_guiListValidate

; end
