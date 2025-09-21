#!/bin/bash

# Package Installer CLI - Release Packaging Script
# Creates distribution packages without using zip

set -e

VERSION="1.0.0"
BUILD_DIR="build"
DIST_DIR="dist"

echo "🚀 Creating Package Installer CLI Release Packages v$VERSION"

# Ensure build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "❌ Build directory not found. Run 'make build-all' first."
    exit 1
fi

# Ensure dist directory exists
if [ ! -d "$DIST_DIR" ]; then
    echo "❌ Dist directory not found. Build the TypeScript CLI first."
    exit 1
fi

echo "📦 Creating distribution packages..."

# Function to create a package
create_package() {
    local binary_name=$1
    local platform=$2
    local arch=$3
    local extension=$4
    
    local package_name="package-installer-cli-$VERSION-$platform-$arch"
    local package_dir="$BUILD_DIR/$package_name"
    
    echo "  📦 Creating package: $package_name"
    
    # Create package directory
    mkdir -p "$package_dir"
    
    # Copy binary
    cp "$BUILD_DIR/$binary_name$extension" "$package_dir/"
    
    # Copy dist directory
    cp -r "$DIST_DIR" "$package_dir/"
    
    # Copy package.json
    cp "package.json" "$package_dir/"
    
    # Copy template.json
    cp "template.json" "$package_dir/"
    
    # Copy templates directory
    cp -r "templates" "$package_dir/"
    
    # Copy features directory
    cp -r "features" "$package_dir/"
    
    # Create README for the package
    cat > "$package_dir/README.txt" << EOF
Package Installer CLI v$VERSION
==============================

This package contains:
- $binary_name$extension: Main CLI binary
- dist/: TypeScript CLI implementation
- package.json: Package configuration
- template.json: Template definitions
- templates/: Project templates
- features/: Feature integrations

Installation:
1. Extract this package
2. Add the binary to your PATH
3. Ensure Node.js is installed
4. Run: $binary_name --help

For more information, visit:
https://github.com/0xshariq/go_package_installer_cli

The binary can be used as both:
- package-installer-cli [command]
- pi [command]
EOF

    # Create tar.gz package
    cd "$BUILD_DIR"
    tar -czf "$package_name.tar.gz" "$package_name"
    cd ..
    
    # Remove temporary directory
    rm -rf "$package_dir"
    
    echo "  ✅ Created: $BUILD_DIR/$package_name.tar.gz"
}

# Create packages for all platforms
echo "🔨 Creating Linux packages..."
create_package "package-installer-cli-linux-amd64" "linux" "amd64" ""
create_package "package-installer-cli-linux-arm64" "linux" "arm64" ""

echo "🔨 Creating Windows packages..."
create_package "package-installer-cli-windows-amd64.exe" "windows" "amd64" ""
create_package "package-installer-cli-windows-arm64.exe" "windows" "arm64" ""

echo "🔨 Creating macOS packages..."
create_package "package-installer-cli-darwin-amd64" "darwin" "amd64" ""
create_package "package-installer-cli-darwin-arm64" "darwin" "arm64" ""

# Create pi-specific packages
echo "🔨 Creating pi binary packages..."
create_package() {
    local binary_name=$1
    local platform=$2
    local arch=$3
    local extension=$4
    
    local package_name="pi-$VERSION-$platform-$arch"
    local package_dir="$BUILD_DIR/$package_name"
    
    echo "  📦 Creating package: $package_name"
    
    # Create package directory
    mkdir -p "$package_dir"
    
    # Copy binary (rename to pi)
    if [ "$platform" = "windows" ]; then
        cp "$BUILD_DIR/$binary_name" "$package_dir/pi.exe"
    else
        cp "$BUILD_DIR/$binary_name" "$package_dir/pi"
    fi
    
    # Copy dist directory
    cp -r "$DIST_DIR" "$package_dir/"
    
    # Copy package.json
    cp "package.json" "$package_dir/"
    
    # Copy template.json
    cp "template.json" "$package_dir/"
    
    # Copy templates directory
    cp -r "templates" "$package_dir/"
    
    # Copy features directory
    cp -r "features" "$package_dir/"
    
    # Create README for the package
    cat > "$package_dir/README.txt" << EOF
Package Installer CLI (pi) v$VERSION
====================================

This package contains:
- pi$extension: CLI binary (short command)
- dist/: TypeScript CLI implementation
- package.json: Package configuration
- template.json: Template definitions
- templates/: Project templates
- features/: Feature integrations

Installation:
1. Extract this package
2. Add the binary to your PATH
3. Ensure Node.js is installed
4. Run: pi --help

Usage:
- pi create my-app
- pi analyze
- pi update
- pi add auth

For more information, visit:
https://github.com/0xshariq/go_package_installer_cli
EOF

    # Create tar.gz package
    cd "$BUILD_DIR"
    tar -czf "$package_name.tar.gz" "$package_name"
    cd ..
    
    # Remove temporary directory
    rm -rf "$package_dir"
    
    echo "  ✅ Created: $BUILD_DIR/$package_name.tar.gz"
}

create_package "pi-linux-amd64" "linux" "amd64" ""
create_package "pi-linux-arm64" "linux" "arm64" ""
create_package "pi-windows-amd64.exe" "windows" "amd64" ".exe"
create_package "pi-windows-arm64.exe" "windows" "arm64" ".exe"
create_package "pi-darwin-amd64" "darwin" "amd64" ""
create_package "pi-darwin-arm64" "darwin" "arm64" ""

echo ""
echo "✅ All packages created successfully!"
echo "📁 Release packages are in the $BUILD_DIR/ directory:"
echo ""
ls -la "$BUILD_DIR"/*.tar.gz

echo ""
echo "🚀 Ready for distribution!"
echo "📋 Next steps:"
echo "  1. Upload packages to GitHub Releases"
echo "  2. Create checksums: sha256sum build/*.tar.gz > build/checksums.txt"
echo "  3. Test packages on different platforms"
echo "  4. Update documentation with download links"