# Dot Files

## Automated Installation

Run the following command and relax

```bash
curl -sL shubham.chaudhary.xyz/dotfiles | bash
```

Or directly with chezmoi:

```bash
chezmoi init --apply ylogx
```

## Coming from the old homeshick setup

The old homeshick symlinks and legacy files are cleaned up automatically by
chezmoi on first apply (see `home/.chezmoiremove.tmpl`) — just run the
install command above on the new machine; nothing else is needed.

## Updating dotfiles

```sh
cd ~/.dotfiles && git pull
chezmoi apply
```

## Adding or editing dotfiles

```sh
chezmoi edit ~/.zshrc       # edit a dotfile
chezmoi add ~/.newconfig    # track a new file
chezmoi diff                # preview changes before applying
chezmoi apply               # deploy to ~
```
