#!/bin/bash

# Install prerequisities for Ubuntu
sudo apt install gnupg2

wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
sudo apt install ./1password-latest.deb

rm 1password-latest.deb
