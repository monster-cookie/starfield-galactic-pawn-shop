Write-Host -ForegroundColor Green "Importing ENV Settings from .env file"
Get-Content .env | ForEach-Object {
  $name, $value = $_.split('=')
  $name.trim() | Out-Null
  if (!$name.StartsWith('#') || ![string]::IsNullOrWhitespace($name) || ![string]::IsNullOrWhitespace($value)) {
    $value.trim() | Out-Null
    Set-Item -Path "env:$name" -Value "$value"
  }
}

Write-Host -ForegroundColor Yellow "`nTool Settings:"
Write-Host -ForegroundColor Yellow "BGS Papyrus Compiler path is $ENV:TOOL_PATH_PAPYRUS_COMPILER\PapyrusCompiler.exe"
Write-Host -ForegroundColor Yellow "BGS Archive2 path is $ENV:TOOL_PATH_ARCHIVER\Archive2.exe"
Write-Host -ForegroundColor Yellow "Spriggit CLI path is $ENV:TOOL_PATH_SPRIGGIT\Spriggit.CLI.exe"
Write-Host -ForegroundColor Yellow "`nSteam Settings:"
Write-Host -ForegroundColor Yellow "Starfield game folder is set to $ENV:STEAM_GAME_FOLDER."
Write-Host -ForegroundColor Yellow "Starfield data folder is set to $ENV:STEAM_DATA_FOLDER."
Write-Host -ForegroundColor Yellow "`nPapyrus Settings:"
Write-Host -ForegroundColor Yellow "BGS Papyrus Compiler Flags files is $ENV:PAPYRUS_COMPILER_FLAGS"
Write-Host -ForegroundColor Yellow "BGS Papyrus Script path is $ENV:PAPYRUS_SCRIPTS_PATH"
Write-Host -ForegroundColor Yellow "BGS Papyrus Source path is $ENV:PAPYRUS_SCRIPTS_SOURCE_PATH"
Write-Host -ForegroundColor Yellow "`nModule Settings:"
Write-Host -ForegroundColor Yellow "Module Database Folder is $ENV:MODULE_DATABASE_PATH"
Write-Host -ForegroundColor Yellow "Module Scripting Folder is $ENV:MODULE_SCRIPTS_PATH"
Write-Host -ForegroundColor Yellow "Module Scripting Source Folder is $ENV:MODULE_SCRIPTS_SOURCE_PATH"

$Global:Databases = @(
  ("Venworks-JunkRecycler.esp")
)

$Global:WorldSpaces = @(
  ("ExampleWorldSpace")
)

$Global:ScriptingNamespaceCompany = "Venworks"
$Global:ScriptingNamespaceModule = "JunkRecycler"
$Global:ScriptingNamespaceSharedLibrary = "Shared"

Write-Host -ForegroundColor Yellow "Papyrus Scripting namespace for module is $Global:SCriptingNamespaceCompany`:$Global:ScriptingNamespaceModule"
Write-Host -ForegroundColor Yellow "Papyrus Scripting namespace for shared library is $Global:SCriptingNamespaceCompany`:$Global:ScriptingNamespaceSharedLibrary"

Write-Host -ForegroundColor Yellow ""
Write-Host -ForegroundColor Yellow "Game Database Files:"
foreach ($database in $Global:Databases) {
  Write-Host -ForegroundColor Yellow $database
}
Write-Host -ForegroundColor Yellow "`n"

$Global:SharedConfigurationLoaded=$true
