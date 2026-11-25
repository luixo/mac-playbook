#!/bin/zsh

playbook_repo_dir=~/git/mac-playbook

# We want to throw in case something fails
set -e

echo "Checking sudo access (Homebrew needs it to install the Command Line Tools)..."
if ! sudo -n true 2>/dev/null; then
  sudo -v
fi

# Install Homebrew
echo "Checking for Homebrew..."
if [[ ! -f /opt/homebrew/bin/brew ]]; then
  echo "Installing Homebrew (and the Command Line Developer Tools it needs)..."
  NONINTERACTIVE=1 CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
fi

# Activate Homebrew for the bootstrap script
echo "Adding homebrew to PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Verify CLT are installed
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools are missing — run 'xcode-select --install' and re-run." >&2
  exit 1
fi

# Clone playbook to a local machine
echo "Verifying playbook is downloaded..."
if [[ ! -d $playbook_repo_dir ]]; then
  mkdir -p ~/git
  git clone https://github.com/luixo/mac-playbook.git $playbook_repo_dir
else
  echo "Updating the existing playbook checkout..."
  if ! git -C "$playbook_repo_dir" fetch --prune
  then
    echo "Could not fetch $playbook_repo_dir — check network or credentials, then re-run." >&2
    exit 1
  fi
  if ! git -C "$playbook_repo_dir" pull --ff-only
  then
    echo "Cannot fast-forward $playbook_repo_dir — there are local commits or changes to resolve first." >&2
    exit 1
  fi
fi

# Only what is needed to run the playbook
echo "Installing Ansible and the Bitwarden CLI..."
HOMEBREW_NO_ASK=1 brew install --quiet ansible bitwarden-cli

# Login to Bitwarden CLI
echo "Checking for Bitwarden CLI..."
if ! bw login --check >/dev/null 2>&1; then
  echo "Signing in to Bitwarden"
  echo "Create an API key at https://vault.bitwarden.com/#/settings/security/security-keys"
  for attempt in {1..3}; do
    vared -p "Enter your client id: " -c BW_CLIENTID
    vared -p "Enter your client secret: " -c BW_CLIENTSECRET
    export BW_CLIENTID BW_CLIENTSECRET
    if bw login --apikey >/dev/null 2>&1; then
      echo "Logged in to Bitwarden."
      break
    fi
    echo "Wrong credentials (attempt $attempt/3), please try again."
  done
  if ! bw login --check >/dev/null 2>&1; then
    echo "Could not log in to Bitwarden after 3 attempts." >&2
    exit 1
  fi
fi

echo "Switching to the playbook dir..."
cd $playbook_repo_dir

# Install ansible requirements
echo "Installing Ansible requirements..."
if [[ ! -d ansible_collections/community/general ]]; then
  # Remove -f when patches are not needed anymore
  ansible-galaxy collection install -r requirements.yml -f
  patch < patches/bitwarden.patch
  patch < patches/osx_defaults.patch
fi

echo ""
echo "Finished bootstrapping!"
echo "Run \`ansible-playbook main.yml --ask-vault-pass -K\`: vault password is the Bitwarden master password, -K asks for your sudo password"
echo "If the session is lost: \`cd $playbook_repo_dir && eval \"\$(/opt/homebrew/bin/brew shellenv)\"\`"
echo ""
