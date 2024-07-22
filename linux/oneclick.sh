#!/bin/bash

# OS and Kernel information
OS_INFO=$(lsb_release -d | awk -F"\t" '{print $2}')
KERNEL_INFO=$(uname -r)

# System time
DATE=$(date)

# System load
SYSTEM_LOAD=$(uptime | awk -F 'load average:''{ print $2 }' | cut -d, -f1)

# Disk usage
DISK_USAGE=$(df -h / | grep / | awk '{ print $5 }')
DISK_TOTAL=$(df -h / | grep / | awk '{ print $2 }')
DISK_USED=$(df -h / | grep / | awk '{ print $3 }')

# Memory usage
MEMORY_USAGE=$(free -m | awk 'NR==2{printf "%.0f%%", $3*100/$2}')

# Swap usage
SWAP_USAGE=$(free -m | awk '/^Swap/ {printf "%.0f%%", $3*100/$2}')

# Number of running processes
PROCESSES=$(ps aux --no-heading | wc -l)

# Number of logged in users
USERS=$(who | wc -l)

# Network information
IPV4_ADDRESS=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

show_main() {
    clear
    echo "Welcome to $OS_INFO (GNU/Linux $KERNEL_INFO)"
    echo ""
    echo " * Documentation:  https://github.com/1kemalozturk/scripts"
    echo " * Support:        https://github.com/1kemalozturk/scripts/issues"
    echo ""
    echo "System information as of $DATE"
    echo ""
    echo "  System load:            $SYSTEM_LOAD"
    echo "  Usage of /:             $DISK_USAGE of $DISK_TOTAL ($DISK_USED used)"
    echo "  Memory usage:           $MEMORY_USAGE"
    echo "  Swap usage:             $SWAP_USAGE"
    echo "  Processes:              $PROCESSES"
    echo "  Users logged in:        $USERS"
    echo "  IPv4 address for eth0:  $IPV4_ADDRESS"
    echo ""
    echo "1. Developer"
    echo "2. Networking"
    echo "3. Home & Automation"
    echo "4. AI"
    echo "5. Tools"
    echo "6. Troubleshooting"
    echo "0. Exit Script"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) developer ;;
    2) networking ;;
    3) home_automation ;;
    4) ai ;;
    5) tools ;;
    6) troubleshooting ;;
    0) exit 0 ;;
    *)
        echo "Invalid option!"
        sleep 1
        show_main
        ;;
    esac
}

check_for_updates() {
    clear
    echo "Checking for updates..."
    sleep 2
    clear

    # URL of the raw script from the GitHub repository
    script_url="https://raw.githubusercontent.com/1kemalozturk/scripts/main/linux/oneclick.sh"

    # Temp file to store the updated script
    temp_script="/tmp/updated_script.sh"

    # Fetch the latest version of the script
    curl -s -o "$temp_script" "$script_url"

    # Check if the temp file was created successfully
    if [[ ! -f "$temp_script" ]]; then
        echo "Failed to download the update."
        sleep 3
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
        sleep 1.5
        clear
        echo "Script updated. Please re-run the script."
        sleep 1.5
        exit 0
    else
        echo "No updates available."
        sleep 1
    fi

    # Clean up
    rm -f "$temp_script"
}

developer() {
    clear
    echo "Developer"
    echo "1. Usbip WSL/HYPERV"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) usbip ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        developer
        ;;
    esac
}

networking() {
    clear
    echo "Networking"
    echo "1. 3x-UI"
    echo "2. AdguardHome"
    echo "3. Pi-hole"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) 3x-ui ;;
    2) adguardhome ;;
    3) pi-hole ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        networking
        ;;
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
    *)
        echo "Invalid option!"
        sleep 1
        home_automation
        ;;
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
    *)
        echo "Invalid option!"
        sleep 1
        usbip
        ;;
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
    *)
        echo "Invalid option!"
        sleep 1
        usbip_managment
        ;;
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
WantedBy=multi-user.target" | tee $service_file >/dev/null

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
usbip attach -r "$host_ip" -b "$bus_id"" | tee $script_file >/dev/null

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

3x-ui() {
    clear
    echo "3x-UI"
    echo "1. Install"
    echo "2. Management"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) 3x-ui_install ;;
    2) 3x-ui_management ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        3x-ui
        ;;
    esac
}

3x-ui_install() {
    clear
    echo "Installing 3x-UI..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    echo "3x-UI installed."
    sleep 10
    3x-ui
}

3x-ui_management() {
    clear
    x-ui
    sleep 10
    3x-ui
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
    *)
        echo "Invalid option!"
        sleep 1
        adguardhome
        ;;
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

pi-hole() {
    clear
    echo "Pi-hole"
    echo "1. Install"
    echo "2. Uninstall"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) pi-hole_install ;;
    2) pi-hole_uninstall ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        pi-hole
        ;;
    esac
}

pi-hole_install() {
    clear
    echo "Installing Pi-hole..."
    curl -sSL https://install.pi-hole.net | bash
    echo "Pi-hole installed."
    sleep 10
    pi-hole
}

pi-hole_uninstall() {
    clear
    echo "Uninstalling Pi-hole..."
    pihole uninstall
    echo "Pi-hole uninstalled."
    sleep 10
    pi-hole
}

homeassistant() {
    clear
    echo "Home Assistant"
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Managment"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) homeassistant_install ;;
    2) homeassistant_uninstall ;;
    3) homeassistant_managment ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        homeassistant
        ;;
    esac
}

# Flag file to check the stage of the installation
HOMEASSISTANT_INSTALL="homeassistant_install"

# Function to check the flag file and continue installation if necessary
homeassistant_install_check() {
    if [ -f "$HOMEASSISTANT_INSTALL" ]; then
        homeassistant_install_supervised
        exit 0
    fi
}

homeassistant_install() {
    clear
    echo "Starting Home Assistant Supervised installation..."

    # Check the status of name resolution
    echo "Checking name resolution..."
    if ping -c 1 checkonline.home-assistant.io &>/dev/null; then
        echo "Name resolution is working."
        if [ -x "$(command -v docker)" ]; then
            apt update && sudo apt upgrade -y && sudo apt autoremove -y
            apt install \
            apparmor \
            bluez \
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
            wget -y
        else
            curl -fsSL get.docker.com | sh
            homeassistant_install
        fi

        echo "supervised" >"$HOMEASSISTANT_INSTALL"
        echo "System is restarting..."
        sleep 5
        systemctl reboot
    else
        echo "Name resolution not working. Starting automatic repair..."

        # Update /etc/systemd/resolved.conf
        echo "Updating /etc/systemd/resolved.conf with disabling DNSStubListener..."

        # Use 'sed' to uncomment and set the DNSStubListener options
        sed -i 's/^#DNSStubListener=.*/DNSStubListener=no/g' /etc/systemd/resolved.conf

        # Restart network service
        echo "Restarting network service..."
        apt remove -y systemd-resolved
        systemctl restart systemd-networkd.service
        systemctl restart NetworkManager
        sleep 5
        homeassistant_install
    fi
}

homeassistant_install_supervised() {
    clear
    # Check the status of name resolution
    echo "Checking name resolution..."
    if ping -c 1 checkonline.home-assistant.io &>/dev/null; then
        # Download and install Home Assistant packages
        wget -O os-agent_linux_x86_64.deb https://github.com/home-assistant/os-agent/releases/latest/download/os-agent_1.6.0_linux_x86_64.deb
        wget -O homeassistant-supervised.deb https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb

        chmod 777 os-agent_linux_x86_64.deb homeassistant-supervised.deb

        apt install -y ./os-agent_linux_x86_64.deb
        BYPASS_OS_CHECK=true dpkg -i --ignore-depends=systemd-resolved homeassistant-supervised.deb

        apt update && sudo apt upgrade -y && sudo apt autoremove -y
        apt install \
        apparmor \
        bluez \
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
        wget -y
        apt --fix-broken install

        rm -fr os-agent_linux_x86_64.deb homeassistant-supervised.deb "$HOMEASSISTANT_INSTALL"

        echo "Home Assistant Hacs services installation..."
        sleep 30
        if [ -n "$(docker ps --format json | jq -r .Names | grep -E 'homeassistant')" ]; then
        echo "Home Assistant containers are expected to start..."
        apt install -y unzip
        wget -O - https://get.hacs.xyz | bash -
        fi

        # getumbrel Services
        if [ -n "$(docker ps --format json | jq -r .Names | grep -E 'gifted_almeida')" ]; then
        else
        docker start gifted_almeida
        fi

        echo "Home Assistant Supervised installation complete."
        sleep 5
        homeassistant
    else
        echo "Name resolution not working. Starting automatic repair..."

        # Update /etc/systemd/resolved.conf
        echo "Updating /etc/systemd/resolved.conf with disabling DNSStubListener..."

        # Use 'sed' to uncomment and set the DNSStubListener options
        sed -i 's/^#DNSStubListener=.*/DNSStubListener=no/g' /etc/systemd/resolved.conf

        # Restart network service
        echo "Restarting network service..."
        apt remove -y systemd-resolved
        systemctl restart systemd-networkd.service
        systemctl restart NetworkManager
        sleep 5
        homeassistant_install_supervised
    fi
}

homeassistant_uninstall() {
    clear
    echo "Uninstalling Home Assistant..."

    systemctl stop haos-agent >/dev/null 2>&1
    systemctl stop hassio-apparmor >/dev/null 2>&1
    systemctl stop hassio-supervisor >/dev/null 2>&1
    apt-get purge -y homeassistant-supervised* >/dev/null 2>&1 || true
    dpkg -r homeassistant-supervised >/dev/null 2>&1 || true
    dpkg -r os-agent >/dev/null 2>&1
    docker ps --format json | jq -r .Names | grep -E 'addon_|hassio_|homeassistant' | xargs -n 1 docker stop || true
    sleep 1
    if [ -n "$(docker ps --format json | jq -r .Names | grep -E 'addon_|hassio_|homeassistant')" ]; then
        echo "Home Assistant containers are expected to stop..."
        docker ps --format json | jq -r .Names | grep -E 'addon_|hassio_|homeassistant' | xargs -n 1 docker stop || true
        sleep 5
    fi

    echo "Home Assistant uninstalled."
    sleep 5
    homeassistant
}

ai() {
    clear
    echo "AI"
    echo "1. Ollama"
    echo "2. Open-webui"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) ollama ;;
    2) open-webui ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        ai
        ;;
    esac
}

ollama() {
    clear
    echo "Ollama"
    echo "1. Install"
    echo "2. Uninstall"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) ollama_install ;;
    2) ollama_uninstall ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        ollama
        ;;
    esac
    sleep 10
    ollama
}

ollama_install() {
    clear
    if [ -x "$(command -v ollama)" ]; then
        echo "Ollama installed."
    else
        echo "Installing Ollama..."
        curl -fsSL https://ollama.com/install.sh | sh
        echo "Ollama installed."
        sleep 10
        ollama
    fi
}

ollama_uninstall() {
    clear
    echo "Uninstalling Ollama..."
    systemctl stop ollama
    systemctl disable ollama
    rm /etc/systemd/system/ollama.service

    cd /usr/local/bin
    rm $(which ollama)
    cd /usr/bin
    rm $(which ollama)
    cd /bin
    rm $(which ollama)

    rm -r /usr/share/ollama
    userdel ollama
    groupdel ollama
    echo "Ollama Uninstalled."
    sleep 10
    ollama
}

open-webui() {
    clear
    echo "Open WebUI"
    echo "1. Install"
    echo "2. Uninstall"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) open-webui_install ;;
    2) open-webui_uninstall ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        open-webui
        ;;
    esac
    sleep 10
    open-webui
}

open-webui_install() {
    clear

    sleep 10
    open-webui
}

open-webui_uninstall() {
    clear

    sleep 10
    open-webui
}

tools() {
    clear
    echo "Tools"
    echo "1. Netstat"
    echo "2. Speedtest"
    echo "3. IPerf3"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) tools_netstat ;;
    2) tools_speedtest ;;
    3) tools_iperf3 ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        tools
        ;;
    esac
}

tools_netstat() {
    clear
    if [ -x "$(command -v netstat)" ]; then
        netstat -tulpn
    else
        echo "Installing Net-tools..."
        apt install -y net-tools
        echo "Net-tools installed."
        sleep 5
        tools_netstat
    fi
}

tools_speedtest() {
    clear
    if [ -x "$(command -v speedtest)" ]; then
        speedtest
    else
        echo "Installing Speedtest..."
        # Ensure curl is installed
        if ! [ -x "$(command -v curl)" ]; then
            apt install -y curl
        fi
        
        # Install speedtest
        curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
        apt install -y speedtest
        echo "Speedtest installed."
        sleep 5
        tools_speedtest
    fi
}

troubleshooting() {
    clear
    echo "Troubleshooting"
    echo "1. Cleaner"
    echo "2. DPKG Repair"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) troubleshooting_monitor_uninstall ;;
    2) troubleshooting_dpkg_repair ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        troubleshooting
        ;;
    esac
}

# Function to monitor for package removal events
troubleshooting_cleaner() {
    clear

    # Remove configuration files
    apt-get autoremove --purge -y
    apt-get clean

    sleep 10
    troubleshooting
}
troubleshooting_dpkg_repair() {
    clear
    dpkg --force-all --configure -a

    # dpkg: error: 2 expected programs not found in PATH or not executable
    apt --fix-broken install

    sleep 10
    troubleshooting
}

check_for_updates
homeassistant_install_check
show_main