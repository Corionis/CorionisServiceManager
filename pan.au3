#include-once
#cs -------------------------------------------------------------------------

	Pan-application global declarations

#ce -------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Setup & Directives
AutoItSetOption("MustDeclareVars", 1)

; constants
Global $STAT_NOTINIT = -1
Global $STAT_OK = 0
Global $STAT_ERROR = 1 ; generic error

; constants for $_mode
Global $WIN_NOTUP = 0
Global $WIN_UP = 1
Global $WIN_DOWN = 2

; debugging
Global $_debugMsg

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
Global $_cfgWidth = 538
Global $_cfgHeight = 388
Global $_cfgMonitoring = False

; error information
Dim $_panErrorValue = 0
Dim $_panErrorMsg = ""
Global $_returnValue
Global $_returnMsg

; log tab
Global $_logBuffer = ""

; main window, tabs and pieces
Global $_mainWindow
Global $_tabbedFrame
Global $_tabs[1]
Global $_monitorTab
Global $_selectTab
Global $_optionsTab
Global $_logTab
Global $_mode = $WIN_NOTUP

; services data
;   first = service
;	second = columns
;		* selected (0)
;		* name (1)
;		* display name (2)
;		* startup type (3)
;		* status (4)

Global $_servicesArray[400]
Global $_servicesCount = 0
Global $_servicesAvailable[100][5]
Global $_selectedServices[100][5]



; end
