#!/bin/bash

latest_release_url=$(curl -sL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | jq -r '.assets[] | select(.name | endswith("amd64.deb")) | .browser_download_url')
file=$(basename "$latest_release_url")

# Download the latest release
curl -LO "$latest_release_url"
