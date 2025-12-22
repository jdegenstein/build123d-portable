package main

import (
	"log"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	// 1. Get the absolute path of this executable
	ex, err := os.Executable()
	if err != nil {
		log.Fatal(err)
	}
	dir := filepath.Dir(ex)

	// 2. Construct the path to the shell script
	// We assume the script is always right next to the binary
	scriptPath := filepath.Join(dir, "Start_VSCode.sh")

	// 3. Prepare the command
	cmd := exec.Command(scriptPath)
	
	// Pass arguments if the user provided any (e.g. file paths)
	cmd.Args = append(cmd.Args, os.Args[1:]...)

	// Connect input/output (helpful for debugging, but optional for GUI)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	// 4. Run it
	// We use Run() to wait for the script to finish. 
	// Since your .sh script backgrounds VS Code (using '&'), 
	// the script exits instantly, and so will this launcher.
	if err := cmd.Run(); err != nil {
		log.Fatal(err)
	}
}
