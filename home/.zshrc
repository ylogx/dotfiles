#################
### Oh My Zsh ###
#################
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(
#    #zsh-completions
#    #zsh-syntax-highlighting
#    )

# User configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
# paths at bottom of file
# export MANPATH="/usr/local/man:$MANPATH"
### source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
##################################################################


###############
### Antigen ###
###############
#source ~/bin/antigen.zsh
source /usr/local/share/antigen/antigen.zsh # brew install antigen

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
#antigen bundle git
#antigen bundle heroku
#antigen bundle pip
#antigen bundle lein
#antigen bundle command-not-found

antigen bundle brew
#antigen bundle chruby
antigen bundle chucknorris
antigen bundle docker
antigen bundle docker-compose
#antigen bundle fortune
antigen bundle git
antigen bundle git-extras
antigen bundle github
antigen bundle git-flow
antigen bundle gnu-utils
antigen bundle golang
antigen bundle gpg-agent
#antigen bundle #gradle
antigen bundle heroku
antigen bundle history-substring-search
antigen bundle jruby
antigen bundle kubectl
antigen bundle last-working-dir
#antigen bundle #lol
antigen bundle macos
antigen bundle pip
antigen bundle pylint
antigen bundle python
#antigen bundle #rails
antigen bundle rake
antigen bundle rake-fast
antigen bundle redis-cli
antigen bundle ruby
antigen bundle rust
antigen bundle sublime
antigen bundle sudo
antigen bundle ufw
antigen bundle web-search
#antigen bundle #tmux
antigen bundle yum
#antigen bundle zsh-completions
#antigen bundle zsh-syntax-highlighting
#antigen bundle zsh-wakatime
#antigen bundle jeffreytse/zsh-vi-mode

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
#antigen theme robbyrussell
# antigen theme agnoster

antigen bundle starship
# antigen theme spaceship-prompt/spaceship-prompt
#SPACESHIP_PROMPT_ORDER=(
#  time          # Time stamps section
#  user          # Username section
#  dir           # Current directory section
#  host          # Hostname section
#  git           # Git section (git_branch + git_status)
#  hg            # Mercurial section (hg_branch  + hg_status)
#  package       # Package version
#  node          # Node.js section
#  ruby          # Ruby section
#  elixir        # Elixir section
#  xcode         # Xcode section
#  swift         # Swift section
#  golang        # Go section
#  php           # PHP section
#  rust          # Rust section
#  haskell       # Haskell Stack section
#  julia         # Julia section
#  docker        # Docker section
#  aws           # Amazon Web Services section
#  venv          # virtualenv section
#  conda         # conda virtualenv section
#  pyenv         # Pyenv section
#  dotnet        # .NET section
#  ember         # Ember.js section
#  kubecontext   # Kubectl context section
#  terraform     # Terraform workspace section
#  exec_time     # Execution time
#  line_sep      # Line break
#  battery       # Battery level and status
#  vi_mode       # Vi-mode indicator
#  jobs          # Background jobs indicator
#  exit_code     # Exit code section
#  char          # Prompt character
#)

# Tell Antigen that you're done.
antigen apply
##################################################################


#########################
### Platform Specific ###
#########################
PLATFORM='Unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   PLATFORM='Linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   PLATFORM='Mac'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   PLATFORM='FreeBSD'
fi

if [ -d "$HOME/.homesick" ]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    #source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
fi
alias hs='homeshick'

if [[ $PLATFORM == 'Linux' ]]; then
    [ -d $HOME/kde/bin ] && export PATH=$PATH:$HOME/kde/bin
    [ -d ~/kde/src/kdesrc-build ] && export PATH=~/kde/src/kdesrc-build:$PATH
    #[ -d /etc/alternatives/java_sdk ] && export JAVA_HOME=/etc/alternatives/java_sdk
    [ -d $JAVA_HOME/bin ] && export PATH=$JAVA_HOME/bin:$PATH
    export ANDROID_HOME=$HOME/sdk/android-sdk
    [ -d $ANDROID_HOME/platform-tools ] && export PATH=$PATH:$ANDROID_HOME/platform-tools
    [ -d $ANDROID_HOME/tools ] && export PATH=$PATH:$ANDROID_HOME/tools
    hash xdg-open 2>/dev/null && alias open='xdg-open'
elif [[ $PLATFORM == 'Mac' ]]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    if [ "$TERM" != "dumb" ]; then
        export LS_OPTIONS='--color=auto'
    fi
    alias ls="ls $LS_OPTIONS"
    export ANDROID_HOME=$HOME/sdk/android-sdk
    [ -d $ANDROID_HOME/platform-tools ] && export PATH=$PATH:$ANDROID_HOME/platform-tools
    [ -d $ANDROID_HOME/tools ] && export PATH=$PATH:$ANDROID_HOME/tools
    [ -d /usr/local/opt/coreutils/libexec/gnubin ] && export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
    [ -d /usr/local/opt/coreutils/libexec/gnubin ] && export PATH=$PATH:/usr/local/opt/go/libexec/bin
    [ -d /usr/local/opt/gnu-sed/libexec/gnubin ] && export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
    [ -d /usr/local/share/npm/bin ] && export PATH="/usr/local/share/npm/bin:$PATH"
    [ -d /usr/local/opt/coreutils/libexec/gnuman ] && export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
    #export JAVA_HOME=`/usr/libexec/java_home`
    #export IDEA_HOME=$JAVA_HOME
    #export PATH=$JAVA_HOME/bin:$PATH
fi
##################################################################

###################
### Executables ###
###################
[ -d $HOME/bin ] && export PATH=$HOME/bin:$PATH
[ -d $HOME/.local/bin ] && export PATH=$PATH:$HOME/.local/bin

#export PATH="/usr/local/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH=$HOME/.local/bin:$PATH
[ -d "/usr/local/sbin" ] && export PATH=/usr/local/sbin:$PATH
##################################################################

###############################
### SSH Agent and GPG Agent ###
###############################
#eval "$(ssh-agent)" > /dev/null    # Naive approach, leaves a lot of orphan agents
add_ssh_agent_safely() {
  if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    echo "If you want to disable adding ssh key to agent, disable this block"
    eval "$(ssh-agent)" > /dev/null
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
  fi
  export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
  ssh-add -l > /dev/null || ssh-add
}
# Using gpg-agent to work as ssh-agent. See below where we export $SSH_AUTH_SOCK created by gpg-agent
#add_ssh_agent_safely

fresh_gpg_agent() {
  eval $(gpg-agent --daemon --enable-ssh-support --sh --use-standard-socket --write-env-file $GPG_AGENT_INFO_FILENAME &> /dev/null)
  touch $GPG_AGENT_INFO_FILENAME
}

add_gpg_agent_safely() {
  #export GPG_TTY=$(tty)
  # Following file will be created by gpg-agent plugin of oh my zsh
  GPG_AGENT_INFO_FILENAME=${HOME}/.gnupg/gpg-agent.env
  if [ ! -f "$GPG_AGENT_INFO_FILENAME" ]; then
    fresh_gpg_agent
  fi

  #. $GPG_AGENT_INFO_FILENAME
  #if [ ! -S "$SSH_AUTH_SOCK" ]; then
    #fresh_gpg_agent
  #fi
  #. $GPG_AGENT_INFO_FILENAME
  #export GPG_AGENT_INFO
  #export SSH_AUTH_SOCK
  #export SSH_AGENT_PID
}
if [ -f "$HOME/.gnupg" ]; then
  add_gpg_agent_safely
fi

if [ -S "$SSH_AUTH_SOCK" ]; then
  ssh-add -l > /dev/null || ssh-add
fi
##################################################################


#########################
### Software Specific ###
#########################
#Hierarchy Viewer Variable
export ANDROID_HVPROTO=ddm

export EDITOR=vi
export VISUAL=vi

### Added by the Heroku Toolbelt
[ -d '/usr/local/heroku/bin' ] && export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

[ -d "$HOME/Library/Python/3.7/bin" ] && export PATH="$HOME/Library/Python/3.7/bin":$PATH
[ -d "$HOME/.pyenv" ] && export PATH="$HOME/.pyenv/bin:$PATH";
if which pyenv > /dev/null; then eval "$(pyenv init -)"; eval "$(pyenv virtualenv-init -)"; fi

# The next line enables shell command completion for gcloud.
#if [ -f ~/google-cloud-sdk/completion.zsh.inc ]; then
  #source '~/google-cloud-sdk/completion.zsh.inc'
#fi

# added by Anaconda3 4.2.0 installer
[ -d "/opt/anaconda3/bin" ] && export PATH="/opt/anaconda3/bin:$PATH"
[ -d "/opt/node-v4.2.1-linux-x64/bin/" ] && export PATH="/opt/node-v4.2.1-linux-x64/bin/:$PATH"
[ -d "/usr/local/opt/node@8/bin" ] && export PATH="/usr/local/opt/node@8/bin:$PATH"

# Cuda
[ -d "/usr/local/cuda/bin" ] && export PATH=/usr/local/cuda/bin:$PATH
[ -d "/usr/local/cuda/lib64" ] && export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

export GOPATH="$HOME/.cache/go"
[ -d "$GOPATH/bin" ] && export PATH="$GOPATH/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.pub-cache/bin" ] && export PATH="$PATH":"$HOME/.pub-cache/bin"

hash thefuck 2>/dev/null && eval $(thefuck --alias)

#export PATH="/usr/local/opt/ruby/bin:$PATH"
#source /usr/local/share/chruby/chruby.sh
#source /usr/local/share/chruby/auto.sh
#chruby 2.2.4
#export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/sdk/google-cloud-sdk/path.zsh.inc' ]; then . '~/sdk/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '~/sdk/google-cloud-sdk/completion.zsh.inc' ]; then . '~/sdk/google-cloud-sdk/completion.zsh.inc'; fi

### FZF ###
# To install useful key bindings and fuzzy completion:
# $(brew --prefix)/opt/fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
#export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || rg --files || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'
export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || rg --files || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'
export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || rg --files --no-ignore --hidden --follow --glob "!.git/*" || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'
export FZF_DEFAULT_COMMAND='(rg --files --no-ignore --hidden --follow --glob "!.git/*" || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'
export FZF_DEFAULT_COMMAND='(rg --files || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

[ -d /home/linuxbrew/.linuxbrew/bin ] && export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

load_conda() {
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
          . "/usr/local/anaconda3/etc/profile.d/conda.sh"
      else
          export PATH="/usr/local/anaconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
}
#################################################################

###############
### Aliases ###
###############
load_aliases() {
  if [ -f ~/.zsh_aliases ]; then
      . ~/.zsh_aliases
  elif [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
  fi

  if [ -f ~/.zsh_functions ]; then
      . ~/.zsh_functions
  fi
  if [ -f ~/.bash_functions ]; then
      . ~/.bash_functions
  fi
}
load_aliases # Doing this at the end, so that $PATH is properly filled
#################################################################


###########################
### Welcome to home! <3 ###
###########################
type welcome_message >/dev/null && welcome_message
