RPCS3, Dolphin, and Ryujinx Updater Scripts
This repository contains scripts that automate the process of updating the RPCS3, Dolphin, and Ryujinx executables.

Scripts Overview
updateRPCS3.ps1:

Automates the update process for the RPCS3 executable (rpcs3.exe). It checks for the latest version on GitHub, downloads it if necessary, and updates the local version information.
updateDolphin.ps1:

Automates the update process for the Dolphin emulator executable. Similar to updateRPCS3.ps1, it checks for the latest version on GitHub and updates the local version.
updateRyujinx.ps1:

Automates the update process for the Ryujinx emulator executable. This script also checks for the latest version on GitHub and updates the local version information.
Features
Checks if the target folder exists and creates it if it does not.
Ensures that the 7Zip4Powershell module is installed for file extraction.
Retrieves the current version of the executable for each emulator.
Compares the current version with the latest release available on GitHub.
Downloads and extracts the latest version if an update is required.
Updates the version information within the executable.
Requirements
PowerShell (version 5.1 or later recommended)
Internet access to fetch the latest releases from GitHub
The 7Zip4Powershell module (installed automatically by the scripts)
Usage
Update RPCS3
Set Your Variables: Modify the following variables in updateRPCS3.ps1:

powershell
Copy code
$targetFile = "rpcs3.exe"  # Change to your target file name
$targetFolder = Join-Path -Path $env:USERPROFILE -ChildPath "Launchbox\Systems\rpcs3"  # Change to your target folder path
$token = "YOUR_GITHUB_TOKEN"  # Replace with your GitHub personal access token
Run the Script: Execute the script with the following optional parameters:

powershell
Copy code
.\updateRPCS3.ps1 [-EnableDebug] [-Verbose] [-Help]
Update Dolphin
Set Your Variables: Modify the following variables in updateDolphin.ps1:

powershell
Copy code
$targetFile = "Dolphin.exe"  # Change to your target file name
$targetFolder = Join-Path -Path $env:USERPROFILE -ChildPath "Launchbox\Systems\Dolphin"  # Change to your target folder path
$token = "YOUR_GITHUB_TOKEN"  # Replace with your GitHub personal access token
Run the Script: Execute the script with the following optional parameters:

powershell
Copy code
.\updateDolphin.ps1 [-EnableDebug] [-Verbose] [-Help]
Update Ryujinx
Set Your Variables: Modify the following variables in updateRyujinx.ps1:

powershell
Copy code
$targetFile = "Ryujinx.exe"  # Change to your target file name
$targetFolder = Join-Path -Path $env:USERPROFILE -ChildPath "Launchbox\Systems\Ryujinx"  # Change to your target folder path
$token = "YOUR_GITHUB_TOKEN"  # Replace with your GitHub personal access token
Run the Script: Execute the script with the following optional parameters:

powershell
Copy code
.\updateRyujinx.ps1 [-EnableDebug] [-Verbose] [-Help]
Example
To run the updateRPCS3 script with verbose output:

powershell
Copy code
.\updateRPCS3.ps1 -Verbose
To run the updateDolphin script with verbose output:

powershell
Copy code
.\updateDolphin.ps1 -Verbose
To run the updateRyujinx script with verbose output:

powershell
Copy code
.\updateRyujinx.ps1 -Verbose
Security Note
Ensure that your GitHub personal access token is kept secure. It is recommended to use environment variables or secure credential storage instead of hard-coding it in the scripts.
Troubleshooting
If you encounter issues with downloading or extracting files, ensure that you have the necessary permissions and that your internet connection is stable.
Check the PowerShell execution policy if you face script execution issues:
powershell
Copy code
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Li
