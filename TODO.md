# More info

- Read dotfiles: https://github.com/mathiasbynens/dotfiles/, https://wilsonmar.github.io/dotfiles/

# One-time tasks

- fix current repo (mac-playbook) origin (from https to ssh)
- GPG: run `echo "test" | gpg --clearsign` to sign in into GPG

# Launchpad + Dock

- https://github.com/blacktop/lporg - launchpad organization from .yml
- maybe https://github.com/kcrawford/dockutil (+ dock folders)

# Defaults:

- Trackpad: touch to click
- Finder: snap to grid automatically
- Keyboards are not set for some reason
- Battery percent is still now shown

# Actually TODO:

- Separate task for copying all .local.env files from all repos, cipher them with ansible-vault, encode instructions (for planned migration) and copy-over task generally
- Fetch "solarized theme" https://gist.github.com/kevin-smets/8568070 and import it to iterm2
- Transfer `com.googlecode.iterm2.plist` from current iterm2 to the next one
- Transfer profile from current iterm2 to the next one
- Transfer `~/Library/Application Support/Arc/User Data` dir
- Open locator and let it know the location

# Check next time:

- is "code" callable from zsh or should we run "install 'code' command in PATH" in VSCode?
