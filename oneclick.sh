#!/bin/bash

show_main() {
    clear
    echo "1. USBIP WSL/HYPERV"
    echo "2. 3x-UI"
    echo "3. AdguardHome"
    echo "4. Home Assistant"
    echo "5. Troubleshooting"
    echo "0. Exit Script"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) usbip ;;
        2) 3xui ;;
        3) adguardhome ;;
        4) homeassistant ;;
        5) troubleshooting ;;
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
    echo "1. DPKG"
    echo "0. Back"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) troubleshooting_dpkg_fix ;;
        0) show_main ;;
        *) echo "Invalid option!"; sleep 1; troubleshooting ;;
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
    modprobe vhci-hcd
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
    echo -n "Enter HOST IP: "
    read host_ip
    echo -n "Enter BUS ID: "
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
    echo "Home Assistant installed."
    su -
    cd /var/local
    apt install \
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
    wget -y
    curl -fsSL get.docker.com | sh
    wget -O os-agent_linux_x86_64.deb https://github.com/home-assistant/os-agent/releases/latest/download/os-agent_1.6.0_linux_x86_64.deb
    wget -O homeassistant-supervised.deb https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
    apt install ./os-agent_linux_x86_64.deb
    apt install ./homeassistant-supervised.deb
    sleep 10
    show_main
}

homeassistant_uninstall() {
    clear
    echo "Uninstalling Home Assistant..."
    apt remove \
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
    os-agent -y
    rm -fr /var/local/os-agent_linux_x86_64.deb /var/local/homeassistant-supervised.deb
    echo "Home Assistant uninstalled."
    sleep 10
    show_main
}

troubleshooting_dpkg_fix() {
    clear
    dpkg --force-all --configure -a
    apt --fix-broken install
    apt-get -f install
    sleep 10
    show_main
}

show_main
