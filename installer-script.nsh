; Custom NSIS installer script for MiniWebPlayer
; Adds Windows startup functionality during installation

!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"

; Variables for startup functionality
Var StartupCheckbox
Var StartupState

; Custom page for startup option
Function StartupOptionsPage
  !insertmacro MUI_HEADER_TEXT "Startup Options" "Choose whether MiniWebPlayer should start with Windows"
  
  nsDialogs::Create 1018
  Pop $0
  
  ${If} $0 == error
    Abort
  ${EndIf}
  
  ${NSD_CreateLabel} 0 10u 100% 20u "Startup Configuration:"
  Pop $0
  
  ${NSD_CreateCheckbox} 10 40u 100% 15u "&Start MiniWebPlayer automatically when Windows starts"
  Pop $StartupCheckbox
  
  ; Set default state (checked)
  ${NSD_Check} $StartupCheckbox
  
  ${NSD_CreateLabel} 10 65u 100% 40u "If enabled, MiniWebPlayer will automatically start when you log into Windows. You can change this setting later from within the application settings."
  Pop $0
  
  nsDialogs::Show
FunctionEnd

Function StartupOptionsPageLeave
  ; Get checkbox state
  ${NSD_GetState} $StartupCheckbox $StartupState
FunctionEnd

; Add the custom page to the installer
Page custom StartupOptionsPage StartupOptionsPageLeave

; Function called after successful installation
Function .onInstSuccess
  ; Check if startup was selected
  ${If} $StartupState == ${BST_CHECKED}
    ; Add to Windows startup registry
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "MiniWebPlayer" '"$INSTDIR\MiniWebPlayer.exe"'
    DetailPrint "Added MiniWebPlayer to Windows startup"
  ${Else}
    DetailPrint "MiniWebPlayer will not start automatically with Windows"
  ${EndIf}
FunctionEnd

; Custom uninstaller section to remove startup entry
Section "un.RemoveStartup"
  ; Remove from Windows startup registry
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "MiniWebPlayer"
  DetailPrint "Removed MiniWebPlayer from Windows startup"
SectionEnd
