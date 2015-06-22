function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '%(!.!.➜)'
}

function prompt_char_with_return {
    git branch >/dev/null 2>/dev/null && print_with_return '±' && return
    hg root >/dev/null 2>/dev/null && print_with_return '☿' && return
    # echo '%(!.!.➜)'
    print_with_return '➜'
}

function print_with_return {
    echo "%(?:%{$fg_bold[green]%}$1:%{$fg_bold[red]%}$1%s)"
}


function parse_hg_dirty {
  if [[ -n $(hg status -mard . 2> /dev/null) ]]; then
    echo "$ZSH_THEME_HG_PROMPT_DIRTY"
  fi
}

function get_RAM {
  free -m | awk '{if (NR==3) print $4}' | xargs -i echo 'scale=1;{}/1000' | bc
}

function get_nr_jobs() {
  jobs | wc -l
}

function get_nr_CPUs() {
  grep -c "^processor" /proc/cpuinfo
}

function get_load() {
  uptime | awk '{print $11}' | tr ',' ' '
}
local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"

# PROMPT='%{$fg_bold[green]%}%n@%m %{$fg[cyan]%}%2c %{$fg_bold[blue]%}$(git_prompt_info)$(parse_hg_dirty)%{$fg_bold[blue]%} %{$fg_bold[red]%}$(prompt_char) % %{$reset_color%}'
# PROMPT='${ret_status}%{$fg_bold[cyan]%}%2c %{$fg_bold[blue]%}$(git_prompt_info)$(parse_hg_dirty)%{$fg_bold[blue]%} %{$fg_bold[red]%}$(prompt_char) % %{$reset_color%}'
PROMPT='%{$fg_bold[cyan]%}%2c %{$fg_bold[blue]%}$(git_prompt_info)$(parse_hg_dirty)%{$fg_bold[blue]%} %{$fg_bold[red]%}$(prompt_char_with_return) % %{$reset_color%}'

RPROMPT='%{$fg_bold[red]%}[$(get_nr_jobs), $(get_RAM)G, $(get_load)($(get_nr_CPUs))] %{$fg_bold[green]%}%*%{$reset_color%}'

ZSH_THEME_HG_PROMPT_PREFIX="hg:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY="%{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
