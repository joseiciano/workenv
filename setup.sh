#!/bin/bash

set -eu -o pipefail

echo "================================================"
echo "% Setting up config files %"
echo "================================================"

echo "================================================"
echo "% Creating backup of existing config files %"
echo "================================================"

# Create a backup copy of existing config directory
timestamp=$(date +%Y%m%d_%H%M%S)
[ -d ~/.config ] && mv ~/.config ~/.config_backup_$timestamp
mkdir -p ~/.config

echo "================================================"
echo "% Installing Dependencies %"
echo "================================================"

echo "Installing AeroSpace..."
brew install --cask nikitabobko/tap/aerospace

echo "Installing Borders..."
brew tap FelixKratz/formulae
brew install borders

echo "Installing fzf..."
brew install fzf

echo "Installing shortcat..."
brew install shortcat

echo "Installing tmux..."
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Installing yazi..."
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick font-symbols-only-nerd-font

echo "Successfully installed all dependencies..."

echo "================================================"
echo "% Creating workspace directory %"
echo "================================================"

# Create workspace directory for git repo if it doesn't exist
mkdir -p ~/Documents/workspace
cd ~/Documents/workspace
if [ -d "workenv" ]; then
    echo "Repository already exists, pulling latest changes..."
    cd workenv
    git pull
    cd ..
else
    echo "Cloning repository..."
    git clone https://github.com/joseiciano/workenv.git
fi

echo "================================================"
echo "% Copying config files %"
echo "================================================"

# Copy config files to ~/.config
cp -ri ./.config ~/.config/

echo "Copying tmux config..."
cp -ri ./tmux/.tmux.conf ~/.tmux.conf
cp -ri ./tmux/.tmux ~/.tmux

echo "================================================"
echo "% Copying vscode config files %"
echo "================================================"

# Copy settings and keybindings files to ~/.config
echo "Copying settings.json..."
cp -ri ./vscode/settings/settings.json $HOME/Library/Application\ Support/Code/User/settings.json

echo "Copying keybindings.json..."
cp -ri ./vscode/settings/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json

echo "Successfully copied vscode config files..."

echo "Copying extensions..."
cp -n -r vscode/extensions/* ~/.vscode/extensions/ 2>/dev/null || true
