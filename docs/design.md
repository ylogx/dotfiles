# Dotfiles Design

## Planned Changes

### Installation

- [ ] Single installation script
- [ ] Minimal installation dependency
- [ ] Repeatability in docker

### Config

#### ZSH
- [x] Clean up zshrc.
  - There are a lot of pre-built tools now to manage plugins.
- [x] Use antigen to install oh-my-zsh
- [x] Use starship.rs as command line prompt
- [ ] Customize starship.rs more using the toml config file.


#### Vim

- [ ] Vim plugin install is super slow and buggy
  - One of the solution is to use: vim-plug.
- [ ] Move Vim/plugin manager from Vundle to SpaceVim
- [ ] Simplify vim plugins.
  - Many of them are no longer needed with newer tools like IntelliJ IDEA and VS Code.


### CI/CD
- [ ] Optimize Dockerfile.
  - Use lighter image. CI is really slow because it is pulling huge a whole ubuntu image.
  - Build incrementally. Don't do operations that haven't changed in diff.
  - Test using unit tests or something more local than docker build.

#### Docker

- [x] Disable vim plugin to fix broken CI/CD pipeline
- [ ] Create a non-root user for testing in Docker image
- [ ] Docker image should start with powerline oh-my-zsh, it starts with empty zsh
