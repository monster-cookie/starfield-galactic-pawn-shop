# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot\..\sharedConfig.ps1"
}

# Export Data File to YAML
foreach ($database in $Global:Databases) {
  if (![System.IO.File]::Exists(".\Source\Database\$database")) {
    Write-Host -ForegroundColor DarkRed "No database file named '$database' found in Source\Database. Skipping."
    continue
  }

  Write-Host -ForegroundColor Green "Disassembling in data file $database to YAML in .\Source\Spriggit\$database"

  & "$ENV:TOOL_PATH_SPRIGGIT" serialize --InputPath ".\Source\Database\$database" --OutputPath ".\Source\Spriggit\$database" --GameRelease Starfield --PackageName Spriggit.Yaml # -v 0.20.0.2
}

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**   Spriggit Datafile Dump Workflow Complete   **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
