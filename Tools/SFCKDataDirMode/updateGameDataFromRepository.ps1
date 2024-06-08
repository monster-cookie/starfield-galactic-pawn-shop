# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot\..\sharedConfig.ps1"
}

# Purge CK output points in case files were deleted
foreach ($database in $Global:Databases) {
  if ([System.IO.File]::Exists("$ENV:MODULE_DATABASE_PATH\$database")) {
    Remove-Item -Force -Path "$ENV:MODULE_DATABASE_PATH\$database"
  }
}
If ([System.IO.Directory]::Exists("$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule")) {
  Remove-Item -Force -Recurse "$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule"
}
If ([System.IO.Directory]::Exists("$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary")) {
  Remove-Item -Force -Recurse "$ENV:MODULE_SCRIPTS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceSharedLibrary"
}

& "$PSScriptRoot\..\compileScripts.ps1"

# Need to copy the ESM/ESP/ESL files to the Game Data folder so SFCK can use them
Write-Host -ForegroundColor Green "Copying the ESM/ESP/ESL files to the Game Data folder so SFCK can use them"
foreach ($database in $Global:Databases) {
  if (![System.IO.File]::Exists(".\Source\Database\$database")) {
    Write-Host -ForegroundColor DarkRed "No database file named '$database' found in Source\Database. Skipping."
    continue
  }
  Write-Host -ForegroundColor Green "Copying Source\Database\$database to the Game Data folder."
  Copy-Item -Force -Path ".\Source\Database\$database" -Destination "$ENV:MODULE_DATABASE_PATH"

  $targetFile = Get-Item -Path "$ENV:MODULE_DATABASE_PATH\$database"
  if ((Get-ItemProperty "$ENV:MODULE_DATABASE_PATH\$database").IsReadOnly) {
    Write-Host -ForegroundColor Green "Clearing readonly from $ENV:MODULE_DATABASE_PATH\$database."
    $targetFile.Attributes -= "ReadOnly"
  }
}

# Need to copy in terrain files (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\Terrain")) {
  if (![System.IO.Directory]::Exists("$ENV:MODULE_TERRAIN_PATH")) {
    New-Item -ItemType "Directory" -Path "$ENV:MODULE_TERRAIN_PATH" | Out-Null
  }
  Write-Host -ForegroundColor Green "Copying Terrain files to the Game Data folder."
  foreach ($worldspace in $Global:WorldSpaces) {
    Write-Host -ForegroundColor Green "Copying Source\Terrain\$worldspace.btd to the Game Data Terrain folder."
    Copy-Item -Force -Path ".\Source\Terrain\$worldspace.btd" -Destination "$ENV:MODULE_TERRAIN_PATH"
  }
}

# Need to copy in terrain meshes (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\TerrainMeshes")) {
  Write-Host -ForegroundColor Green "Copying Terrain meshes to the Game Data folder."
  if (![System.IO.Directory]::Exists("$ENV:MODULE_TERRAIN_MESHES_PATH")) {
    New-Item -ItemType "Directory" -Path "$ENV:MODULE_TERRAIN_MESHES_PATH" | Out-Null
  }
  foreach ($worldspace in $Global:WorldSpaces) {
    Write-Host -ForegroundColor Green "Copying Source\Terrain\$worldspace*.nif to the Game Data Meshes/Terrain folder."
    if (![System.IO.Directory]::Exists("$ENV:MODULE_TERRAIN_MESHES_PATH/$worldspace")) {
      New-Item -ItemType "Directory" -Path "$ENV:MODULE_TERRAIN_MESHES_PATH/$worldspace" | Out-Null
    }
    if (![System.IO.Directory]::Exists("$ENV:MODULE_TERRAIN_MESHES_PATH/$worldspace/Objects")) {
      New-Item -ItemType "Directory" -Path "$ENV:MODULE_TERRAIN_MESHES_PATH/$worldspace/Objects" | Out-Null
    }
    Copy-Item -Force -Path ".\Source\Terrain\$worldspace*.nif" -Destination "$ENV:MODULE_TERRAIN_MESHES_PATH/$worldspace/Objects"
  }
}

# Need to copy in LOD files (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\LODSettings")) {
  if (![System.IO.Directory]::Exists("$ENV:MODULE_LOD_PATH")) {
    New-Item -ItemType "Directory" -Path "$ENV:MODULE_LOD_PATH" | Out-Null
  }
  Write-Host -ForegroundColor Green "Copying LOD files to the Game Data folder."
  foreach ($worldspace in $Global:WorldSpaces) {
    Write-Host -ForegroundColor Green "Copying Source\LODSettings\$worldspace.lod to the Game Data LODSettings folder."
    Copy-Item -Force -Path ".\Source\LODSettings\$worldspace.lod" -Destination "$ENV:MODULE_LOD_PATH"
  }
}

# Need to copy in Meshes (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Meshes")) {
  if (![System.IO.Directory]::Exists("$ENV:MODULE_MESHES_PATH")) {
    New-Item -ItemType "Directory" -Path "$ENV:MODULE_MESHES_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
  }
  Write-Host -ForegroundColor Green "Copying Meshes to the Game Data folder."
  Copy-Item -Force -Path ".\Source\Meshes\*.nif" -Destination "$ENV:MODULE_MESHES_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule"
}

# Need to copy in Material definitions (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Materials")) {
  if (![System.IO.Directory]::Exists("$ENV:MODULE_MATERIALS_PATH")) {
    New-Item -ItemType "Directory" -Path "$ENV:MODULE_MATERIALS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
  }
  Write-Host -ForegroundColor Green "Copying Material Definitions to the Game Data folder."
  Copy-Item -Force -Path ".\Source\Materials\*.mat" -Destination "$ENV:MODULE_MATERIALS_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule"
}

# Need to copy in Textures (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Textures")) {
  if (![System.IO.Directory]::Exists("$ENV:MODULE_TEXTURES_PATH")) {
    New-Item -ItemType "Directory" -Path "$ENV:MODULE_TEXTURES_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
  }
  Write-Host -ForegroundColor Green "Copying Textures to the Game Data folder."
  Copy-Item -Force -Path ".\Source\Textures\*.dds" -Destination "$ENV:MODULE_TEXTURES_PATH\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule"
}

# Need to copy in Batch Files (This cannot have subdirectories)
if ([System.IO.Directory]::Exists(".\Source\BatchFiles")) {
  if (![System.IO.Directory]::Exists("$ENV:MODULE_BATCH_FILES_PATH")) {
    New-Item -ItemType "Directory" -Path "$ENV:MODULE_BATCH_FILES_PATH" | Out-Null
  }
  Write-Host -ForegroundColor Green "Copying BatchFiles to the Game Data folder."
  Copy-Item -Force -Path ".\Source\BatchFiles\*.txt" -Destination "$ENV:MODULE_BATCH_FILES_PATH"
}

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "************************************************"
Write-Host -ForegroundColor Cyan "**    Update CK Files Workflow complete       **"
Write-Host -ForegroundColor Cyan "************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
