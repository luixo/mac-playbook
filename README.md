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

Some settings apply only after restart

### Connecting to backup source

There are several options to get initial backup files to the laptop

- Get dotfiles backup from previous laptop (if available)
- Get dotfiles from NAS (if available)
- Get dotfiles from Yandex S3 (if available)
- Get dotfiles from Scaleway S3

Getting restic backup from NAS requires:

```
export RESTIC_REPOSITORY=sftp:nas:/mnt/user/backups
```

Getting restic backup from Yandex S3 requires:

```
export RESTIC_REPOSITORY=s3://storage.yandexcloud.net/luixo-backups
export AWS_ACCESS_KEY_ID=${YA_AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${YA_AWS_SECRET_ACCESS_KEY}
```

Getting restic backup from Scaleway S3 requires:

```
export RESTIC_REPOSITORY=s3://s3.fr-par.scw.cloud/luixo-archive/restic
export AWS_ACCESS_KEY_ID=${SCW_AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${SCW_AWS_SECRET_ACCESS_KEY}
```

### Backup restoration

1. Restore latest dotFiles snapshot from a given source

```
~/.local/share/backrest/restic restore latest --tag 'plan:dotFiles' --target /tmp/restored --include '/Users/luixo/.config/backrest'
mv -f /tmp/restored/Users/luixo/.config/backrest/* ~/.config/backrest/
rm -r /tmp/restored`
```

1. Restart Backrest: `brew services restart backrest`
1. Go to [Backrest](http://localhost:9898/) UI
1. Restore everything else (`dotFiles` needed, `git`, `documents`)
1. Look through `~/.downloads-list` for missing files and act accordingly

### Password manager

1. Copy over `~/Library/Application Support/Arc/User Data` to original folder
1. Open Arc, authorize, enable sync (via Arc sync) & add Bitwarden extension
1. Authorize in Bitwarden, proceed with auth from there

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
  - add extensions: Adguard
  - set auto-archive to 30 days
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
- Manual dock / widget / launchpad restoration (with lporg.yaml hints) until alternative to lporg is found

### Follow-up for next restorations

- Compare changes made to `roles/apps/files` with files from `~`.

## Cleaning up old Mac

Follow Apple's guide [here](https://support.apple.com/en-au/HT212749)

## Credentials

This project was created by (and for) [luixo](https://github.com/luixo) (inspired by [Jeff Geerling](https://github.com/geerlingguy/) and [James Hardwick](https://github.com/jamesdh/)).
