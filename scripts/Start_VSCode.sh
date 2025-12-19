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
    PYTHON_BIN="$BUNDLE_ROOT/pyinst/cpython-3.12.12-macos-aarch64-none/bin/python3"
    
    # Path to the VS Code executable
    # MacOS apps are folders. Point to the binary inside the .app bundle.
    VSCODE_EXEC="$BUNDLE_ROOT/vscode/Visual Studio Code.app/Contents/MacOS/Electron"

    export PORTABLE_PYTHON_DIR="$(dirname "$PYTHON_BIN")"
    
elif [ "$OS" = "Linux" ]; then
    # --- LINUX CONFIGURATION ---
    
    # Path to the Python executable inside your bundle
    # TODO: Update 'cpython-3.12...linux...' to match your actual Linux Python folder name
    PYTHON_BIN="$BUNDLE_ROOT/pyinst/cpython-3.12.12-linux-x86_64-gnu/bin/python3"
    
    # Path to the VS Code executable
    # On Linux, the binary is usually named 'code' inside the 'bin' folder
    VSCODE_EXEC="$BUNDLE_ROOT/vscode/VSCode-linux-x64/bin/code"

    export PORTABLE_PYTHON_DIR="$(dirname "$PYTHON_BIN")"
    
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

# 6. Export PATH with portable python directory prepended
export PATH="$PORTABLE_PYTHON_DIR:$PATH"

# 7. Launch VS Code
# We explicitly set user-data-dir to ensure portability works regardless of folder names

if [ "$OS" = "Darwin" ]; then
    "$VSCODE_EXEC" "$@" &
    
elif [ "$OS" = "Linux" ]; then
    # linux needs the no-sandbox flag to run without manual permissions adjustments
    # there is technically a security risk here, but this is the best way to achieve 
    # ease-of-use currently
    # see https://code.visualstudio.com/docs/editor/portable#_linux for further information
    "$VSCODE_EXEC" --no-sandbox "$@" &
fi
