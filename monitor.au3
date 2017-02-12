#include-once
#cs -------------------------------------------------------------------------

	Monitor Selected Services tab

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
Global $_monitorView
Global $i1, $i2, $i3
Global $_monitorSelected = -1
Global $_monitorList[100]
Global $_monitorListCount = 0
Global $MonitorButton

;----------------------------------------------------------------------------
Func MonitorInit()
	Dim $i, $j, $l

	$_monitorView = GUICtrlCreateListView("Identifier          |Name                    |Startup Type         |Status    ", 13, 31, $_cfgWidth - 29, $_cfgHeight - 118)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	$_selectedServices[0][0] = False
	$_selectedServices[0][1] = "tomcat7"
	$_selectedServices[0][2] = "DocVue Enterprise Server"
	$_selectedServices[0][3] = "Automatic"
	$_selectedServices[0][4] = "-"

	$_selectedServices[1][0] = False
	$_selectedServices[1][1] = "jasperreportsTomcat"
	$_selectedServices[1][2] = "Jasperreports Tomcat"
	$_selectedServices[1][3] = "Automatic"
	$_selectedServices[1][4] = "-"

	$_selectedServices[2][0] = False
	$_selectedServices[2][1] = "jasperreportsPostgreSQL"
	$_selectedServices[2][2] = "jasperreportsPostgreSQL"
	$_selectedServices[2][3] = "Automatic"
	$_selectedServices[2][4] = "-"

	$_selectedServices[3][0] = False
	$_selectedServices[3][1] = "MSSQLSERVER"
	$_selectedServices[3][2] = "SQL Server"
	$_selectedServices[3][3] = "Automatic"
	$_selectedServices[3][4] = "-"

	$_selectedServices[4][0] = False
	$_selectedServices[4][1] = "Spooler"
	$_selectedServices[4][2] = "Print Spooler"
	$_selectedServices[4][3] = "Automatic"
	$_selectedServices[4][4] = "-"

	ReDim $_selectedServices[5][5]

	For $i = 0 To UBound($_selectedServices) - 1
		$l = ""
		For $j = 1 To 4
			$l = $l & $_selectedServices[$i][$j]
			If $j < 4 Then
				$l = $l & "|"
			EndIf
		Next
		$_monitorList[$_monitorListCount] = GUICtrlCreateListViewItem($l, $_monitorView)
		GUICtrlSetOnEvent($_monitorList[$_monitorListCount], "monitorItemPicked")
		$_monitorListCount = $_monitorListCount + 1
	Next


	Local $AllButton = GUICtrlCreateButton("&All", 21, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($AllButton, "monitorAll")
	GUICtrlSetTip($AllButton, "Select all services")

	Local $NoneButton = GUICtrlCreateButton("&None", 75, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($NoneButton, "monitorNone")
	GUICtrlSetTip($NoneButton, "De-select all services")


	Local $StartButton = GUICtrlCreateButton("&Start", 145, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($StartButton, "monitorStart")
	GUICtrlSetTip($StartButton, "Start the selected services")

	Local $StopButton = GUICtrlCreateButton("S&top", 199, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($StopButton, "monitorStop")
	GUICtrlSetTip($StopButton, "Stop the selected services")


	Local $AutomaticButton = GUICtrlCreateButton("A&uto", 269, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($AutomaticButton, "monitorAutomatic")
	GUICtrlSetTip($AutomaticButton, "Set the selected services startup type to Automatic")

	Local $ManualButton = GUICtrlCreateButton("Manua&l", 323, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($ManualButton, "monitorManual")
	GUICtrlSetTip($ManualButton, "Set the selected services startup type to Manual")

	Local $DisableButton = GUICtrlCreateButton("&Disable", 377, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($DisableButton, "monitorDisable")
	GUICtrlSetTip($DisableButton, "Set the selected services startup type to Disabled")


	$MonitorButton = GUICtrlCreateButton("&Monitor", 447, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($MonitorButton, "monitorMonitor")
	GUICtrlSetTip($MonitorButton, "Toggle active monitoring")

	If IsAdmin() == 9999 Then ;;;;;;;;;;;;;; 0 Then
		GUICtrlSetState($AutomaticButton, $GUI_DISABLE)
		GUICtrlSetTip($AutomaticButton, "Automatic requires Administrator privileges")
		GUICtrlSetState($ManualButton, $GUI_DISABLE)
		GUICtrlSetTip($ManualButton, "Manual requires Administrator privileges")
	EndIf
EndFunc   ;==>MonitorInit

;----------------------------------------------------------------------------
Func monitorItemPicked()
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
	$_monitorSelected = $item
	;MsgBox(64, "Item Picked", "Item " & $item & " was picked")
EndFunc   ;==>monitorItemPicked

;----------------------------------------------------------------------------
Func monitorAll()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "All" & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc   ;==>monitorAll

;----------------------------------------------------------------------------
Func monitorNone()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "None" & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc   ;==>monitorNone

;----------------------------------------------------------------------------
Func monitorStart()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "Start " & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc   ;==>monitorStart

;----------------------------------------------------------------------------
Func monitorStop()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "Stop " & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc   ;==>monitorStop

;----------------------------------------------------------------------------
Func monitorAutomatic()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "Automatic " & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc   ;==>monitorAutomatic

;----------------------------------------------------------------------------
Func monitorManual()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "Manual " & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc   ;==>monitorManual

;----------------------------------------------------------------------------
Func monitorDisable()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "Disable " & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc   ;==>monitorManual

;----------------------------------------------------------------------------
Func monitorMonitor()
	If $_cfgMonitoring == True Then
		$_cfgMonitoring = False
	Else
		$_cfgMonitoring = True
	EndIf
	MonitorSetMonitorButton($_cfgMonitoring)
	UpdateMonitor()
EndFunc   ;==>monitorMonitor

;----------------------------------------------------------------------------
Func MonitorSetMonitorButton($state)
	If $state == True Then
		GUICtrlSetColor($MonitorButton, $_cfgRunningTextColor)
		GUICtrlSetBkColor($MonitorButton, $_cfgRunningBackColor)
	Else
		GUICtrlSetColor($MonitorButton, $_cfgStoppedTextColor)
		GUICtrlSetBkColor($MonitorButton, $_cfgStoppedBackColor)
	EndIf
EndFunc   ;==>monitorMonitor


; end
