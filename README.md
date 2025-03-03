# Mac bootstrap Ansible playbook

This playbook bootstraps a fresh Mac to be ready for my personal usage.

## Prerequisites

1. Run MacOS install wizard
1. Login to iCloud
1. Login into [Bitwarden Vault](https://vault.bitwarden.com/#/settings/security/security-keys) to obtain an API key
1. Add Terminal app to Settings -> Privacy and Security -> Full Disk Access

## Installation

```sh
# Bootstrap
source <(curl -s https://raw.githubusercontent.com/luixo/mac-playbook/main/bootstrap.sh)`
# Run playbook
ansible-playbook main.yml --ask-become-pass
# (wait a bit until Bitwarden password is obtained by the playbook)
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

## Data to backup from old machine / Arq

- `~/git` (probably skip some repos in `~/git/open-source`)
- `~/Documents` / `~/Downloads` / `~/Desktop`
- Compare changes made to `roles/apps/files` with files from `~`.

## Manual tasks

### Authorize

With apps

- Arc
- VSCode (through "enable settings sync")
- DataGrip
- Amnezia (from bitwarden)
- Notion
- Todoist
- Slack
- Ableton
- Telegram
- Docker (Y.Cloud auth via [token](https://yandex.cloud/ru/docs/container-registry/operations/authentication#user-oauth))
- Ledger Live

### The rest

- Touch ID: add more fingerprints
- Wireguard: add tunnels from algo git directory
- Ableton: disable automatic update
- Arc: set as default browser, enable sync, add extensions: AdBlock, Bitwarden (auth), React Devtools
- Arq: create a new backup plan
- Arq: transfer `~/Library/Application Support/Arc/User Data` from backup
- GPG: run `echo "test" | gpg --clearsign` and type the password (from Bitwarden) to sign in into GPG
- Apple locator: register
- Telegram options
  - emoji -> turn off 'suggest'
  - general -> emoji -> turn off 'emoji autoreplace'
  - general -> interface -> all off
  - sound -> off
  - send messages as cmd+enter
  - appearance -> text size 3/7

## Cleaning up old Mac

Follow Apple's guide [here](https://support.apple.com/en-au/HT212749)

## Credentials

This project was created by (and for) [luixo](https://github.com/luixo) (inspired by [Jeff Geerling](https://github.com/geerlingguy/) and [James Hardwick](https://github.com/jamesdh/)).
