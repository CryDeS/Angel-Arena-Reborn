@echo off

:: CONFIGURABLE
:: Please, configure you DOTA 2 PATH parent directory
:: DOTA_PATH=D:\Games\Steam\steamapps\common\dota 2 beta\

set DOTA_PATH=D:\Steam game\steamapps\common\dota 2 beta\
set ADDON_NAME=angel_arena_reborn

::
:: INTERNALS
::
 
set EXIT_WITH_ERROR=exit /b -1
set _ADDON_PATH=dota_addons\%ADDON_NAME%
set DOTA_GAME_PATH=%DOTA_PATH%\game\%_ADDON_PATH%
set DOTA_CONTENT_PATH=%DOTA_PATH%\content\%_ADDON_PATH%

set SOURCE_GAME_PATH=%cd%/game
set SOURCE_CONTENT_PATH=%cd%/content

if not 	exist "%SOURCE_GAME_PATH%" 		( echo Folder "%SOURCE_GAME_PATH%" not exists && %EXIT_WITH_ERROR%)
if not 	exist "%SOURCE_CONTENT_PATH%" 	( echo Folder "%%SOURCE_CONTENT_PATH%%" not exists && %EXIT_WITH_ERROR%)
if not 	exist "%DOTA_PATH%" 			( echo Dota path not found "%DOTA_PATH%" && %EXIT_WITH_ERROR% )
if 		exist "%DOTA_GAME_PATH%" 		( echo Dota game path "%DOTA_GAME_PATH%" already exists, it shouldn't && %EXIT_WITH_ERROR%)
if 		exist "%DOTA_CONTENT_PATH%" 	( echo Dota content path "%DOTA_CONTENT_PATH%" already exists, it shouldn't && %EXIT_WITH_ERROR%)

move "%SOURCE_GAME_PATH%" "%DOTA_GAME_PATH%"
move "%SOURCE_CONTENT_PATH%" "%DOTA_CONTENT_PATH%"

mklink /d /j "%SOURCE_GAME_PATH%" "%DOTA_GAME_PATH%" 
mklink /d /j "%SOURCE_CONTENT_PATH%" "%DOTA_CONTENT_PATH%" 

echo Done, symlinks created
pause
