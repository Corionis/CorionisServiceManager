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
#include "pan.au3"						; must be include first
#include "build.au3"

;----------------------------------------------------------------------------
; globals
Global $_guiAboutForm

;----------------------------------------------------------------------------
Func guiAbout()
	$_guiAboutForm = GUICreate("About", 400, 146, -1, -1, BitOR($DS_MODALFRAME, $WS_SYSMENU, $WS_CAPTION), Default, $_mainWindow)
	GUISetIcon("res\information.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "guiAboutFormClose")
	Local $bg = GUICtrlCreatePic("res\about_header.gif", 0, 0, 400, 60)
	Local $OkButton = GUICtrlCreateButton("OK", 176, 112, 49, 25)
	GUICtrlSetOnEvent($OkButton, "guiAboutFormClose")
	GUICtrlSetOnEvent(-1, "guiAboutFormClose")
	Local $copyrightLine = GUICtrlCreateLabel($_copyright, 77, 88, 246, 17, $SS_CENTER)
	Local $buildLine = GUICtrlCreateLabel($_build, 77, 68, 246, 17, $SS_CENTER)
	GUISetState(@SW_SHOW, $_guiAboutForm)
EndFunc   ;==>guiAbout

;----------------------------------------------------------------------------
Func guiAboutFormClose()
	;MsgBox(0, "GUI Event", "You clicked CLOSE")
	If @GUI_WinHandle = $_guiAboutForm Then
		GUISetState(@SW_HIDE, $_guiAboutForm)
		WinActivate($_mainWindow)
	EndIf
EndFunc   ;==>guiAboutFormClose
