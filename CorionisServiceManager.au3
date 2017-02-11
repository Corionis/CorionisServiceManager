#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=res\manager.ico
#AutoIt3Wrapper_Res_Comment=MIT License
#AutoIt3Wrapper_Res_Description=Monitor & manage selected services
#AutoIt3Wrapper_Res_Fileversion=1.0.0.19
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=By Todd R. Hill, MIT license
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
#include "pan.au3" ; must be include first
#include "about.au3"
#include "configuration.au3"
#include "control.au3"
#include "logger.au3"
#include "monitor.au3"
#include "options.au3"
#include "restart.au3"
#include "services.au3"

;----------------------------------------------------------------------------
; Globals

Global $_returnMsg = ""
Global $_returnValue = 0

;============================================================================
; Main
Dim $cd = @ScriptDir
Dim $waitTime

loggerAppend($_progActual & " " & $_build & @CRLF & _
	"    Started " & _NowDate() & " " & _NowTime() & @CRLF & _
	"    Running from " & $cd & @CRLF )

ParseOptions()
If $_returnValue <> 0 Then
	CloseProgram()
EndIf

configurationReadConfig()
If $_returnValue <> 0 Then
	CloseProgram()
EndIf

InitMainWindow() ; done after configuration so the title may be changed before window created

loggerUpdate()
If $_returnValue <> 0 Then
	GUICtrlSetState($_logTab, $GUI_SHOW)
	$_returnValue = 0
	$_returnMsg = ""
	CloseProgram()
EndIf

GUISetState()
$_mode = $WIN_UP

$waitTime = $_cfgRefreshInterval
If $waitTime < 500 Then
	$waitTime = 500 ; less than 500 milliseconds consumes the CPU too much, 2000 or more is best
EndIf

While 1
	Sleep($waitTime)
	UpdateMonitor()
WEnd

CloseProgram()

; Main
;============================================================================

Func UpdateMonitor()
	Dim $i, $j, $l, $state, $svc[5]
	If $_monitorIsMonitoring == True Then
		For $i = 0 To $_monitorListCount - 1
			$l = GUICtrlRead($_monitorList[$i])
			$svc = StringSplit($l, "|", $STR_NOCOUNT)
			$j = _ServiceRunning("", $svc[0])
			If $j == 1 Then
				$state = "Running"
			Else
				$state = "Stopped"
			EndIf
			If $svc[3] <> $state Then
				$svc[3] = $state
				$l = ""
				For $j = 0 To 3
					$l = $l & $svc[$j]
					If $j < 3 Then
						$l = $l & "|"
					EndIf
				Next
				GUICtrlSetData($_monitorList[$i], $l)
			EndIf
			;MsgBox(64, "Service", $i & " = " & $l)
		Next
	EndIf

EndFunc   ;==>UpdateMonitor

;----------------------------------------------------------------------------
Func CloseProgram()
	; Note: at this point @GUI_CTRLID would equal $GUI_EVENT_CLOSE,
	; and @GUI_WINHANDLE would equal $_mainWindow
	;;;MsgBox(0, "GUI Event", "CLOSE clicked, Exiting...")

	If $_mode <> $WIN_NOTUP Then
		; capture coordinates & state
	EndIf

	If $_returnValue <> 0 Then
		loggerAppend($_returnMsg)
		MsgBox($MB_ICONERROR, $_progName, "Problem occurred with " & $_progActual & @CRLF & @CRLF & $_returnMsg)
	EndIf
	Exit $_returnValue
EndFunc   ;==>CloseProgram

;----------------------------------------------------------------------------
Func InitMainWindow()
	Local $aboutItem, $exitItem, $fileMenu, $helpMenu, $optionsMenu, $preferencesItem, $restartItem, $servicesItem

	If $_cfgEscapeCloses == True Then
		Opt("GUICloseOnESC", 1)
	Else
		Opt("GUICloseOnESC", 0)
	EndIf
	Opt("GUIOnEventMode", 1)

	; Main Window
	$_mainWindow = GUICreate($_progTitle, $_cfgWidth, $_cfgHeight, $_cfgLeft, $_cfgTop, $WS_MAXIMIZEBOX + $WS_MINIMIZEBOX + $WS_SIZEBOX + $WS_SYSMENU)
	GUISetIcon("res\manager.ico")

	; Basic events
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseProgram")

	; File menu
	$fileMenu = GUICtrlCreateMenu("&File")

	$restartItem = GUICtrlCreateMenuItem("&Restart ...", $fileMenu)
	GUICtrlSetOnEvent($restartItem, "RestartProgram")
	GUICtrlSetTip($restartItem, "Restart the " & $_progName)

	GUICtrlCreateMenuItem("", $fileMenu) ; Create a separator line1

	$exitItem = GUICtrlCreateMenuItem("E&xit", $fileMenu)
	GUICtrlSetOnEvent($exitItem, "CloseProgram")
	GUICtrlSetTip($exitItem, "End the program")

	; Options menu
	$optionsMenu = GUICtrlCreateMenu("&Options")

	$preferencesItem = GUICtrlCreateMenuItem("&Preferences", $optionsMenu)
	GUICtrlSetOnEvent($preferencesItem, "ShowPreferences")
	GUICtrlSetTip($preferencesItem, "Set user preferences")

	;GUICtrlCreateMenuItem("", $optionsMenu) ; Create a separator line1

	$servicesItem = GUICtrlCreateMenuItem("S&elect Services", $optionsMenu)
	GUICtrlSetOnEvent($servicesItem, "ShowServices")
	GUICtrlSetTip($servicesItem, "Set user preferences")

	; Help menu
	$helpMenu = GUICtrlCreateMenu("&Help")
	$aboutItem = GUICtrlCreateMenuItem("&About ...", $helpMenu)
	GUICtrlSetOnEvent($aboutItem, "ShowAbout")

	; Tabbed Frame
	$_tabbedFrame = GUICtrlCreateTab(6, 6, $_cfgWidth - 14, $_cfgHeight - 56)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	; name must match that in InitTab
	$_monitorTab = InitTab("Monitor")
	$_logTab = InitTab("Runtime Log")

EndFunc   ;==>InitMainWindow

;----------------------------------------------------------------------------
Func InitTab($name)
	Local $index

	$index = UBound($_tabs) - 1
	$_tabs[$index] = GUICtrlCreateTabItem($name)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	; initialize the content of the tab before GUICtrlCreateTabItem
	Select
		Case $name = "Monitor"
			monitorInit()
		Case $name = "Runtime Log"
			loggerInit()
	EndSelect

	; ReDim array
	ReDim $_tabs[UBound($_tabs) + 1]
	GUICtrlCreateTabItem("")

	Return $_tabs[$index]
EndFunc   ;==>InitTab

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
					$_returnMsg = $_configurationFilePath & " configuration .ini file not found" & @CRLF
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
	Dim $bc = MsgBox(1 + 32, "Restart " & $_progName, "Are you sure you want to restart the " & $_progName & "?")
	If $bc == 1 Then
		_ScriptRestart()
	EndIf
EndFunc   ;==>RestartProgram

;----------------------------------------------------------------------------
Func ShowAbout()
	about()
EndFunc   ;==>ShowAbout

;----------------------------------------------------------------------------
Func ShowPreferences()
	about()
EndFunc   ;==>ShowPreferences

;----------------------------------------------------------------------------
Func ShowServices()
	about()
EndFunc   ;==>ShowServices


; end
