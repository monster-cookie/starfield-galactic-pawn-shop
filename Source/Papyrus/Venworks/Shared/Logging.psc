ScriptName Venworks:Shared:Logging

;;
;; MAJOR NOTE: ALL FUNCTIONS MUST BE GLOBAL WITHOUT CREATION KIT
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

;; ****************************************************************************
;; Debug Message Handler
;;
Function Log(string modName, string moduleName, string functionName, string logMessage, int level, int debugModeEnabled) Global
  If (debugModeEnabled == 0)
    return
  EndIf

  if Debug.OpenUserLog(modName)
    Debug.TraceUser(modName, "\n\n[[--------------------------------------------------------------------------------]]\n" + modName + " LOG\n[[--------------------------------------------------------------------------------]]\n\n", 0)
  endif

  If (level == 1)
    Debug.TraceUser(modName, "VPI_WARN " + moduleName + "(" + functionName + "): " + logMessage, level)
  ElseIf (level == 2)
    Debug.TraceUser(modName, "VPI_ERROR " + moduleName + "(" + functionName + "): " + logMessage, level)
  Else
    Debug.TraceUser(modName, "VPI_DEBUG " + moduleName + "(" + functionName + "): " + logMessage, level)
  EndIf
EndFunction