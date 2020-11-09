#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=res\manager-round-bronco.ico
#AutoIt3Wrapper_Res_Comment=Distributed under the MIT License
#AutoIt3Wrapper_Res_Description=Monitor & manage selected services
#AutoIt3Wrapper_Res_Fileversion=1.0.1.183
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=By Todd R. Hill, MIT License
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#AutoIt3Wrapper_Res_Field=ProductName|Corionis Service Manager
#AutoIt3Wrapper_Res_Field=ProgramName|Corionis Service Manager
#AutoIt3Wrapper_Res_Field=Timestamp|%date%
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-round-bronco.ico,1
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-round-blue.ico,2
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-round-green.ico,3
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-round-purple.ico,4
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-round-red.ico,5
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-round-white.ico,6
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-round-yellow.ico,7
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-square-bronco.ico,8
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-square-blue.ico,9
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-square-green.ico,10
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-square-purple.ico,11
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-square-red.ico,12
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-square-white.ico,13
#AutoIt3Wrapper_Res_Icon_Add=.\res\manager-square-yellow.ico,14
#AutoIt3Wrapper_Res_File_Add=.\res\about-header.jpg, rt_rcdata, ABOUT_HDR
#AutoIt3Wrapper_Run_After=echo @echo off >build_installer.bat
#AutoIt3Wrapper_Run_After=echo REM Use this to build the installer >>build_installer.bat
#AutoIt3Wrapper_Run_After=echo worker_build-installer.bat %fileversion% >>build_installer.bat
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
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <StringConstants.au3>
#include <TabConstants.au3>
#include <TrayConstants.au3>
#include <WindowsConstants.au3>

; application components
#include "globals.au3" ; must be include first
#include "about.au3"
#include "configuration.au3"
#include "logger.au3"
#include "monitor.au3"
#include "options.au3"
#include "restart.au3"
#include "select.au3"
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

LoggerAppend("-----------------------------------------------------------------------------------------------" & @CRLF)
LoggerAppend($_progActual & " " & $_build & "   " & $_buildDate & @CRLF & _
		"    Started " & _NowDate() & " " & _NowTime() & @CRLF & _
		"    Running from " & $cd & @CRLF)
If IsAdmin() == 0 Then
	LoggerAppend("    - User does not have Administrative privileges" & @CRLF)
Else
	LoggerAppend("    + User has Administrative privileges" & @CRLF)
EndIf

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

If $_cfgStartMinimized == True Then
	$_mode = $WIN_DOWN
	If $_cfgHideWhenMinimized == True Then
		GUISetState(@SW_HIDE, $_mainWindow)
	Else
		GUISetState(@SW_SHOWMINIMIZED, $_mainWindow)
	EndIf
Else
	GUISetState(@SW_SHOWNORMAL, $_mainWindow)
	$_mode = $WIN_UP
EndIf


$waitTime = $_cfgRefreshInterval
If $waitTime < 500 Then
	$waitTime = 500 ; less than 500 milliseconds consumes the CPU too much, 2000 or more is best
EndIf

MonitorSetMonitorButton($_cfgMonitoring)
LoggerAppend("Initial status of selected services:" & @CRLF)
Global $__cmsIsStartup = True

While 1
	UpdateMonitor()
	Sleep($waitTime)
WEnd

CloseProgram()

; Main
;============================================================================

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
	Local $aboutItem, $exitItem, $fileMenu, $helpMenu, $helpItem, $optionsMenu, $preferencesItem, $restartItem, $servicesItem

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

	GUICtrlCreateMenuItem("", $fileMenu) ; Create a separator line

	$exitItem = GUICtrlCreateMenuItem("E&xit", $fileMenu)
	GUICtrlSetOnEvent($exitItem, "ExitProgram")
	GUICtrlSetTip($exitItem, "End the program")

	; Help menu
	$helpMenu = GUICtrlCreateMenu("&Help")
	$helpItem = GUICtrlCreateMenuItem("&Online help ...", $helpMenu)
	GUICtrlSetOnEvent($helpItem, "ShowHelp")

	GUICtrlCreateMenuItem("", $helpMenu) ; Create a separator line

	$aboutItem = GUICtrlCreateMenuItem("&About ...", $helpMenu)
	GUICtrlSetOnEvent($aboutItem, "ShowAbout")

	; Tabbed Frame
	$_tabbedFrame = GUICtrlCreateTab(6, 6, $_cfgWidth - 13, $_cfgHeight - 56)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	; Initialize the tabs; Name must match that in InitTab exactly
	$_monitorTab = InitTab("&1 Monitor")
	$_selectTab = InitTab("&2 Select")
	$_optionsTab = InitTab("&3 Options")
	$_logTab = InitTab("&4 Runtime Log")

	; add accelerator keys for tabs
	Local $monitorDummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent($monitorDummy, "activateMonitor")

	Local $selectDummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent($selectDummy, "activateSelect")

	Local $optionsDummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent($optionsDummy, "activateOptions")

	Local $logDummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent($logDummy, "activateLog")

	Local $aAccelKeys[4][2] = [["!1", $monitorDummy], ["!2", $selectDummy], ["!3", $optionsDummy], ["!4", $logDummy]]
	GUISetAccelerators($aAccelKeys)

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
		Case $name = "&1 Monitor"
			MonitorInit()
		Case $name = "&2 Select"
			SelectInit()
		Case $name = "&3 Options"
			OptionsInit()
		Case $name = "&4 Runtime Log"
			LoggerInit()
	EndSelect

	; ReDim array
	ReDim $_tabs[UBound($_tabs) + 1]
	GUICtrlCreateTabItem("")

	Return $_tabs[$index]
EndFunc   ;==>InitTab


;----------------------------------------------------------------------------
Func activateMonitor()
	_GUICtrlTab_ActivateTab($_tabbedFrame, 0)
EndFunc   ;==>activateMonitor

;----------------------------------------------------------------------------
Func activateSelect()
	_GUICtrlTab_ActivateTab($_tabbedFrame, 1)
EndFunc   ;==>activateSelect

;----------------------------------------------------------------------------
Func activateOptions()
	_GUICtrlTab_ActivateTab($_tabbedFrame, 2)
EndFunc   ;==>activateOptions

;----------------------------------------------------------------------------
Func activateLog()
	_GUICtrlTab_ActivateTab($_tabbedFrame, 3)
EndFunc   ;==>activateLog

;----------------------------------------------------------------------------
Func InitTray()
	Opt("TrayOnEventMode", 1)
	Opt("TrayMenuMode", 1 + 2)
	Opt("TrayAutoPause", 0)

	; get the icon from the executable
	TraySetIcon(@ScriptFullPath, $_cfgIconIndex)
	TraySetClick(1 + 8)
	TraySetToolTip($_progTitle)

	Local $showAboutItem = TrayCreateItem("About " & $_progTitle & " ...")
	TrayItemSetOnEvent($showAboutItem, "ShowAbout")

	Local $resetAboutItem = TrayCreateItem("Reset screen position and size")
	TrayItemSetOnEvent($resetAboutItem, "ResetPosition")

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
Func ResetPosition()
	$_cfgLeft = -1
	$_cfgTop = -1
	$_cfgWidth = 534
	$_cfgHeight = 388

	$_cfgMonitorWidths = "262|70|86|64"
	Local $l = StringSplit($_cfgMonitorWidths, "|", $STR_NOCOUNT)
	For $i = 0 To $SVC_LAST
		_GUICtrlListView_SetColumnWidth($_monitorView, $i, Int($l[$i]))
	Next

	$_cfgSelectWidths = "262|70|86|64"
	$l = StringSplit($_cfgSelectWidths, "|", $STR_NOCOUNT)
	For $i = 0 To $SVC_LAST
		_GUICtrlListView_SetColumnWidth($_selectView, $i, Int($l[$i]))
	Next

	ConfigurationWriteRunning(True)
	_ScriptRestart()
EndFunc

;----------------------------------------------------------------------------
Func RestartProgram()
	Dim $bc = MsgBox($MB_OKCANCEL + $MB_ICONQUESTION, "Restart " & $_progName, "Are you sure you want to restart the " & $_progName & "?", 0, $_mainWindow)
	If $bc == $IDOK Then
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
Func ShowHelp()
	ShellExecute("https://corionis.github.io/CorionisServiceManager/help")
	TrayItemSetState($showHideItem, $TRAY_DEFAULT)
EndFunc   ;==>ShowAbout

;----------------------------------------------------------------------------
Func ShowHide()
	If $_mode <> $WIN_UP Then
		$_mode = $WIN_UP
		If $_cfgHideWhenMinimized == True Then
			GUISetState(@SW_SHOWNORMAL, $_mainWindow)
		Else
			GUISetState(@SW_RESTORE, $_mainWindow)
		EndIf
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

;----------------------------------------------------------------------------
Func UpdateMonitor()
	Dim $i, $j, $l, $start, $state, $stateDesc, $svc[$SVC_LAST]

	; protect running more than once concurrently
	If $_updateBusy == True Then
		Return
	EndIf
	$_updateBusy = True

	For $i = 0 To $_monitorListCtrlsCount - 1
		$l = GUICtrlRead($_monitorListCtrls[$i])
		$svc = StringSplit($l, "|", $STR_NOCOUNT)
		If $_cfgMonitoring == True Then
			$state = servicesIsRunning($_cfgHostname, $svc[$SVC_ID])
			$start = servicesGetStartTypeString(RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $svc[$SVC_ID], "Start"));
		Else
			$state = 2 ; unknown
		EndIf
		Select
			Case $state == 0
				$stateDesc = "Stopped"
			Case $state == 1
				$stateDesc = "Running"
			Case $state == 2
				$stateDesc = "-------"
		EndSelect
		If $svc[$SVC_STATUS] <> $stateDesc Or $svc[$SVC_START] <> $start Then
			If $svc[$SVC_STATUS] <> $stateDesc And $state <> 2 Then
				If $__cmsIsStartup == True Then
					LoggerAppend("    " & $svc[$SVC_NAME] & " starts " & $svc[$SVC_START] & " is " & $stateDesc & @CRLF)
				Else
					LoggerAppend(_NowDate() & " " & _NowTime() & " service " & $svc[$SVC_ID] & ": " & $svc[$SVC_NAME] & " | " & $svc[$SVC_START] & " | " & $stateDesc & @CRLF)
					If $_cfgDisplayNotifications == True Then
						TrayTip($_progTitle, $svc[$SVC_NAME] & " | " & $svc[$SVC_START] & " | " & $stateDesc, 30, (($state == 0) ? $TIP_ICONEXCLAMATION : $TIP_ICONASTERISK) + $TIP_NOSOUND)
					EndIf
				EndIf
				LoggerUpdate()
			EndIf
			If $svc[$SVC_START] <> $start Then
				$svc[$SVC_START] = $start
				If $__cmsIsStartup == True Then
					LoggerAppend("    " & $svc[$SVC_NAME] & " start type " & $svc[$SVC_START] & " is now " & $start & @CRLF)
				Else
					LoggerAppend(_NowDate() & " " & _NowTime() & " service " & $svc[$SVC_ID] & ": " & $svc[$SVC_NAME] & " | " & $svc[$SVC_START] & " | " & $stateDesc & @CRLF)
					If $_cfgDisplayNotifications == True Then
						TrayTip($_progTitle, $svc[$SVC_NAME] & " | " & $svc[$SVC_START] & " | " & $stateDesc, 30, (($state == 0) ? $TIP_ICONEXCLAMATION : $TIP_ICONASTERISK) + $TIP_NOSOUND)
					EndIf
				EndIf
				LoggerUpdate()
			EndIf
			$svc[$SVC_STATUS] = $stateDesc
			$l = ""
			For $j = 0 To $SVC_LAST
				$l = $l & $svc[$j]
				If $j < $SVC_LAST Then
					$l = $l & "|"
				EndIf
			Next
			GUICtrlSetData($_monitorListCtrls[$i], $l)
			Select
				Case $state == 0
					GUICtrlSetColor($_monitorListCtrls[$i], $_cfgStoppedTextColor)
					GUICtrlSetBkColor($_monitorListCtrls[$i], $_cfgStoppedBackColor)
				Case $state == 1
					GUICtrlSetColor($_monitorListCtrls[$i], $_cfgRunningTextColor)
					GUICtrlSetBkColor($_monitorListCtrls[$i], $_cfgRunningBackColor)
				Case $state == 2
					GUICtrlSetColor($_monitorListCtrls[$i], 0x000000)
					GUICtrlSetBkColor($_monitorListCtrls[$i], 0xffffff)
			EndSelect
		EndIf
		;MsgBox(64, "Service", $i & " = " & $l)
	Next
	; show a (hopefully) helpful dialog at startup if no services have been selected
	If $__cmsIsStartup == True Then
		If $_monitorListCtrlsCount < 1 Then
			MsgBox($MB_OK + $MB_ICONINFORMATION, $_progTitle, "To get started - first go to the Select tab to choose services to monitor. Then on the Monitor tab click the Monitor button to toggle active monitoring on/off.", 0, $_mainWindow)
		EndIf
		$__cmsIsStartup = False
		LoggerAppend("Service status monitor begins:" & @CRLF)
		LoggerUpdate()
	EndIf
	$_updateBusy = False
EndFunc   ;==>UpdateMonitor



; end
