# Ensure the script uses UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Define the script URL on GitHub
$scriptUrl = "https://raw.githubusercontent.com/1kemalozturk/scripts/main/windows/oneclick.ps1"
$tempScriptPath = "$env:TEMP\updated_script.ps1"

function Check-ForUpdates {
    try {
        Write-Output "Checking for updates..."

        # Download the latest version of the script
        Invoke-RestMethod -Uri $scriptUrl -OutFile $tempScriptPath
        
        # Check if the temp file was created successfully
        if (-Not (Test-Path $tempScriptPath)) {
            throw "Failed to download the update or the temp file does not exist."
        }

        # Compute the hash of the local and updated scripts
        $localPath = $MyInvocation.MyCommand.Path
        if (-Not (Test-Path $localPath)) {
            throw "Local script file does not exist."
        }
        
        $localHash = Get-FileHash -Path $localPath -Algorithm SHA256 | Select-Object -ExpandProperty Hash
        $updatedHash = Get-FileHash -Path $tempScriptPath -Algorithm SHA256 | Select-Object -ExpandProperty Hash

        # Compare the hashes
        if ($localHash -ne $updatedHash) {
            Write-Output "Update found. Applying update..."
            Copy-Item -Path $tempScriptPath -Destination $localPath -Force
            Write-Output "Script updated. Please re-run the script."
            exit
        } else {
            Write-Output "No updates available."
        }
    } catch {
        Write-Output "Failed to check for updates: $_.Exception.Message"
    } finally {
        # Clean up
        if (Test-Path $tempScriptPath) {
            Remove-Item -Path $tempScriptPath -ErrorAction SilentlyContinue
        }
    }
}

function Install-USBIPD {
    winget install usbipd
    Write-Output "USBIPD successfully installed."
}

function Uninstall-USBIPD {
    winget uninstall usbipd
    Write-Output "USBIPD successfully uninstalled."
}

function List-USBDevices {
    $usbipdList = usbipd list
    Write-Output "Current USB devices:"
    Write-Output $usbipdList
}

function Bind-USBDevice {
    List-USBDevices
    $busid = Read-Host -Prompt 'Enter the BUSID of the device you want to bind'
    usbipd bind --busid $busid
    Write-Output "Device successfully bound."
}

function Unbind-USBDevice {
    List-USBDevices
    $busid = Read-Host -Prompt 'Enter the BUSID of the device you want to unbind'
    usbipd detach --busid $busid

    # Sleep for 5 seconds (change the number as needed)
    Start-Sleep -Seconds 5

    usbipd unbind --busid $busid
    Write-Output "Device unbinding successful."
}

function Show-Menu {
    Write-Output "Please select the operation you want to perform:"
    Write-Output "1. Install USBIPD"
    Write-Output "2. Uninstall USBIPD"
    Write-Output "3. List USB Devices"
    Write-Output "4. Bind USB Device"
    Write-Output "5. Unbind USB Device"
    Write-Output "0. Exit"
}

function Main {
    Check-ForUpdates
    while ($true) {
        Show-Menu
        $choice = Read-Host -Prompt 'Your choice'
        switch ($choice) {
            '1' { Install-USBIPD }
            '2' { Uninstall-USBIPD }
            '3' { List-USBDevices }
            '4' { Bind-USBDevice }
            '5' { Unbind-USBDevice }
            '0' { exit }
            default { Write-Output "Invalid selection, please try again." }
        }
    }
}

# Run the main function
Main
