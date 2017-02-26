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
#include "globals.au3" ; must be include first

#include "resources.au3"

;----------------------------------------------------------------------------
; globals
Global $_aboutForm

;----------------------------------------------------------------------------
Func about()
	Local $w = 400
	Local $h = 166
	Local $info = WinGetPos($_mainWindow)
	$_aboutForm = GUICreate("About", $w, $h, $info[0] + (($info[2] - $w) / 2), $info[1] + (($info[3] - $h) / 2), BitOR($DS_MODALFRAME, $DS_SETFOREGROUND, $WS_SYSMENU, $WS_CAPTION), $WS_EX_TOPMOST, $_mainWindow)
	GUISetIcon("res\information.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "aboutFormClose")

	Local $bg = GUICtrlCreatePic("", 0, 0, 400, 60)
	;GUICtrlSetState(-1, $GUI_DISABLE)
	_ResourceSetImageToCtrl($bg, "ABOUT_HDR")

	Local $urlLine = GUICtrlCreateLabel("See the Corionis Service Manager project on GitHub",  49, $h - 98, 300, 17, $SS_CENTER)
	GUICtrlSetOnEvent($urlLine, "aboutUrlLine")
	GUICtrlSetCursor($urlLine, 0)
	GUICtrlSetColor($urlLine, 0x4287f8)

	Local $buildLine = GUICtrlCreateLabel("Version: " & $_build & "   " & $_buildDate,  49, $h - 78, 300, 17, $SS_CENTER)

	Local $copyrightLine = GUICtrlCreateLabel("By Todd R. Hill, Corionis, LLC", 49, $h - 58, 300, 17, $SS_CENTER)

	Local $OkButton = GUICtrlCreateButton("&OK", 176, $h - 34, 49, 25)
	GUICtrlSetOnEvent($OkButton, "aboutFormClose")
	GUICtrlSetOnEvent(-1, "aboutFormClose")

	GUISetState(@SW_SHOW, $_aboutForm)

EndFunc   ;==>about

;----------------------------------------------------------------------------
Func aboutUrlLine()
	ShellExecute("https://corionis.github.io/CorionisServiceManager/")
	aboutFormClose()
EndFunc

;----------------------------------------------------------------------------
Func aboutFormClose()
	If @GUI_WinHandle = $_aboutForm Then
		GUISetState(@SW_HIDE, $_aboutForm)
		WinActivate($_mainWindow)
	EndIf
EndFunc   ;==>aboutFormClose
