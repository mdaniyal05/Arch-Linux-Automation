#!/bin/bash

is_package_installed() {
    pacman -Qi "$1" &> /dev/null
}

is_package_group_installed() {
    pacman -Qg "$1" &> /dev/null
}

install_required_packages() {
    local packages=("$@")
    local to_install=()

    for package in "${packages[@]}"; do
        if ! is_package_installed "$package" && ! is_package_group_installed "$package"; then
            to_install+=("$package")
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        echo "Installing: ${to_install[*]}"
        yay -S --noconfirm "${to_install[@]}"
    fi
}
