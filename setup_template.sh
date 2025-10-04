#!/bin/bash
echo "🚀 Setting up Package Installer CLI..."

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not found in PATH."
    echo "   Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js found: $(node --version)"

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "❌ npm is required but not found in PATH."
    echo "   Please install npm (usually comes with Node.js)"
    exit 1
fi

echo "✅ npm found: $(npm --version)"

# Install dependencies
echo "📦 Installing CLI dependencies..."
npm install --production --silent

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully!"
    echo ""
    echo "🎉 Setup complete! You can now use the CLI:"
    echo "   ./package-installer-cli-* --help"
    echo "   ./pi --help"
else
    echo "❌ Failed to install dependencies"
    echo "   Please check your internet connection and try again"
    exit 1
fi