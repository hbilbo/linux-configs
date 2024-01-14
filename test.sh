#!/bin/bash

function check_input {
  read -p "$1" user_input
  user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')

  #local user_input=$1
  if [[ "$user_input" == "y" ]]; then
    echo "You entered 'y'"
  elif [[ "$user_input" == "n" ]]; then
    echo "You entered 'n'" 
  else
    echo "Invalid input. Please enter 'y' or 'n'."
    check_input "$1"
  fi
}

read -p "Install neovim? (y/n): " user_input
# Neovim install
neovim_install=$(check_input "Install neovim? (y/n):")
# Homebrew install

# Rest of your script continues here...
echo "The script continues after user input."
