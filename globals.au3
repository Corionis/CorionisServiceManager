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

; constants for monitor and select list services
Global $SVC_NAME = 0
Global $SVC_ID = 1
Global $SVC_START = 2
Global $SVC_STATUS = 3
Global $SVC_LAST = 3	; last list column
Global $SVC_MAX = 500 ; maximum number of services for any array

; debugging
Global $_debugMsg

; basics
Global $_build
Global $_buildDate
If @Compiled Then
	$_build = FileGetVersion(@ScriptFullPath)
	$_buildDate = FileGetVersion(@ScriptFullPath, "Timestamp")
Else
	$_build = "99.99.99.9999"
	$_buildDate = @MON & "/" & @MDAY & "/" & @YEAR
EndIf
Global $_progActual = "Corionis Service Manager"
Global $_progName = $_progActual
Global $_progShort = "CSM"
Global $_progTitle = $_progName & $_build

; configuration - preferences
Global $_configurationFilePath = ""

Global $_cfgHostname = "localhost"
Global $_cfgFriendlyName = "My Computer"
Global $_cfgFriendlyInTitle = False
Global $_cfgStartAtLogin = False
Global $_cfgStartMinimized = False
Global $_cfgDisplayNotifications = True
Global $_cfgWriteToLogFile = False
Global $_cfgEscapeCloses = False
Global $_cfgMinimizeOnClose = False
Global $_cfgHideWhenMinimized = False
Global $_cfgRefreshInterval = 5000
Global $_cfgRunningTextColor = "0x000000"
Global $_cfgRunningBackColor = "0XAAFFAA"
Global $_cfgStoppedTextColor = "0X000000"
Global $_cfgStoppedBackColor = "0XFFAAAA"
Global $_cfgIconIndex = -1

; configuration - running
Global $_cfgLeft = -1
Global $_cfgTop = -1
Global $_cfgWidth = 534
Global $_cfgHeight = 388
Global $_cfgMonitoring = False
Global $_cfgMonitorWidths = "262|70|86|64"
Global $_cfgSelectWidths = "262|70|86|64"

; error information
Dim $_panErrorValue = 0
Dim $_panErrorMsg = ""
Global $_returnValue
Global $_returnMsg

; log tab
Global $_logBuffer = ""
Global $__logStartHold = True
Global $__loggerBufferFlushed = False

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
Global $_monitorView
Global $_monitorListCtrls[$SVC_MAX]
Global $_monitorListCtrlsCount = 0
Global $_servicesArray[$SVC_MAX]
Global $_selectView
Global $_servicesCount = 0
Global $_selectedServices[$SVC_MAX]
Global $_selectedServicesCount = 0

; Service Control Manager access types
Global $SC_MANAGER_CONNECT = 0x0001
Global $SC_MANAGER_CREATE_SERVICE = 0x0002
Global $SC_MANAGER_ENUMERATE_SERVICE = 0x0004
Global $SC_MANAGER_LOCK = 0x0008
Global $SC_MANAGER_QUERY_LOCK_STATUS = 0x0010
Global $SC_MANAGER_MODIFY_BOOT_CONFIG = 0x0020
Global $SC_MANAGER_ALL_ACCESS = BitOR($STANDARD_RIGHTS_REQUIRED, $SC_MANAGER_CONNECT, $SC_MANAGER_CREATE_SERVICE, $SC_MANAGER_ENUMERATE_SERVICE, $SC_MANAGER_LOCK, $SC_MANAGER_QUERY_LOCK_STATUS, $SC_MANAGER_MODIFY_BOOT_CONFIG)

; service access types
Global $SERVICE_QUERY_CONFIG = 0x0001
Global $SERVICE_CHANGE_CONFIG = 0x0002
Global $SERVICE_QUERY_STATUS = 0x0004
Global $SERVICE_ENUMERATE_DEPENDENTS = 0x0008
Global $SERVICE_START = 0x0010
Global $SERVICE_STOP = 0x0020
Global $SERVICE_PAUSE_CONTINUE = 0x0040
Global $SERVICE_INTERROGATE = 0x0080
Global $SERVICE_USER_DEFINED_CONTROL = 0x0100
Global $SERVICE_ALL_ACCESS = BitOR($STANDARD_RIGHTS_REQUIRED, $SERVICE_QUERY_CONFIG, $SERVICE_CHANGE_CONFIG, $SERVICE_QUERY_STATUS, $SERVICE_ENUMERATE_DEPENDENTS, $SERVICE_START, $SERVICE_STOP, $SERVICE_PAUSE_CONTINUE, $SERVICE_INTERROGATE, $SERVICE_USER_DEFINED_CONTROL)

; service types
Global $SERVICE_KERNEL_DRIVER = 0x00000001
Global $SERVICE_FILE_SYSTEM_DRIVER = 0x00000002
Global $SERVICE_ADAPTER = 0x00000004
Global $SERVICE_RECOGNIZER_DRIVER = 0x00000008
Global $SERVICE_DRIVER = BitOR($SERVICE_KERNEL_DRIVER, $SERVICE_FILE_SYSTEM_DRIVER, $SERVICE_RECOGNIZER_DRIVER)
Global $SERVICE_WIN32_OWN_PROCESS = 0x00000010
Global $SERVICE_WIN32_SHARE_PROCESS = 0x00000020
Global $SERVICE_WIN32 = BitOR($SERVICE_WIN32_OWN_PROCESS, $SERVICE_WIN32_SHARE_PROCESS)
Global $SERVICE_INTERACTIVE_PROCESS = 0x00000100
Global $SERVICE_TYPE_ALL = BitOR($SERVICE_WIN32, $SERVICE_ADAPTER, $SERVICE_DRIVER, $SERVICE_INTERACTIVE_PROCESS)

; service start types
Global $SERVICE_BOOT_START = 0x00000000
Global $SERVICE_SYSTEM_START = 0x00000001
Global $SERVICE_AUTO_START = 0x00000002
Global $SERVICE_DEMAND_START = 0x00000003
Global $SERVICE_DISABLED = 0x00000004

; service controls
Global $SERVICE_CONTROL_STOP = 0x00000001
Global $SERVICE_CONTROL_PAUSE = 0x00000002
Global $SERVICE_CONTROL_CONTINUE = 0x00000003
Global $SERVICE_CONTROL_INTERROGATE = 0x00000004
Global $SERVICE_CONTROL_SHUTDOWN = 0x00000005
Global $SERVICE_CONTROL_PARAMCHANGE = 0x00000006
Global $SERVICE_CONTROL_NETBINDADD = 0x00000007
Global $SERVICE_CONTROL_NETBINDREMOVE = 0x00000008
Global $SERVICE_CONTROL_NETBINDENABLE = 0x00000009
Global $SERVICE_CONTROL_NETBINDDISABLE = 0x0000000A
Global $SERVICE_CONTROL_DEVICEEVENT = 0x0000000B
Global $SERVICE_CONTROL_HARDWAREPROFILECHANGE = 0x0000000C
Global $SERVICE_CONTROL_POWEREVENT = 0x0000000D
Global $SERVICE_CONTROL_SESSIONCHANGE = 0x0000000E

; service error control
Global $SERVICE_ERROR_IGNORE = 0x00000000
Global $SERVICE_ERROR_NORMAL = 0x00000001
Global $SERVICE_ERROR_SEVERE = 0x00000002
Global $SERVICE_ERROR_CRITICAL = 0x00000003


; end
