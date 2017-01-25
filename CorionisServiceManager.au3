#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Comment=MIT License
#AutoIt3Wrapper_Res_Description=Manage selected Windows Services
#AutoIt3Wrapper_Res_Fileversion=1.0.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Copyright (c) 2017 Todd R. Hill
#AutoIt3Wrapper_Res_Field=ProductName|Corionis Service Manager
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs -------------------------------------------------------------------------

	Corionis Service Manager

	AutoIt Version: 3.3.14.2

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

;----------------------------------------------------------------------------
; Includes
#include <Array.au3>
#include <Constants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>

; application components
#include "pan.au3"						; must be include first
#include "build.au3"
#include "configuration.au3"
#include "guiAbout.au3"
#include "guiMonitor.au3"
#include "guiList.au3"
#include "guiLog.au3"
#include "Restart.au3"					; 3rd party function
#include "services.au3"

;----------------------------------------------------------------------------
; Globals
Global $_mode = 0
Global $_progName = "Corionis Service Manager "
Global $_progTitle = $_progName & $_build

Global $_returnMsg = ""
Global $_returnValue = 0


;============================================================================
; Main

InitMainWindow()

CheckAdmin()
If $_panErrorValue <> 0 Then
	$_returnValue = $_panErrorValue
	$_returnMsg = $_panErrorMsg
	CloseProgram()
EndIf

ParseOptions()
If $_panErrorValue <> 0 Then
	$_returnValue = $_panErrorValue
	$_returnMsg = $_panErrorMsg
	CloseProgram()
EndIf

configurationReadConfig()
If $_panErrorValue <> 0 Then
	$_returnValue = $_panErrorValue
	$_returnMsg = $_panErrorMsg
EndIf

servicesReadAll()
If $_panErrorValue <> 0 Then
	$_returnValue = $_panErrorValue
	$_returnMsg = $_panErrorMsg
EndIf

guiLogUpdate()
If $_panErrorValue <> 0 Then
	GUICtrlSetState($_logTab, $GUI_SHOW)
	$_panErrorValue = 0
	$_panErrorMsg = ""
EndIf

; guiListMakeTree()

GUISetState()
While 1
	Sleep(1000)
WEnd

CloseProgram()

; Main
;============================================================================

;----------------------------------------------------------------------------
Func CheckAdmin()
;~ 	If IsAdmin() <> 1 Then
;~ 		MsgBox(16 + 4096, $_progTitle, "You must have Administrator privileges to run this program.")
;~ 		$_panErrorValue = 3
;~ 		$_panErrorMsg = "Must have Administrator privileges"
;~ 	EndIf
EndFunc   ;==>CheckAdmin

;----------------------------------------------------------------------------
Func CloseProgram()
	; Note: at this point @GUI_CTRLID would equal $GUI_EVENT_CLOSE,
	; and @GUI_WINHANDLE would equal $_mainWindow
	;;;MsgBox(0, "GUI Event", "CLOSE clicked, Exiting...")
	Exit $_returnValue
EndFunc   ;==>CloseProgram

;----------------------------------------------------------------------------
Func InitMainWindow()
	Local $aboutItem, $exitItem, $fileMenu, $helpMenu, $restartItem

	Opt("GUICloseOnESC", 0)
	Opt("GUIOnEventMode", 1)

	; Main Window
	$_mainWindow = GUICreate($_progTitle, 638, 400)
	GUISetIcon("res\manager.ico")
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	; Basic events
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseProgram")

	; Menu
	$fileMenu = GUICtrlCreateMenu("&File")
	$restartItem = GUICtrlCreateMenuItem("&Restart/Reload ...", $fileMenu)
	GUICtrlSetOnEvent($restartItem, "RestartProgram")
	GUICtrlSetTip($restartItem, "Restart the " & $_progName)
	GUICtrlCreateMenuItem("", $fileMenu) ; Create a separator line1
	$exitItem = GUICtrlCreateMenuItem("E&xit", $fileMenu)
	GUICtrlSetOnEvent($exitItem, "CloseProgram")

	$helpMenu = GUICtrlCreateMenu("&Help")
	$aboutItem = GUICtrlCreateMenuItem("&About ...", $helpMenu)
	GUICtrlSetOnEvent($aboutItem, "ShowGuiAbout")

	; Tabbed Frame
	$_tabbedFrame = GUICtrlCreateTab(8, 6, 624, 369)

	; name must match that in InitTab
	$_monitorTab = InitTab("Monitor")
	$_listTab = InitTab("Select")
	$_logTab = InitTab("Runtime Log")

EndFunc   ;==>InitMainWindow

;----------------------------------------------------------------------------
Func InitTab($name)
	Local $index

	$index = UBound($_tabs) - 1
	$_tabs[$index] = GUICtrlCreateTabItem($name)

	; initialize the content of the tab before GUICtrlCreateTabItem
	Select
		Case $name = "Monitor"
			guiMonitorInit()
		Case $name = "Select"
			guiListInit()
		Case $name = "Runtime Log"
			guiLogInit()
	EndSelect

	; ReDim array
	ReDim $_tabs[UBound($_tabs) + 1]
	GUICtrlCreateTabItem("")

	Return $_tabs[$index]
EndFunc   ;==>InitTab

;----------------------------------------------------------------------------
Func ParseOptions()
	Dim $l, $opt
	$l = $CmdLine[0]
	For $j = 1 To $l
		$opt = $CmdLine[$j]
		If $opt == "-B" Then
			$_mode = 1
		EndIf
	Next
EndFunc   ;==>ParseOptions

;----------------------------------------------------------------------------
Func RestartProgram()
	Dim $bc = MsgBox(1 + 32, "Restart " & $_progName, "Are you sure you want to restart the " & $_progName & "?")
	If $bc = 1 Then
		_ScriptRestart()
	EndIf
EndFunc   ;==>RestartProgram

;----------------------------------------------------------------------------
Func ShowGuiAbout()
	guiAbout()
EndFunc   ;==>ShowGuiAbout


; end
