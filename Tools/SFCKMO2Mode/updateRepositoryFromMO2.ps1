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

# Need to copy the ESM/ESP/ESL files from the MO2 folder to update the repository verison for commit
Write-Host -ForegroundColor Green "Copying the ESM/ESP/ESL files from the MO2 folder to update the repository verison for commit"
foreach ($database in $Global:Databases) {
  if (![System.IO.File]::Exists("$ENV:MODULE_DATABASE_PATH\$database")) {
    Write-Host -ForegroundColor DarkRed "No database file named '$database' found in $ENV:MODULE_DATABASE_PATH. Skipping."
    continue
  }
  Write-Host -ForegroundColor Green "Copying $ENV:MODULE_DATABASE_PATH\$database to Source\Database."
  Copy-Item -Force -Path "$ENV:MODULE_DATABASE_PATH\$database" -Destination ".\Source\Database"
}

# Need to copy out terrain files (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\Terrain") -and [System.IO.Directory]::Exists("$ENV:MODULE_TERRAIN_PATH")) {
  Write-Host -ForegroundColor Green "Copying Terrain files from the MO2 folder."
  foreach ($worldspace in $Global:WorldSpaces) {
    Write-Host -ForegroundColor Green "Copying $ENV:MODULE_TERRAIN_PATH\$worldspace.btd to Source\Terrain."
    Copy-Item -Force -Path "$ENV:MODULE_TERRAIN_PATH\$worldspace.btd" -Destination ".\Source\Terrain"
  }
}

# Need to copy out terrain meshes (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\TerrainMeshes") -and [System.IO.Directory]::Exists("$ENV:MODULE_TERRAIN_MESHES_PATH")) {
  Write-Host -ForegroundColor Green "Copying Terrain meshes from the MO2 folder."
  foreach ($worldspace in $Global:WorldSpaces) {
    Write-Host -ForegroundColor Green "Copying $ENV:MODULE_TERRAIN_MESHES_PATH\$worldspace\Objects\$worldspace*.nif to Source\TerrainMeshes."
    Copy-Item -Force -Path "$ENV:MODULE_TERRAIN_MESHES_PATH\$worldspace\Objects\$worldspace*.nif" -Destination ".\Source\TerrainMeshes"
  }
}

# Need to copy out LOD files (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\LODSettings") -and [System.IO.Directory]::Exists("$ENV:MODULE_LOD_PATH")) {
  Write-Host -ForegroundColor Green "Copying LOD files from the MO2 folder."
  foreach ($worldspace in $Global:WorldSpaces) {
    Write-Host -ForegroundColor Green "Copying $ENV:MODULE_LOD_PATH\$worldspace.lod to Source\LODSettings."
    Copy-Item -Force -Path "$ENV:MODULE_LOD_PATH\$worldspace.lod" -Destination ".\Source\LODSettings"
  }
}

# Need to copy out Meshes (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Meshes") -and [System.IO.Directory]::Exists("$ENV:MODULE_MESHES_PATH")) {
  Write-Host -ForegroundColor Green "Copying Meshes from the MO2 folder."
  Copy-Item -Force -Path "$ENV:MODULE_MESHES_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule\*.nif" -Destination ".\Source\Meshes\"
}

# Need to copy in Material definitions (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Materials") -and [System.IO.Directory]::Exists("$ENV:MODULE_MATERIALS_PATH")) {
  Write-Host -ForegroundColor Green "Copying Material Definitions from the MO2 folder."
  Copy-Item -Force -Path "$ENV:MODULE_MATERIALS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule\*.mat" -Destination ".\Source\Materials\"
}

# Need to copy in Textures (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Textures") -and [System.IO.Directory]::Exists("$ENV:MODULE_TEXTURES_PATH")) {
  Write-Host -ForegroundColor Green "Copying Textures from the MO2 folder."
  Copy-Item -Force -Path "$ENV:MODULE_TEXTURES_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule\*.dds" -Destination ".\Source\Textures\"
}

# Need to copy in Batch Files (This cannot have subdirectories)
if ([System.IO.Directory]::Exists(".\Source\BatchFiles") -and [System.IO.Directory]::Exists("$ENV:MODULE_BATCH_FILES_PATH")) {
  Write-Host -ForegroundColor Green "Copying Batch Files from the MO2 folder."
  Copy-Item -Force -Path "$ENV:MODULE_BATCH_FILES_PATH\$Global:ScriptingNamespaceCompany`_*.txt" -Destination ".\Source\BatchFiles"
}

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "***********************************************************"
Write-Host -ForegroundColor Cyan "**  Update Repository Files From MO2 Workflow complete   **"
Write-Host -ForegroundColor Cyan "***********************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
