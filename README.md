# Emulator Updater Scripts

This repository contains scripts that automate the process of updating the RPCS3, Dolphin, and Ryujinx executables to the latest version.

## Scripts Overview

1. **`updateRPCS3.ps1`**: 
   - Automates the update process for the RPCS3 executable (`rpcs3.exe`). It checks for the latest version on GitHub, downloads it if necessary.

2. **`updateDolphin.ps1`**: 
   - Automates the update process for the Dolphin emulator executable. Similar to `updateRPCS3.ps1`, it checks for the latest version on GitHub and downloads the latest version if necessary.

3. **`updateRyujinx.ps1`**: 
   - Automates the update process for the Ryujinx emulator executable. This script also checks for the latest version on GitHub.
   - 
## Features

- Checks if the target folder exists and creates it if it does not.
- Ensures that the `7Zip4Powershell` module is installed for file extraction.
- Retrieves the current version of the executable for each emulator.
- Compares the current version with the latest release available on GitHub.
- Downloads and extracts the latest version if an update is required.


## Requirements

- PowerShell (version 5.1 or later recommended)
- Internet access to fetch the latest releases from GitHub
- The `7Zip4Powershell` module (installed automatically by the scripts)

## Usage (Example RPCS3)

### Update RPCS3

1. **Set Your Variables**:
   Modify the following variables in `updateRPCS3.ps1`:
   ```powershell
   $targetFile = "rpcs3.exe"  # Change to your target file name
   $targetFolder = Join-Path -Path $env:USERPROFILE -ChildPath "Launchbox\Systems\rpcs3"  # Change to your target folder path
   $token = "YOUR_GITHUB_TOKEN"  # Replace with your GitHub personal access token
