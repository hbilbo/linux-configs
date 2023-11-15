#!/bin/bash

echo "Installing dependencies"
sudo apt install git pass gpg dotnet-sdk-7.0
echo "Checking if dotnet was added to PATH"
sleep 3
echo $PATH
DOTNET_DIR=$HOME/.dotnet/tools
if [[ ":$PATH:" == *":$DOTNET_DIR:"* ]]; then
    echo "export PATH=\$DOTNET_DIR:\$PATH" > ~/.bashrc
fi
# add env variable for running gcm headless
echo "export GPG_TTY=\$(tty)" > ~/.bashrc
echo "Dotnet should have been added to path if it wasn't already"
echo $PATH
sleep 5

echo "Installing gcm..."
# install and configure gcm
dotnet tool install -g git-credential-manager
git-credential-manager configure
dotnet tool update -g git-credential-manager

# create symbolic link to chrome installation location and set BROWSER env variable
# ln -s "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" chrome
# Then add the env variable to end of .bashrc file
# export BROWSER=~/chrome > .bashrc

GPG_KEY_NAME="gcm_key"
GIT_NAME="Hayden Bilbo"
GIT_EMAIL="83983938+hbilbo@users.noreply.github.com"
GIT_HELPER="$HOME/.dotnet/tools/git-credential-manager"

echo "Initializing GPG key with pass..."
#gpg --batch --quick-gen-key "$GIT_NAME <$GIT_EMAIL>" && pass init $GPG_KEY_NAME
gpg_output=$(gpg --batch --quick-gen-key "$GIT_NAME <$GIT_EMAIL>")
GPG_KEY_ID=$(echo "$gpg_output" | grep -oP 'Key fingerprint = \K\S+')
echo "GPG Key ID: $GPG_KEY_ID"
pass init "$GPG_KEY_ID"

echo "Configuring Git with GPG signing..."
git config --global credential.helper "$GIT_HELPER"
git config --global credential.credentialStore "gpg"
echo "Git credential manager setup completed!"

echo "Configuring Git settings..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main
git config --global pull.rebase false 
