# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\..\sharedFunctions.ps1"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot\..\sharedConfig.ps1"
}

# Purge MO2 staging folder in case files were deleted
Get-ChildItem -Force -Path "$ENV:MODULE_DATABASE_PATH" | ForEach-Object {
  if ($_.Name.ToLower() -ne "meta.ini") {
    Remove-Item -Force -Recurse -Path "$_"
  }  
}

& "$PSScriptRoot\..\compileScripts.ps1" -ourPapyrusSourcePath ".\Source\Papyrus" -bgsPapyrusSourcePath "$ENV:PAPYRUS_SCRIPTS_SOURCE_PATH" -targetCompiledScriptsPath "$ENV:MODULE_SCRIPTS_PATH" -targetSourceScriptsPath "$ENV:MODULE_SCRIPTS_SOURCE_PATH"

# Need to copy the ESM/ESP/ESL files to the Game Data folder so SFCK can use them
Write-Host -ForegroundColor Green "Copying the ESM/ESP/ESL files to the Game Data folder so SFCK can use them"
copyInDatabases -sourcePath ".\Source\Database" -targetPath "$ENV:MODULE_DATABASE_PATH" -databases $Global:Databases

# Need to copy in terrain files (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\Terrain")) {
  copyInTerrainFiles -sourcePath ".\Source\Terrain" -targetPath "$ENV:MODULE_TERRAIN_PATH"
}

# Need to copy in terrain meshes (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\TerrainMeshes")) {
  copyInTerrainMeshes -sourcePath ".\Source\TerrainMeshes" -targetPath "$ENV:MODULE_TERRAIN_MESHES_PATH"
}

# Need to copy in LOD files (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\LODSettings")) {
  copyInLODSettings -sourcePath ".\Source\LODSettings" -targetPath "$ENV:MODULE_LOD_PATH"
}

# Need to copy in Meshes (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Meshes")) {
  copyInMeshes -sourcePath ".\Source\Meshes" -targetPath "$ENV:MODULE_MESHES_PATH"
}

# Need to copy in Material definitions (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Materials")) {
  copyInMaterialDefinitions -sourcePath ".\Source\Materials" -targetPath "$ENV:MODULE_MATERIALS_PATH"
}

# Need to copy in Textures (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Textures")) {
  copyInTextures -sourcePath ".\Source\Textures" -targetPath "$ENV:MODULE_TEXTURES_PATH"
}

# Need to copy in Batch Files (This cannot have subdirectories)
if ([System.IO.Directory]::Exists(".\Source\BatchFiles")) {
  copyInBatchFiles -sourcePath ".\Source\BatchFiles" -targetPath "$ENV:MODULE_BATCH_FILES_PATH"
}

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**     Update MO2 Files Workflow complete       **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
