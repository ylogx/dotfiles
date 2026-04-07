if status is-interactive
    # Source shared environment via bass (POSIX -> fish bridge)
    if type -q bass
        bass source ~/.config/shell/env.sh
    end

    # Starship prompt
    if type -q starship
        starship init fish | source
    end

    # Zoxide
    if type -q zoxide
        zoxide init fish | source
    end

    # Direnv
    if type -q direnv
        direnv hook fish | source
    end

    # FZF key bindings
    if type -q fzf
        fzf --fish 2>/dev/null | source
    end

    # Common aliases (subset of .bash_aliases that work in fish)
    alias ll 'ls -alF'
    alias la 'ls -lAtrFhH'
    alias cl 'clear'
    alias g 'git'
    alias d 'date'
    alias p 'pwd'
    alias py 'python3'
    alias rm 'rm -v'
    alias df 'df -h'
    alias du 'du -h -c'
    alias serve 'python3 -m http.server'

    if type -q eza
        alias l 'eza -lsnew'
    else
        alias l 'ls -ltrFhH'
    end

    if type -q bat
        alias c 'bat'
    end

    # Welcome message
    if type -q figlet
        figlet "Welcome, " $USER
    end
end
