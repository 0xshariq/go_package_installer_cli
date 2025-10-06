#!/bin/bash

# Package Installer CLI - Build Script
# Cross-platform build script for the Go wrapper

set -e

APP_NAME="package-installer-cli"
# Linux arm64
echo "� Preparing bundle for Linux arm64..."
cp -r bundle-executables $BUILD_DIR/bundle-linux-arm64
cp $BUILD_DIR/package-installer-cli-linux-arm64 $BUILD_DIR/bundle-linux-arm64/package-installer-cli

echo "✅ Binaries with embedded bundle are ready in the $BUILD_DIR/ directory:"
ls -la $BUILD_DIR/

cp $BUILD_DIR/pi-linux-arm64 $BUILD_DIR/bundle-linux-arm64/pi

# macOS amd64
echo "  2. To create release packages, run: ./package.sh"
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