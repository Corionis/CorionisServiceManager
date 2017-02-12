#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=res\manager.ico
#AutoIt3Wrapper_Res_Comment=Distributed under the MIT License
#AutoIt3Wrapper_Res_Description=Monitor & manage selected services
#AutoIt3Wrapper_Res_Fileversion=1.0.0.43
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=By Todd R. Hill, MIT License
#AutoIt3Wrapper_Res_Field=ProductName|Corionis Service Manager
#AutoIt3Wrapper_Res_Icon_Add=D:\Users\trh\Work\corionis\git\corionis\CorionisServiceManager\res\manager-orange.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\Users\trh\Work\corionis\git\corionis\CorionisServiceManager\res\manager-green.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\Users\trh\Work\corionis\git\corionis\CorionisServiceManager\res\manager-purple.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\Users\trh\Work\corionis\git\corionis\CorionisServiceManager\res\manager-red.ico
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
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
#include <TrayConstants.au3>
#include <WindowsConstants.au3>

; application components
#include "pan.au3" ; must be include first
#include "about.au3"
#include "configuration.au3"
#include "control.au3"
#include "logger.au3"
#include "monitor.au3"
#include "preferences.au3"
#include "restart.au3"
#include "services.au3"

;----------------------------------------------------------------------------
; Globals
Global $showHideItem
Global $_returnMsg = ""
Global $_returnValue = 0
Global $_updateBusy = False

;============================================================================
; Main
Dim $cd = @ScriptDir
Dim $waitTime

LoggerAppend($_progActual & " " & $_build & @CRLF & _
		"    Started " & _NowDate() & " " & _NowTime() & @CRLF & _
		"    Running from " & $cd & @CRLF)

ParseOptions()
If $_returnValue <> 0 Then
	CloseProgram()
EndIf

ConfigurationReadConfig()
If $_returnValue <> 0 Then
	CloseProgram()
EndIf

InitMainWindow() ; done after configuration so the title may be changed before window created

LoggerUpdate()
If $_returnValue <> 0 Then
	GUICtrlSetState($_logTab, $GUI_SHOW)
	$_returnValue = 0
	$_returnMsg = ""
	CloseProgram()
EndIf

GUISetState(@SW_SHOWNORMAL, $_mainWindow)
$_mode = $WIN_UP

$waitTime = $_cfgRefreshInterval
If $waitTime < 500 Then
	$waitTime = 500 ; less than 500 milliseconds consumes the CPU too much, 2000 or more is best
EndIf

MonitorSetMonitorButton($_cfgMonitoring)

While 1
	UpdateMonitor()
	Sleep($waitTime)
WEnd

CloseProgram()

; Main
;============================================================================

Func UpdateMonitor()
	Dim $i, $j, $l, $state, $desc, $svc[5]

	; protect running more than once concurrently
	If $_updateBusy == True Then
		Return
	EndIf
	$_updateBusy = True

	For $i = 0 To $_monitorListCount - 1
		$l = GUICtrlRead($_monitorList[$i])
		$svc = StringSplit($l, "|", $STR_NOCOUNT)
		If $_cfgMonitoring == True Then
			$state = _ServiceRunning("", $svc[0])
		Else
			$state = 2
		EndIf
		Select
			Case $state == 0
				$desc = "Stopped"
			Case $state == 1
				$desc = "Running"
			Case $state == 2
				$desc = "-------"
		EndSelect
		If $svc[3] <> $desc Then
			$svc[3] = $desc
			$l = ""
			For $j = 0 To 3
				$l = $l & $svc[$j]
				If $j < 3 Then
					$l = $l & "|"
				EndIf
			Next
			GUICtrlSetData($_monitorList[$i], $l)
			Select
				Case $state == 0
					GUICtrlSetColor($_monitorList[$i], $_cfgStoppedTextColor)
					GUICtrlSetBkColor($_monitorList[$i], $_cfgStoppedBackColor)
				Case $state == 1
					GUICtrlSetColor($_monitorList[$i], $_cfgRunningTextColor)
					GUICtrlSetBkColor($_monitorList[$i], $_cfgRunningBackColor)
				Case $state == 2
					GUICtrlSetColor($_monitorList[$i], 0x000000)
					GUICtrlSetBkColor($_monitorList[$i], 0xffffff)
			EndSelect
		EndIf
		;MsgBox(64, "Service", $i & " = " & $l)
	Next
	$_updateBusy = False
EndFunc   ;==>UpdateMonitor

;----------------------------------------------------------------------------
Func CloseProgram()
	If $_cfgMinimizeOnClose == True Then
		Minimize()
	Else
		ExitProgram()
	EndIf
EndFunc   ;==>CloseProgram

;----------------------------------------------------------------------------
Func ExitProgram()
	; Note: at this point @GUI_CTRLID would equal $GUI_EVENT_CLOSE,
	; and @GUI_WINHANDLE would equal $_mainWindow
	;;;MsgBox(0, "GUI Event", "CLOSE clicked, Exiting...")

	If $_mode <> $WIN_NOTUP Then
		; capture coordinates & state
		ConfigurationWriteRunning(False)
	EndIf

	If $_returnValue <> 0 Then
		LoggerAppend($_returnMsg)
		MsgBox($MB_ICONERROR, $_progName, "Problem occurred with " & $_progActual & @CRLF & @CRLF & $_returnMsg)
	EndIf
	Exit $_returnValue
EndFunc   ;==>ExitProgram

;----------------------------------------------------------------------------
Func InitMainWindow()
	Local $aboutItem, $exitItem, $fileMenu, $helpMenu, $optionsMenu, $preferencesItem, $restartItem, $servicesItem

	Opt("GUIOnEventMode", 1)
	If $_cfgEscapeCloses == True Then
		Opt("GUICloseOnESC", 1)
	Else
		Opt("GUICloseOnESC", 0)
	EndIf

	InitTray()

	; Main Window
	$_mainWindow = GUICreate($_progTitle, $_cfgWidth, $_cfgHeight, $_cfgLeft, $_cfgTop, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX + $WS_SYSMENU)
	GUISetIcon(@ScriptFullPath, $_cfgIconIndex, $_mainWindow)

	; Basic events
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseProgram", $_mainWindow)
	GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Maximize", $_mainWindow)
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "Minimize", $_mainWindow)
	GUISetOnEvent($GUI_EVENT_RESTORE, "Restore", $_mainWindow)

	; File menu
	$fileMenu = GUICtrlCreateMenu("&File")

	$restartItem = GUICtrlCreateMenuItem("&Restart ...", $fileMenu)
	GUICtrlSetOnEvent($restartItem, "RestartProgram")
	GUICtrlSetTip($restartItem, "Restart the " & $_progName)

	GUICtrlCreateMenuItem("", $fileMenu) ; Create a separator line1

	$exitItem = GUICtrlCreateMenuItem("E&xit", $fileMenu)
	GUICtrlSetOnEvent($exitItem, "ExitProgram")
	GUICtrlSetTip($exitItem, "End the program")

	; Options menu
	$optionsMenu = GUICtrlCreateMenu("&Options")

	$preferencesItem = GUICtrlCreateMenuItem("&Preferences", $optionsMenu)
	GUICtrlSetOnEvent($preferencesItem, "ShowPreferences")
	GUICtrlSetTip($preferencesItem, "Set user preferences")

	$servicesItem = GUICtrlCreateMenuItem("S&elect Services", $optionsMenu)
	GUICtrlSetOnEvent($servicesItem, "ShowServices")
	GUICtrlSetTip($servicesItem, "Set user preferences")

	; Help menu
	$helpMenu = GUICtrlCreateMenu("&Help")
	$aboutItem = GUICtrlCreateMenuItem("&About ...", $helpMenu)
	GUICtrlSetOnEvent($aboutItem, "ShowAbout")

	; Tabbed Frame
	$_tabbedFrame = GUICtrlCreateTab(6, 6, $_cfgWidth - 13, $_cfgHeight - 56)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	; name must match that in InitTab
	$_monitorTab = InitTab("Monitor")
	$_logTab = InitTab("Runtime Log")
EndFunc   ;==>InitMainWindow

;----------------------------------------------------------------------------
Func InitTab($name)
	Local $index

	; add a new tab; this technique allows easy addition of tabs
	$index = UBound($_tabs) - 1
	$_tabs[$index] = GUICtrlCreateTabItem($name)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	; initialize the content of the tab before GUICtrlCreateTabItem
	Select
		Case $name = "Monitor"
			MonitorInit()
		Case $name = "Runtime Log"
			LoggerInit()
	EndSelect

	; ReDim array
	ReDim $_tabs[UBound($_tabs) + 1]
	GUICtrlCreateTabItem("")

	Return $_tabs[$index]
EndFunc   ;==>InitTab


;----------------------------------------------------------------------------
Func InitTray()
	Opt("TrayOnEventMode", 1)
	Opt("TrayMenuMode", 1 + 2)
	Opt("TrayAutoPause", 0)

	; get the icon from the executable
	TraySetIcon(@ScriptFullPath, $_cfgIconIndex)
	TraySetClick(1 + 8)

	Local $showAboutItem = TrayCreateItem("About " & $_progTitle & " ...")
	TrayItemSetOnEvent($showAboutItem, "ShowAbout")

	$showHideItem = TrayCreateItem("Show/Hide (double-click)")
	TrayItemSetOnEvent($showHideItem, "ShowHide")
	TrayItemSetState($showHideItem, $TRAY_DEFAULT)

	TrayCreateItem("")

	Local $exitItem = TrayCreateItem("Exit")
	TrayItemSetOnEvent($exitItem, "ExitProgram")
EndFunc   ;==>InitTray

;----------------------------------------------------------------------------
Func ParseOptions()
	Local $cd = @ScriptDir, $p
	Local $l, $opt
	$l = $CmdLine[0]
	For $j = 1 To $l
		$opt = $CmdLine[$j]
		; -c [path]configuration.ini file
		If $opt == "-c" Then
			If $j < $l Then
				$j = $j + 1
				$_configurationFilePath = $cmdLine[$j]
				$_configurationFilePath = StringReplace($_configurationFilePath, "/", "\")
				; if there is more than one segment then it has a path
				$p = StringSplit($_configurationFilePath, "\")
				If $p[0] == 1 Then
					; only one segment so prepend the path to this executable
					$_configurationFilePath = $cd & "\" & $_configurationFilePath
				EndIf
				; check that the file exists
				If FileExists($_configurationFilePath) == 0 Then
					$_returnMsg = $_configurationFilePath & " configuration file not found" & @CRLF
					$_returnValue = $STAT_ERROR
					Return
				EndIf
			Else
				$_returnMsg = "The -c option must be followed by the path to a configuration file." & @CRLF & "Example:  -c C:\Users\Batman\My Bat Computer.ini"
				$_returnValue = $STAT_ERROR
				Return
			EndIf
		EndIf
	Next
EndFunc   ;==>ParseOptions

;----------------------------------------------------------------------------
Func RestartProgram()
	Dim $bc = MsgBox(1 + 32, "Restart " & $_progName, "Are you sure you want to restart the " & $_progName & "?", 0, $_mainWindow)
	If $bc == 1 Then
		; capture coordinates & state
		ConfigurationWriteRunning(False)
		_ScriptRestart()
	EndIf
EndFunc   ;==>RestartProgram

;----------------------------------------------------------------------------
Func ShowAbout()
	about()
	TrayItemSetState($showHideItem, $TRAY_DEFAULT)
EndFunc   ;==>ShowAbout

;----------------------------------------------------------------------------
Func ShowHide()
	If $_mode <> $WIN_UP Then
		If $_cfgHideWhenMinimized == True Then
			GUISetState(@SW_SHOWNORMAL, $_mainWindow)
		Else
			GUISetState(@SW_RESTORE, $_mainWindow)
		EndIf
		$_mode = $WIN_UP
	Else
		$_mode = $WIN_DOWN
		If $_cfgHideWhenMinimized == True Then
			GUISetState(@SW_HIDE, $_mainWindow)
		Else
			GUISetState(@SW_MINIMIZE, $_mainWindow)
		EndIf
	EndIf
	TrayItemSetState($showHideItem, $TRAY_DEFAULT)
EndFunc   ;==>ShowHide

;----------------------------------------------------------------------------
Func Maximize()
	$_mode = $WIN_UP
EndFunc   ;==>Maximize

;----------------------------------------------------------------------------
Func Minimize()
	If $_cfgHideWhenMinimized == True Then
		GUISetState(@SW_HIDE, $_mainWindow)
	Else
		GUISetState(@SW_MINIMIZE, $_mainWindow)
	EndIf
	$_mode = $WIN_DOWN
	TrayItemSetState($showHideItem, $TRAY_DEFAULT)
EndFunc   ;==>Minimize

;----------------------------------------------------------------------------
Func Restore()
	$_mode = $WIN_UP
EndFunc   ;==>Restore

;----------------------------------------------------------------------------
Func ShowPreferences()
	about()
EndFunc   ;==>ShowPreferences

;----------------------------------------------------------------------------
Func ShowServices()
	about()
EndFunc   ;==>ShowServices


; end
