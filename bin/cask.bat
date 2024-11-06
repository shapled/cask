@echo off

setlocal enabledelayedexpansion

set "ARGS=%*"
set "EMACS=%CASK_EMACS%"
for /f "delims=" %%i in ('where cask.bat') do (set CASK=%%i & goto :doneCask)
:doneCask
if "%EMACS%"=="" set "EMACS=%EMACS%"
if "%EMACS%"=="" set "EMACS=emacs"

if "%~1"=="" (
    set "subcommand=install"
) else (
    set "subcommand=%1"
    shift /1
    for /f "tokens=1,* delims= " %%a in ("%*") do set ARGS=%%b
)

for %%I in ("%CASK%") do set "SRCDIR_=%%~dpI"
for %%I in ("%SRCDIR_%") do set "SRCDIR=%%~dpI.."

if /i "%subcommand%"=="emacs" (
    "%EMACS%" -Q -L "%SRCDIR%" -l "%SRCDIR%\cask" --eval "(cask--initialize (expand-file-name default-directory))" %ARGS%
) else if /i "%subcommand%"=="exec" (
    set "EMACSLOADPATH=%CASK% load-path"
    set "PATH=%CASK% path;%PATH%"
    "%EMACS%" %ARGS%
) else (
    "%EMACS%" -Q --script "%SRCDIR%\cask-cli.el" -- %subcommand% %ARGS%
)

endlocal
