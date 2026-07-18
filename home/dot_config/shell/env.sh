# Shared environment variables — POSIX sh compatible
# Sourced by: .zshenv, .bashrc, .profile, fish (via bass)

# XDG Base Directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Editor: prefer nvim when installed, fall back to vim otherwise
if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim
    export VISUAL=nvim
else
    export EDITOR=vim
    export VISUAL=vim
fi

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Go
export GOPATH="$HOME/.cache/go"

# FZF
export FZF_DEFAULT_COMMAND='(rg --files || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'

# Android SDK
export ANDROID_HOME="$HOME/sdk/android-sdk"
[ -d "$ANDROID_HOME/platform-tools" ] && PATH="$PATH:$ANDROID_HOME/platform-tools"
[ -d "$ANDROID_HOME/tools" ] && PATH="$PATH:$ANDROID_HOME/tools"

# Core PATH additions
[ -d "/usr/local/bin" ] && PATH="/usr/local/bin:$PATH"
[ -d "/usr/local/sbin" ] && PATH="/usr/local/sbin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$GOPATH/bin" ] && PATH="$GOPATH/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.pub-cache/bin" ] && PATH="$PATH:$HOME/.pub-cache/bin"
[ -d "$HOME/.pyenv/bin" ] && PATH="$HOME/.pyenv/bin:$PATH"
# Heroku's own standalone installer (not a Homebrew formula), historically
# Intel-only at /usr/local/heroku; checked defensively in case that changes.
[ -d "/usr/local/heroku/bin" ] && PATH="/usr/local/heroku/bin:$PATH"
[ -d "/opt/homebrew/heroku/bin" ] && PATH="/opt/homebrew/heroku/bin:$PATH"
export PATH
