if status is-interactive
    # Source shared environment via bass (POSIX -> fish bridge)
    if type -q bass
        bass source ~/.config/shell/env.sh
        bass source ~/.bash_aliases 2>/dev/null
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

    # Welcome message
    if type -q figlet
        figlet "Welcome, " $USER
    end
end
