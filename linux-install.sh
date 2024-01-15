#!/bin/bash

echo "Please enter y(yes), n(no), or a(abort)"
echo
# Update package repositories
# sudo apt update

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

read -p "Install contents of 'packages.txt'? [y/n/a]: " package_install
# echo $(cat packages.txt | tr '\n' ' ')
# read -p "[y/n/a]: " package_install
package_install=$(echo "$package_install" | tr '[:upper:]' '[:lower:]')
check_input "$package_install"

read -p "Install Neovim? [y/n/a]: " neovim_install
neovim_install=$(echo "$neovim_install" | tr '[:upper:]' '[:lower:]')
check_input "$neovim_install"

read -p "Install Google Chrome? [y/n/a]: " chrome_install
chrome_install=$(echo "$chrome_install" | tr '[:upper:]' '[:lower:]')
check_input "$chrome_install"

read -p "Install Homebrew? [y/n/a]: " homebrew_install
homebrew_install=$(echo "$homebrew_install" | tr '[:upper:]' '[:lower:]')
check_input "$homebrew_install"

read -p "Install Lazygit? [y/n/a]: " lazygit_install
lazygit_install=$(echo "$lazygit_install" | tr '[:upper:]' '[:lower:]')
check_input "$lazygit_install"

# Package Installation
if [[ "$package_install" == "y" ]]; then
	echo "Installing packages..."
	sudo apt update && sudo apt upgrade -y
	xargs sudo apt -y install < packages.txt
	#
	# Create symbolic links to programs
	ln -s $(which fdfind) /usr/local/bin/fd
fi

# Neovim Installation
if [[ "$neovim_install" == "y" ]]; then
	echo "Installing neovim..."
	# Install latest neovim from source
	wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
	chmod +x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim_app 
fi

# Google Chrome Installation
if [[ "$chrome_install" == "y" ]]; then
	echo "Installing Google Chrome..."
	# Install google chrome for wsl (REQUIRES WSL2)
	cd /tmp
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	sudo apt install --fix-broken -y
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	cd $OLDPWD
fi

# Homebrew Installation
if [[ "$homebrew_install" == "y" ]]; then
	echo "Installing Homebrew package manager..."
	# Install homebrew package manager
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> $HOME/.bashrc
fi

# Lazygit Installation
if [[ "$lazygit_install" == "y" ]]; then
	echo "Installing lazygit..."
	# Install lazygit
	# via Ubuntu native commands
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin
	# or via homebrew
	# brew install jesseduffield/lazygit/lazygit
fi
