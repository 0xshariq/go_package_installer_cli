@echo off
setlocal enableextensions enabledelayedexpansion
set "DIR=%~dp0"

where node >nul 2>&1
if errorlevel 1 (
	echo Error: Node.js is required but not found in PATH.
	echo Install Node.js with: scoop install node (or use the installer from https://nodejs.org/)
	exit /b 2
)

node "%DIR%cli-with-packages.js" %*
exit /b %ERRORLEVEL%
