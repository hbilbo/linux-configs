#!/bin/bash

sudo apt update && sudo apt upgrade -y

wget https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb
sudo dpkg -i 1password-cli-amd64-latest.deb

rm 1password-cli-amd64-latest.deb
