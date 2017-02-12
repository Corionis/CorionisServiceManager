#include-once
#cs -------------------------------------------------------------------------

	Pan-application global declarations

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

; basics
Global $_build = "1.0.0" ; match 3 digits with CorionisServiceManager.au3 #AutoIt3Wrapper_Res_Fileversion
Global $_copyright = "By Todd R. Hill, MIT license"
Global $_progActual = "Corionis Service Manager"
Global $_progName = $_progActual
Global $_progShort = "CSM"
Global $_progTitle = $_progName & $_build

; configuration
Global $_configurationFilePath = ""
Global $_cfgLeft = -1
Global $_cfgTop = -1
Global $_cfgWidth = 638
Global $_cfgHeight = 400
Global $_cfgMonitoring = False
;

; constants
Global $STAT_NOTINIT = -1
Global $STAT_OK = 0
Global $STAT_ERROR = 1 ; generic error

; for $_mode
Global $WIN_NOTUP = 0
Global $WIN_UP = 1
Global $WIN_DOWN = 2

; debugging
Global $_debugMsg

; error information
Dim $_panErrorValue = 0
Dim $_panErrorMsg = ""
Global $_returnValue
Global $_returnMsg

; log tab
Global $_logBuffer = ""

; main window and pieces
Global $_mainWindow
Global $_tabbedFrame
Global $_tabs[1]
Global $_monitorTab
Global $_listTab
Global $_logTab
Global $_mode = $WIN_NOTUP
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
