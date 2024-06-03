read -p "Specify git email: " git_email
ssh-keygen -t ed25519 -C "${git_email}"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
