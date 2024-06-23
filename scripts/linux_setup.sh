#!/bin/bash

echo "Please enter y(yes), n(no), or a(abort)"
echo

function check_input {
if [[ "$1" == "a" ]]; then
	echo "Aborting." 
	exit 1
fi
if [[ "$1" != "y" && "$1" != "n" ]]; then
	echo "Invalid input '$1', aborting install." 
	exit 1
fi
}

read -p "Replace dotfiles with custom configs? [y/n/a]: " configure_setup
configure_setup=$(echo "$configure_setup" | tr '[:upper:]' '[:lower:]')
check_input "$configure_setup"

read -p "Install contents of 'apt_packages.txt'? [y/n/a]: " package_install
package_install=$(echo "$package_install" | tr '[:upper:]' '[:lower:]')
check_input "$package_install"

read -p "Install Docker? [y/n/a]: " docker_install
docker_install=$(echo "$docker_install" | tr '[:upper:]' '[:lower:]')
check_input "$docker_install"

read -p "Install Oh-My-Posh? [y/n/a]: " ohmyposh_install
ohmyposh_install=$(echo "$ohmyposh_install" | tr '[:upper:]' '[:lower:]')
check_input "$ohmyposh_install"

read -p "Install Neovim? [y/n/a]: " neovim_install
neovim_install=$(echo "$neovim_install" | tr '[:upper:]' '[:lower:]')
check_input "$neovim_install"

read -p "Install Moonlight Remote Desktop Client? [y/n/a]: " moonlight_install
moonlight_install=$(echo "$moonlight_install" | tr '[:upper:]' '[:lower:]')
check_input "$moonlight_install"

read -p "Install Obsidian? [y/n/a]: " obsidian_install
obsidian_install=$(echo "$obsidian_install" | tr '[:upper:]' '[:lower:]')
check_input "$obsidian_install"

# Update package repositories
echo
echo "Updgrading current packages..."
sudo apt update -qq && sudo apt upgrade -qq -y

# Configuration
if [ ! -d ~/.local/bin ]; then
	mkdir ~/.local/bin
fi
if [[ "$configure_setup" == "y" ]]; then
	# Replace .bashrc and .bash_aliases
	cp .bashrc ~
	cp .bash_aliases ~
	cp .gitconfig ~
fi

# Package Installation
if [[ "$package_install" == "y" ]]; then
	echo "Installing packages..."
	xargs sudo apt -y install < ../apt_packages.txt

	# Create symbolic links to programs
	ln -s $(which fdfind) /usr/local/bin/fd
fi

# Docker Installation
if [[ "$docker_install" == "y" ]]; then
	echo "Installing Docker..."
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	rm get-docker.sh
fi

# Oh-My-Posh Installation
if [[ "$ohmyposh_install" == "y" ]]; then
	echo "Installing oh-my-posh..."
	# Install oh-my-posh using install script
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
	# Install nerd fonts (This uses hack font, tailer to your desired font)
 	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
	unzip Hack.zip -d ~/.local/share/fonts
	fc-cache -fv
	rm Hack.zip
 	# Copy config and update .bashrc
  	cp hacker.omp.json ~/.config/
  	echo "eval \"\$(oh-my-posh init bash --config ~/.config/hacker.omp.json)\"" >> ~/.bashrc
fi

# Neovim Installation
if [[ "$neovim_install" == "y" ]]; then
	echo "Installing neovim..."
	# Install latest neovim from source
	wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
	chmod +x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim	
	# sudo apt install neovim
	# Add neovim configs
	git clone https://github.com/hbilbo/nvim-config.git ~/.config/nvim
fi
 
# Moonlight Installation
if [[ "$moonlight_install" == "y" ]]; then
	echo "Installing Moonlight..."
	# Fetch latest release information from GitHub API
	latest_release_url=$(curl -sL https://api.github.com/repos/moonlight-stream/moonlight-qt/releases/latest | jq -r '.assets[] | select(.name | endswith(".AppImage")) | .browser_download_url')
	file=$(basename "$latest_release_url")

	# Download the latest AppImage
	curl -L -o moonlight.appimage "$latest_release_url"
	chmod +x moonlight.appimage && mv ~/.local/bin/moonlight
fi

# Obsidian Installation
if [[ "$obsidian_install" == "y" ]]; then
	echo "Installing Obsidian..."
	# Fetch latest release information from GitHub API
	latest_release_url=$(curl -sL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[] | select(.name | endswith("amd64.deb")) | .browser_download_url')
	file=$(basename "$latest_release_url")

	# Download the latest release
	curl -LO "$latest_release_url"
	sudo apt install ./"$file"
	rm ./"$file"
fi

echo; echo
echo "Setup completed. Please restart terminal session!"
echo "NOTE: If this is a VM, you may need to reboot for changes to take effect."
