#!/bin/bash

DEV_ONLY=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dev-only) DEV_ONLY=true; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
done

set -e

source utils.sh

if [ ! -f "packages.conf" ]; then
    echo "Error: packages.conf not found!"
    exit 1
fi

source packages.conf

if [[ "$DEV_ONLY" == true ]]; then
    echo "Starting development-only setup...."
else
    echo "Starting full system setup...."
fi

echo "Updating whole system first...."
sudo pacman -Syu --noconfirm

if ! command -v yay &> /dev/null; then
    echo "Installing yay AUR helper...."
    sudo pacman -S --needed git base-devel --noconfirm

    if [[ ! -d "yay" ]]; then
        echo "Cloning yay repository...."
    else
        echo "yay directory already exists, removing it...."
        rm -rf yay
    fi

    git clone https://aur.archlinux.org/yay.git

    cd yay

    echo "Building yay...."

    makepkg -si --noconfirm

    cd ..

    rm -rf yay
else
    echo "yay is already installed"
fi

# Install packages
if [[ "$DEV_ONLY" == true ]]; then
    echo "Installing system utilities...."
    install_required_packages "${SYSTEM_UTILS[@]}"

    echo "Installing dev tools...."
    install_required_packages "${DEV_TOOLS[@]}"
else
    echo "Installing system utilities...."
    install_required_packages "${SYSTEM_UTILS[@]}"

    echo "Installing dev tools...."
    install_required_packages "${DEV_TOOLS[@]}"

    echo "Installing media tools...."
    install_required_packages "${MEDIA_TOOLS[@]}"

    echo "Installing hyprland tools...."
    install_required_packages "${HYPRLAND[@]}"

    echo "Installing fonts...."
    install_required_packages "${FONTS[@]}"
fi

echo "Setup completed! Reboot your system."
