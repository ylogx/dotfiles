# Shared environment variables — POSIX sh compatible
# Sourced by: .zshenv, .bashrc, .profile, fish (via bass)

# Idempotence guard: several shells source this file more than once per
# session (.zshenv + 03-path.zsh, .profile + .bashrc) — nested shells only
# run the innermost source, so make re-sourcing a no-op instead of
# duplicating every PATH entry.
if [ -n "${_SHELL_ENV_SOURCED:-}" ]; then
    return 0 2>/dev/null || exit 0
fi
_SHELL_ENV_SOURCED=1

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

# GPG: tell gpg-agent which terminal owns this shell, so its (possibly
# TTY-based) pinentry can prompt in the right place instead of failing
# and re-prompting.
GPG_TTY=$(tty)
export GPG_TTY

# Go
export GOPATH="$HOME/.cache/go"

# FZF (hidden files included to match the interactive `rg --hidden` alias)
export FZF_DEFAULT_COMMAND='(rg --files --hidden --glob "!.git" || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'

# Android SDK (Homebrew layout; Apple Silicon path first, Intel fallback)
if [ -d "/opt/homebrew/share/android-commandlinetools" ]; then
    export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
elif [ -d "/usr/local/share/android-commandlinetools" ]; then
    export ANDROID_HOME="/usr/local/share/android-commandlinetools"
fi
[ -n "${ANDROID_HOME:-}" ] && export ANDROID_SDK_ROOT="$ANDROID_HOME"
[ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ] && PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
[ -d "$ANDROID_HOME/platform-tools" ] && PATH="$PATH:$ANDROID_HOME/platform-tools"

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
[ -d "$HOME/.rd/bin" ] && PATH="$HOME/.rd/bin:$PATH"
export PATH
