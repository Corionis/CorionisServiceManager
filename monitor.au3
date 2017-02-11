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
#include "pan.au3"						; must be include first

;----------------------------------------------------------------------------
; globals
Global $_monitorView
Global $i1, $i2, $i3
Global $_monitorSelected = -1
Global $_monitorIsMonitoring = false
Global $_monitorList[100]
Global $_monitorListCount = 0

;----------------------------------------------------------------------------
Func monitorInit()
	Dim $i, $j, $l

	$_monitorView = GUICtrlCreateListView("Identifier          |Name                    |Startup Type         |Status    ", 13, 31, $_cfgWidth - 47,  $_cfgHeight - 118)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
;	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)

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

	For $i = 0 to UBound($_selectedServices) - 1
		$l = ""
		For $j = 1 to 4
			$l = $l & $_selectedServices[$i][$j]
			If $j < 4 Then
				$l = $l & "|"
			EndIf
		Next
		$_monitorList[$_monitorListCount] = GUICtrlCreateListViewItem($l, $_monitorView)
		GUICtrlSetOnEvent($_monitorList[$_monitorListCount], "monitorItemPicked")
		$_monitorListCount = $_monitorListCount + 1
	Next




 	Local $StartButton = GUICtrlCreateButton("Start", 286, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
 	GUICtrlSetOnEvent($StartButton, "monitorStart")
 	GUICtrlSetTip($StartButton, "Start the selected services")

	Local $StopButton = GUICtrlCreateButton("Stop", 346, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($StopButton, "monitorStop")
	GUICtrlSetTip($StopButton, "Stop the selected services")

	Local $AutomaticButton = GUICtrlCreateButton("Automatic", 406, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($AutomaticButton, "monitorAutomatic")
	GUICtrlSetTip($AutomaticButton, "Set the selected services start to Automatic")

	Local $ManualButton = GUICtrlCreateButton("Manual", 466, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($ManualButton, "monitorManual")
	GUICtrlSetTip($ManualButton, "Set the selected services to start to Manual")

	Local $MonitorButton = GUICtrlCreateButton("Monitor", 526, $_cfgHeight - 82, 50, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent($MonitorButton, "monitorMonitor")
	GUICtrlSetTip($MonitorButton, "Monitor the selected completely")

	if IsAdmin() == 0 then
		GUICtrlSetState($AutomaticButton, $GUI_DISABLE)
		GUICtrlSetTip($AutomaticButton, "Automatic requires Administrator privileges")
		GUICtrlSetState($ManualButton, $GUI_DISABLE)
		GUICtrlSetTip($ManualButton, "Manual requires Administrator privileges")
	endif
EndFunc

;----------------------------------------------------------------------------
Func monitorItemPicked()
	Dim $item
	Dim $msg = @GUI_CTRLID
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
;~ 	GUICtrlSetState($GUIButton, $GUI_ENABLE)
;~ 	GUICtrlSetState($StartButton, $GUI_ENABLE)
;~ 	GUICtrlSetState($StopButton, $GUI_ENABLE)
;~ 	GUICtrlSetState($ReinstallButton, $GUI_ENABLE)
;~ 	GUICtrlSetState($ManualButton, $GUI_ENABLE)
;~ 	GUICtrlSetState($MonitorButton, $GUI_ENABLE)
EndFunc

;----------------------------------------------------------------------------
Func monitorGUI()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "Run GUI " & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func monitorStart()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "Start " & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func monitorStop()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "Stop " & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func monitorManual()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "Manual " & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func monitorAutomatic()
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
	MsgBox(64, "Action", "Automatic " & $_monitorSelected)
	_GUICtrlListView_ClickItem($_monitorView, $_monitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func monitorMonitor()
	$_monitorIsMonitoring = Not $_monitorIsMonitoring
;~ 	Dim $s
;~ 	If $_monitorIsMonitoring = True Then
;~ 		$s = "True"
;~ 	Else
;~ 		$s = "False"
;~ 	EndIf
;~ 	MsgBox(64, "Action", "Monitoring = " & $s)
EndFunc

;----------------------------------------------------------------------------
Func monitorUpdate()
	;GUICtrlSetData($_loggerEdit, $_logBuffer)
EndFunc

; end
