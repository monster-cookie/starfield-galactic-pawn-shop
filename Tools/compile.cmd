@echo off

@REM Get Caprica from https://github.com/Orvid/Caprica currently installed is old manual compile -- v0.3.0 causes a io stream failure

@REM Notepad++/VSCODE needs current working directory to be where Caprica.exe is 
cd "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Tools"

@REM Clear Dist DIR
@echo "Clearing and scafolding the Dist dir"
del /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist\*.*"
rmdir /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"

@REM Clear Dist-BA2-Main DIR
@echo "Clearing and scafolding the Dist-BA2-Main dir"
del /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\*.*"
rmdir /s /q "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\Scripts\"

mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\meshes\Venworks\PawnShop"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\materials\Venworks\PawnShop"
mkdir "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\textures\Venworks\PawnShop"

@REM Compile and deploy Scripts to Dist-BA2-Main folder
@echo "Compiling all script in Source/Papyrus to Dist-BA2-Main folder"
"D:\Program Files\PexTools\Caprica-0.3.0.exe" --game starfield --import "C:\Repositories\Public\Starfield-Script-Source;C:\Repositories\Public\Starfield Mods\starfield-venpi-core\Source\Papyrus;C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\Papyrus" --output "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\Scripts" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\Papyrus" -R -q && (
  @echo "Compile all scripts has successfully compiled"
  (call )
) || (
  @echo "Error:  Compile all scripts has failed to compile <======================================="
  exit /b 1
)

REM ESM is purely binary so need to pull from starfield dir where xedit has to have it 
@echo "Copying the ESM from MO2 into the Dist folder"
copy /y "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental\GalacticPawnShop.esm" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\ESM"
copy /y "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental\GalacticPawnShop.esm" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"

@REM Use Spriggit to extract record from ESM
"D:\Program Files\Spriggit\Spriggit.CLI.exe" serialize --InputPath "D:\MO2Staging\Starfield\mods\GalacticPawnShop-Experimental\GalacticPawnShop.esm" --OutputPath "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\ESM-GalacticPawnShop-Extracted" --GameRelease Starfield --PackageName Spriggit.Yaml

@echo "Deploying textures to Dist-BA2-Textures"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\Meshes\pawn_shop_terminal.nif" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\meshes\Venworks\PawnShop"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\Materials\pawn_shop_splashscreen.mat" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\materials\Venworks\PawnShop"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Source\Textures\pawn_shop_splashscreen_color.dds" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\textures\Venworks\PawnShop"

@REM Create and copy the BA2 Main Archive to Dist folder
@echo "Creating the BA2 Main Archive"
"D:\Program Files\xEdit\BSArch64.exe" pack "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main" "GalacticPawnShop - Main.ba2" -sf1 -mt && (
  @echo "Main Archive successfully assembled"
  (call )
) || (
  @echo "ERROR:  Main Archive failed to assemble <======================================="
  exit /b 1
)

@REM Copying the BA2 Archives to the Dist folder
@echo "Copying the BA2 Archives to the Dist folder"
copy /y "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist-BA2-Main\GalacticPawnShop - Main.ba2" "C:\Repositories\Public\Starfield Mods\starfield-galactic-pawn-shop\Dist"
