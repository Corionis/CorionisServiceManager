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
Global $_guiListCurrentType

; configuration										Read in configuration.au3 and push into monitor GUI - use THAT data
Global $_cfgHostname = "localhost"
Global $_cfgFriendlyName = "My Computer"
Global $_cfgFileInTitle = True
Global $_cfgFileInTitleFull = False
Global $_cfgEscapeCloses = False
Global $_cfgMinimizeOnClose = True
Global $_cfgHideWhenMinimized = False
Global $_cfgRefreshInterval = 5000
Global $_cfgRunColor = 0x00FF00
Global $_cfgStopColor = 0xFF0000
;
Global $_cfgLeft = -1
Global $_cfgTop = -1
Global $_cfgWidth = 638
Global $_cfgHeight = 400
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
