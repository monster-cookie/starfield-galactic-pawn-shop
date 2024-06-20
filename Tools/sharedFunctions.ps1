# Abort on first error
$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"

# If not loaded already pull in the shared config
if (!$Global:SharedConfigurationLoaded) {
  Write-Host -ForegroundColor Green "Importing Shared Configuration"
  . "$PSScriptRoot\sharedConfig.ps1"
}

function copyInTerrainFiles {
  param (
    [Parameter(Mandatory=$true)]
    [string]$sourcePath,

    [Parameter(Mandatory=$true)]
    [string]$targetPath
  )

  if ([System.IO.Directory]::Exists("$sourcePath")) {
    if (![System.IO.Directory]::Exists("$targetPath")) {
      New-Item -ItemType "Directory" -Path "$targetPath" | Out-Null
    }
    Write-Host -ForegroundColor Green "Copying Terrain files to the MO2 folder."
    foreach ($worldspace in $Global:WorldSpaces) {
      Write-Host -ForegroundColor Green "Copying $sourcePath\$worldspace.btd to the $targetPath folder."
      Copy-Item -Force -Path "$sourcePath\$worldspace.btd" -Destination "$targetPath"
    }
  }
}

function copyInTerrainMeshes {
  param (
    [Parameter(Mandatory=$true)]
    [string]$sourcePath,

    [Parameter(Mandatory=$true)]
    [string]$targetPath
  )

  if ([System.IO.Directory]::Exists("$sourcePath")) {
    Write-Host -ForegroundColor Green "Copying Terrain meshes to the target folder folder."
    if (![System.IO.Directory]::Exists("$targetPath")) {
      New-Item -ItemType "Directory" -Path "$targetPath" | Out-Null
    }
    foreach ($worldspace in $Global:WorldSpaces) {
      Write-Host -ForegroundColor Green "Copying $sourcePath\$worldspace*.nif to the MO2 $targetPath folder."
      if (![System.IO.Directory]::Exists("$targetPath\$worldspace")) {
        New-Item -ItemType "Directory" -Path "$targetPath\$worldspace" | Out-Null
      }
      if (![System.IO.Directory]::Exists("$targetPath\$worldspace\Objects")) {
        New-Item -ItemType "Directory" -Path "$targetPath\$worldspace\Objects" | Out-Null
      }
      Copy-Item -Force -Path "$sourcePath\$worldspace*.nif" -Destination "$targetPath\$worldspace\Objects"
    }
  }
}

function copyInLODSettings {
  param (
    [Parameter(Mandatory=$true)]
    [string]$sourcePath,

    [Parameter(Mandatory=$true)]
    [string]$targetPath
  )

  if ([System.IO.Directory]::Exists("$sourcePath")) {
    if (![System.IO.Directory]::Exists("$ENV:MODULE_LOD_PATH")) {
      New-Item -ItemType "Directory" -Path "$ENV:MODULE_LOD_PATH" | Out-Null
    }
    Write-Host -ForegroundColor Green "Copying LOD files to the MO2 folder."
    foreach ($worldspace in $Global:WorldSpaces) {
      Write-Host -ForegroundColor Green "Copying $sourcePath\$worldspace.lod to the $targetPath folder."
      Copy-Item -Force -Path "$sourcePath\$worldspace.lod" -Destination "$targetPath"
    }
  }  
}

function copyInMeshes {
  param (
    [Parameter(Mandatory=$true)]
    [string]$sourcePath,

    [Parameter(Mandatory=$true)]
    [string]$targetPath
  )

  if ([System.IO.Directory]::Exists("$sourcePath")) {
    if (![System.IO.Directory]::Exists("$targetPath")) {
      New-Item -ItemType "Directory" -Path "$targetPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
    }
    Write-Host -ForegroundColor Green "Copying Meshes to the $targetPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule folder."
    Copy-Item -Force -Path "$sourcePath\*.nif" -Destination "$targetPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule"
  }  
}

function copyInMaterialDefinitions {
  param (
    [Parameter(Mandatory=$true)]
    [string]$sourcePath,

    [Parameter(Mandatory=$true)]
    [string]$targetPath
  )

  if ([System.IO.Directory]::Exists("$sourcePath")) {
    if (![System.IO.Directory]::Exists("$targetPath")) {
      New-Item -ItemType "Directory" -Path "$targetPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
    }
    Write-Host -ForegroundColor Green "Copying Material Definitions to the $targetPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule folder."
    Copy-Item -Force -Path "$sourcePath\*.mat" -Destination "$targetPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule"
  }
}

function copyInTextures {
  param (
    [Parameter(Mandatory=$true)]
    [string]$sourcePath,

    [Parameter(Mandatory=$true)]
    [string]$targetPath
  )

  if ([System.IO.Directory]::Exists("$sourcePath")) {
    if (![System.IO.Directory]::Exists("$targetPath")) {
      New-Item -ItemType "Directory" -Path "$targetPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule" | Out-Null
    }
    Write-Host -ForegroundColor Green "Copying Textures to the $targetPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule folder."
    Copy-Item -Force -Path "$sourcePath\*.dds" -Destination "$targetPath\$Global:ScriptingNamespaceCompany\$Global:ScriptingNamespaceModule"
  }
}

function copyInBatchFiles {
  param (
    [Parameter(Mandatory=$true)]
    [string]$sourcePath,

    [Parameter(Mandatory=$true)]
    [string]$targetPath
  )

  if ([System.IO.Directory]::Exists("$sourcePath")) {
    if (![System.IO.Directory]::Exists("$targetPath")) {
      New-Item -ItemType "Directory" -Path "$targetPath" | Out-Null
    }
    Write-Host -ForegroundColor Green "Copying BatchFiles to the $targetPath folder."
    Copy-Item -Force -Path "$sourcePath\*.txt" -Destination "$targetPath"
  }
}

function copyInDatabases {
  param (
    [Parameter(Mandatory=$true)]
    [string]$sourcePath,

    [Parameter(Mandatory=$true)]
    [string]$targetPath,

    [Parameter(Mandatory=$true)]
    [array]$databases
  )

  foreach ($database in $databases) {
    if (![System.IO.File]::Exists("$sourcePath\$database")) {
      Write-Host -ForegroundColor DarkRed "No database file named '$database' found in $sourcePath. Skipping."
      continue
    }
    Write-Host -ForegroundColor Green "Copying $sourcePath\$database to the $targetPath folder."
    Copy-Item -Force -Path "$sourcePath\$database" -Destination "$targetPath"
  
    $targetFile = Get-Item -Path "$targetPath\$database"
    if ((Get-ItemProperty "$targetPath\$database").IsReadOnly) {
      Write-Host -ForegroundColor Green "Clearing readonly from $targetPath\$database."
      $targetFile.Attributes -= "ReadOnly"
    }
  }
}