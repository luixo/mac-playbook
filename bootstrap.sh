#!/bin/zsh

# Install Xcode Command Line Developer Tools
echo "Checking for Xcode Command Line Developer Tools..."
xcode-select -p >& /dev/null || {
  xcode-select --install
  echo "Select \"Install\" when prompted for Command Line Developer Tools"
  sleep 3
  osascript -e 'tell application "Install Command Line Developer Tools" to activate'
  echo "Waiting for Xcode Command Line Tools to finish installing..."
  while ! pkgutil --pkg-info=com.apple.pkg.CLTools_Executables &>/dev/null; do
      sleep 1
  done
  echo "Xcode Command Line Tools are installed."
}

# Install Rosetta 2
if ! /usr/bin/pgrep -q oahd; then
  echo "Installing Rosetta dynamic translator..."
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

# Clone playbook to a local machine
echo "Verifying playbook is downloaded..."
mkdir -p ~/git/personal/mac-playbook
if [[ ! -d .git ]]; then
  git clone https://github.com/luixo/mac-playbook.git ~/git/personal/mac-playbook
fi

# Install Homebrew
echo "Checking for Homebrew..."
if ! brew config >& /dev/null; then 
  if [[ ! -f /opt/homebrew/bin/brew ]]; then
    echo "Installing Homebrew..." 
    NONINTERACTIVE=1 sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# Activate Homebrew for the boostrapt script
echo "Adding homebrew to PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install all apps that are immediately required for bootstrapping. 
echo "Checking for immediately installed apps"
export HOMEBREW_CASK_OPTS='--no-quarantine'
# TODO: add bitwarden-cli when "status" command is fixed
# https://github.com/bitwarden/clients/issues/9254
brew install --quiet jq ansible python pyenv python-setuptools virtualenv

# Temporary: download working bw-cli version
curl -L -o /tmp/bw-macos-2024.1.0.zip https://github.com/bitwarden/clients/releases/download/cli-v2024.1.0/bw-macos-2024.1.0.zip
sudo unzip -d /usr/local/bin /tmp/bw-macos-2024.1.0.zip

# Login to Bitwarden CLI
echo "Checking for Bitwarden CLI..."
output=$(bw lock 2>&1)
unlock_count=0
unlock_max_attempts=10
while [[ ! "$output" == *"Your vault is locked"* ]] || [[ $unlock_count -eq $unlock_max_attempts ]]; do
  echo "Signing in to Bitwarden"
  echo "Please visit url https://vault.bitwarden.com/#/settings/security/security-keys to obtain a key"
  vared -p "Enter your client id: " -c BW_CLIENTID
  vared -p "Enter your client secret: " -c BW_CLIENTSECRET
  export BW_CLIENTID
  export BW_CLIENTSECRET
  output=$(bw login --apikey 2>&1)
  if [[ ! "$output" == *"You are logged in"* ]]; then
    echo "Wrong credentials, please try again"
    (( unlock_count++ ))
  fi
done

# TODO: get back whenever vaultpass is needed
# Add `vault_password_file=~/.ansible/vaultpass` to `ansible.cfg`
#
# Restore Ansible vaultpass via Bitwarden
# echo "Checking for vault password file..."
# if [[ ! -f ~/.ansible/vaultpass ]]; then
#   echo "Retrieving vault password"
#   mkdir -p -m 0755 ~/.ansible
#   touch ~/.ansible/vaultpass
#   read -ps "Enter your Bitwarden master password: " BW_PASSWORD
#   export BW_PASSWORD
#   echo "\nUnlocking the vault..."
#   export BW_SESSION=$(bw unlock --passwordenv BW_PASSWORD --raw)
#   bw get item "Ansible Vault - Playbook" | jq ".fields[0].value" > ~/.ansible/vaultpass
# fi

echo "Switching to the playbook dir..."
cd ~/git/personal/mac-playbook

# Install python environment to run ansible
echo "Checking python environment..."
eval "$(pyenv init -)"
python3 -m venv venv
source venv/bin/activate

# Install ansible requirements
ansible-galaxy install -r requirements.yml

echo ""
echo "Finished bootstrapping!"
echo "Run \`eval \"\$(/opt/homebrew/bin/brew shellenv)\" && source venv/bin/activate && ansible-playbook main.yml --ask-become-pass\` to run the installation."
echo ""
