#include-once
#cs -------------------------------------------------------------------------

 Current list of Bridges tab

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

;----------------------------------------------------------------------------
Func guiMonitorInit()
	$_guiMonitorView = GUICtrlCreateListView("Name          |Description                    |Status         |Installed    ", 13, 31, 611, 305)
	;GUICtrlSetBkColor($_guiMonitorView, $GUI_BKCOLOR_LV_ALTERNATE)
	$i1 = GUICtrlCreateListViewItem("CHECK|Standard Check Bridge|Running|03/31/2013 14:23:32", $_guiMonitorView)
	GUICtrlSetOnEvent($i1, "guiMonitorItemPicked")
	;GUICtrlSetBkColor(-1, 0xf4f4f4)
	$i2 = GUICtrlCreateListViewItem("CVI|Standard CVI Bridge|Stopped|03/31/2013 14:34:06", $_guiMonitorView)
	GUICtrlSetOnEvent($i2, "guiMonitorItemPicked")
	;GUICtrlSetBkColor(-1, 0xf4f4f4)
	$i3 = GUICtrlCreateListViewItem("DOC_ID|Standard DOC_ID Bridge|Running|03/31/2013 14:40:52", $_guiMonitorView)
	GUICtrlSetOnEvent($i3, "guiMonitorItemPicked")

	Local $GUIButton = GUICtrlCreateButton("GUI", 226, 342, 50, 25)
	GUICtrlSetOnEvent($GUIButton, "guiMonitorGUI")
	GUICtrlSetTip($GUIButton, "Run the selected Bridge GUI")
	Local $StartButton = GUICtrlCreateButton("Start", 286, 342, 50, 25)
	GUICtrlSetOnEvent($StartButton, "guiMonitorStart")
	GUICtrlSetTip($StartButton, "Start the selected Bridge service")
	Local $StopButton = GUICtrlCreateButton("Stop", 346, 342, 50, 25)
	GUICtrlSetOnEvent($StopButton, "guiMonitorStop")
	GUICtrlSetTip($StopButton, "Stop the selected Bridge service")
	Local $ReinstallButton = GUICtrlCreateButton("Reinstall", 406, 342, 50, 25)
	GUICtrlSetOnEvent($ReinstallButton, "guiMonitorReinstall")
	GUICtrlSetTip($ReinstallButton, "Reinstall the selected Bridge service")
	Local $UninstallButton = GUICtrlCreateButton("Uninstall", 466, 342, 50, 25)
	GUICtrlSetOnEvent($UninstallButton, "guiMonitorUninstall")
	GUICtrlSetTip($UninstallButton, "Uninstall the selected Bridge service")
	Local $DeleteButton = GUICtrlCreateButton("Delete", 526, 342, 50, 25)
	GUICtrlSetOnEvent($DeleteButton, "guiMonitorDelete")
	GUICtrlSetTip($DeleteButton, "Delete the selected Bridge completely")
;~ 	GUICtrlSetState($GUIButton, $GUI_DISABLE)
;~ 	GUICtrlSetState($StartButton, $GUI_DISABLE)
;~ 	GUICtrlSetState($StopButton, $GUI_DISABLE)
;~ 	GUICtrlSetState($ReinstallButton, $GUI_DISABLE)
;~ 	GUICtrlSetState($UninstallButton, $GUI_DISABLE)
;~ 	GUICtrlSetState($DeleteButton, $GUI_DISABLE)
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
;~ 	GUICtrlSetState($DeleteButton, $GUI_ENABLE)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorGUI()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Bridge Action", "Run GUI " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorStart()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Bridge Action", "Start " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorStop()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Bridge Action", "Stop " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorUninstall()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Bridge Action", "Uninstall " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorReinstall()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Bridge Action", "Reinstall " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorDelete()
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
	MsgBox(64, "Bridge Action", "Delete " & $_guiMonitorSelected)
	_GUICtrlListView_ClickItem($_guiMonitorView, $_guiMonitorSelected)
EndFunc

;----------------------------------------------------------------------------
Func guiMonitorUpdate()
	;GUICtrlSetData($_guiLogEdit, $_logBuffer)
EndFunc





; end
