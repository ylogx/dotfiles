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

## Migrating from homeshick

If you were using the old homeshick setup (`~/.homesick/repos/dotfiles`), run:

```bash
cd ~/.homesick/repos/dotfiles && git pull
./install.sh
```

This will automatically:
1. Remove old homeshick symlinks
2. Move the repo to `~/.dotfiles`
3. Install chezmoi
4. Apply all dotfiles

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
