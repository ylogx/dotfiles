if status is-interactive
    # Source shared environment via bass (POSIX -> fish bridge)
    # Note: bass only diffs exported env vars/functions from the bash
    # subprocess, not aliases, so ~/.shell_aliases doesn't come across this
    # way — fish aliases are defined natively below instead.
    if type -q bass
        bass source ~/.config/shell/env.sh
    end

    # Editor aliases (prefer nvim when installed)
    if type -q nvim
        alias vim nvim
        alias vi nvim
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
