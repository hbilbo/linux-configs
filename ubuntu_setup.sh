#!/bin/bash

xargs sudo apt -y install < packages.txt

wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod +x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim

git clone https://github.com/hbilbo/kickstart.nvim.git ~/.config/nvim
