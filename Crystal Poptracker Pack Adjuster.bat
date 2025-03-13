@echo off
setlocal

:mainmenu
cls
echo Welcome to the Pokemon Crystal AP Poptracker Pack Adjuster by palex00
echo.
echo All this pack does is download files from https://github.com/palex00/crystal-ap-tracker/tree/user-overrides, move files and delete files inside your Document folder.
echo.
echo Please select what you want to adjust:
echo 1 - Badge Images
echo 2 - Map Overlays
echo 3 - Remove all modifications
echo.
echo To exit, close the program.
set /p option=Enter your choice (1/2/3): 

if "%option%"=="" goto mainmenu
if "%option%"=="1" goto badges
if "%option%"=="2" goto mapoverlays
if "%option%"=="3" goto remove_modifications
goto mainmenu


:badges
cls
echo Which version of badges do you want to use?
echo 1 - Retro with no border
echo 2 - Retro with 1-pixel white border
echo 3 - Retro with 2-pixel white border
echo 4 - Modern
set /p badge_choice=Enter your choice (1/2/3/4): 

set "folder="
if "%badge_choice%"=="1" set "folder=color_no_border"
if "%badge_choice%"=="2" set "folder=color_1_border"
if "%badge_choice%"=="3" set "folder=color_2_border"
if "%badge_choice%"=="4" set "folder=modern"
if "%badge_choice%"=="" goto badges

if "%folder%"=="" goto badges

set "target_dir=%USERPROFILE%\Documents\PopTracker\user-override\ap_crystal_palex00\images\items\"
if not exist "%target_dir%" (
    echo Creating directory: %target_dir%
    mkdir "%target_dir%"
)

echo Downloading badge images from GitHub...
powershell -Command "Invoke-WebRequest -Uri https://github.com/palex00/crystal-ap-tracker/archive/refs/heads/user-overrides.zip -OutFile '%temp%\crystal-ap-tracker.zip'"
powershell -Command "Expand-Archive -Path '%temp%\crystal-ap-tracker.zip' -DestinationPath '%temp%\crystal-ap-tracker'"

echo Copying from %temp%\crystal-ap-tracker\crystal-ap-tracker-user-overrides\badge_overrides\%folder% to %target_dir%
xcopy /s /y /q "%temp%\crystal-ap-tracker\crystal-ap-tracker-user-overrides\badge_overrides\%folder%\*" "%target_dir%"

rem Clean up downloaded files
rmdir /s /q "%temp%\crystal-ap-tracker"
del "%temp%\crystal-ap-tracker.zip"

echo Files downloaded and moved to %target_dir%


echo Done! If you had poptracker open, restart it to apply changes. Returning to root menu now.
pause
goto mainmenu

:mapoverlays
cls
echo Coming soon!
pause
goto mainmenu

:remove_modifications
echo Are you sure you want to remove all modifications? (Y/N)
set /p confirm=
if /I not "%confirm%"=="Y" goto mainmenu
cls
set "mod_dir=%USERPROFILE%\Documents\PopTracker\user-override\ap_crystal_palex00"
if exist "%mod_dir%" (
    echo Deleting modifications in: %mod_dir%
    rmdir /s /q "%mod_dir%"
    echo Modifications deleted.
) else (
    echo No modifications found to delete.
)
pause
goto mainmenu
