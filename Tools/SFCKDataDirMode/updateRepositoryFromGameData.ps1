# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot\..\sharedConfig.ps1"
}

# Need to copy the source scripts to the Scripts Source folder so SFCK can use them
Write-Host -ForegroundColor Green "Copying the source scripts to the Scripts Source folder so SFCK can use them"
If ([System.IO.Directory]::Exists("$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany")) {
  Copy-Item -Recurse -Force -Path "$ENV:MODULE_SCRIPTS_SOURCE_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule\**" -Destination ".\Source\Papyrus\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule"
  Copy-Item -Recurse -Force -Path "$ENV:MODULE_SCRIPTS_SOURCE_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary\**" -Destination ".\Source\Papyrus\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary"
} Else {
  Write-Host -ForegroundColor Red "WARNING: No scripting support detected so no scripts to sync."
}

# Need to copy the ESM/ESP/ESL files from the Game Data folder to update the repository verison for commit
Write-Host -ForegroundColor Green "Copying the ESM/ESP/ESL files from the Game Data folder to update the repository verison for commit"
foreach ($database in $Global:Databases) {
  if (![System.IO.File]::Exists("$ENV:MODULE_DATABASE_PATH\$database")) {
    Write-Host -ForegroundColor DarkRed "No database file named '$database' found in $ENV:MODULE_DATABASE_PATH. Skipping."
    continue
  }
  Write-Host -ForegroundColor Green "Copying $ENV:MODULE_DATABASE_PATH\$database to Source\Database."
  Copy-Item -Force -Path "$ENV:MODULE_DATABASE_PATH\$database" -Destination ".\Source\Database"
}

# Need to copy out terrain files
if ([System.IO.Directory]::Exists(".\Source\Terrain") -and [System.IO.Directory]::Exists("$ENV:MODULE_TERRAIN_PATH")) {
  Write-Host -ForegroundColor Green "Copying Terrain files from the Game Data folder."
  foreach ($worldspace in $Global:WorldSpaces) {
    Write-Host -ForegroundColor Green "Copying $ENV:MODULE_TERRAIN_PATH\$worldspace.btd to Source\Terrain."
    Copy-Item -Force -Path "$ENV:MODULE_TERRAIN_PATH\$worldspace.btd" -Destination ".\Source\Terrain"
  }
}

# Need to copy out terrain meshes
if ([System.IO.Directory]::Exists(".\Source\TerrainMeshes") -and [System.IO.Directory]::Exists("$ENV:MODULE_TERRAIN_MESHES_PATH")) {
  Write-Host -ForegroundColor Green "Copying Terrain meshes from the Game Data folder."
  foreach ($worldspace in $Global:WorldSpaces) {
    Write-Host -ForegroundColor Green "Copying $ENV:MODULE_TERRAIN_MESHES_PATH\$worldspace\Objects\$worldspace*.nif to Source\TerrainMeshes."
    Copy-Item -Force -Path "$ENV:MODULE_TERRAIN_MESHES_PATH\$worldspace\Objects\$worldspace*.nif" -Destination ".\Source\TerrainMeshes"
  }
}

# Need to copy out LOD files
if ([System.IO.Directory]::Exists(".\Source\LODSettings") -and [System.IO.Directory]::Exists("$ENV:MODULE_LOD_PATH")) {
  Write-Host -ForegroundColor Green "Copying LOD files from the Game Data folder."
  foreach ($worldspace in $Global:WorldSpaces) {
    Write-Host -ForegroundColor Green "Copying $ENV:MODULE_LOD_PATH\$worldspace.lod to Source\LODSettings."
    Copy-Item -Force -Path "$ENV:MODULE_LOD_PATH\$worldspace.lod" -Destination ".\Source\LODSettings"
  }
}

# Need to copy out Meshes
if ([System.IO.Directory]::Exists(".\Source\Meshes") -and [System.IO.Directory]::Exists("$ENV:MODULE_MESHES_PATH")) {
  Write-Host -ForegroundColor Green "Copying Meshes from the Game Data folder."
  Copy-Item -Force -Path "$ENV:MODULE_MESHES_PATH\$Global:ScriptingNamespaceCompany\*.nif" -Destination ".\Source\Meshes\$Global:ScriptingNamespaceCompany"
}

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**  Update Repository Files Workflow complete   **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
