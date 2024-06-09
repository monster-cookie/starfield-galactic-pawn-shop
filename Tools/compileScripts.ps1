# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot\sharedConfig.ps1"
}


#######################################
## Handle the source coded
##
If (![System.IO.Directory]::Exists("$PWD\Source\Papyrus") -and ![System.IO.Directory]::Exists("$PWD\Source\Papyrus\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule")) {
  Write-Host -ForegroundColor Red "WARNING: No scripting support detected so no scripts to compile. Aborting compile scripts."
  Exit
}

# Scaffold Source Pathing if needed
If (![System.IO.Directory]::Exists("$ENV:MODULE_SCRIPTS_SOURCE_PATH\$Global:ScriptingNamespaceCompany")) {
  New-Item -ItemType "Directory" -Path "$ENV:MODULE_SCRIPTS_SOURCE_PATH\$Global:ScriptingNamespaceCompany" | Out-Null
}
If (![System.IO.Directory]::Exists("$ENV:MODULE_SCRIPTS_SOURCE_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule")) {
  New-Item -ItemType "Directory" -Path "$ENV:MODULE_SCRIPTS_SOURCE_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
}
If (![System.IO.Directory]::Exists("$ENV:MODULE_SCRIPTS_SOURCE_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary")) {
  New-Item -ItemType "Directory" -Path "$ENV:MODULE_SCRIPTS_SOURCE_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary" | Out-Null
}

# Need to copy the source scripts to the Scripts Source folder so SFCK can use them
Write-Host -ForegroundColor Green "Copying the source scripts to the Scripts Source folder so SFCK can use them"
Copy-Item -Recurse -Force -Path ".\Source\Papyrus\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule\**" -Destination "$ENV:MODULE_SCRIPTS_SOURCE_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule"
Copy-Item -Recurse -Force -Path ".\Source\Papyrus\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary\**" -Destination "$ENV:MODULE_SCRIPTS_SOURCE_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary"


#######################################
## Handle the source coded
##
# Scaffold Compiled Pathing if needed
If (![System.IO.Directory]::Exists("$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany")) {
  New-Item -ItemType "Directory" -Path "$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany" | Out-Null
}
If (![System.IO.Directory]::Exists("$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule")) {
  New-Item -ItemType "Directory" -Path "$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
}
If (![System.IO.Directory]::Exists("$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary")) {
  New-Item -ItemType "Directory" -Path "$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary" | Out-Null
}

# Compile and deploy Scripts to CK Scripts folder
Write-Host -ForegroundColor Green "Compiling all scripts in Source/Papyrus to SFCK Scripts folder"

& "$ENV:TOOL_PATH_PAPYRUS_COMPILER" ".\Source\Papyrus" -all -f -optimize -flags="$ENV:PAPYRUS_COMPILER_FLAGS" -output="$ENV:MODULE_SCRIPTS_PATH" -import="$ENV:PAPYRUS_SCRIPTS_SOURCE_PATH;$ENV:MODULE_SCRIPTS_SOURCE_PATH" -ignorecwd

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**       Compile Scripts Workflow complete      **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
