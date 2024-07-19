#!/bin/bash

show_main() {
    clear
    echo "1. Developer Tools"
    echo "2. Networking"
    echo "3. Home & Automation"
    echo "4. Troubleshooting"
    echo "5. System Info"
    echo "6. Check for Updates"
    echo "0. Exit Script"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) developer_tools ;;
        2) networking ;;
        3) home_automation ;;
        4) troubleshooting ;;
        5) systeminfo ;;
        6) check_for_updates ;;
        0) exit 0 ;;
        *) echo "Invalid option!"; sleep 1; show_main ;;
    esac
}

check_for_updates() {
    clear
    echo "Checking for updates..."

    # URL of the raw script from the GitHub repository
    script_url="https://raw.githubusercontent.com/1kemalozturk/scripts/main/oneclick.sh"
    
    # Temp file to store the updated script
    temp_script="/tmp/updated_script.sh"

    # Fetch the latest version of the script
    curl -s -o "$temp_script" "$script_url"
    
    # Check if the temp file was created successfully
    if [[ ! -f "$temp_script" ]]; then
        echo "Failed to download the update."
        sleep 5
        show_main
        return
    fi

    # Compute the hash of the local and updated scripts
    local_hash=$(sha256sum "$0" | awk '{print $1}')
    updated_hash=$(sha256sum "$temp_script" | awk '{print $1}')

    # Compare the hashes
    if [[ "$local_hash" != "$updated_hash" ]]; then
        echo "Update found. Applying update..."
        cp "$temp_script" "$0"
        chmod +x "$0"
        echo "Script updated. Please re-run the script."
        sleep 5
        exit 0
    else
        echo "No updates available."
    fi

    # Clean up
    rm -f "$temp_script"
    sleep 5
    show_main
}

developer_tools() {
    clear
    echo "Developer Tools"
    echo "1. Usbip WSL/HYPERV"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) usbip ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; developer_tools ;;
    esac
}

networking() {
    clear
    echo "Networking"
    echo "1. 3x-UI"
    echo "2. AdguardHome"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) 3xui ;;
        2) adguardhome ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; networking ;;
    esac
}

home_automation() {
    clear
    echo "Home & Automation"
    echo "1. Home Assistant"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) homeassistant ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; home_automation ;;
    esac
}

usbip() {
    clear
    echo "Usbip WSL/HYPERV"
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Managment"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) usbip_install ;;
        2) usbip_uninstall ;;
        3) usbip_managment ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; usbip ;;
    esac
}

usbip_managment() {
    clear
    echo "Usbip WSL/HYPERV Managment"
    echo "1. Attach Service Install"
    echo "2. Attach Service Uninstall"
    echo "3. Attach Service Status"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) usbip_attach_service_install ;;
        2) usbip_attach_service_uninstall ;;
        3) usbip_attach_service_status ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; usbip_managment ;;
    esac
}

usbip_install() {
    clear
    echo "Usbip Installation"
    echo "1. Ubuntu"
    echo "2. Debian"
    echo "0. Back"
    echo -n "Choose your OS: "
    read choice

    case $choice in
        1)
            echo "Installing Usbip on Ubuntu..."
            apt update
            apt install -y hwdata usbutils linux-tools-virtual
            update-alternatives --install /usr/local/bin/usbip usbip $(ls /usr/lib/linux-tools/*/usbip | tail -n1) 20
            modprobe vhci-hcd
            echo "Usbip installed on Ubuntu."
            ;;
        2)
            echo "Installing Usbip on Debian..."
            apt update
            apt install -y hwdata usbutils usbip
            echo "Usbip installed on Debian."
            ;;
        0)
            show_main
            return
            ;;
        *)
            echo "Invalid option!"
            sleep 1
            usbip_install
            return
            ;;
    esac
    sleep 10
    usbip
}

usbip_uninstall() {
    clear
    echo "Usbip Uninstallation"
    echo "1. Ubuntu"
    echo "2. Debian"
    echo "0. Back"
    echo -n "Choose your OS: "
    read choice

    case $choice in
        1)
            echo "Uninstalling Usbip on Ubuntu..."
            apt remove -y hwdata usbutils linux-tools-virtual
            apt autoremove -y
            echo "Usbip uninstalled on Ubuntu."
            ;;
        2)
            echo "Uninstalling Usbip on Debian..."
            apt remove -y hwdata usbutils usbip
            apt autoremove -y
            echo "Usbip uninstalled on Debian."
            ;;
        0)
            show_main
            return
            ;;
        *)
            echo "Invalid option!"
            sleep 1
            usbip_install
            return
            ;;
    esac
    sleep 10
    usbip
}

# usbip_attach_service() {
#     clear
#     modprobe vhci-hcd
#     echo -n "Host/Server IP: "
#     read host_ip
#     echo -n "Host/Server BUSID: "
#     read bus_id
#     usbip attach -r "$host_ip" -b "$bus_id"
#     lsusb
#     echo "USB device attached from $host_ip with bus ID $bus_id."
#     sleep 10
#     usbip_managment
# }

# Function to create and configure the Usbip-Attach service
usbip_attach_service_install() {
    clear
    echo "Setting up Usbip-Attach service..."

    # Prompt for IP and BUSID
    echo -n "Host/Server IP: "
    read host_ip
    echo -n "Host/Server BUSID: "
    read bus_id

    # Check if the inputs are not empty
    if [[ -z "$host_ip" || -z "$bus_id" ]]; then
        echo "Host/Server IP or BUSID cannot be empty."
        sleep 10
        show_main
        return
    fi

    # Create the systemd service file
    service_file="/etc/systemd/system/usbip-attach.service"
    script_file="/usr/local/bin/usbip-attach.sh"

    echo "[Unit]
Description=Usbip-Attach Service
After=network.target

[Service]
Type=simple
ExecStart=$script_file
Restart=on-failure

[Install]
WantedBy=multi-user.target" | tee $service_file > /dev/null

    # Check if the service file was created successfully
    if [[ $? -ne 0 ]]; then
        echo "Failed to create service file."
        sleep 10
        show_main
        return
    fi

    # Create the attach script
    echo "#!/bin/bash

# Load Usbip kernel module
modprobe vhci-hcd

# Attach USB device
usbip attach -r \"$host_ip\" -b \"$bus_id\"" | tee $script_file > /dev/null

    # Check if the script file was created successfully
    if [[ $? -ne 0 ]]; then
        echo "Failed to create attach script."
        sleep 10
        show_main
        return
    fi

    # Make the script executable
    chmod +x $script_file

    # Reload systemd, enable, and start the service
    systemctl daemon-reload
    systemctl enable usbip-attach.service
    systemctl start usbip-attach.service

    # Check if the service was started successfully
    if [[ $? -eq 0 ]]; then
        echo "Usbip-Attach service setup completed successfully."
    else
        echo "Failed to start Usbip-Attach service."
    fi

    sleep 5
    usbip_managment
}

usbip_attach_service_uninstall() {
    clear
    echo "Removing Usbip-Attach service..."

    # Stop the service if it's running
    systemctl stop usbip-attach.service

    # Disable the service to prevent it from starting on boot
    systemctl disable usbip-attach.service

    # Remove the service file
    rm -f /etc/systemd/system/usbip-attach.service

    # Reload the systemd daemon to apply changes
    systemctl daemon-reload

    echo "Usbip-Attach service removed successfully."
    sleep 10
    usbip_managment
}

# Function to check the status of the USBIP-Attach service
usbip_attach_service_status() {
    clear
    echo "Checking status of Usbip-Attach service..."
    systemctl status usbip-attach.service
    sleep 10
    usbip_managment
}

3xui() {
    clear
    echo "3x-UI"
    echo "1. Install"
    echo "2. Management"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) 3xui_install ;;
        2) 3xui_management ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; 3xui ;;
    esac
}

3xui_install() {
    clear
    echo "Installing 3x-UI..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    echo "3x-UI installed."
    sleep 10
    3xui
}

3xui_management() {
    clear
    x-ui
    sleep 10
    3xui
}

adguardhome() {
    clear
    echo "AdguardHome"
    echo "1. Install"
    echo "2. Uninstall"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) adguardhome_install ;;
        2) adguardhome_uninstall ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; adguardhome ;;
    esac
}

adguardhome_install() {
    clear
    echo "Installing AdguardHome loading..."
    curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
    echo "AdguardHome installed."
    sleep 10
    adguardhome
}

adguardhome_uninstall() {
    clear
    echo "Uninstalling AdguardHome..."
    /opt/AdGuardHome/AdGuardHome -s uninstall
    rm -fr /opt/AdGuardHome
    systemctl daemon-reload
    systemctl restart systemd-networkd
    systemctl restart systemd-resolved
    echo "AdguardHome uninstalled."
    sleep 10
    adguardhome
}

homeassistant() {
    clear
    echo "Home Assistant"
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Hacs Install"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) homeassistant_install ;;
        2) homeassistant_uninstall ;;
        3) homeassistant_hacs_install ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; homeassistant ;;
    esac
}

homeassistant_install() {
    clear
    echo "Installing Home Assistant..."

    cd /var/local
    apt update
    apt install -y \
        apparmor \
        cifs-utils \
        curl \
        dbus \
        jq \
        libglib2.0-bin \
        lsb-release \
        network-manager \
        nfs-common \
        systemd-journal-remote \
        systemd-resolved \
        udisks2 \
        wget

    # Install Docker
    curl -fsSL get.docker.com | sh

    # Download and install Home Assistant packages
    wget -O os-agent_linux_x86_64.deb https://github.com/home-assistant/os-agent/releases/latest/download/os-agent_1.6.0_linux_x86_64.deb
    wget -O homeassistant-supervised.deb https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb

    # Force install the packages
    dpkg -i os-agent_linux_x86_64.deb || apt-get install -f -y
    dpkg -i homeassistant-supervised.deb || apt-get install -f -y

    echo "Home Assistant installed."
    sleep 10
    echo "System is restarting..."
    sleep 10
    systemctl reboot
}

homeassistant_uninstall() {
    clear
    echo "Uninstalling Home Assistant..."
    apt-get remove -y --purge docker-ce docker-ce-cli containerd.io
    apt remove -y \
    apparmor \
    cifs-utils \
    dbus \
    jq \
    libglib2.0-bin \
    lsb-release \
    network-manager \
    nfs-common \
    systemd-journal-remote \
    systemd-resolved \
    udisks2 \
    os-agent
    rm -fr /var/local/os-agent_linux_x86_64.deb /var/local/homeassistant-supervised.deb /var/lib/docker /var/lib/containerd
    apt-get -y autoremove
    echo "Home Assistant uninstalled."
    sleep 10
    homeassistant
}

homeassistant_hacs_install() {
    clear
    echo "Installing Home Assistant Hacs..."
    apt-get -y install unzip
    wget -O - https://get.hacs.xyz | bash -
    echo "Home Assistant Hacs installed."
    sleep 10
    homeassistant
}

troubleshooting() {
    clear
    echo "Troubleshooting"
    echo "1. Monitor for Uninstallations"
    echo "2. DPKG Repair"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) troubleshooting_monitor_uninstall ;;
        2) troubleshooting_dpkg_repair ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; troubleshooting ;;
    esac
}

# Function to clean up after uninstallation
cleanup_app() {
    local app_name="$1"

    echo "Cleaning up $app_name..."
    
    # Remove configuration files
    sudo apt-get autoremove --purge -y
    sudo apt-get clean
    sudo rm -rf /etc/"$app_name"
    sudo rm -rf /var/lib/"$app_name"
    sudo rm -rf /var/log/"$app_name"
    sudo rm -rf /usr/share/"$app_name"
    sudo rm -rf ~/.config/"$app_name"
    sudo rm -rf ~/.local/share/"$app_name"
    sudo rm -rf ~/."$app_name"

    echo "$app_name and its configuration files have been removed."
}

# Function to monitor for package removal events
troubleshooting_monitor_uninstall() {
    local last_removed_package=""

    while true; do
        # Check for the latest removed package
        current_removed_package=$(grep "remove" /var/log/dpkg.log | tail -n 1 | awk '{print $5}')

        # If a new package was removed, clean it up
        if [[ "$current_removed_package" != "$last_removed_package" ]]; then
            last_removed_package="$current_removed_package"
            cleanup_app "$last_removed_package"
        fi

        # Wait for a short period before checking again
        sleep 10
        troubleshooting
    done
}
troubleshooting_dpkg_repair() {
    clear
    dpkg --force-all --configure -a

    # dpkg: error: 2 expected programs not found in PATH or not executable
    apt --fix-broken install
    sleep 10
    troubleshooting
}

systeminfo() {
    clear
    echo "System Info"
    echo "1. Lan IP"
    echo "2. Check Port"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) systeminfo_lanIP ;;
        2) systeminfo_checkPort ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; systeminfo ;;
    esac
}

systeminfo_lanIP() {
    clear
    # Identify the primary network interface by checking the default route.
    primary_interface=$(ip route | grep default | awk '{print $5}')

    # Try to retrieve the server's primary IP address using 'ip addr'.
    lan_ip=$(ip addr show $primary_interface | grep -oE 'inet (10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3})' | awk '{print $2}')

    # Check if the result from 'ip addr' is non-empty.
    if [ -n "$lan_ip" ]; then
        echo "LAN IP: $lan_ip"
    else
        echo "Unable to determine server IP"
    fi

    sleep 10
    systeminfo
}

systeminfo_checkPort() {
    clear
    
    echo -n "Check Port: "
    read checkPort
    ss -lntp | grep "$checkPort"
    sleep 10
    systeminfo
}

show_main
