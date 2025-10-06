#!/bin/bash

# Package Installer CLI - Build Script
# Cross-platform build script for the Go wrapper

set -e

APP_NAME="package-installer-cli"
VERSION="2.0.0"
BUILD_DIR="build"
LDFLAGS="-ldflags=-s -w -X main.appVersion=$VERSION"

echo "🚀 Building Package Installer CLI Go Wrapper v$VERSION"

# Clean and create build directory
echo "🧹 Cleaning build directory..."
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR


# Build Go binaries for all platforms/architectures (both names)
echo "🔨 Building Go binaries for all platforms (package-installer-cli and pi)..."
# Linux amd64
GOOS=linux   GOARCH=amd64 go build -o $BUILD_DIR/package-installer-cli-linux-amd64   .
GOOS=linux   GOARCH=amd64 go build -o $BUILD_DIR/pi-linux-amd64   .
# Linux arm64
GOOS=linux   GOARCH=arm64 go build -o $BUILD_DIR/package-installer-cli-linux-arm64   .
GOOS=linux   GOARCH=arm64 go build -o $BUILD_DIR/pi-linux-arm64   .
# macOS amd64
GOOS=darwin  GOARCH=amd64 go build -o $BUILD_DIR/package-installer-cli-macos-amd64   .
GOOS=darwin  GOARCH=amd64 go build -o $BUILD_DIR/pi-macos-amd64   .
# macOS arm64
GOOS=darwin  GOARCH=arm64 go build -o $BUILD_DIR/package-installer-cli-macos-arm64   .
GOOS=darwin  GOARCH=arm64 go build -o $BUILD_DIR/pi-macos-arm64   .
# Windows amd64
GOOS=windows GOARCH=amd64 go build -o $BUILD_DIR/package-installer-cli-windows-amd64.exe   .
GOOS=windows GOARCH=amd64 go build -o $BUILD_DIR/pi-windows-amd64.exe   .
# Windows arm64
GOOS=windows GOARCH=arm64 go build -o $BUILD_DIR/package-installer-cli-windows-arm64.exe   .
GOOS=windows GOARCH=arm64 go build -o $BUILD_DIR/pi-windows-arm64.exe   .

# Linux amd64
echo "📦 Preparing bundle for Linux amd64..."
cp -r bundle-executables $BUILD_DIR/bundle-linux-amd64
cp $BUILD_DIR/package-installer-cli-linux-amd64 $BUILD_DIR/bundle-linux-amd64/package-installer-cli
cp $BUILD_DIR/pi-linux-amd64 $BUILD_DIR/bundle-linux-amd64/pi

# Linux arm64
echo "📦 Preparing bundle for Linux arm64..."
cp -r bundle-executables $BUILD_DIR/bundle-linux-arm64
cp $BUILD_DIR/package-installer-cli-linux-arm64 $BUILD_DIR/bundle-linux-arm64/package-installer-cli
cp $BUILD_DIR/pi-linux-arm64 $BUILD_DIR/bundle-linux-arm64/pi

# macOS amd64
echo "📦 Preparing bundle for macOS amd64..."
cp -r bundle-executables $BUILD_DIR/bundle-macos-amd64
cp $BUILD_DIR/package-installer-cli-macos-amd64 $BUILD_DIR/bundle-macos-amd64/package-installer-cli
cp $BUILD_DIR/pi-macos-amd64 $BUILD_DIR/bundle-macos-amd64/pi

# macOS arm64
echo "📦 Preparing bundle for macOS arm64..."
cp -r bundle-executables $BUILD_DIR/bundle-macos-arm64
cp $BUILD_DIR/package-installer-cli-macos-arm64 $BUILD_DIR/bundle-macos-arm64/package-installer-cli
cp $BUILD_DIR/pi-macos-arm64 $BUILD_DIR/bundle-macos-arm64/pi

# Windows amd64
echo "📦 Preparing bundle for Windows amd64..."
cp -r bundle-executables $BUILD_DIR/bundle-windows-amd64
cp $BUILD_DIR/package-installer-cli-windows-amd64.exe $BUILD_DIR/bundle-windows-amd64/package-installer-cli.exe
cp $BUILD_DIR/pi-windows-amd64.exe $BUILD_DIR/bundle-windows-amd64/pi.exe

# Windows arm64
echo "📦 Preparing bundle for Windows arm64..."
cp -r bundle-executables $BUILD_DIR/bundle-windows-arm64
cp $BUILD_DIR/package-installer-cli-windows-arm64.exe $BUILD_DIR/bundle-windows-arm64/package-installer-cli.exe
cp $BUILD_DIR/pi-windows-arm64.exe $BUILD_DIR/bundle-windows-arm64/pi.exe

echo "✅ Bundles are ready in the $BUILD_DIR/ directory:"
ls -la $BUILD_DIR/

echo ""
echo "📋 Next steps:"
echo "  1. Distribute the bundle-* directories from build/"
echo "  2. To create release packages, run: ./package.sh"