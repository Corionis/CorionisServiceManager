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

;----------------------------------------------------------------------------
; globals
Global $_selectView
Global $i1, $i2, $i3
Global $_selectSelected = -1
Global $_selectList[100]
Global $_selectListCount = 0
Global $SelectButton

;----------------------------------------------------------------------------
Func SelectInit()
	Dim $i, $j, $l

	$_selectView = GUICtrlCreateListView("Identifier          |Name                    |Startup Type         |Status    ", 13, 31, $_cfgWidth - 29, $_cfgHeight - 118)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	$_availableServices[0][0] = False
	$_availableServices[0][1] = "tomcat7"
	$_availableServices[0][2] = "DocVue Enterprise Server"
	$_availableServices[0][3] = "Automatic"
	$_availableServices[0][4] = "-"

	$_availableServices[1][0] = False
	$_availableServices[1][1] = "jasperreportsTomcat"
	$_availableServices[1][2] = "Jasperreports Tomcat"
	$_availableServices[1][3] = "Automatic"
	$_availableServices[1][4] = "-"

	$_availableServices[2][0] = False
	$_availableServices[2][1] = "jasperreportsPostgreSQL"
	$_availableServices[2][2] = "jasperreportsPostgreSQL"
	$_availableServices[2][3] = "Automatic"
	$_availableServices[2][4] = "-"

	$_availableServices[3][0] = False
	$_availableServices[3][1] = "MSSQLSERVER"
	$_availableServices[3][2] = "SQL Server"
	$_availableServices[3][3] = "Automatic"
	$_availableServices[3][4] = "-"

	$_availableServices[4][0] = False
	$_availableServices[4][1] = "Spooler"
	$_availableServices[4][2] = "Print Spooler"
	$_availableServices[4][3] = "Automatic"
	$_availableServices[4][4] = "-"

	ReDim $_availableServices[5][5]

	For $i = 0 To UBound($_availableServices) - 1
		$l = ""
		For $j = 1 To 4
			$l = $l & $_availableServices[$i][$j]
			If $j < 4 Then
				$l = $l & "|"
			EndIf
		Next
		$_selectList[$_selectListCount] = GUICtrlCreateListViewItem($l, $_selectView)
		GUICtrlSetOnEvent($_selectList[$_selectListCount], "selectItemPicked")
		$_selectListCount = $_selectListCount + 1
	Next


	Local $AllButton = GUICtrlCreateButton("&All", 21, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($AllButton, "selectAll")
	GUICtrlSetTip($AllButton, "Select all services")

	Local $NoneButton = GUICtrlCreateButton("&None", 75, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($NoneButton, "selectNone")
	GUICtrlSetTip($NoneButton, "De-select all services")


	Local $StartButton = GUICtrlCreateButton("&Start", 145, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($StartButton, "selectStart")
	GUICtrlSetTip($StartButton, "Start the selected services")

	Local $StopButton = GUICtrlCreateButton("S&top", 199, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($StopButton, "selectStop")
	GUICtrlSetTip($StopButton, "Stop the selected services")


	Local $AutomaticButton = GUICtrlCreateButton("A&uto", 269, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($AutomaticButton, "selectAutomatic")
	GUICtrlSetTip($AutomaticButton, "Set the selected services startup type to Automatic")

	Local $ManualButton = GUICtrlCreateButton("Manua&l", 323, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($ManualButton, "selectManual")
	GUICtrlSetTip($ManualButton, "Set the selected services startup type to Manual")

	Local $DisableButton = GUICtrlCreateButton("&Disable", 377, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($DisableButton, "selectDisable")
	GUICtrlSetTip($DisableButton, "Set the selected services startup type to Disabled")


	$SelectButton = GUICtrlCreateButton("&Select", 447, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetTip($SelectButton, "Toggle active selecting")

	If IsAdmin() == 9999 Then ;;;;;;;;;;;;;; 0 Then
		GUICtrlSetState($AutomaticButton, $GUI_DISABLE)
		GUICtrlSetTip($AutomaticButton, "Automatic requires Administrator privileges")
		GUICtrlSetState($ManualButton, $GUI_DISABLE)
		GUICtrlSetTip($ManualButton, "Manual requires Administrator privileges")
	EndIf
EndFunc   ;==>SelectInit

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
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
	MsgBox(64, "Action", "All" & $_selectSelected)
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
EndFunc   ;==>selectAll

;----------------------------------------------------------------------------
Func selectNone()
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
	MsgBox(64, "Action", "None" & $_selectSelected)
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
EndFunc   ;==>selectNone

;----------------------------------------------------------------------------
Func selectStart()
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
	MsgBox(64, "Action", "Start " & $_selectSelected)
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
EndFunc   ;==>selectStart

;----------------------------------------------------------------------------
Func selectStop()
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
	MsgBox(64, "Action", "Stop " & $_selectSelected)
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
EndFunc   ;==>selectStop

;----------------------------------------------------------------------------
Func selectAutomatic()
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
	MsgBox(64, "Action", "Automatic " & $_selectSelected)
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
EndFunc   ;==>selectAutomatic

;----------------------------------------------------------------------------
Func selectManual()
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
	MsgBox(64, "Action", "Manual " & $_selectSelected)
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
EndFunc   ;==>selectManual

;----------------------------------------------------------------------------
Func selectDisable()
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
	MsgBox(64, "Action", "Disable " & $_selectSelected)
	_GUICtrlListView_ClickItem($_selectView, $_selectSelected)
EndFunc   ;==>selectManual


; end
