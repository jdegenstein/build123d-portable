# build123d-portable
A cross-platform portable build123d installation with VSCode and OCP CAD Viewer.

## Why does this exist, and what is it?
Currently installing build123d and supporting tools is harder than it should be for the average new user just wanting to get started. `build123d-portable` aims to solve this issue by providing a "download, unzip, and run" experience without needing to understand anything about Python virtual environments and how to make VSCode work with them.

The main components provided with `build123d-portable` are:
 - Bundled standalone Python
 - [build123d](https://github.com/gumyr/build123d) library
 - VSCode editor Portable Mode)
 - OCP CAD Viewer extension for VSCode (one of the most popular viewers for build123d)

Generally this project will be made available for all platforms for which the above components are supported. Currently that is Windows (x86_64), Linux (x86_64), and MacOS (arm64). 

## Installation
1. Download the latest release for your OS from [releases](https://github.com/jdegenstein/build123d-portable/releases)
2. Unzip the folder
3. Run the launcher script `Start_VSCode`

## Screenshot

<img width="1918" height="1163" alt="image" src="https://github.com/user-attachments/assets/a89ba40e-d22a-4986-a451-92f82f530e45" />
