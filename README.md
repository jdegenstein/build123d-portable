# build123d-portable
A cross-platform portable build123d installation with VSCode and OCP CAD Viewer.

## Why does this exist, and what is it?
Currently installing build123d and supporting tools is harder than it should be for the average new user just wanting to get started. `build123d-portable` aims to solve this issue by providing a "download, unzip, and run" experience without needing to understand anything about Python virtual environments and how to make VSCode work with them.

The main components provided with `build123d-portable` are:
 - Bundled standalone Python
 - [build123d](https://github.com/gumyr/build123d) library
 - VSCode editor Portable Mode (bundled as-is on Linux/Windows and downloaded via script on MacOS -- see below note on why this is necessary)
 - OCP CAD Viewer extension for VSCode (one of the most popular viewers for build123d)

Generally this project will be made available for all platforms for which the above components are supported. Currently that is Windows (x86_64), Linux (x86_64), and MacOS (arm64). 

## Installation (Windows / Linux)
1. Download the latest release for your OS from [releases](https://github.com/jdegenstein/build123d-portable/releases)
2. Extract the folder
3. Run the launcher script `Start_VSCode.*`

## Installation (MacOS)
1. Download the latest release for your OS from [releases](https://github.com/jdegenstein/build123d-portable/releases)
2. Unzip the folder
3. Run the `macos-install-vscode.sh` script which will unquarantine files and download and extract VSCode. (NOTE: This is necessary because it helps ensure the signed VSCode app is accepted by MacOS gatekeeper)
5. Run the launcher script `Start_VSCode.sh`

## Screenshot

<img width="1918" height="1163" alt="image" src="https://github.com/user-attachments/assets/a89ba40e-d22a-4986-a451-92f82f530e45" />

## Basic Example Script:

You can copy paste this into a new tab in VSCode and use the "Run Cell" buttons that appear on the imports and script body:
```py
# %%
from build123d import *
from ocp_vscode import *

# %%
length, width, thickness = 80.0, 60.0, 10.0

with BuildPart() as ex16_single:
    with BuildSketch(Plane.XZ) as ex16_sk:
        Rectangle(length, width)
        fillet(ex16_sk.vertices(), radius=length / 10)
        with GridLocations(x_spacing=length / 4, y_spacing=0, x_count=3, y_count=1):
            Circle(length / 12, mode=Mode.SUBTRACT)
        Rectangle(length, width, align=(Align.MIN, Align.MIN), mode=Mode.SUBTRACT)
    extrude(amount=length)

with BuildPart() as ex16:
    add(ex16_single.part)
    mirror(ex16_single.part, about=Plane.XY.offset(width))
    mirror(ex16_single.part, about=Plane.YX.offset(width))
    mirror(ex16_single.part, about=Plane.YZ.offset(width))
    mirror(ex16_single.part, about=Plane.YZ.offset(-width))

show_all()
```

## Other Useful Details:

- In a new tab you can type `?template` <TAB> and this will give you a preconfigured VSCode template for build123d modeling. The top part imports build123d and ocp_vscode (viewer library) and the bottom part has the statements to automatically show the objects you create in the 3D viewer. You can just add your build123d code to the middle section and re-run the cell to get an updated preview.
