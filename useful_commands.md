This is a collection of example commands or useful templates that may not be obvious or easy to remember.

### Git
`git reset --soft HEAD~1`

### Find
# Find files that match a specific pattern (Image_C001) and replace it with a specific character (C).
`find . -type f -name "Image_C001*" -execdir bash -c 'mv "$1" "${1//Image_C001/C}"' _ {} \;`
# The above command should work on almost anything running bash (like git bash). For full linux distros, the following command is simpler and can be more efficient
`find . -type f -name "Image_C001*" -execdir rename 's/Image_C001/C001/' '{}' +`

### Downloading latest github release
`wget https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-amd64`
`wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage`
Or
`wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage`

### Clear DNS cache (Ubuntu 24.04)
sudo resolvectl flush-caches
sudo resolvectl statistics # Check DNS statistics
