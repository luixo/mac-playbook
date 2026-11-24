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
# Bootstrap (wait for sudo password prompt); if it fails on sudo error, run `sudo echo 1` and re-run script afterwards
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

1. Run `~/.scripts/.restore.sh <target>` to run base restoration process (target can be: `nas` or `scaleway`)
1. Move files from `~/Downloads/restored` to proper places
1. Reboot

### Password manager

1. Copy over `~/Library/Application Support/Dia/User Data` to original folder
1. Open Dia, authorize, enable sync & add Bitwarden extension
1. Authorize in Bitwarden, proceed with auth from there

### Manual tasks

Authorize in:

- Dia
- VSCode (through "enable settings sync")
- DataGrip
- Notion
- Todoist
- Telegram
- Docker

Misc:

- Touch ID: add more fingerprints (left & right index & right thumb)
- Dia
  - add extensions: Adguard
- Apple locator: register
- Bitwarden settings:
  - autocomplete
    - turn off browser autocomplete
- Telegram options
  - emoji -> sticker packs -> Suggest stickers: None
  - general -> interface: Contacts tab, Calls tab, status bar item and chat previews all off
  - appearance -> text size: 3rd marker (13 pt on the 11–18 pt scale)
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
