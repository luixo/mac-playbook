# Mac bootstrap Ansible playbook

This playbook bootstraps a fresh Mac to be ready for my personal usage.

## Installation

1. Run MacOS install wizard and login to iCloud & App Store.
1. Run `sudo source <(curl -s https://raw.githubusercontent.com/luixo/mac-playbook/main/bootstrap.sh)`.

## If old machine is not available

Get data from Arq backup:

- Transfer `~/git` (probably skip some repos in `~/git/open-source`) to a new machine.
- Transfer `~/Documents` to a new machine.
- Transfer (what's needed) `~/Downloads` to a new machine.

## If old machine is available

- Get the same data, but from an old machine.
- Compare changes made to `roles/apps/files` with files from `~`.

## Manual tasks

- Arc: authorize, set as default browser, enable sync, add extensions: AdBlock, Bitwarden (auth), React Devtools
- VSCode: authorize, enable settings sync
- DataGrip: authorize
- Whisky: download GTPK
- Outline Manager: authorize (git algo configs dir contains credentials, connect and run `cat /opt/outline/access.txt` to get keys)
- Outline: add tunnels from Outline Manager
- Wireguard: add tunnels from algo git directory
- Arq: adopt a backup set, create a new backup plan
- Notion: authorize
- Todoist: authorize
- Slack: authorize
- Ableton: disable automatic update and generate Authorize.auz
- Telegram: authorize, "emoji -> turn off 'suggest'", "general -> emoji -> turn off 'emoji autoreplace'" and "general -> interface -> all off", "sound -> off", "send messages as cmd+enter"
- Ngrok: authorize (get token from website) # ngrok config add-authtoken <TOKEN>
- Docker: Y.Cloud auth (token from here: https://yandex.cloud/ru/docs/container-registry/operations/authentication#user-oauth)
- Change screenshots path (cmd + shift + 5 -> choose path)
- Touch ID - add more fingerprints
- Open any folder, set "icons" view, cmd+J, use "snap to grid", set "sort by name", click "set as default"
- Ledger Live: authorize

## Cleaning up old Mac

Follow Apple's guide [here](https://support.apple.com/en-au/HT212749)

## Credentials

This project was created by (and for) [luixo](https://github.com/luixo) (inspired by [Jeff Geerling](https://github.com/geerlingguy/) and [James Hardwick](https://github.com/jamesdh/)).
