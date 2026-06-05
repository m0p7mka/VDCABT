#!/bin/bash

mkdir -p ./logs
exec > >(tee -a "./logs/main_$(date +%Y%m%d_%H%M%S).log") 2>&1

red='\033[0;31m'
nc='\033[0m'
green='\033[0;32m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${red}This script should be launched with root priveleges!${nc}"
   echo "Use: sudo $0"
   exit 1
fi

disconnected=()
for p in /sys/class/drm/*/status; do
    if grep -q "disconnected" "$p"; then
        name=$(basename "$(dirname "$p")" | cut -d- -f2-)
        disconnected+=("$name")
    fi
done

disconnected=()
for p in /sys/class/drm/*/status; do
    grep -q "disconnected" "$p" && disconnected+=("$(basename "$(dirname "$p")" | cut -d- -f2-)")
done

echo "What output will the virtual display occupy?"
echo "Available disconnected outputs:"
select output in "${disconnected[@]}"; do
    if [[ -n "$output" ]]; then
        echo "You selected: $output"
        break
    else
        echo "Invalid choice. Please enter a number from the list."
    fi
done

if [[ $output == *DP* ]]; then
    filename="aoc-c24g1-dp"
else
    filename="aoc-c24g1-hdmi"
fi
if [[ ! -f "./edids/$filename" ]]; then
    echo -e "${red}Cant find EDID files.${nc}"
    exit 1
fi

mkdir -p /usr/lib/firmware/edid
cp "./edids/$filename" /usr/lib/firmware/edid/ || { echo "Failed to copy EDID file."; exit 1; }
[ -f "/usr/lib/firmware/edid/$filename" ] || { echo "EDID file not copied"; exit 1; }

update_initramfs() {
    local edid_file="$1"
    echo "Updating initramfs to include EDID file: $edid_file"

    if command -v mkinitcpio &>/dev/null; then
        echo "Detected mkinitcpio. Adding EDID to FILES and rebuilding..."
        if ! grep -q "$edid_file" /etc/mkinitcpio.conf; then
            cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup.$(date +%Y%m%d_%H%M%S)
            if grep -q '^FILES=' /etc/mkinitcpio.conf; then
                sed -i "/^FILES=/ s|)| $edid_file)|" /etc/mkinitcpio.conf
            else
                echo "FILES=($edid_file)" >> /etc/mkinitcpio.conf
            fi
        fi
        mkinitcpio -P

    elif command -v update-initramfs &>/dev/null; then
        echo "Detected update-initramfs. Adding EDID to initramfs.conf and rebuilding..."
        local conf_file="/etc/initramfs-tools/initramfs.conf"
        if ! grep -q "^FILES=" "$conf_file"; then
            echo "FILES=$edid_file" >> "$conf_file"
        elif ! grep -q "$edid_file" "$conf_file"; then
            sed -i "s|^FILES=\(.*\)|FILES=\1 $edid_file|" "$conf_file"
        fi
        update-initramfs -u

    elif command -v dracut &>/dev/null; then
        echo "Detected dracut. Creating config and rebuilding initramfs..."
        local dracut_conf_dir="/etc/dracut.conf.d"
        mkdir -p "$dracut_conf_dir"
        local conf_file="$dracut_conf_dir/edid.conf"
        echo "install_items+=\" $edid_file \"" >> "$conf_file"
        dracut --force --regenerate-all

    elif command -v mkinitrd &>/dev/null; then
        echo "Detected mkinitrd. Rebuilding initramfs..."
        mkinitrd

    else
        echo -e "${red}Could not automatically update initramfs.${nc}"
        echo "Please ensure the EDID file is included in your initramfs manually."
        echo "Otherwise the system may boot incorrectly."
        return 1
    fi
    echo -e "${green}Initramfs updated successfully.${nc}"
}

read -p "Add EDID file to initramfs? (y/N) [default y]: " confirm
confirm=${confirm:-y}
if [[ $confirm == [yY] ]]; then
    update_initramfs "/usr/lib/firmware/edid/$filename"
else
    echo "Please ensure the EDID file is included in your initramfs manually."
    echo "Otherwise the system may boot incorrectly."
fi

current=$(grep '^GRUB_CMDLINE_LINUX_DEFAULT=' /etc/default/grub | cut -d= -f2- | tr -d '"' | tr -d "'")
new_value="$current drm.edid_firmware=$output:edid/$filename video=$output:e"

echo -e "In ${red}/etc/default/grub${nc} string ${red}$(grep '^GRUB_CMDLINE_LINUX_DEFAULT=' /etc/default/grub)${nc} will be replaced with string ${red}GRUB_CMDLINE_LINUX_DEFAULT=\"$new_value\"${nc} and backup will be created."
sleep 3

read -p "Apply changes? (y/N) [default y]: " confirm
confirm=${confirm:-y}
if [[ $confirm == [yY] ]]; then
    if [ ! -w "/etc/default/grub" ]; then
        echo -e "${red}Cant write to /etc/default/grub.${nc}"
        exit 1
    fi
    cp /etc/default/grub "/etc/default/grub.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Grub config was backed up as ${red}/etc/default/grub.backup.$(date +%Y%m%d_%H%M%S)${nc}."
    if ! grep -q '^GRUB_CMDLINE_LINUX_DEFAULT=' /etc/default/grub; then
        echo "GRUB_CMDLINE_LINUX_DEFAULT=\"$new_value\"" | sudo tee -a /etc/default/grub
    else
        sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"$new_value\"|" /etc/default/grub
    fi
        
    if command -v update-grub &> /dev/null; then
        sudo update-grub
    elif command -v grub2-mkconfig &> /dev/null; then
        sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    else
        echo -e "${red}Please update GRUB configuration manually.${nc}"
    fi
    echo "Grub config was changed. "
else
    echo "Cancelled."
fi

install_sunshine() {
    echo "Installing Sunshine..."
    if command -v pacman &> /dev/null; then
        if command -v yay &> /dev/null; then
            echo -e "\n[lizardbyte]\nSigLevel = Optional\nServer = https://github.com/LizardByte/pacman-repo/releases/latest/download" | sudo tee -a /etc/pacman.conf
            sudo pacman -Sy
            sudo pacman -S lizardbyte/sunshine
        echo "Unsupported distribution."
        exit 1
    fi
    echo "${green}Sunshine installed.${nc}"
}

echo ""
read -p 'Install Sunshine? (y/N) [default y]: ' confirm
confirm=${confirm:-y}
if [[ $confirm == [yY] ]];then
    install_sunshine
    read -p 'Add Sunshine to startup? (y/N) [default y]: ' autostart
    autostart=${autostart:-y}
    if [[ $autostart == [yY] ]];then
        systemctl --user enable sunshine
    fi
fi

echo ""
echo 'Virtual display will become active only after reboot.'
read -p 'Reboot now to apply changes? (y/N) [default y]: ' reboot_confirm
reboot_confirm=${reboot_confirm:-y}
if [[ $reboot_confirm == [yY] ]]; then
    sudo reboot
else
    exit 0
fi