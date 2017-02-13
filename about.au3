#include-once
#cs -------------------------------------------------------------------------

	About box

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

;----------------------------------------------------------------------------
; Includes
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

; application components
#include "pan.au3" ; must be include first

;----------------------------------------------------------------------------
; globals
Global $_aboutForm

;----------------------------------------------------------------------------
Func about()
	Local $w = 400
	Local $h = 146
	Local $info = WinGetPos($_mainWindow)
	$_aboutForm = GUICreate("About", $w, $h, $info[0] + (($info[2] - $w) / 2), $info[1] + (($info[3] - $h) / 2), BitOR($DS_MODALFRAME, $DS_SETFOREGROUND, $WS_SYSMENU, $WS_CAPTION), $WS_EX_TOPMOST, $_mainWindow)
	GUISetIcon("res\information.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "aboutFormClose")
	Local $bg = GUICtrlCreatePic("res\about_header.gif", 0, 0, 400, 60)
	Local $OkButton = GUICtrlCreateButton("&OK", 176, 112, 49, 25)
	GUICtrlSetOnEvent($OkButton, "aboutFormClose")
	GUICtrlSetOnEvent(-1, "aboutFormClose")
	Local $copyrightLine = GUICtrlCreateLabel($_copyright, 77, 88, 246, 17, $SS_CENTER)
	Local $buildLine = GUICtrlCreateLabel($_build, 77, 68, 246, 17, $SS_CENTER)
	GUISetState(@SW_SHOW, $_aboutForm)
EndFunc   ;==>about

;----------------------------------------------------------------------------
Func aboutFormClose()
	If @GUI_WinHandle = $_aboutForm Then
		GUISetState(@SW_HIDE, $_aboutForm)
		WinActivate($_mainWindow)
	EndIf
EndFunc   ;==>aboutFormClose
