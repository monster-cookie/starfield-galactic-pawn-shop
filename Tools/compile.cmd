@echo off

@REM Notepad++/VSCODE needs current working directory to be where Caprica.exe is 
cd "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Tools"

@REM Clear Dist DIR
@echo "Clearing and scafolding the Dist dir"
del /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist\*.*"
rmdir /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"
REM mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist\textures\setdressing\terminals\splashscreens\"

@REM Clear Dist-BA2 DIR
@echo "Clearing and scafolding the Dist-BA2 dir"
del /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2\*.*"
rmdir /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2\textures\setdressing\terminals\splashscreens\"

REM ESM is purely binary so need to pull from starfield dir where xedit has to have it 
@echo "Copying the ESM from MO2 into the Dist folder"
copy /y "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental\GalacticPawnShop.esm" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\ESM"
copy /y "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental\GalacticPawnShop.esm" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"

REM Create and copy the BA2 to Dist folder
 @echo "Deploying textures to Dist-BA2"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\Textures\crimsonfleet_splashscreen_color.dds" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2\textures\setdressing\terminals\splashscreens"
@echo "Creating the BA2 Archive"
BSArch64.exe pack "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2" "GalacticPawnShop - Main.ba2" -sf1dds -mt
@echo "Copying the BA2 Archive to the Dist folder"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2\GalacticPawnShop - Main.ba2" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"
