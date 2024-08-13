@echo off
setlocal

:: Set console color scheme for a nice appearance
color 0A

:: Clear the screen and display header
cls
echo ==========================================================
echo            Wave 1.0 Fix - Created by Sassy
echo ==========================================================

:: Get the current user's profile directory
set "userProfileDir=%USERPROFILE%"

:: Set the path to the directory containing WaveWindows.exe
set "waveDir=%userProfileDir%\AppData\Local\Wave"

:: Kill WaveWindows.exe and WaveBootstrapper.exe with force
echo Attempting to kill WaveWindows.exe and WaveBootstrapper.exe...
taskkill /f /im WaveWindows.exe >nul 2>&1
taskkill /f /im WaveBootstrapper.exe >nul 2>&1

:: Change to the directory
cd /d "%waveDir%"

:: Attempt to start WaveWindows.exe
echo Attempting to start WaveWindows.exe from: %waveDir%
start "" "WaveWindows.exe"

:: Check if the application started successfully
timeout /t 5 /nobreak >nul
tasklist /fi "IMAGENAME eq WaveWindows.exe" | find /i "WaveWindows.exe" >nul
if %ERRORLEVEL%==0 (
    echo Success: WaveWindows.exe is running.
) else (
    echo Error: WaveWindows.exe failed to start or is not running.
)

:: Display footer and pause before exiting
echo ==========================================================
echo              Script completed. Press any key to exit.
echo ==========================================================
pause >nul
exit /b 0
