# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\sharedFunctions.ps1"

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
If ([System.IO.Directory]::Exists(".\Dist")) {
  Remove-Item -Force -Recurse -Path ".\Dist" | Out-Null
}
If (![System.IO.Directory]::Exists(".\Dist")) {
  New-Item -ItemType "Directory" -Path ".\Dist" | Out-Null
}
If ([System.IO.Directory]::Exists(".\Dist-Archive-Main")) {
  Remove-Item -Force -Recurse -Path ".\Dist-Archive-Main" | Out-Null
}
If (![System.IO.Directory]::Exists(".\Dist-Archive-Main")) {
  New-Item -ItemType "Directory" -Path ".\Dist-Archive-Main" | Out-Null
}
If ([System.IO.Directory]::Exists(".\Dist-Archive-Texture-Windows")) {
  Remove-Item -Force -Recurse -Path ".\Dist-Archive-Texture-Windows" | Out-Null
}
If (![System.IO.Directory]::Exists(".\Dist-Archive-Texture-Windows")) {
  New-Item -ItemType "Directory" -Path ".\Dist-Archive-Texture-Windows" | Out-Null
}
If ([System.IO.Directory]::Exists(".\Dist-Archive-Texture-Xbox")) {
  Remove-Item -Force -Recurse -Path ".\Dist-Archive-Texture-Xbox" | Out-Null
}
If (![System.IO.Directory]::Exists(".\Dist-Archive-Texture-Xbox")) {
  New-Item -ItemType "Directory" -Path ".\Dist-Archive-Texture-Xbox\Textures\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
}

# Compile code and put it into the proper place
& "$PSScriptRoot\compileScripts.ps1" -ourPapyrusSourcePath ".\Source\Papyrus" -bgsPapyrusSourcePath "$ENV:PAPYRUS_SCRIPTS_SOURCE_PATH" -targetCompiledScriptsPath ".\Dist-Archive-Main\Scripts" -targetSourceScriptsPath ".\Dist-Archive-Main\Scripts\Source"

# Need to copy in terrain files (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\Terrain")) {
  copyInTerrainFiles -sourcePath ".\Source\Terrain" -targetPath ".\Dist-Archive-Main\Terrain"
}

# Need to copy in terrain meshes (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\TerrainMeshes")) {
  copyInTerrainMeshes -sourcePath ".\Source\TerrainMeshes" -targetPath ".\Dist-Archive-Main\Meshes\Terrain"
}

# Need to copy in LOD files (The engines uses file name matching on editor ID so our files have to go in the same folder as BGS's files)
if ([System.IO.Directory]::Exists(".\Source\LODSettings")) {
  copyInLODSettings -sourcePath ".\Source\LODSettings" -targetPath ".\Dist-Archive-Main\LODSettings"
}

# Need to copy in Meshes (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Meshes")) {
  copyInMeshes -sourcePath ".\Source\Meshes" -targetPath ".\Dist-Archive-Main\Meshes"
}

# Need to copy in Material definitions (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Materials")) {
  copyInMaterialDefinitions -sourcePath ".\Source\Materials" -targetPath ".\Dist-Archive-Main\Materials"
}

# Need to copy in Textures (These are only referenced by editor path so they need to end up a subdir using our company name and module name)
if ([System.IO.Directory]::Exists(".\Source\Textures")) {
  copyInTextures -sourcePath ".\Source\Textures" -targetPath "Dist-Archive-Texture-Windows\Textures"
  foreach ($item in Get-ChildItem -Path ".\Source\Textures") {
    $textureName = $item.NameString
    $texturePath = $item.FullName
    Write-Host -ForegroundColor Green "Converting $texturePath to Xbox format and outputting as $textureName to Dist-Archive-Texture-Xbox\Textures folder."
    # SEE: https://github.com/Microsoft/DirectXTex/wiki/Texconv
    & "$ENV:TOOL_PATH_XTEXCONV" -f "DXT5" -ft "dds" -l -nologo -o ".\Dist-Archive-Texture-Xbox\Textures\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" "$texturePath"
  }
}

# Need to copy in Batch Files (This cannot have subdirectories)
if ([System.IO.Directory]::Exists(".\Source\BatchFiles")) {
  copyInBatchFiles -sourcePath ".\Source\BatchFiles" -targetPath ".\Dist-Archive-Main\BatchFiles"
}

# Place the databases in the master dist folder
copyInDatabases -sourcePath ".\Source\Database" -targetPath ".\Dist" -databases $Global:Databases

# TODO: Handle creating the archives and placing then in the mast Dist folder
& "$ENV:TOOL_PATH_ARCHIVER" ".\Dist-Archive-Main" -create=".\Dist\$Global:ScriptingNamespaceCompany-$Global:ScriptingNamespaceModule - Main.ba2" -root="$PWD\Dist-Archive-Main" -format="General" -compression="Default" -maxSizeMB=2048 
& "$ENV:TOOL_PATH_ARCHIVER" ".\Dist-Archive-Texture-Windows" -create=".\Dist\$Global:ScriptingNamespaceCompany-$Global:ScriptingNamespaceModule - Textures.ba2" -root="$PWD\Dist-Archive-Texture-Windows" -format="DDS" -compression="Default" -maxSizeMB=2048 
& "$ENV:TOOL_PATH_ARCHIVER" ".\Dist-Archive-Texture-Xbox" -create=".\Dist\$Global:ScriptingNamespaceCompany-$Global:ScriptingNamespaceModule - Textures_XBox.ba2" -root="$PWD\Dist-Archive-Texture-Xbox" -format="XBoxDDS" -compression="XBox" -maxSizeMB=2048 

Write-Host -ForegroundColor Cyan "`n`n"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "**     BA2 Windows and XBox Archives Created    **"
Write-Host -ForegroundColor Cyan "**************************************************"
Write-Host -ForegroundColor Cyan "`n`n"
