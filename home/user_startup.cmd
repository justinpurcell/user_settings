:: useful user startup for my surface and hvd on windows
@echo off
setlocal
echo %COMPUTERNAME% | findstr "HVD" >nul 2>&1 && set "WHATPC=HVD" || set "WHATPC=LOCAL"

:: 32 or 64 bit
FOR /F "tokens=3" %%x in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /V PROCESSOR_ARCHITECTURE') do set "_ARCH=%%x"
set "_ARCH=x%_ARCH:~-2%"

:: Not needed apps
set "not_needed_apps_hvd=lync busylight MSEdge RunTimeBroker BingWallpaperApp spotify snagit Teams"
set "not_needed_apps_local=lync busylight MSEdge RunTimeBroker BingWallpaperApp spotify snagit"

if "%ahome%"=="" set "ahome=%~dp0"
if "%ancp%"=="" (
for %%I in ("%ahome%\..") do (set "ancp=%~dpnxI")
)
if "%anc%"=="" (
for %%I in ("%ahome%\..") do (set "anc=%~dpnxI")
)
if "%aapps%"=="" set "aapps=%ahome%\apps"
if "%appps%"=="" set "appps=%ahome%\portableapps"
if "%ashell%"=="" set "ashell=%ahome%\shell"
if "%batch%"=="" set "batch=%ahome%\shell\cmd"

:: This ensures a PAUSE if run from double clicking a batch file, and no pause if run from cmd line
:: Similiar functionality to bash $-
:: See https://stackoverflow.com/questions/886848/how-to-make-windows-batch-file-pause-when-double-clicked/12036163#12036163
if "%parent%"=="" set parent=%~0
if "%console_mode%"=="" (set console_mode=1& for %%x in (%cmdcmdline%) do if /i "%%~x"=="/c" set console_mode=0)

@echo.
for /f "usebackq delims==" %%X in (`"%batch%\get_console_width.cmd"`) do (SET /A console_width=%%X-2)
@echo %~n0
call "%batch%\repeat.cmd" - %console_width%
@echo.

:: Not needed apps
if /I "%WHATPC%"=="LOCAL" (
for %%A in (%not_needed_apps_loc%) do (
call "%batch%\cmd\tk.cmd" %%A*
)
)

if /I "%WHATPC%"=="HVD" (
for %%A in (%not_needed_apps_hvd%) do (
call "%batch%\tk.cmd" %%A*
)
)
:: my productivity hotkeys
:: use 32 bit even if 64 bit CPU
@ECHO ...assigning Hotkeys
start "" /D "%aapps%\autohotkey" "%aapps%\autohotkey\AutoHotkeyU32.exe" "%aapps%\autohotkey\autohotkey.ahk"

:: clipboard manager
:: use 32 or 64 bit depending on CPU
@ECHO ...clipboard Manager
IF "%_ARCH%==64" (
start "" /D "%aapps%\Clipjump\x64" "%aapps%\Clipjump\x64\Clipjump_x64.exe"
) else (
start "" /D "%aapps%\Clipjump\x64" "%aapps%\Clipjump\x86\Clipjump.exe"
)

:: sysinfo
@echo %COMPUTERNAME% - %OS%
@ECHO.
call "%batch%\repeat.cmd" - %console_width%
@echo.
if "%parent%"=="%~0" ( if "%console_mode%"=="0" pause. >nul | echo Press Any Key to Quit )
:eof
