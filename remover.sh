#!/bin/bash

mkdir -p ./logs
exec > >(tee -a "./logs/remover_$(date +%Y%m%d_%H%M%S).log") 2>&1

red='\033[0;31m'
nc='\033[0m'
green='\033[0;32m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${red}This script must be run as root!${nc}"
   echo "Use: sudo $0"
   exit 1
fi

echo -e "${red}WARNING${nc}: All dummy displays and their EDID files will be removed."
read -p "Proceed? (y/N) [default y]: " confirm
confirm=${confirm:-y}
if [[ ! $confirm =~ ^[yY]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo -e "${green}Removing EDID files...${nc}"
if [[ -d /usr/lib/firmware/edid ]]; then
    rm -rf /usr/lib/firmware/edid
    echo "Directory /usr/lib/firmware/edid removed."
else
    echo "No EDID files found."
fi

restore_initramfs() {
    echo -e "\n${green}Restoring initramfs...${nc}"
    
    if command -v mkinitcpio &>/dev/null; then
        conf_file="/etc/mkinitcpio.conf"
        backup_restored=false
        for backup in "$conf_file".backup.*; do
            if [[ -f "$backup" ]]; then
                cp "$backup" "$conf_file"
                echo "Restored $conf_file from $backup"
                backup_restored=true
                break
            fi
        done
        if [[ "$backup_restored" == false ]]; then
            if grep -q 'edid' "$conf_file"; then
                sed -i '/^FILES=/ s| /usr/lib/firmware/edid/[^ )]*||g' "$conf_file"
                echo "Removed EDID references from $conf_file"
            fi
        fi
        mkinitcpio -P
        echo "Initramfs rebuilt."
        
    elif command -v update-initramfs &>/dev/null; then
        conf_file="/etc/initramfs-tools/initramfs.conf"
        backup_restored=false
        for backup in "$conf_file".backup.*; do
            if [[ -f "$backup" ]]; then
                cp "$backup" "$conf_file"
                echo "Restored $conf_file from $backup"
                backup_restored=true
                break
            fi
        done
        if [[ "$backup_restored" == false ]]; then
            if grep -q 'edid' "$conf_file"; then
                sed -i '/^FILES=/ s| /usr/lib/firmware/edid/[^ ]*||g' "$conf_file"
                echo "Removed EDID references from $conf_file"
            fi
        fi
        update-initramfs -u
        echo "Initramfs updated."
        
    elif command -v dracut &>/dev/null; then
        dracut_conf_dir="/etc/dracut.conf.d"
        conf_file="$dracut_conf_dir/edid.conf"
        if [[ -f "$conf_file" ]]; then
            rm -f "$conf_file"
            echo "Removed $conf_file"
        fi
        dracut --force --regenerate-all
        echo "Initramfs rebuilt."
        
    elif command -v mkinitrd &>/dev/null; then
        mkinitrd
        echo "Initramfs rebuilt (via mkinitrd)."
        
    else
        echo -e "${red}Could not determine initramfs tool. Skipping initramfs restoration.${nc}"
    fi
}

restore_grub() {
    echo -e "\n${green}Restoring GRUB parameters...${nc}"
    
    if [ ! -w "/etc/default/grub" ]; then
        echo -e "${red}Cant write to /etc/default/grub.${nc}"
        exit 1
    fi
    cp /etc/default/grub "/etc/default/grub.backup.$(date +%Y%m%d_%H%M%S)"
    sudo sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"\"|" /etc/default/grub
    if command -v update-grub &> /dev/null; then
        update-grub
        echo "GRUB updated."
    elif command -v grub2-mkconfig &> /dev/null; then
        grub2-mkconfig -o /boot/grub2/grub.cfg
        echo "GRUB updated."
    else
        echo -e "${red}Could not update GRUB. Please do it manually.${nc}"
    fi
}

remove_sunshine() {
    echo -e "\n${green}Removing Sunshine...${nc}"
    
    if command -v pacman &>/dev/null; then
        pacman -Rns --noconfirm sunshine 2>/dev/null || echo "Sunshine not installed via pacman."
    elif command -v dnf &>/dev/null; then
        dnf remove -y sunshine 2>/dev/null || echo "Sunshine not installed via dnf."
    elif command -v apt &>/dev/null; then
        dpkg -r sunshine 2>/dev/null || echo "Sunshine not installed via dpkg."
    else
        echo "Could not determine package manager. Remove Sunshine manually."
    fi
    
    if systemctl --user is-enabled sunshine 2>/dev/null | grep -q enabled; then
        systemctl --user disable sunshine
        echo "Sunshine autostart disabled."
    fi
}

restore_initramfs
restore_grub

read -p "Remove Sunshine? (y/N) [default y]: " remove_sun
remove_sun=${remove_sun:-y}
if [[ $remove_sun =~ ^[yY]$ ]]; then
    remove_sunshine
else
    echo "Sunshine kept."
fi

echo -e "\n${green}All changes undone. A reboot is required for changes to take effect.${nc}"
read -p "Reboot now? (y/N) [default n]: " reboot_now
reboot_now=${reboot_now:-n}
if [[ $reboot_now =~ ^[yY]$ ]]; then
    reboot
else
    echo "Reboot postponed. Changes will apply after next reboot."
fi