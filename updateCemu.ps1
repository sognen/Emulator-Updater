# Instructions for Users:
# -------------------------------------------
# Before running the script, please set your own values for the following variables:
# - $targetFile: The name of the target executable file (e.g., "Cemu.exe").
# - $targetFolder: The path to the folder where your target file is located.

param (
    [switch]$EnableDebug,  # Parameter to enable/disable debug messages
    [switch]$Verbose,       # Parameter for verbose output
    [switch]$Help           # Parameter for displaying help information
)

# Display help information
if ($Help) {
    @"
Usage: .\updateCemu.ps1 [-EnableDebug] [-Verbose] [-Help]

Parameters:
    -EnableDebug   Enables debug messages for detailed logging.
    -Verbose       Enables verbose output to see more details during execution.
    -Help          Displays this help message.
"@ | Write-Host
    exit
}

# Set your target file and folder here
$targetFile = "Cemu.exe"  # Change this to your target file name
$targetFolder = Join-Path -Path $env:USERPROFILE -ChildPath "Launchbox\Systems\cemu"  # Change this to your target folder path

# GitHub personal access token (use with caution)
$token = "insert token here"

$initialDirectory = Get-Location

# Function to write debug messages
function Write-DebugMessage {
    param (
        [string]$Message  # Message to display
    )
    if ($EnableDebug) {
        Write-Host "Debug: $Message"
    }
}

# Ensure the target folder exists
if (-not (Test-Path $targetFolder)) {
    Write-DebugMessage "Target folder does not exist. Creating folder: $targetFolder"
    New-Item -ItemType Directory -Path $targetFolder -Force
    Write-Verbose "Created target folder: $targetFolder" -Verbose
} else {
    Write-DebugMessage "Target folder already exists: $targetFolder"
    Write-Verbose "Using existing target folder: $targetFolder" -Verbose
}

Set-Location -Path $targetFolder

# Ensure 7Zip4Powershell module is installed
try {
    if (-not (Get-Module -Name "7Zip4Powershell" -ListAvailable)) {
        Write-DebugMessage "Installing 7Zip4Powershell module..."
        Install-Module -Name 7Zip4Powershell -Force -Scope CurrentUser
        Write-Verbose "7Zip4Powershell module installed successfully." -Verbose
    } else {
        Write-DebugMessage "7Zip4Powershell module is already installed."
        Write-Verbose "Using existing 7Zip4Powershell module." -Verbose
    }
} catch {
    Write-DebugMessage "Failed to install 7Zip4Powershell module: $_"
    Write-Verbose "Exiting due to module installation failure." -Verbose
    Set-Location -Path $initialDirectory
    exit
}

# Function to get the current file version or myVersion
function Get-CurrentFileVersion {
    try {
        if (Test-Path $targetFile) {
            $fileVersionInfo = (Get-Item $targetFile).VersionInfo
            $currentVersion = $fileVersionInfo.FileVersion
            
            if (-not $currentVersion) {
                Write-DebugMessage "File version is not available. Checking for myVersion stream..."
                Write-Verbose "Attempting to read myVersion stream..." -Verbose
                # Attempt to read the myVersion stream
                $myVersion = Get-Content -Path $targetFile -Stream myVersion -ErrorAction SilentlyContinue
                if ($myVersion) {
                    Write-DebugMessage "myVersion stream found: $myVersion"
                    Write-Verbose "Using version from myVersion stream: $myVersion" -Verbose
                    return $myVersion
                } else {
                    Write-DebugMessage "No version information available."
                    Write-Verbose "No version found in myVersion stream." -Verbose
                    return $null
                }
            }

            Write-DebugMessage "Current version retrieved: $currentVersion"
            Write-Verbose "Current file version: $currentVersion" -Verbose
            return $currentVersion
        } else {
            Write-DebugMessage "Target file does not exist."
            Write-Verbose "Target file path: $targetFile" -Verbose
            return $null
        }
    } catch {
        Write-DebugMessage "An error occurred while getting the current version: $_"
        Write-Verbose "Error details: $_" -Verbose
        return $null
    }
}

$currentVersion = Get-CurrentFileVersion

# Fetch the latest release information from GitHub API
try {
    Write-DebugMessage "Fetching latest release information from GitHub..."
    $headers = @{ Authorization = "token $token" }
    $response = Invoke-RestMethod -Uri "https://api.github.com/repos/cemu-project/Cemu/releases/latest" -Headers $headers -Timeout 2
    $latestVersion = $response.name
    Write-Verbose "Latest version retrieved from GitHub: $latestVersion" -Verbose

    if ($latestVersion -ne $currentVersion) {
        Write-DebugMessage "Latest version ($latestVersion) is different from current version ($currentVersion). Proceeding with download..."

        # Filter the download URL for the win64.zip file
        $downloadUrl = $response.assets | Where-Object { $_.name -like "*windows-x64.zip" } | Select-Object -ExpandProperty browser_download_url
        
        # Download the file
        Write-DebugMessage "Downloading from $downloadUrl..."
        $outputFile = "cemu-binaries-win64.zip"
        Invoke-WebRequest -Uri $downloadUrl -OutFile $outputFile
        Write-Verbose "Download completed: $outputFile" -Verbose

        Write-DebugMessage "Extracting downloaded files..."
        Expand-7Zip -ArchiveFileName $outputFile -TargetPath .
        Write-Verbose "Extraction completed." -Verbose

		# Move all files and subfolders from the publish folder to the target location
	
		# Construct the source folder path using the latestVersion variable
		$sourceFolder = Join-Path -Path $targetFolder -ChildPath "$($latestVersion -replace ' ', '_')"


		Write-Verbose "Source folder: $sourceFolder" -Verbose   
		
		# Move files and subfolders while preserving the structure
		Get-ChildItem -Path $sourceFolder -Recurse | ForEach-Object {
			# Construct the destination path by calculating the relative path
			$relativePath = $_.FullName.Substring($sourceFolder.Length).TrimStart('\')
			$destinationPath = Join-Path -Path $targetFolder -ChildPath $relativePath

			# If it's a directory, create the directory structure in the destination
			if ($_.PSIsContainer) {
				New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
				Write-Verbose "Created directory: $destinationPath" -Verbose
			} else {
				# Move the file to the destination
				Move-Item -Path $_.FullName -Destination $destinationPath -Force
				Write-Verbose "Moved file: $($_.FullName) to $destinationPath" -Verbose
			}
		}
		Write-Verbose "All files and folders have been moved successfully." -Verbose

        # Update the version in the executable
        if (-not $currentVersion) {
            Write-DebugMessage "Current file does not have a version. Writing latest version to file as a stream variable."
            Set-Content -Value "$latestVersion" -Path $targetFile -Stream myVersion -Force
            Write-Verbose "Wrote latest version to myVersion stream." -Verbose
        } else {
            Write-DebugMessage "Updating file version to $latestVersion..."
            Set-Content -Value "$latestVersion" -Path $targetFile -Stream myVersion -Force
            Write-Verbose "File version updated to $latestVersion." -Verbose
        }

        # Cleanup
        Remove-Item $outputFile -Force
        Write-Verbose "Removed temporary download file: $outputFile" -Verbose
        Write-DebugMessage "Removing publish folder..."
        Remove-Item -Path $sourceFolder -Recurse -Force -ErrorAction SilentlyContinue
        Write-Verbose "Publish folder removed." -Verbose

        Write-DebugMessage "Update to version $latestVersion completed successfully."
		# Create the JSON body
		$body = @{
			urls = "hassio://192.168.1.122/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3NTYzMjgyMWFiYTQ0ZjM3ODJiNGM0Y2QxODkwNTJkYSIsImlhdCI6MTY4NTU0OTM2MSwiZXhwIjoyMDAwOTA5MzYxfQ.KkPVmn0cL25YvPRywEwBCe5YJxi6SPyhEH0urLX3QKQ"
			body = "Update to version $latestVersion completed successfully."
			title = "Cemu"
		}

		# Convert to JSON
		$jsonBody = $body | ConvertTo-Json

		# Invoke the web request
		Invoke-WebRequest -Uri "http://192.168.1.123:8000/notify/" -ContentType "application/json" -Method POST -Body $jsonBody
    } else {
        Write-DebugMessage "Update not necessary. Current version ($currentVersion) is up to date."
        Write-Verbose "No update required. Current version is the latest." -Verbose
    }
} catch {
    Write-DebugMessage "An error occurred during the update process: $_"
    Write-Verbose "Error details: $_" -Verbose
} finally {
    # Return to the initial directory
    Set-Location -Path $initialDirectory
    Write-DebugMessage "Returned to initial directory: $initialDirectory"
    Write-Verbose "Script execution completed." -Verbose
}



	
	
	
	

