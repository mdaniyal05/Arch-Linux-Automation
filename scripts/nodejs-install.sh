#!/bin/bash

set -e

if ! command -v nvm &> /dev/null; then
  echo "Installing NVM...."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  \. "$HOME/.nvm/nvm.sh"
else
  echo "NVM is already installed"
fi

echo "Installing Node.js LTS via NVM...."

nvm install --lts

echo "Node.js installed successfully."

node --version
npm --version

echo "List all installed Node.js versions with 'nvm ls'"
