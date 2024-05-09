#!/bin/bash

echo "Please enter y(yes), n(no), or a(abort)"
echo
# Update package repositories
sudo apt update && sudo apt upgrade -y

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

read -p "Replace .bashrc and .bash_aliases file? [y/n/a]: " replace_config
replace_config=$(echo "$replace_config" | tr '[:upper:]' '[:lower:]')
check_input "$replace_config"

read -p "Install contents of 'apt_packages.txt'? [y/n/a]: " package_install
package_install=$(echo "$package_install" | tr '[:upper:]' '[:lower:]')
check_input "$package_install"

read -p "Install Oh-My-Posh? [y/n/a]: " ohmyposh_install
ohmyposh_install=$(echo "$ohmyposh_install" | tr '[:upper:]' '[:lower:]')
check_input "$ohmyposh_install"

read -p "Install Neovim? [y/n/a]: " neovim_install
neovim_install=$(echo "$neovim_install" | tr '[:upper:]' '[:lower:]')
check_input "$neovim_install"

#read -p "Install Google Chrome for WSL2? [y/n/a]: " chrome_install
#chrome_install=$(echo "$chrome_install" | tr '[:upper:]' '[:lower:]')
#check_input "$chrome_install"

#read -p "Install Homebrew? [y/n/a]: " homebrew_install
#homebrew_install=$(echo "$homebrew_install" | tr '[:upper:]' '[:lower:]')
#check_input "$homebrew_install"

#read -p "Install Lazygit? [y/n/a]: " lazygit_install
#lazygit_install=$(echo "$lazygit_install" | tr '[:upper:]' '[:lower:]')
#check_input "$lazygit_install"

# Configuration
if [[ "$replace_config" == "y" ]]; then
	# Replace .bashrc and .bash_aliases
	cp .bashrc ~
	cp .bash_aliases ~
	cp .gitconfig ~
	# Update bash
	source ~/.bashrc
fi

# Package Installation
if [[ "$package_install" == "y" ]]; then
	echo "Installing packages..."
	xargs sudo apt -y install < apt_packages.txt

	# Create symbolic links to programs
	ln -s $(which fdfind) /usr/local/bin/fd
fi

# Oh-My-Posh Installation
if [[ "$ohmyposh_install" == "y" ]]; then
	echo "Installing oh-my-posh..."
	mkdir ~/.local/bin
	# Install oh-my-posh using install script
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
	# Install nerd fonts (This uses hack font, tailer to your desired font)
 	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
	unzip Hack.zip -d ~/.local/share/fonts
	fc-cache -fv
	rm Hack.zip
 	# Copy config and update .bashrc
  	cp hacker.omp.json ~/.config/
  	echo "eval \"\$(oh-my-posh init bash --config /home/hbilbo/.config/hacker.omp.json)\"" >> ~/.bashrc
   	# Update bash
    	source ~/.bashrc
fi

# Neovim Installation
if [[ "$neovim_install" == "y" ]]; then
	echo "Installing neovim..."
	# Install latest neovim from source
	wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
	chmod +x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim	
	# Add neovim configs
	git clone git@github.com:hbilbo/nvim-config.git ~/.config/nvim
fi

# # Google Chrome Installation
# if [[ "$chrome_install" == "y" ]]; then
# 	echo "Installing Google Chrome..."
# 	# Install google chrome for wsl (REQUIRES WSL2)
# 	cd /tmp
# 	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# 	sudo dpkg -i google-chrome-stable_current_amd64.deb
# 	sudo apt install --fix-broken -y
# 	sudo dpkg -i google-chrome-stable_current_amd64.deb
# 	cd $OLDPWD

# 	# --- ONLY FOR WSL ---
# 	# create symbolic link to chrome installation location and set BROWSER env variable
# 	# ln -s "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" chrome
# 	# export BROWSER=~/chrome >> .bashrc
# fi

# # Homebrew Installation
# if [[ "$homebrew_install" == "y" ]]; then
# 	echo "Installing Homebrew package manager..."
# 	# Install homebrew package manager
# 	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# 	(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> $HOME/.bashrc
# fi

# # Lazygit Installation
# if [[ "$lazygit_install" == "y" ]]; then
# 	echo "Installing lazygit..."
# 	# Install lazygit
# 	# via Ubuntu native commands
# 	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
# 	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
# 	tar xf lazygit.tar.gz lazygit
# 	sudo install lazygit /usr/local/bin
# 	# or via homebrew
# 	# brew install jesseduffield/lazygit/lazygit
# fi
