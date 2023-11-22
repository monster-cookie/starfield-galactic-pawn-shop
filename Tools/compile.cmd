@echo off

@REM Get Caprica from https://github.com/Orvid/Caprica currently installed is old manual compile -- v0.3.0 causes a io stream failure

@REM Notepad++/VSCODE needs current working directory to be where Caprica.exe is 
cd "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Tools"

@REM Clear Dist DIR
@echo "Clearing and scafolding the Dist dir"
del /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist\*.*"
rmdir /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"
REM mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist\textures\setdressing\terminals\splashscreens\"

@REM Clear Dist-BA2-Main DIR
@echo "Clearing and scafolding the Dist-BA2-Main dir"
del /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\*.*"
rmdir /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\Scripts\"

@REM Clear Dist-BA2-Textures DIR
@echo "Clearing and scafolding the Dist-BA2-Textures dir"
del /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Textures\*.*"
rmdir /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Textures"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Textures"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Textures\textures\setdressing\terminals\splashscreens\"

REM Compile and deploy Scripts to Dist-BA2-Main folder
Caprica-Experimental.exe --game starfield --flags "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Tools\Starfield_Papyrus_Flags.flg" --import "C:\Repositories\Public\Starfield-Script-Source;C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\Papyrus;C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\Papyrus" --output "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\Scripts" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\Papyrus\VPI_VendorActivatorScript.psc" && (
  @echo "VPI_VendorActivatorScript.psc successfully compiled"
  (call )
) || (
  @echo "ERROR:  VPI_VendorActivatorScript.psc failed to compile <======================================="
  exit /b 1
)

REM ESM is purely binary so need to pull from starfield dir where xedit has to have it 
@echo "Copying the ESM from MO2 into the Dist folder"
copy /y "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental\GalacticPawnShop.esm" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\ESM"
copy /y "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental\GalacticPawnShop.esm" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"

REM Create and copy the BA2 Textures Archive to Dist folder
 @echo "Deploying textures to Dist-BA2-Textures"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\Textures\crimsonfleet_splashscreen_color.dds" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Textures\textures\setdressing\terminals\splashscreens"
@echo "Creating the BA2 Textures Archive"
BSArch64.exe pack "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Textures" "GalacticPawnShop - Textures.ba2" -sf1dds -mt && (
  @echo "Textures Archive successfully assembled"
  (call )
) || (
  @echo "ERROR:  Textures Archive failed to assemble <======================================="
  exit /b 1
)

REM Create and copy the BA2 Main Archive to Dist folder
REM @echo "Deploying Scripts to Dist-BA2-Main"
REM copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\Textures\crimsonfleet_splashscreen_color.dds" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Textures\textures\setdressing\terminals\splashscreens"
@echo "Creating the BA2 Main Archive"
BSArch64.exe pack "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main" "GalacticPawnShop - Main.ba2" -sf1 -mt && (
  @echo "Main Archive successfully assembled"
  (call )
) || (
  @echo "ERROR:  Main Archive failed to assemble <======================================="
  exit /b 1
)

@echo "Copying the BA2 Archives to the Dist folder"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Textures\GalacticPawnShop - Textures.ba2" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\GalacticPawnShop - Main.ba2" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"
