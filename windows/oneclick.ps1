# Ensure the script uses UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Define the script version and GitHub update check details
$scriptVersion = "24.07.19.2720"
$repositoryOwner = "1kemalozturk"
$repositoryName = "scripts"
$versionFilePath = "windows/version.txt"  # Path to the file in the GitHub repo that contains the latest version
$scriptFileName = "windows/oneclick.ps1"  # Script file name in the GitHub repo

function Check-For-Updates {
    try {
        $versionUrl = "https://raw.githubusercontent.com/$repositoryOwner/$repositoryName/main/$versionFilePath"
        $latestVersion = Invoke-RestMethod -Uri $versionUrl

        if ($latestVersion -ne $scriptVersion) {
            Write-Output "A new version of the script is available. Updating..."
            
            $scriptUrl = "https://raw.githubusercontent.com/$repositoryOwner/$repositoryName/main/$scriptFileName"
            $updatedScript = Invoke-RestMethod -Uri $scriptUrl
            
            $localScriptPath = $MyInvocation.MyCommand.Path
            Set-Content -Path $localScriptPath -Value $updatedScript -Encoding UTF8
            
            Write-Output "Script updated successfully. Please run the script again."
            exit
        } else {
            Write-Output "You are using the latest version of the script."
        }
    } catch {
        Write-Output "Failed to check for updates. Proceeding with the current version."
    }
}

function Install-USBIPD {
    cls
    winget install usbipd
    Write-Output "USBIPD successfully installed."
}

function Uninstall-USBIPD {
    cls
    winget uninstall usbipd
    Write-Output "USBIPD successfully uninstalled."
}

function List-USBDevices {
    cls
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
    Check-For-Updates
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
