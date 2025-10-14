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

# Start and enable services
for service in "${SERVICES[@]}"; do
  if [ "$service" == "postgresql.service" ]; then
    sudo -u postgres initdb --locale en_US.UTF-8 -D /var/lib/postgres/data --data-checksums
  fi

  if ! systemctl is-active "$service" &> /dev/null; then
    echo "Starting $service...."
    sudo systemctl start "$service"
  else
    echo "$service is already active."
  fi

  if ! systemctl is-enabled "$service" &> /dev/null; then
    echo "Enabling $service...."
    sudo systemctl enable "$service"
  else
    echo "$service is already enabled."
  fi

  sudo systemctl status "$service"
done
