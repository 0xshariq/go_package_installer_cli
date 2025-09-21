# Package Installer CLI - Go Wrapper Build Configuration

# Variables
APP_NAME = package-installer-cli
VERSION = 1.0.0
BUILD_DIR = build
DIST_DIR = dist

# Go build flags
LDFLAGS = -ldflags "-s -w -X main.appVersion=$(VERSION)"

# Default target
.PHONY: all
all: clean build-all

# Clean build directory
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)

# Build for current platform
.PHONY: build
build: clean
	go build $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME) .

# Build for all platforms
.PHONY: build-all
build-all: clean build-linux build-windows build-darwin

# Build for Linux (amd64 and arm64)
.PHONY: build-linux
build-linux:
	GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-linux-amd64 .
	GOOS=linux GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-linux-arm64 .

# Build for Windows (amd64 and arm64)
.PHONY: build-windows
build-windows:
	GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-windows-amd64.exe .
	GOOS=windows GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-windows-arm64.exe .

# Build for macOS (amd64 and arm64)
.PHONY: build-darwin
build-darwin:
	GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-darwin-amd64 .
	GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-darwin-arm64 .

# Create release packages
.PHONY: package
package: build-all
	@echo "Creating release packages..."
	# Copy dist directory to build for packaging
	cp -r $(DIST_DIR) $(BUILD_DIR)/
	
	# Create Linux packages
	cd $(BUILD_DIR) && tar -czf $(APP_NAME)-$(VERSION)-linux-amd64.tar.gz $(APP_NAME)-linux-amd64 $(DIST_DIR)/
	cd $(BUILD_DIR) && tar -czf $(APP_NAME)-$(VERSION)-linux-arm64.tar.gz $(APP_NAME)-linux-arm64 $(DIST_DIR)/
	
	# Create Windows packages
	cd $(BUILD_DIR) && zip -r $(APP_NAME)-$(VERSION)-windows-amd64.zip $(APP_NAME)-windows-amd64.exe $(DIST_DIR)/
	cd $(BUILD_DIR) && zip -r $(APP_NAME)-$(VERSION)-windows-arm64.zip $(APP_NAME)-windows-arm64.exe $(DIST_DIR)/
	
	# Create macOS packages
	cd $(BUILD_DIR) && tar -czf $(APP_NAME)-$(VERSION)-darwin-amd64.tar.gz $(APP_NAME)-darwin-amd64 $(DIST_DIR)/
	cd $(BUILD_DIR) && tar -czf $(APP_NAME)-$(VERSION)-darwin-arm64.tar.gz $(APP_NAME)-darwin-arm64 $(DIST_DIR)/
	
	@echo "Release packages created in $(BUILD_DIR)/"

# Install locally (requires sudo for system-wide installation)
.PHONY: install
install: build
	sudo cp $(BUILD_DIR)/$(APP_NAME) /usr/local/bin/
	@echo "$(APP_NAME) installed to /usr/local/bin/"

# Uninstall
.PHONY: uninstall
uninstall:
	sudo rm -f /usr/local/bin/$(APP_NAME)
	@echo "$(APP_NAME) uninstalled from /usr/local/bin/"

# Test the build
.PHONY: test
test: build
	$(BUILD_DIR)/$(APP_NAME) --help

# Show available targets
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build       - Build for current platform"
	@echo "  build-all   - Build for all platforms"
	@echo "  build-linux - Build for Linux (amd64, arm64)"
	@echo "  build-windows - Build for Windows (amd64, arm64)"
	@echo "  build-darwin - Build for macOS (amd64, arm64)"
	@echo "  package     - Create release packages"
	@echo "  install     - Install locally (requires sudo)"
	@echo "  uninstall   - Uninstall from system"
	@echo "  test        - Test the build"
	@echo "  clean       - Clean build directory"
	@echo "  help        - Show this help"