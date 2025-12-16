#!/bin/bash

# 1. Get the directory where this script is located (The Bundle Root)
BUNDLE_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 2. Detect the Operating System
OS="$(uname -s)"

# 3. Define paths based on OS
if [ "$OS" = "Darwin" ]; then
    # --- MACOS CONFIGURATION ---
    
    # Path to the Python executable inside your bundle
    # TODO: Update 'cpython-3.12...macos...' to match your actual Mac Python folder name
    PYTHON_BIN="$BUNDLE_ROOT/pyinst/cpython-3.12.12-aarch64-apple-darwin/bin/python3"
    
    # Path to the VS Code executable
    # MacOS apps are folders. Point to the binary inside the .app bundle.
    VSCODE_EXEC="$BUNDLE_ROOT/vscode/Visual Studio Code.app/Contents/MacOS/Electron"
    
elif [ "$OS" = "Linux" ]; then
    # --- LINUX CONFIGURATION ---
    
    # Path to the Python executable inside your bundle
    # TODO: Update 'cpython-3.12...linux...' to match your actual Linux Python folder name
    PYTHON_BIN="$BUNDLE_ROOT/pyinst/cpython-3.12.12-linux-x86_64-gnu/bin/python3"
    
    # Path to the VS Code executable
    # On Linux, the binary is usually named 'code' inside the 'bin' folder
    VSCODE_EXEC="$BUNDLE_ROOT/vscode/bin/code"
    
else
    echo "Unsupported Operating System: $OS"
    exit 1
fi

# 4. Check if files actually exist (Sanity Check)
if [ ! -f "$PYTHON_BIN" ]; then
    echo "ERROR: Python not found at: $PYTHON_BIN"
    exit 1
fi

if [ ! -f "$VSCODE_EXEC" ]; then
    echo "ERROR: VS Code not found at: $VSCODE_EXEC"
    exit 1
fi

# 5. Export the variable for VS Code settings
export PORTABLE_PYTHON_BIN="$PYTHON_BIN"

# 6. Launch VS Code
# We explicitly set user-data-dir to ensure portability works regardless of folder names
"$VSCODE_EXEC" --user-data-dir "$BUNDLE_ROOT/vscode/data/user-data" "$@" &
