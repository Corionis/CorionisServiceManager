#include-once
#cs -------------------------------------------------------------------------

 Pan-application global declarations

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

; error information
Dim $_panErrorValue = 0
Dim $_panErrorMsg = ""

; debugging
Global $_debugMsg

; main window and pieces
Global $_mainWindow
Global $_tabbedFrame
Global $_tabs[1]
Global $_monitorTab
Global $_listTab
Global $_logTab
Global $_guiListCurrentType

; log tab
Global $_logBuffer = ""

; template data
; first dimension  = types			Bolo, Excalibur, OGsql
; second dimension = components		Bridges, Docs, SQL
; third dimension  = files			CHECK, CVI, DOC_ID, ...
Global $_winservicesData[100][100][100]


; end
