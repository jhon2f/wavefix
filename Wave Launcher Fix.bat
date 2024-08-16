@echo off
setlocal

:: Get the current username
set "USERNAME=%USERNAME%"

:: Set variables using the current username
set "RAR_FILE=C:\Wave.rar"
set "TARGET_DIR=C:\Users\%USERNAME%\AppData\Local\Wave"
set "PATCHED_FILE=%TARGET_DIR%\patched.txt"
set "OLD_SHORTCUT_PATH1=C:\Users\%USERNAME%\Desktop\Wave.lnk"
set "OLD_SHORTCUT_PATH2=C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Wave\Wave.lnk"
set "NEW_SHORTCUT_DIR=C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Wave"
set "NEW_SHORTCUT_PATH=%NEW_SHORTCUT_DIR%\Wave.lnk"
set "NEW_SHORTCUT_DESKTOP=C:\Users\%USERNAME%\Desktop\Wave.lnk"
set "NEW_TARGET=C:\Users\%USERNAME%\AppData\Local\Wave\WaveWindows.exe"
set "START_IN=C:\Users\%USERNAME%\AppData\Local\Wave"

:: Check if the RAR file exists
if not exist "%RAR_FILE%" (
    echo Wave.rar is missing.
    echo Please download the RAR file from the following link and place it in C:\
    echo https://zerocdn.com/700465151/Wave.rar
    echo.
    echo Press any key once the file is placed in C:\
    pause
    exit /b
)

:: Clear the target directory if patched file does not exist
if not exist "%PATCHED_FILE%" (
    echo Clearing directory: %TARGET_DIR%
    if exist "%TARGET_DIR%" (
        rd /s /q "%TARGET_DIR%"
    )
    mkdir "%TARGET_DIR%"

    :: Extract the RAR file
    echo Extracting RAR file to: %TARGET_DIR%
    "C:\Program Files\WinRAR\WinRAR.exe" x -ibck "%RAR_FILE%" "%TARGET_DIR%"

    :: Create patched.txt file
    echo Patched > "%PATCHED_FILE%"

    :: Run the old shortcut to start the application the first time
    echo Running the old shortcut to start the application...
    start "" "%OLD_SHORTCUT_PATH2%"

    :: Pause to let the application start
    timeout /t 5
)

:: Delete old shortcuts if they exist
echo Deleting old shortcuts...
if exist "%OLD_SHORTCUT_PATH1%" (
    del "%OLD_SHORTCUT_PATH1%"
)
if exist "%OLD_SHORTCUT_PATH2%" (
    del "%OLD_SHORTCUT_PATH2%"
)

:: Check if the new shortcut directory exists, create if it doesn't
if not exist "%NEW_SHORTCUT_DIR%" (
    echo Creating shortcut directory: %NEW_SHORTCUT_DIR%
    mkdir "%NEW_SHORTCUT_DIR%"
)

:: Create the new shortcut with "Start In" directory
echo Creating new shortcut: %NEW_SHORTCUT_PATH%
powershell -command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%NEW_SHORTCUT_PATH%'); $s.TargetPath='%NEW_TARGET%'; $s.WorkingDirectory='%START_IN%'; $s.Save()"

:: Check if the shortcut was created successfully
if exist "%NEW_SHORTCUT_PATH%" (
    echo Shortcut created successfully.

    :: Copy the shortcut to the desktop
    echo Copying shortcut to desktop: %NEW_SHORTCUT_DESKTOP%
    copy "%NEW_SHORTCUT_PATH%" "%NEW_SHORTCUT_DESKTOP%"

    :: Check if the desktop shortcut was created successfully
    if exist "%NEW_SHORTCUT_DESKTOP%" (
        echo Desktop shortcut created successfully.
    ) else (
        echo Failed to create desktop shortcut.
    )
) else (
    echo Failed to create the shortcut.
)

:: Clean up
cls
echo Done.
echo You may now open Wave from the shortcut on your desktop.

pause
endlocal
