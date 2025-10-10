#!/bin/bash

echo "Configuring services...."

if ! pacman -Q mongodb-bin &> /dev/null; then
  echo "mongodb-bin is not installed."
  echo "Run install.sh to install both databases."
  exit 1
fi

if ! pacman -Q postgresql &> /dev/null; then
  echo "postgresql is not installed."
  echo "Run install.sh to install both databases."
  exit 1
fi

set -e

if [ ! -f "packages.conf" ]; then
    echo "Error: packages.conf not found!"
    exit 1
fi

source packages.conf

echo "Updating whole system first...."
sudo pacman -Syu --noconfirm

# Start and enable services
for service in "${SERVICES[@]}"; do
  if ! systemctl is-active "$service" &> /dev/null; then
    echo "Starting $service...."
    sudo systemctl start "$service"
  else
    echo "$service is already active."

  if ! systemctl is-enabled "$service" &> /dev/null; then
    echo "Enabling $service...."
    sudo systemctl enable "$service"
  else
    echo "$service is already enabled."
done
