#!/bin/bash

# Package Installer CLI - Build Script
# Cross-platform build script for the Go wrapper

set -e

APP_NAME="package-installer-cli"
VERSION="1.3.2"
BUILD_DIR="build"
LDFLAGS="-ldflags=-s -w -X main.appVersion=$VERSION"

echo "🚀 Building Package Installer CLI Go Wrapper v$VERSION"

# Clean and create build directory
echo "🧹 Cleaning build directory..."
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

# Build for all platforms
echo "🔨 Building for all platforms..."

echo "  📦 Building for Linux amd64..."
GOOS=linux GOARCH=amd64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/$APP_NAME-linux-amd64 .
GOOS=linux GOARCH=amd64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/pi-linux-amd64 .

echo "  📦 Building for Linux arm64..."
GOOS=linux GOARCH=arm64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/$APP_NAME-linux-arm64 .
GOOS=linux GOARCH=arm64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/pi-linux-arm64 .

echo "  📦 Building for Windows amd64..."
GOOS=windows GOARCH=amd64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/$APP_NAME-windows-amd64.exe .
GOOS=windows GOARCH=amd64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/pi-windows-amd64.exe .

echo "  📦 Building for Windows arm64..."
GOOS=windows GOARCH=arm64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/$APP_NAME-windows-arm64.exe .
GOOS=windows GOARCH=arm64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/pi-windows-arm64.exe .

echo "  📦 Building for macOS amd64..."
GOOS=darwin GOARCH=amd64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/$APP_NAME-darwin-amd64 .
GOOS=darwin GOARCH=amd64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/pi-darwin-amd64 .

echo "  📦 Building for macOS arm64..."
GOOS=darwin GOARCH=arm64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/$APP_NAME-darwin-arm64 .
GOOS=darwin GOARCH=arm64 go build -ldflags "-s -w -X main.appVersion=$VERSION" -o $BUILD_DIR/pi-darwin-arm64 .

echo "✅ Build completed! Binaries are in the $BUILD_DIR/ directory:"
ls -la $BUILD_DIR/

echo ""
echo "📋 Next steps:"
echo "  1. Copy the dist/ directory alongside your binary when distributing"
echo "  2. Run: ./$BUILD_DIR/$APP_NAME-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/') --help"
echo "  3. To create release packages, run: make package"