@echo off

REM Notepad++/VSCODE needs current working directory to be where Caprica.exe is 
cd "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Tools"

del /s /q "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental\*.ba2"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist\GalacticPawnShop - Main.ba2" "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental"
