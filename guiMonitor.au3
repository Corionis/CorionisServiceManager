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
Global $_guiMonitorView
Global $i1, $i2, $i3
Global $_guiMonitorSelected = -1
Global $_guiMonitorIsMonitoring = false
Global $_guiMonitorList[100]
Global $_guiMonitorListCount = 0

;----------------------------------------------------------------------------
Func guiMonitorInit()
	Dim $i, $j, $l

	$_guiMonitorView = GUICtrlCreateListView("Identifier          |Name                    |Startup Type         |Status    ", 13, 31, 611, 305)

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
		$_guiMonitorList[$_guiMonitorListCount] = GUICtrlCreateListViewItem($l, $_guiMonitorView)
		GUICtrlSetOnEvent($_guiMonitorList[$_guiMonitorListCount], "guiMonitorItemPicked")
		$_guiMonitorListCount = $_guiMonitorListCount + 1
	Next




	Local $StartButton = GUICtrlCreateButton("Start", 286, 342, 50, 25)
	GUICtrlSetOnEvent($StartButton, "guiMonitorStart")
	GUICtrlSetTip($StartButton, "Start the selected service")
	Local $StopButton = GUICtrlCreateButton("Stop", 346, 342, 50, 25)
	GUICtrlSetOnEvent($StopButton, "guiMonitorStop")
	GUICtrlSetTip($StopButton, "Stop the selected service")
	Local $ReinstallButton = GUICtrlCreateButton("Reinstall", 406, 342, 50, 25)
	GUICtrlSetOnEvent($ReinstallButton, "guiMonitorReinstall")
	GUICtrlSetTip($ReinstallButton, "Reinstall the selected service")
	Local $UninstallButton = GUICtrlCreateButton("Uninstall", 466, 342, 50, 25)
	GUICtrlSetOnEvent($UninstallButton, "guiMonitorUninstall")
	GUICtrlSetTip($UninstallButton, "Uninstall the selected service")
	Local $MonitorButton = GUICtrlCreateButton("Monitor", 526, 342, 50, 25)
	GUICtrlSetOnEvent($MonitorButton, "guiMonitorMonitor")
	GUICtrlSetTip($MonitorButton, "Monitor the selected completely")
;~ 	GUICtrlSetState($GUIButton, $GUI_DISABLE)
;~ 	GUICtrlSetState($StartButton, $GUI_DISABLE)
;~ 	GUICtrlSetState($StopButton, $GUI_DISABLE)
;~ 	GUICtrlSetState($ReinstallButton, $GUI_DISABLE)
;~ 	GUICtrlSetState($UninstallButton, $GUI_DISABLE)
;~ 	GUICtrlSetState($MonitorButton, $GUI_DISABLE)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorItemPicked()
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
	$_guiMonitorSelected = $item
	;MsgBox(64, "Item Picked", "Item " & $item & " was picked")
;~ 	GUICtrlSetState($GUIButton, $GUI_ENABLE)
;~ 	GUICtrlSetState($StartButton, $GUI_ENABLE)
;~ 	GUICtrlSetState($StopButton, $GUI_ENABLE)
;~ 	GUICtrlSetState($ReinstallButton, $GUI_ENABLE)
;~ 	GUICtrlSetState($UninstallButton, $GUI_ENABLE)
;~ 	GUICtrlSetState($MonitorButton, $GUI_ENABLE)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorGUI()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Action", "Run GUI " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorStart()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Action", "Start " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorStop()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Action", "Stop " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorUninstall()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Action", "Uninstall " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorReinstall()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Action", "Reinstall " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorMonitor()
	$_guiMonitorIsMonitoring = Not $_guiMonitorIsMonitoring
;~ 	Dim $s
;~ 	If $_guiMonitorIsMonitoring = True Then
;~ 		$s = "True"
;~ 	Else
;~ 		$s = "False"
;~ 	EndIf
;~ 	MsgBox(64, "Action", "Monitoring = " & $s)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorUpdate()
	;GUICtrlSetData($_guiLogEdit, $_logBuffer)
EndFunc

; end
