# Source shared aliases and functions (also used by bash)
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_functions ] && . ~/.bash_functions

# Zsh-specific aliases
alias reload='reset; source ~/.zshrc'
alias reloads='source ~/.zshrc &> /dev/null'

# Suffix aliases (open file type with vim)
alias -s java=vim
alias -s c=vim
alias -s cpp=vim
