#!/bin/bash

# Install prerequisities for Debian
sudo apt install gnupg2

wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb
sudo dpkg -i 1password-latest.deb

rm 1password-latest.deb
