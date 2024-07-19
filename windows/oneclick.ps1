## Ensure the script uses UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Define the script URL on GitHub
$scriptUrl = "https://raw.githubusercontent.com/1kemalozturk/scripts/main/windows/oneclick.ps1"
$tempScriptPath = "$env:TEMP\updated_script.ps1"

function Check-For-Updates {
    Clear-Host
    Write-Host "Checking for updates..."

    # GitHub repository bilgileri
    $scriptUrl = "https://raw.githubusercontent.com/1kemalozturk/scripts/main/windows/oneclick.ps1"
    
    # Temp dosyası için yol
    $tempScript = "$env:TEMP\updated_script.ps1"
    
    # Güncel scripti indir
    try {
        Invoke-WebRequest -Uri $scriptUrl -OutFile $tempScript -ErrorAction Stop
    } catch {
        Write-Host "Failed to download the update."
        Start-Sleep -Seconds 5
        Show-Main
        return
    }

    # Yerel ve güncel scriptlerin hash'ini hesapla
    $localHash = Get-FileHash -Path $MyInvocation.MyCommand.Path -Algorithm SHA256 | Select-Object -ExpandProperty Hash
    $updatedHash = Get-FileHash -Path $tempScript -Algorithm SHA256 | Select-Object -ExpandProperty Hash

    # Hash'leri karşılaştır
    if ($localHash -ne $updatedHash) {
        Write-Host "Update found. Applying update..."
        Copy-Item -Path $tempScript -Destination $MyInvocation.MyCommand.Path -Force
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
        Write-Host "Script updated. Please re-run the script."
        Start-Sleep -Seconds 5
        exit
    } else {
        Write-Host "No updates available."
    }

    # Temp dosyasını temizle
    Remove-Item -Path $tempScript -Force
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
