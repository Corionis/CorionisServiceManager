#include-once
#cs -------------------------------------------------------------------------

 Pan-application global declarations

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

; basics
Global $_build = "1.0.0"  ; match 3 digits with CorionisServiceManager.au3 #AutoIt3Wrapper_Res_Fileversion
Global $_copyright = "By Todd R. Hill, MIT license"

; debugging
Global $_debugMsg

; error information
Dim $_panErrorValue = 0
Dim $_panErrorMsg = ""

; log tab
Global $_logBuffer = ""

; main window and pieces
Global $_mainWindow
Global $_tabbedFrame
Global $_tabs[1]
Global $_monitorTab
Global $_listTab
Global $_logTab
Global $_optionsCurrentType

;


; selected services
;   first = service
;	second = columns
;		* selected (0)
;		* name (1)
;		* display name (2)
;		* startup type (3)
;		* status (4)
Global $_selectedServices[100][5]

; template data
; first dimension  = types			Bolo, Excalibur, OGsql
; second dimension = components		Bridges, Docs, SQL
; third dimension  = files			CHECK, CVI, DOC_ID, ...
Global $_winservicesData[10][10][10]


; end
