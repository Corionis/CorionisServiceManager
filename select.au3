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
#include "globals.au3" ; must be include first
#include "services.au3"

;----------------------------------------------------------------------------
; globals
Global $_selectListCtrls[$SVC_MAX]
Global $_selectListCtrlsCount = 0
Global $SelectButton

;----------------------------------------------------------------------------
Func SelectInit()
	Dim $i, $j, $l

	$_selectView = GUICtrlCreateListView("      Name                                                 |Identifier |Startup Type |Status ", _
			13, 31, $_cfgWidth - 29, $_cfgHeight - 118, _
			BitOR($LVS_REPORT, $LVS_SINGLESEL), BitOR($LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT, $WS_EX_CLIENTEDGE))
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
	GUICtrlSetBkColor($_selectView, $GUI_BKCOLOR_LV_ALTERNATE)
	GUICtrlSetBkColor($_selectView, 0xffffff)

	servicesReadAll()
	selectPopulate()

	If StringLen($_cfgSelectWidths) > 0 Then
		$l = StringSplit($_cfgSelectWidths, "|", $STR_NOCOUNT)
		For $i = 0 To $SVC_LAST
			_GUICtrlListView_SetColumnWidth($_selectView, $i, Int($l[$i]))
		Next
	EndIf

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


	;_GUICtrlListView_HideColumn($_selectView, 2) ; hide startup type because it is "unknown" at this point
	;_GUICtrlListView_SetColumnWidth($_selectView, 0, $LVSCW_AUTOSIZE_USEHEADER)

EndFunc   ;==>SelectInit

; #FUNCTION# ====================================================================================================================
; Name ..........: selectIsCfgSelected
; Description ...: Determine if the id is one of the selected (monitored) services
; Syntax ........: selectIsCfgSelected($id)
; Parameters ....: $id - service name to look for
; Return values .: True - yes, the id matches a selected service
;                : False - no, not one of those
; ===============================================================================================================================
Func selectIsCfgSelected($id)
	Local $i, $l, $svc
	For $i = 0 To $_selectedServicesCount - 1
		$l = $_selectedServices[$i]
		$svc = StringSplit($l, "|", $STR_NOCOUNT)
		If $id == $svc[$SVC_ID] Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>selectIsCfgSelected

;----------------------------------------------------------------------------
Func selectPopulate()
	Local $id, $l, $svc
	; remove any existing list view items
	If $_selectListCtrlsCount > 0 Then
		For $i = 0 To $_selectListCtrlsCount - 1
			GUICtrlDelete($_selectListCtrls[$i])
		Next
		$_selectListCtrlsCount = 0
	EndIf
	; reset data
	If $_selectListCtrlsCount == 0 Or UBound($_selectListCtrls) == 0 Then
		ReDim $_selectListCtrls[$SVC_MAX]
		$_selectListCtrlsCount = 0
	EndIf
	; create list view items one per service
	For $i = 0 To $_servicesCount - 1
		$l = $_servicesArray[$i]
		$svc = StringSplit($l, "|", $STR_NOCOUNT)
		$id = $svc[$SVC_ID]
		$_selectListCtrls[$_selectListCtrlsCount] = GUICtrlCreateListViewItem($l, $_selectView)
		GUICtrlSetOnEvent($_selectListCtrls[$_selectListCtrlsCount], "selectItemPicked")
		GUICtrlSetBkColor($_selectListCtrls[$_selectListCtrlsCount], 0xeeeeee)
		; if it is one of the selected (monitored) services check its checkbox
		If selectIsCfgSelected($id) == True Then
			GUICtrlSetState($_selectListCtrls[$_selectListCtrlsCount], $GUI_CHECKED)
		EndIf
		$_selectListCtrlsCount = $_selectListCtrlsCount + 1
	Next
	ReDim $_selectListCtrls[$_selectListCtrlsCount]
	Dim $sort = False
	_GUICtrlListView_SimpleSort($_selectView, $sort, 0)
EndFunc   ;==>selectPopulate

;----------------------------------------------------------------------------
Func selectItemPicked()
	Dim $item = @GUI_CtrlId
	;MsgBox(64, "Item Picked", "Item " & $item & " was picked")
EndFunc   ;==>selectItemPicked

;----------------------------------------------------------------------------
Func selectAll()
	Local $i
	For $i = 0 To $_selectListCtrlsCount - 1
		GUICtrlSetState($_selectListCtrls[$i], $GUI_CHECKED)
	Next
EndFunc   ;==>selectAll

;----------------------------------------------------------------------------
Func selectNone()
	Local $i
	For $i = 0 To $_selectListCtrlsCount - 1
		GUICtrlSetState($_selectListCtrls[$i], $GUI_UNCHECKED)
	Next
EndFunc   ;==>selectNone

;----------------------------------------------------------------------------
Func selectSave()
	Local $i, $it, $j = 1, $l, $svc
	Local $dat[$SVC_MAX][2]
	Global $_selectedServices[$SVC_MAX]
	$_selectedServicesCount = 0
	For $i = 0 To $_selectListCtrlsCount - 1
		If _GUICtrlListView_GetItemChecked($_selectView, $i) == True Then
			$it = _GUICtrlListView_GetItem($_selectView, $i)
			$l = GUICtrlRead($it[5])
			$svc = StringSplit($l, "|", $STR_NOCOUNT)
			$svc[$SVC_STATUS] = "-------" ; change state so the monitor refreshes
			$l = _ArrayToString($svc, "|")
			$dat[$j][0] = $svc[$SVC_ID] ; key
			$dat[$j][1] = $l ; value
			$j = $j + 1
			$_selectedServices[$_selectedServicesCount] = $l
			$_selectedServicesCount = $_selectedServicesCount + 1
		EndIf
	Next
	ReDim $_selectedServices[$_selectedServicesCount]
	If $j > 1 Then
		ReDim $dat[$j][2] ; redimension to the exact count
		$dat[0][0] = $j ; set the count
		$dat[0][1] = ""
		IniWriteSection($_configurationFilePath, "services", $dat)
	EndIf
	monitorPopulate()
	UpdateMonitor()
EndFunc   ;==>selectSave

;----------------------------------------------------------------------------
Func selectCancel()
	selectPopulate()
EndFunc   ;==>selectCancel

;----------------------------------------------------------------------------
Func selectRefresh()
	servicesReadAll()
	selectPopulate()
EndFunc   ;==>selectRefresh


; end
