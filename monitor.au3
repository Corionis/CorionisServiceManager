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
#include "globals.au3" ; must be include first

;----------------------------------------------------------------------------
; globals
Global $_monitorSelected = -1
Global $MonitorButton
Global $WORK_TYPE = 1
Global $WORK_START = 2
Global $WORK_STOP = 3

;----------------------------------------------------------------------------
Func MonitorInit()
	Dim $i, $j, $l

	$_monitorView = GUICtrlCreateListView("      Name                                                 |Identifier |Startup Type |Status ", _
		13, 31, $_cfgWidth - 29, $_cfgHeight - 118, _
		BitOR($LVS_REPORT, $LVS_SINGLESEL), BitOR($LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT, $WS_EX_CLIENTEDGE))
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	monitorPopulate()
	If $_selectedServicesCount > 0 Then
		monitorPopulate()
	EndIf

	If StringLen($_cfgMonitorWidths) > 0 Then
		$l = StringSplit($_cfgMonitorWidths, "|", $STR_NOCOUNT)
		For $i = 0 To $SVC_LAST
			_GUICtrlListView_SetColumnWidth($_monitorView, $i, Int($l[$i]))
		Next
	EndIf

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

	If IsAdmin() == 0 Then
		GUICtrlSetState($AutomaticButton, $GUI_DISABLE)
		GUICtrlSetTip($AutomaticButton, "Automatic requires Administrator privileges")
		GUICtrlSetState($ManualButton, $GUI_DISABLE)
		GUICtrlSetTip($ManualButton, "Manual requires Administrator privileges")
		GUICtrlSetState($DisableButton, $GUI_DISABLE)
		GUICtrlSetTip($DisableButton, "Disable requires Administrator privileges")
	EndIf
EndFunc   ;==>MonitorInit

;----------------------------------------------------------------------------
Func monitorPopulate()
	Local $i, $l
	; remove any existing list view items
	If $_monitorListCtrlsCount > 0 Then
		For $i = 0 To $_monitorListCtrlsCount - 1
			GUICtrlDelete($_monitorListCtrls[$i])
		Next
		$_monitorListCtrlsCount = 0
	EndIf
	; reset data
	If $_monitorListCtrlsCount == 0 Or UBound($_monitorListCtrls) == 0 Then
		ReDim $_monitorListCtrls[$SVC_MAX]
		$_monitorListCtrlsCount = 0
	EndIf
	; create list view items one per service
	For $i = 0 To $_selectedServicesCount - 1
		$l = $_selectedServices[$i]
		$_monitorListCtrls[$_monitorListCtrlsCount] = GUICtrlCreateListViewItem($l, $_monitorView)
		GUICtrlSetOnEvent($_monitorListCtrls[$_monitorListCtrlsCount], "monitorItemPicked")
		$_monitorListCtrlsCount = $_monitorListCtrlsCount + 1
	Next
	ReDim $_monitorListCtrls[$_monitorListCtrlsCount]
EndFunc   ;==>monitorPopulate

;----------------------------------------------------------------------------
Func monitorItemPicked()
;~ 	Dim $item = @GUI_CtrlId
;~ 	$_monitorSelected = $item
;~ 	MsgBox(64, "Item Picked", "Item " & $item & " was picked")
EndFunc   ;==>monitorItemPicked

;----------------------------------------------------------------------------
Func monitorAll()
	Local $i
	For $i = 0 To $_monitorListCtrlsCount - 1
		GUICtrlSetState($_monitorListCtrls[$i], $GUI_CHECKED)
	Next
EndFunc   ;==>monitorAll

;----------------------------------------------------------------------------
Func monitorNone()
	Local $i
	For $i = 0 To $_monitorListCtrlsCount - 1
		GUICtrlSetState($_monitorListCtrls[$i], $GUI_UNCHECKED)
	Next
EndFunc   ;==>monitorNone

;----------------------------------------------------------------------------
Func monitorStart()
	monitorWork($WORK_START, 0)
EndFunc   ;==>monitorStart

;----------------------------------------------------------------------------
Func monitorStop()
	monitorWork($WORK_STOP, 0)
EndFunc   ;==>monitorStop

;----------------------------------------------------------------------------
Func monitorAutomatic()
	monitorWork($WORK_TYPE, $SERVICE_AUTO_START)
EndFunc   ;==>monitorAutomatic

;----------------------------------------------------------------------------
Func monitorManual()
	monitorWork($WORK_TYPE, $SERVICE_DEMAND_START)
EndFunc   ;==>monitorManual

;----------------------------------------------------------------------------
Func monitorDisable()
	monitorWork($WORK_TYPE, $SERVICE_DISABLED)
EndFunc   ;==>monitorDisable

;----------------------------------------------------------------------------
Func monitorMonitor()
	If $_cfgMonitoring == True Then
		$_cfgMonitoring = False
		LoggerAppend(_NowDate() & " " & _NowTime() & " monitoring off " & @CRLF)
	Else
		$_cfgMonitoring = True
		LoggerAppend(_NowDate() & " " & _NowTime() & " monitoring on " & @CRLF)
	EndIf
	MonitorSetMonitorButton($_cfgMonitoring)
	UpdateMonitor()
	LoggerUpdate()
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
EndFunc   ;==>MonitorSetMonitorButton

;----------------------------------------------------------------------------
Func monitorWork($op, $type)
	Local $i, $id, $it, $l, $svc, $worked = False
	For $i = 0 To $_monitorListCtrlsCount - 1
		If _GUICtrlListView_GetItemChecked($_monitorView, $i) == True Then
			$it = _GUICtrlListView_GetItem($_monitorView, $i)
			$l = GUICtrlRead($it[5]) ; use the item id to get the line regardless of the sort
			$svc = StringSplit($l, "|", $STR_NOCOUNT)
			$id = $svc[$SVC_ID]
			If $op == $WORK_TYPE Then
				If RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $id, "Start", "REG_DWORD", $type) == 0 Then
					MsgBox($MB_OK + $MB_ICONERROR, "Set Startup Type Failed", "Set Startup Type for " & $svc[$SVC_NAME] & " failed with code " & @error)
					Return
				EndIf
				$svc[$SVC_START] = servicesGetStartTypeString($type)
			EndIf
			If $op == $WORK_START Then
				If servicesStartService($_cfgHostname, $id) == 0 Then
					MsgBox($MB_OK + $MB_ICONERROR, "Start Failed", "Start failed for " & $id & " with code " & @error)
					Return
				EndIf
			EndIf
			If $op == $WORK_STOP Then
				If servicesStopService($_cfgHostname, $id) == 0 Then
					MsgBox($MB_OK + $MB_ICONERROR, "Stop Failed", "Stop failed for " & $id & " with code " & @error)
					Return
				EndIf
			EndIf
			$l = ""
			$svc[$SVC_STATUS] = "?" ; change service status so the monitor refreshes
			$l = _ArrayToString($svc, "|")
			GUICtrlSetData($_monitorListCtrls[$i], $l)
			$worked = True
		EndIf
	Next
	If $worked == False Then
		MsgBox($MB_OK + $MB_ICONINFORMATION, $_progTitle, "No checkboxes are checked - nothing to do.", 0, $_mainWindow)
	EndIf
	UpdateMonitor()
EndFunc   ;==>monitorStop


; end
