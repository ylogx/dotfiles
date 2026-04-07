# Source shared aliases and functions (also used by bash and fish)
[ -f ~/.shell_aliases ] && . ~/.shell_aliases
[ -f ~/.shell_functions ] && . ~/.shell_functions

# Zsh-specific overrides
alias reload='reset; source ~/.zshrc'
alias reloads='source ~/.zshrc &> /dev/null'

# Suffix aliases (open file type with vim)
alias -s java=vim
alias -s c=vim
alias -s cpp=vim
