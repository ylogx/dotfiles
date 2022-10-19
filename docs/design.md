# Dotfiles Design

## Planned Changes

### Installation

- [ ] Single installation script
- [ ] Minimal installation dependency
- [ ] Repeatability in docker

### Config

#### ZSH

- [ ] Clean up zshrc.
  - There are a lot of pre-built tools now to manage plugins.

#### Vim

- [ ] Vim plugin install is super slow and buggy
- [ ] Simplify vim plugins.
  - Many of them are no longer needed with newere tools like IntelliJ IDEA and VS Code.
- [ ] Move Vim/plugin manager from Vundle to SpaceVim


### CI/CD

#### Docker

- [x] Disable vim plugin to fix broken CI/CD pipeline
- [ ] Create a non-root user for testing in Docker image
- [ ] Docker image should start with powerline oh-my-zsh, it starts with empty zsh
