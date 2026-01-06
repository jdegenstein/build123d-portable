#!/bin/bash

# 1. Get the directory where this script is located (The Bundle Root)
BUNDLE_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 2. Detect the Operating System
OS="$(uname -s)"

# 3. Define Configuration based on OS
if [ "$OS" = "Darwin" ]; then
    # --- MACOS CONFIGURATION ---
    
    # Path to the Python executable
    # TODO: Update folder name if version changes
    PYTHON_BIN="$BUNDLE_ROOT/pyinst/cpython-3.12.12-macos-aarch64-none/bin/python3"
    
    # Path to the VS Code executable
    VSCODE_EXEC="$BUNDLE_ROOT/vscode/Visual Studio Code.app/Contents/MacOS/Electron"
    
    # Data Directories
    DATA_ROOT="$BUNDLE_ROOT/vscode/code-portable-data"

elif [ "$OS" = "Linux" ]; then
    # --- LINUX CONFIGURATION ---
    
    # Path to the Python executable
    PYTHON_BIN="$BUNDLE_ROOT/pyinst/cpython-3.12.12-linux-x86_64-gnu/bin/python3"
    
    # Path to the VS Code executable
    VSCODE_EXEC="$BUNDLE_ROOT/vscode/VSCode-linux-x64/bin/code"
    
    # Data Directories
    DATA_ROOT="$BUNDLE_ROOT/vscode/VSCode-linux-x64/data"
    
else
    echo "Unsupported Operating System: $OS"
    exit 1
fi

# 4. Define Common Data Paths
USER_DATA_DIR="$DATA_ROOT/user-data"
EXT_DIR="$DATA_ROOT/extensions"
SETTINGS_FILE="$USER_DATA_DIR/User/settings.json"
PORTABLE_PYTHON_DIR="$(dirname "$PYTHON_BIN")"

# 5. Sanity Checks
if [ ! -f "$PYTHON_BIN" ]; then
    echo "ERROR: Python not found at: $PYTHON_BIN"
    exit 1
fi

if [ ! -f "$VSCODE_EXEC" ]; then
    echo "ERROR: VS Code not found at: $VSCODE_EXEC"
    if [ "$OS" = "Darwin" ]; then
        echo "Note: please run macos-install-vscode.sh first"
    fi
    exit 1
fi

# 6. Inject Absolute Python Path into settings.json (using sed)

if [ "$OS" = "Darwin" ]; then
    sed -i '' "s|\"python.defaultInterpreterPath\": \".*\"|\"python.defaultInterpreterPath\": \"$PYTHON_BIN\"|" "$SETTINGS_FILE"
else
    sed -i "s|\"python.defaultInterpreterPath\": \".*\"|\"python.defaultInterpreterPath\": \"$PYTHON_BIN\"|" "$SETTINGS_FILE"
fi

# 7. Prepend Portable Python to PATH
export PATH="$PORTABLE_PYTHON_DIR:$PATH"

# 8. Launch VS Code
# We force --user-data-dir and --extensions-dir to ensure strictly portable mode
# and prevent VS Code from falling back to system ~ (HOME) paths.

if [ "$OS" = "Darwin" ]; then
    "$VSCODE_EXEC" --user-data-dir "$USER_DATA_DIR" --extensions-dir "$EXT_DIR" "$@" >/dev/null 2>&1 &

elif [ "$OS" = "Linux" ]; then
    # linux needs the no-sandbox flag to run without manual permissions adjustments
    # there is technically a security risk here, but this is the best way to achieve 
    # ease-of-use currently
    # see https://code.visualstudio.com/docs/editor/portable#_linux for further information
    "$VSCODE_EXEC" --no-sandbox --user-data-dir "$USER_DATA_DIR" --extensions-dir "$EXT_DIR" "$@" >/dev/null 2>&1 &
fi
