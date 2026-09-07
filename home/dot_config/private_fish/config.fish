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

    ##############
    ### Aliases ##
    ##############
    # Ported from ~/.shell_aliases (the shared file doesn't load in fish).
    # ls flags are BSD-compatible — fish config is macOS-only.
    if type -q eza
        alias l 'eza -lsnew'
    else
        alias l 'ls -ltr'
    end
    alias la 'ls -lAtrFhH'
    alias ll 'ls -alF'
    alias lsd "ls -l | grep '^d'"
    alias cm chezmoi
    alias cl clear
    alias p pwd
    alias d date
    alias g git
    alias py python3
    alias serve 'python3 -m http.server'
    if type -q tree
        alias t 'tree -Csh'
        alias t2 'tree -Csh -L 2'
    end
    if type -q tmux
        alias ta 'tmux attach'
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

    # FZF key bindings (the only registration — do NOT also define
    # fish_user_key_bindings with fzf_key_bindings, that double-binds)
    if type -q fzf
        fzf --fish 2>/dev/null | source
    end

    # Welcome message — same cached output as bash/zsh (figlet + status
    # panel), rendered through bass so print_system_status_fast runs
    if type -q bass
        bass 'source ~/.shell_functions && welcome_message'
    else if type -q figlet
        figlet "Welcome, " $USER
    end
end
