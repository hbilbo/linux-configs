#!/bin/bash

# configuration
GIT_NAME="Hayden Bilbo"
GIT_EMAIL="83983938+hbilbo@users.noreply.github.com"
GIT_HELPER="$HOME/.dotnet/tools/git-credential-manager"

echo "Installing dependencies"
sudo apt install git pass gpg dotnet-sdk-7.0

echo "Configuring Git settings..."
git config --global credential.helper "$GIT_HELPER"
git config --global credential.credentialStore "gpg"
git config --global credential.guiPrompt false
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main
git config --global pull.rebase false 

# install and configure gcm
echo "Installing gcm..."
dotnet tool install -g git-credential-manager
export PATH=$HOME/.dotnet/tools:$PATH
echo "export PATH=\$HOME/.dotnet/tools:\$PATH" >> ~/.bashrc

git-credential-manager configure
dotnet tool update -g git-credential-manager
# add env variable for running gcm headless
echo "export GPG_TTY=\$(tty)" > ~/.bashrc

# --- ONLY FOR WSL ---
# create symbolic link to chrome installation location and set BROWSER env variable
ln -s "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" chrome
export BROWSER=~/chrome > .bashrc

echo "Initializing GPG key with pass..."
gpg --batch --quick-gen-key "$GIT_NAME <$GIT_EMAIL>" && pass init "$GIT_NAME <$GIT_EMAIL>"
