#include-once
#cs -------------------------------------------------------------------------

	Select Selected Services tab

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

;----------------------------------------------------------------------------
; Includes
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>

; application components
#include "pan.au3" ; must be include first
#include "services.au3"

;----------------------------------------------------------------------------
; globals
Global $_selectView
Global $i1, $i2, $i3
Global $_selectSelected = -1
Global $_selectList[400]
Global $_selectListCount = 0
Global $SelectButton

;----------------------------------------------------------------------------
Func SelectInit()
	Dim $i, $j, $l

	servicesReadAll()

	$_selectView = GUICtrlCreateListView("      Identifier                        |Name                        |Startup Type         |Status    ", _
			13, 31, $_cfgWidth - 29, $_cfgHeight - 118, _
			BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_SORTASCENDING), BitOR($LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT))
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
	GUICtrlSetBkColor($_selectView, $GUI_BKCOLOR_LV_ALTERNATE)
	GUICtrlSetBkColor($_selectView, 0xffffff)

	selectPopulate()

	_GUICtrlListView_HideColumn($_selectView, 2) ; hide startup type because it is "unknown" at this point

	;_GUICtrlListView_SetColumnWidth($_selectView, 0, $LVSCW_AUTOSIZE_USEHEADER)

	Local $AllButton = GUICtrlCreateButton("&All", 21, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($AllButton, "selectAll")
	GUICtrlSetTip($AllButton, "Select all services")

	Local $NoneButton = GUICtrlCreateButton("&None", 75, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($NoneButton, "selectNone")
	GUICtrlSetTip($NoneButton, "De-select all services")


	Local $SavetButton = GUICtrlCreateButton("&Save", 145, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($SavetButton, "selectSave")
	GUICtrlSetTip($SavetButton, "Save the selected services")


	Local $CancelButton = GUICtrlCreateButton("&Cancel", 215, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($CancelButton, "selectCancel")
	GUICtrlSetTip($CancelButton, "Cancel any changes")


	Local $RefreshButton = GUICtrlCreateButton("&Refresh", 285, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($RefreshButton, "selectRefresh")
	GUICtrlSetTip($RefreshButton, "Refresh this list of Windows services")
EndFunc   ;==>SelectInit

;----------------------------------------------------------------------------
Func selectPopulate()
	Local $l
	If $_selectListCount > 0 Then
		For $i = 0 To $_selectListCount - 1
			GUICtrlDelete($_selectList[$i])
		Next
		ReDim $_selectList[400]
		$_selectListCount = 0
	EndIf
	For $i = 0 To $_servicesCount - 1
		$l = $_servicesArray[$i]
		$_selectList[$_selectListCount] = GUICtrlCreateListViewItem($l, $_selectView)
		GUICtrlSetOnEvent($_selectList[$_selectListCount], "selectItemPicked")
		GUICtrlSetBkColor($_selectList[$_selectListCount], 0xeeeeee)
		$_selectListCount = $_selectListCount + 1
	Next
EndFunc

;----------------------------------------------------------------------------
Func selectItemPicked()
	Dim $item
	Dim $msg = @GUI_CtrlId
	Select
		Case $msg = $i1
			$item = 0
		Case $msg = $i2
			$item = 1
		Case $msg = $i3
			$item = 2
	EndSelect
	$_selectSelected = $item
	;MsgBox(64, "Item Picked", "Item " & $item & " was picked")
EndFunc   ;==>selectItemPicked

;----------------------------------------------------------------------------
Func selectAll()
	Local $i
	For $i = 0 To $_servicesCount - 1
		GUICtrlSetState($_selectList[$i], $GUI_CHECKED)
	Next
EndFunc   ;==>selectAll

;----------------------------------------------------------------------------
Func selectNone()
	Local $i
	For $i = 0 To $_servicesCount - 1
		GUICtrlSetState($_selectList[$i], $GUI_UNCHECKED)
	Next
EndFunc   ;==>selectNone

;----------------------------------------------------------------------------
Func selectSave()
	Local $i, $j = 1, $l, $svc
	Local $dat[400][2]
	For $i = 0 To $_selectListCount - 1
		If _GUICtrlListView_GetItemChecked($_selectView, $i) == True Then
			$l = GUICtrlRead($_selectList[$i])
			$svc = StringSplit($l, "|", $STR_NOCOUNT)
			$dat[$j][0] = $svc[0]
			$dat[$j][1] = $l
			$j = $j + 1
		EndIf
	Next
	If $j > 1 Then
		ReDim $dat[$j][2]
		$dat[0][0] = $j;
		$dat[0][1] = "";
		IniWriteSection($_configurationFilePath, "services", $dat)
	EndIf
EndFunc   ;==>selectSave

;----------------------------------------------------------------------------
Func selectCancel()
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
	MsgBox(64, "Action", "Cancel " & $_selectSelected)
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
EndFunc   ;==>selectCancel

;----------------------------------------------------------------------------
Func selectRefresh()
	servicesReadAll()
	selectPopulate()
EndFunc   ;==>selectRefresh


; end
