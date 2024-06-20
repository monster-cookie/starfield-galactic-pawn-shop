param (
  [Parameter(Mandatory=$true)]
  [string]$ourPapyrusSourcePath,

  [Parameter(Mandatory=$true)]
  [string]$bgsPapyrusSourcePath,

  [Parameter(Mandatory=$true)]
  [string]$targetCompiledScriptsPath,

  [Parameter(Mandatory=$true)]
  [string]$targetSourceScriptsPath
)

# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot\sharedConfig.ps1"
}

# Scaffold Source Pathing if needed
If (![System.IO.Directory]::Exists("$targetSourceScriptsPath\$Global:ScriptingNamespaceCompany")) {
  New-Item -ItemType "Directory" -Path "$targetSourceScriptsPath\$Global:ScriptingNamespaceCompany" | Out-Null
}
If (![System.IO.Directory]::Exists("$targetSourceScriptsPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule")) {
  New-Item -ItemType "Directory" -Path "$targetSourceScriptsPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
}
If (![System.IO.Directory]::Exists("$targetSourceScriptsPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary")) {
  New-Item -ItemType "Directory" -Path "$targetSourceScriptsPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary" | Out-Null
}

# Need to copy the source scripts to the Scripts Source folder so SFCK can use them
Write-Host -ForegroundColor Green "Copying the source scripts from $ourPapyrusSourcePath to $targetSourceScriptsPath"
Copy-Item -Recurse -Force -Path "$ourPapyrusSourcePath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule\**" -Destination "$targetSourceScriptsPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule"
Copy-Item -Recurse -Force -Path "$ourPapyrusSourcePath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary\**" -Destination "$targetSourceScriptsPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary"


#######################################
## Handle the source coded
##
# Scaffold Compiled Pathing if needed
If (![System.IO.Directory]::Exists("$targetCompiledScriptsPath\$Global:ScriptingNamespaceCompany")) {
  New-Item -ItemType "Directory" -Path "$targetCompiledScriptsPath\$Global:ScriptingNamespaceCompany" | Out-Null
}
If (![System.IO.Directory]::Exists("$targetCompiledScriptsPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule")) {
  New-Item -ItemType "Directory" -Path "$targetCompiledScriptsPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
}
If (![System.IO.Directory]::Exists("$targetCompiledScriptsPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary")) {
  New-Item -ItemType "Directory" -Path "$targetCompiledScriptsPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary" | Out-Null
}

# Compile and deploy Scripts to CK Scripts folder
Write-Host -ForegroundColor Green "Compiling all scripts in $ourPapyrusSourcePath to $targetCompiledScriptsPath folder"

& "$ENV:TOOL_PATH_PAPYRUS_COMPILER" "$ourPapyrusSourcePath" -all -f -optimize -flags="$ENV:PAPYRUS_COMPILER_FLAGS" -output="$targetCompiledScriptsPath" -import="$ourPapyrusSourcePath;$bgsPapyrusSourcePath" -ignorecwd

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**       Compile Scripts Workflow complete      **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
