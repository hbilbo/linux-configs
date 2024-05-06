# linux-configs
Collection of my personal configs and readme's to setup varius services in Linux.

OH-MY-POSH
hacker.omp.json is a configuration file for the oh-my-posh prompt customization. Installation instructions can be found at https://ohmyposh.dev/docs/. The basic steps are:
    1. Install oh-my-posh to local directory: `curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin`
    2. Ensure PATH in .bashrc (change <username> to your username: `export PATH=$HOME/.local/bin:$PATH`
    3. Ensure nerd fonts are installed. Can alternatively be installed by oh-my-posh: `oh-my-posh font install`
    4. Add to .bashrc (verify path is correct): `eval "$(oh-my-posh init bash --config ~/.config/hacker.omp.json)"`
    5. Run `exec bash`
