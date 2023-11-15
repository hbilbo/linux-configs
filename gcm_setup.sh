#!/bin/bash

echo "Installing dependencies"
sudo apt install git pass gpg dotnet-sdk-7.0
# add env variable for running gcm headless

echo "Installing gcm..."
# install and configure gcm
dotnet tool install -g git-credential-manager
export PATH=$HOME/.dotnet/tools:$PATH
echo "export PATH=\$HOME/.dotnet/tools:\$PATH" >> ~/.bashrc

git-credential-manager configure
dotnet tool update -g git-credential-manager
echo "export GPG_TTY=\$(tty)" > ~/.bashrc

# create symbolic link to chrome installation location and set BROWSER env variable
# ln -s "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" chrome
# Then add the env variable to end of .bashrc file
# export BROWSER=~/chrome > .bashrc

GIT_NAME="Hayden Bilbo"
GIT_EMAIL="83983938+hbilbo@users.noreply.github.com"
GIT_HELPER="$HOME/.dotnet/tools/git-credential-manager"

echo "Initializing GPG key with pass..."
gpg --batch --quick-gen-key "$GIT_NAME <$GIT_EMAIL>" && pass init "$GIT_NAME <$GIT_EMAIL>"
# gpg_output=$(gpg --batch --quick-gen-key "$GIT_NAME <$GIT_EMAIL>")
# GPG_KEY_ID=$(echo "$gpg_output" | grep -oP 'Key fingerprint = \K\S+')
# echo "GPG Key ID: $GPG_KEY_ID"
# pass init "$GPG_KEY_ID"

echo "Configuring Git settings..."
git config --global credential.helper "$GIT_HELPER"
git config --global credential.credentialStore "gpg"
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main
git config --global pull.rebase false 
