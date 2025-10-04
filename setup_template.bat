@echo off
echo 🚀 Setting up Package Installer CLI...

:: Check if Node.js is available
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js is required but not found in PATH.
    echo    Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ Node.js found
node --version

:: Check if npm is available
npm --version >nul 2>&1
if errorlevel 1 (
    echo ❌ npm is required but not found in PATH.
    echo    Please install npm (usually comes with Node.js^)
    pause
    exit /b 1
)

echo ✅ npm found
npm --version

:: Install dependencies
echo 📦 Installing CLI dependencies...
npm install --production --silent

if errorlevel 1 (
    echo ❌ Failed to install dependencies
    echo    Please check your internet connection and try again
    pause
    exit /b 1
) else (
    echo ✅ Dependencies installed successfully!
    echo.
    echo 🎉 Setup complete! You can now use the CLI:
    echo    package-installer-cli.exe --help
    echo    pi.exe --help
    echo.
    pause
)