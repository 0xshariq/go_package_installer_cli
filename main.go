package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
)

const (
	appName    = "Package Installer CLI"
	appVersion = "3.2.0"
)

func main() {
	// Check if Node.js is available
	if !isNodeAvailable() {
		fmt.Fprintf(os.Stderr, "Error: Node.js is required but not found in PATH.\n")
		fmt.Fprintf(os.Stderr, "Please install Node.js from https://nodejs.org/\n")
		os.Exit(1)
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

	// Prepare the command to run the Node.js CLI
	args := []string{cliPath}
	if len(os.Args) > 1 {
		args = append(args, os.Args[1:]...)
	}

	// Create and execute the command
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