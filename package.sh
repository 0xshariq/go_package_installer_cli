#!/bin/bash

# Package Installer CLI - Release Packaging Script
# Creates distribution packages without using zip

set -e

VERSION="1.4.0"
BUILD_DIR="build"
DIST_DIR="dist"

echo "🚀 Creating Package Installer CLI Release Packages v$VERSION"

# Ensure build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "❌ Build directory not found. Run build.sh first."
    exit 1
fi

echo "📦 Creating platform-specific tar.gz packages..."

cd "$BUILD_DIR"
for dir in bundle-linux-amd64 bundle-linux-arm64 bundle-macos-amd64 bundle-macos-arm64 bundle-windows-amd64 bundle-windows-arm64; do
    if [ -d "$dir" ]; then
        # Determine platform and arch from directory name
        # Format: bundle-<platform>-<arch>
        platform_arch=${dir#bundle-}
        # For package-installer-cli
        tar -czf "package-installer-cli-$VERSION-$platform_arch.tar.gz" "$dir/package-installer-cli" -C "$dir" .
        echo "  ✅ Created: package-installer-cli-$VERSION-$platform_arch.tar.gz"
        # For pi
        if [[ $platform_arch == windows-* ]]; then
            tar -czf "pi-$VERSION-$platform_arch.tar.gz" "$dir/pi.exe" -C "$dir" .
            echo "  ✅ Created: pi-$VERSION-$platform_arch.tar.gz"
        else
            tar -czf "pi-$VERSION-$platform_arch.tar.gz" "$dir/pi" -C "$dir" .
            echo "  ✅ Created: pi-$VERSION-$platform_arch.tar.gz"
        fi
    else
        echo "  ⚠️  Skipped missing directory: $dir"
    fi
done
cd ..

echo ""
echo "✅ All platform/arch bundles packaged as tar.gz in $BUILD_DIR/"
ls -lh $BUILD_DIR/*.tar.gz
echo ""
echo "🚀 Ready for distribution!"
echo "📋 Next steps:"
echo "  1. Upload the tar.gz files to your release platform."
echo "  2. Test the bundles on different platforms."
echo "  3. Update documentation with download links."