#!/bin/bash
BUNDLE_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 1: Ask user about downloading VS Code
echo "This script will download and install VS Code for macOS."
echo ""
read -p "Do you want to download and install VS Code? (y/n): " download_choice

if [[ "$download_choice" != "y" && "$download_choice" != "Y" ]]; then
    echo "Aborting. VS Code will not be downloaded."
    exit 0
fi

# Step 2: Download and install VS Code
echo ""
echo "Downloading VS Code..."
curl -L -o vscode.zip https://update.code.visualstudio.com/latest/darwin-universal/stable
cd vscode
unzip -q ../vscode.zip
cd ..
rm vscode.zip

# Step 3: Ask user about removing quarantine flags
echo ""
echo "macOS applies a quarantine flag to downloaded files for security."
echo "To run the bundled tools, the quarantine flag needs to be removed."
echo ""
echo "The following commands will be executed:"
echo "  xattr -dr com.apple.quarantine $BUNDLE_ROOT/pyinst"
echo "  xattr -dr com.apple.quarantine $BUNDLE_ROOT/python"
echo "  xattr -dr com.apple.quarantine $BUNDLE_ROOT/uv"
echo ""
read -p "Do you want to remove the quarantine flag from these folders? (y/n): " quarantine_choice

# Step 4: User must explicitly select 'y' (no default)
if [[ "$quarantine_choice" != "y" && "$quarantine_choice" != "Y" ]]; then
    echo "Quarantine flags will not be removed. Some tools may not work correctly."
    exit 0
fi

# Step 5: Remove quarantine flags
echo ""
echo "Removing quarantine flags..."
xattr -dr com.apple.quarantine $BUNDLE_ROOT/pyinst
xattr -dr com.apple.quarantine $BUNDLE_ROOT/python
xattr -dr com.apple.quarantine $BUNDLE_ROOT/uv

echo ""
echo "Done! VS Code and tools are ready to use."    
