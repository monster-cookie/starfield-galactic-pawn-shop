@echo off

REM Notepad++/VSCODE needs current working directory to be where Caprica.exe is 
cd "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Tools"

copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist\GalacticPawnShop - Main.ba2" "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist\GalacticPawnShop - Textures.ba2" "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental"

REM mkdir "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental\textures\setdressing\terminals\splashscreens"
REM copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist\textures\setdressing\terminals\splashscreens\crimsonfleet_splashscreen_color.dds" "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental\textures\setdressing\terminals\splashscreens"
