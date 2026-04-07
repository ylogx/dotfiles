# Dot Files

## Automated Installation

Run the following command and relax

```bash
curl -sL shubham.chaudhary.xyz/dotfiles | bash
```

See [chaudhary.xyz/dotfiles](http://shubham.chaudhary.xyz/dotfiles) for more info. For manual installation please read the instructions from [wiki](https://github.com/ylogx/dotfiles/wiki/Manual-Installation)

## Updating dotfiles

Dotfiles are managed by [chezmoi](https://chezmoi.io). To update:

```sh
cd ~/.homesick/repos/dotfiles && git pull
chezmoi apply
```

## Adding or editing dotfiles

```sh
chezmoi edit ~/.zshrc       # edit a dotfile
chezmoi add ~/.newconfig    # track a new file
chezmoi diff                # preview changes before applying
chezmoi apply               # deploy to ~
```
