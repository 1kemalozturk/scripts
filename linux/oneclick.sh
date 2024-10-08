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
    echo "0. Exit Script"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) developer ;;
    2) networking ;;
    3) home_automation ;;
    4) ai ;;
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
    echo "2. NVM"
    echo "3. My Server Status"
    echo "4. Portainer"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) usbip ;;
    2) nvm_sh ;;
    3) my_server_status_api ;;
    4) portainer;;
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
    echo "Usbip is starting the installation..."
    apt update
    apt install -y hwdata usbutils usbip
    echo "Usbip installation complete."
    sleep 10
    usbip
}

usbip_uninstall() {
    clear
    echo "Usbip is being removed..."
    apt remove -y hwdata usbutils usbip
    apt autoremove -y
    echo "Usbip uninstallation completed."
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
    echo "Usbip-Attach service is being removed..."

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

nvm_sh() {
    clear
    echo "NVM"
    echo "1. Install"
    echo "2. Uninstall"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) nvm_sh_install ;;
    2) nvm_sh_uninstall ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        nvm_sh
        ;;
    esac
}

nvm_sh_install() {
    clear
    echo "NVM is starting the installation..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    source ~/.bashrc
    nvm install node
    nvm use node
    nvm -v
    node -v
    echo "NVM installation completed."
    sleep 10
    nvm_sh
}

nvm_sh_uninstall() {
    clear
    sleep 10
    nvm_sh
}

my_server_status_api() {
    clear
    echo "My Server Status Api"
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Managment"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) my_server_status_api_install ;;
    2) my_server_status_api_uninstall ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        my_server_status_api
        ;;
    esac
}

my_server_status_api_install() {
    clear
    echo "My Server Status Api is starting the installation..."

    echo "My Server Status Api installation completed."
    sleep 10
    my_server_status_api
}

my_server_status_api_uninstall() {
    clear
    sleep 10
    my_server_status_api
}

portainer() {
    clear
    echo "Portainer"
    echo "1. Install"
    echo "2. Uninstall"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
    1) portainer_install ;;
    2) portainer_uninstall ;;
    0) show_main ;;
    *)
        echo "Invalid option!"
        sleep 1
        portainer
        ;;
    esac
}

portainer_install() {
    clear
    echo "Portainer is starting the installation..."
    docker pull portainer/portainer
    docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
    echo "Portainer installation completed."
    sleep 10
    portainer
}

portainer_uninstall() {
    clear
    echo "Portainer is being removed..."
    docker stop portainer
    docker rm portainer
    docker volume rm portainer_data
    echo "Portainer uninstallation completed."
    sleep 10
    portainer
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
    echo "3x-UI is starting the installation..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    echo "3x-UI installation completed."
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
    echo "AdguardHome is starting the installation..."
    curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
    echo "AdguardHome installation completed."
    sleep 10
    adguardhome
}

adguardhome_uninstall() {
    clear
    echo "AdguardHome is being removed..."
    /opt/AdGuardHome/AdGuardHome -s uninstall
    rm -fr /opt/AdGuardHome
    systemctl daemon-reload
    systemctl restart systemd-networkd
    systemctl restart systemd-resolved
    echo "AdguardHome uninstallation completed."
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
    echo "Pi-hole is starting the installation..."
    curl -sSL https://install.pi-hole.net | bash
    echo "Pi-hole installation completed."
    sleep 10
    pi-hole
}

pi-hole_uninstall() {
    clear
    echo "Pi-hole is being removed..."
    pihole uninstall
    echo "Pi-hole uninstallation completed."
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
    echo "Home Assistant Supervised is starting the installation..."

    if [ -x "$(command -v docker)" ]; then
        apt update && apt upgrade -y && apt autoremove -y

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
            udisks2 \
            wget -y

        #Install equivs
        apt install equivs -y
        #Generate a template control file
        equivs-control systemd-resolved.control
        #Fix the package name
        sed -i 's/<package name; defaults to equivs-dummy>/systemd-resolved/g' systemd-resolved.control
        #Build the package
        equivs-build systemd-resolved.control
        #Install it
        dpkg -i systemd-resolved_1.0_all.deb
    else
        curl -fsSL get.docker.com | sh
        homeassistant_install
    fi

    echo "supervised" >"$HOMEASSISTANT_INSTALL"
    echo "System is restarting..."
    sleep 5
    systemctl reboot
}

homeassistant_install_supervised() {
    clear

    # Download and install Home Assistant packages
    wget -O os-agent_linux_x86_64.deb https://github.com/home-assistant/os-agent/releases/latest/download/os-agent_1.6.0_linux_x86_64.deb
    wget -O homeassistant-supervised.deb https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb

    chmod 777 os-agent_linux_x86_64.deb homeassistant-supervised.deb

    apt install -y ./os-agent_linux_x86_64.deb
    BYPASS_OS_CHECK=true dpkg -i --ignore-depends=systemd-resolved homeassistant-supervised.deb

    rm -fr os-agent_linux_x86_64.deb homeassistant-supervised.deb "$HOMEASSISTANT_INSTALL"

    while [ -z "$(docker ps --format json | jq -r .Names | grep -E 'homeassistant')" ]; do
        echo "Home Assistant container not started, please wait. Checking..."
        sleep 30 # waits 30 seconds and checks again
    done

    echo "Home Assistant Hacs services installation..."
    apt install -y unzip
    wget -O - https://get.hacs.xyz | bash -
    ha core restart

    # 'HomeAssistantCore.update' blocked from execution, system is not healthy - docker #82049
    ha jobs options --ignore-conditions healthy

    # getumbrel Services
    if [ -n "$(docker ps --format json | jq -r .Names | grep -E 'auth|tor_proxy')" ]; then
        if [ -n "$(docker ps --format json | jq -r .Names | grep -E 'auth')" ]; then
            echo "UmbrelOS Container auth-server is already running."
        else
            docker start auth
        fi
        if [ -n "$(docker ps --format json | jq -r .Names | grep -E 'tor_proxy')" ]; then
            echo "UmbrelOS Container tor_proxy is already running."
        else
            docker start tor_proxy
        fi
    else
        echo "UmbrelOS is not installation completed."
    fi

    echo "Home Assistant Supervised installation complete."
    sleep 5
    homeassistant
}

homeassistant_uninstall() {
    clear
    echo "Home Assistant is being removed..."

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

    # getumbrel Services
    if [ -n "$(docker ps --format json | jq -r .Names | grep -E 'auth|tor_proxy')" ]; then
        if [ -n "$(docker ps --format json | jq -r .Names | grep -E 'auth')" ]; then
            echo "Container auth-server is already running."
        else
            docker start auth
        fi
        if [ -n "$(docker ps --format json | jq -r .Names | grep -E 'tor_proxy')" ]; then
            echo "Container tor_proxy is already running."
        else
            docker start tor_proxy
        fi
    else
        echo "UmbrelOS is not installation completed."
    fi

    echo "Home Assistant uninstallation completed."
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
        echo "Ollama is starting the installation..."
    else
        echo "Installing Ollama..."
        curl -fsSL https://ollama.com/install.sh | sh
        echo "Ollama installation completed."
        sleep 10
        ollama
    fi
}

ollama_uninstall() {
    clear
    echo "Ollama is being removed..."
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
    echo "Ollama uninstallation completed."
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

check_for_updates
homeassistant_install_check
show_main