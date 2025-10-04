package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
	"time"
)

const (
	appName    = "Package Installer CLI"
	appVersion = "1.4.0"
)

func main() {
	// Check if Node.js is available
	if !isNodeAvailable() {
		fmt.Fprintf(os.Stderr, "Error: Node.js is required but not found in PATH.\n")
		fmt.Fprintf(os.Stderr, "Please install Node.js from https://nodejs.org/\n")
		os.Exit(1)
	}

	// Get the binary name to determine how we were called
	binaryName := filepath.Base(os.Args[0])
	
	// Remove extension if on Windows
	if strings.HasSuffix(binaryName, ".exe") {
		binaryName = strings.TrimSuffix(binaryName, ".exe")
	}

	// Get the directory where the binary is located
	execPath, err := os.Executable()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error getting executable path: %v\n", err)
		os.Exit(1)
	}
	
	// Get the directory containing the executable
	execDir := filepath.Dir(execPath)
	
	// Path to the compiled TypeScript CLI
	cliPath := filepath.Join(execDir, "dist", "index.js")
	
	// Check if the CLI file exists
	if _, err := os.Stat(cliPath); os.IsNotExist(err) {
		fmt.Fprintf(os.Stderr, "Error: CLI file not found at %s\n", cliPath)
		fmt.Fprintf(os.Stderr, "Make sure the dist/ directory is present alongside the binary.\n")
		os.Exit(1)
	}

	// Check if dependencies are installed, if not run setup automatically
	if !areDependenciesInstalled(execDir) {
		fmt.Println("🔧 First time setup required. Installing dependencies...")
		if err := runSetupScript(execDir); err != nil {
			fmt.Fprintf(os.Stderr, "Error during setup: %v\n", err)
			fmt.Fprintf(os.Stderr, "Please run the setup script manually:\n")
			if runtime.GOOS == "windows" {
				fmt.Fprintf(os.Stderr, "  %s\\setup.bat\n", execDir)
			} else {
				fmt.Fprintf(os.Stderr, "  %s/setup.sh\n", execDir)
			}
			os.Exit(1)
		}
	}

	// Prepare the command to run the Node.js CLI
	// Whether called as 'pi' or 'package-installer-cli', we run the same Node.js CLI
	args := []string{cliPath}
	
	// Pass through all command line arguments
	if len(os.Args) > 1 {
		args = append(args, os.Args[1:]...)
	}

	// Create and execute the command: node dist/index.js [args...]
	cmd := exec.Command("node", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	// Run the command and exit with the same code
	if err := cmd.Run(); err != nil {
		if exitError, ok := err.(*exec.ExitError); ok {
			os.Exit(exitError.ExitCode())
		}
		fmt.Fprintf(os.Stderr, "Error executing command: %v\n", err)
		os.Exit(1)
	}
}

// isNodeAvailable checks if Node.js is available in the system PATH
func isNodeAvailable() bool {
	var cmd *exec.Cmd
	
	if runtime.GOOS == "windows" {
		cmd = exec.Command("cmd", "/c", "node", "--version")
	} else {
		cmd = exec.Command("node", "--version")
	}
	
	return cmd.Run() == nil
}

// areDependenciesInstalled checks if Node.js dependencies are installed
func areDependenciesInstalled(execDir string) bool {
	// Check if node_modules directory exists
	nodeModulesPath := filepath.Join(execDir, "node_modules")
	if _, err := os.Stat(nodeModulesPath); os.IsNotExist(err) {
		return false
	}
	
	// Check if package.json exists (indicating dependencies are needed)
	packageJsonPath := filepath.Join(execDir, "package.json")
	if _, err := os.Stat(packageJsonPath); os.IsNotExist(err) {
		// No package.json means dependencies might be bundled
		return true
	}
	
	// Try to run a simple node command to test if dependencies work
	testCmd := exec.Command("node", "-e", "require('commander')")
	testCmd.Dir = execDir
	return testCmd.Run() == nil
}

// runSetupScript executes the appropriate setup script based on the platform
func runSetupScript(execDir string) error {
	var setupScript string
	var cmd *exec.Cmd
	
	if runtime.GOOS == "windows" {
		setupScript = filepath.Join(execDir, "setup.bat")
		if _, err := os.Stat(setupScript); os.IsNotExist(err) {
			return fmt.Errorf("setup.bat not found")
		}
		cmd = exec.Command("cmd", "/c", setupScript)
	} else {
		setupScript = filepath.Join(execDir, "setup.sh")
		if _, err := os.Stat(setupScript); os.IsNotExist(err) {
			return fmt.Errorf("setup.sh not found")
		}
		// Make sure the script is executable
		os.Chmod(setupScript, 0755)
		cmd = exec.Command("bash", setupScript)
	}
	
	cmd.Dir = execDir
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	
	fmt.Printf("Running setup script: %s\n", setupScript)
	
	// Add a small delay to show the message
	time.Sleep(500 * time.Millisecond)
	
	return cmd.Run()
}