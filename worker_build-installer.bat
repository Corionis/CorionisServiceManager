@echo off
REM Worker to build the installer
REM
REM Requires Advanced Installer to be available and
REM the "aiexe" variable below to be set correctly.


REM The location of the Advanced Installer executable MUST be correct
set aiexe=D:\Tools\Advanced Installer 13.7\bin\x86\AdvancedInstaller.com

if not exist "%aiexe%" goto NoAI


if "r%1" == "r" goto NoArgs

echo/
echo Building the Corionis Service Manager MSI installer %1
echo/

REM get positioned to the correct directory
set thisdir=%~dp0
cd /d "%thisdir%"

REM clean-out any prior msi files
if exist "*.msi" del /q "*.msi"

REM set the version and build the installer
"%aiexe%" /edit "Corionis Service Manager.aip" /SetVersion %1
"%aiexe%" /edit "Corionis Service Manager.aip" /SetProductCode -langid 1033
"%aiexe%"  /rebuild "Corionis Service Manager.aip"
set r=%ERRORLEVEL%
if not %r% == 0 goto Error

REM generate a new _config.yml with the build number
echo theme: jekyll-theme-tactile >docs/_config.yml
echo title: Corionis Service Manager >>docs/_config.yml
echo description: Monitor ^& manage selected Windows services >>docs/_config.yml
echo show_downloads: true >>docs/_config.yml
echo excerpt_separator: thisnevermatchme >>docs/_config.yml
echo version: %1>>docs/_config.yml

goto JXT

:NoAI
echo/
echo ERROR: Building the installer requires the free version of Advanced Installer.
echo Cannot find the executable as specified in this batch file.
echo Install Advanced Installer and/or edit this batch file to set the location.
echo See http://www.advancedinstaller.com/
goto JXT

:NoArgs
echo/
echo ERROR: Requires an argument for the version number, e.g. 1.2.3.456
echo It is recommended to use the generated build_installer.bat that has
echo the version incremented from the last build with AutoIt.
goto JXT

:Error
echo/
echo An error occurred while building the installer.

:JXT
echo/
set /p r="Press ENTER to continue: "
