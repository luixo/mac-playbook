# Mac bootstrap Ansible playbook

This playbook bootstraps a fresh Mac to be ready for my personal usage.

## Prerequisites

1. Run MacOS install wizard
1. Login to iCloud
1. Login into [Bitwarden Vault](https://vault.bitwarden.com/#/settings/security/security-keys) to obtain an API key
1. Add Terminal app to Settings -> Privacy and Security -> Full Disk Access
1. Run `sudo echo 1` at least once to get access to sudo from your account

## Installation

```sh
# Bootstrap (wait for sudo password prompt)
source <(curl -s https://raw.githubusercontent.com/luixo/mac-playbook/main/bootstrap.sh)
# Run playbook with vault password (Bitwarden master password)
ansible-playbook main.yml --ask-vault-pass
```

In case you lost the session after bootstrap has finished:

```sh
# Change directory to playbook's
cd git/mac-playbook
# Add homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"
# Activate python virtual env
source venv/bin/activate
```

## After installation

Some settings apply only after restart

### Password manager

1. Authorize in Arq & adopt the backup
1. Copy over `~/Library/Application Support/Arc/User Data` to original folder
1. Open Arc, authorize, enable sync & add Bitwarden extension
1. Authorize in Bitwarden, proceed with auth from there

### Restore from Arq

- `~/git` (probably skip some repos in `~/git/open-source`)
- `~/Documents` / `~/Downloads` / `~/Desktop`

### Manual tasks

Authorize in:

- Arc
- VSCode (through "enable settings sync")
- DataGrip
- Amnezia (from bitwarden)
- Notion
- Todoist
- Telegram
- Docker

Misc:

- Set default profile in iTerm2
- Touch ID: add more fingerprints (left & right index & right thumb)
- Wireguard: install from MAS & add tunnel from Bitwarden (VPN ru)
- Arc
  - set as default browser
  - enable sync (via Arc sync)
  - add extensions: Bitwarden, Adguard
  - set auto-archive to 30 days
- Arq: adopt a backup plan (only after detaching it from old machine)
- GPG: run `echo "test" | gpg --clearsign` and type the password (from Bitwarden) to sign in into GPG
- Apple locator: register
- Bitwarden settings:
  - autocomplete
    - turn off browser autocomplete
- Telegram options
  - emoji -> suggest -> off
  - emoji -> sticker packs -> suggest instead of stickers -> off
  - general -> emoji -> emoji autoreplace -> off
  - general -> interface -> all off
  - sound -> off
  - general -> send messages -> as cmd+enter
  - appearance -> text size 3/7
- Notion options
  - Preferences -> Use Command Search -> off
- DataGrip
  - import projects from `~/DataGripProjects`
  - download required drivers
  - re-enter all the passwords

### Follow-up for next restorations

- Compare changes made to `roles/apps/files` with files from `~`.

## Cleaning up old Mac

Follow Apple's guide [here](https://support.apple.com/en-au/HT212749)

## Credentials

This project was created by (and for) [luixo](https://github.com/luixo) (inspired by [Jeff Geerling](https://github.com/geerlingguy/) and [James Hardwick](https://github.com/jamesdh/)).
