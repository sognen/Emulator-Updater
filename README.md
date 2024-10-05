# One-Click Emulator Updater

This repository contains scripts that automate the process of updating various emulators to its latest version.

## Supported Emulators:

1. **`RPCS3`**
2. **`Dolphin`**
4. **`Sudachi`**
5. **`Lime3ds`**
6. **`ShadPS4`**
7. **`Cemu`**

## Usercases

- Update emulators when there is no other convenient way to update it, .e.g., if using Arcade machines without keyboard and mouse.

   
## Features

- Checks if the emulator folder exists and creates it if it does not.
- Retrieves the current version of the emulator.
- Compares the current version with the latest release available on GitHub.
- Downloads and extracts the latest version if an update is required.


## Requirements

- PowerShell (version 5.1 or later recommended)
- Internet access to fetch the latest releases from GitHub
- The `7Zip4Powershell` module (installed automatically by the scripts)


## Todo

- Improve error handling
- Improve version handling
- Configurator

### Example Usage

**Set Your Variables**:
   Modify the following variables in `updateRPCS3.ps1`:
   ```powershell
   $targetFile = "rpcs3.exe"  # Change to your target file name
   $targetFolder = Join-Path -Path $env:USERPROFILE -ChildPath "Launchbox\Systems\rpcs3"  # Change to your target folder path
   $token = "YOUR_GITHUB_TOKEN"  # Replace with your GitHub personal access token


