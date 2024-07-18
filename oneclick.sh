#!/bin/bash

show_main() {
    clear
    echo "1. USBIP WSL/HYPERV"
    echo "2. 3x-UI"
    echo "3. AdguardHome"
    echo "4. Home Assistant"
    echo "5. Troubleshooting"
    echo "6. System Info"
    echo "7. Check for Updates"
    echo "0. Exit Script"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) usbip ;;
        2) 3xui ;;
        3) adguardhome ;;
        4) homeassistant ;;
        5) troubleshooting ;;
        6) systeminfo ;;
        7) check_for_updates ;;
        0) exit 0 ;;
        *) echo "Invalid option!"; sleep 1; show_main ;;
    esac
}

usbip() {
    clear
    echo "USBIP WSL/HYPERV"
    echo "1. Ubuntu Install"
    echo "2. Debian Install"
    echo "3. Uninstall"
    echo "4. Attach"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) usbip_ubuntu_install ;;
        2) usbip_debian_install ;;
        3) usbip_uninstall ;;
        4) usbip_attach ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; usbip ;;
    esac
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

homeassistant() {
    clear
    echo "Home Assistant"
    echo "1. Install"
    echo "2. Uninstall"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) homeassistant_install ;;
        2) homeassistant_uninstall ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; homeassistant ;;
    esac
}

troubleshooting() {
    clear
    echo "Troubleshooting"
    echo "1. DPKG Repair"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) troubleshooting_dpkg_repair ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; troubleshooting ;;
    esac
}

systeminfo() {
    clear
    echo "System Info"
    echo "1. Get Lan IP"
    echo "2. Check Port"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) systeminfo_getLanIP ;;
        2) systeminfo_checkPort ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; systeminfo ;;
    esac
}

usbip_ubuntu_install() {
    clear
    echo "Installing USBIP on Ubuntu..."
    apt update
    apt install -y hwdata usbutils linux-tools-virtual
    update-alternatives --install /usr/local/bin/usbip usbip `ls /usr/lib/linux-tools/*/usbip | tail -n1` 20
    modprobe vhci-hcd
    echo "USBIP installed on Ubuntu."
    sleep 10
    show_main
}

usbip_debian_install() {
    clear
    echo "Installing USBIP on Debian..."
    apt update
    apt install -y hwdata usbutils usbip
    echo "USBIP installed on Debian."
    sleep 10
    show_main
}

usbip_uninstall() {
    clear
    echo "Uninstalling USBIP..."
    apt remove -y hwdata usbutils usbip linux-tools-virtual
    apt autoremove -y
    echo "USBIP uninstalled."
    sleep 10
    show_main
}

usbip_attach() {
    clear
    modprobe vhci-hcd
    echo -n "Host/Server IP: "
    read host_ip
    echo -n "Host/Server BUSID: "
    read bus_id
    usbip attach -r "$host_ip" -b "$bus_id"
    lsusb
    echo "USB device attached from $host_ip with bus ID $bus_id."
    sleep 10
    show_main
}

3xui_install() {
    clear
    echo "Installing 3x-UI..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    echo "3x-UI installed."
    sleep 10
    show_main
}

3xui_management() {
    clear
    x-ui
    sleep 10
    show_main
}

adguardhome_install() {
    clear
    echo "Installing AdguardHome loading..."
    curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
    echo "AdguardHome installed."
    sleep 10
    show_main
}

adguardhome_uninstall() {
    clear
    echo "Uninstalling AdguardHome..."
    /opt/AdGuardHome/AdGuardHome -s uninstall
    rm -fr /opt/AdGuardHome
    echo "AdguardHome uninstalled."
    sleep 10
    show_main
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
    apt install -y ./os-agent_linux_x86_64.deb
    apt install -y ./homeassistant-supervised.deb

    echo "Home Assistant installed."
    sleep 10
    show_main
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
    show_main
}

troubleshooting_dpkg_repair() {
    clear
    dpkg --force-all --configure -a

    # dpkg: error: 2 expected programs not found in PATH or not executable
    apt --fix-broken install
    apt-get -f install
    sleep 10
    show_main
}

systeminfo_getLanIP() {
    clear
    # This script attempts to find the server's primary IP address.
    # It first tries using 'ifconfig' and then falls back to 'ip addr' if 'ifconfig' doesn't produce a result.

    # Identify the primary network interface by checking the default route.
    primary_interface=$(ip route | grep default | awk '{print $5}')

    # Try to retrieve the server's primary IP address using ifconfig.
    ifconfig_ip=$(ifconfig $primary_interface | grep -oE 'inet (10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3})' | awk '{print $2}')

    # Check if the result from ifconfig is empty.
    # If it is, try to use 'ip addr' to retrieve the IP.
    if [ -z "$ifconfig_ip" ]; then
        # Try to retrieve the server's primary IP address using 'ip addr'.
        ip_ip=$(ip addr show $primary_interface | grep -oE 'inet (10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3})' | awk '{print $2}')

        # Check if the result from 'ip addr' is non-empty.
        # If it is, print the IP. Otherwise, print an error message.
        if [ -n "$ip_ip" ]; then
            echo "Server IP (via ip): $ip_ip"
        else
            echo "Unable to determine server IP"
        fi
    else
        # If the result from 'ifconfig' was non-empty, print the IP.
        echo "Server IP (via ifconfig): $ifconfig_ip"
    fi
    sleep 10
    show_main
}

systeminfo_checkPort() {
    clear
    
    echo -n "Check Port: "
    read checkPort
    ss -lntp | grep "$checkPort"
    sleep 10
    show_main
}

check_for_updates() {
    clear
    echo "Checking for updates..."
    
    # URL of the raw script from the GitHub repository
    script_url="https://raw.githubusercontent.com/1kemalozturk/scripts/main/oneclick.sh"
    
    # Temp file to store the updated script
    temp_script="/tmp/updated_script.sh"
    
    # Download the latest version of the script
    curl -s -o "$temp_script" "$script_url"
    
    # Compare the local script with the updated script
    if ! cmp -s "$0" "$temp_script"; then
        echo "Update found. Applying update..."
        cp "$temp_script" "$0"
        chmod +x "$0"
        echo "Script updated. Please re-run the script."
        sleep 5
        exit 0
    else
        echo "No updates available."
        sleep 2
        show_main
    fi
}

show_main
