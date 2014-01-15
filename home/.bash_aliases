alias myhistory='cat ~/bashbackup.txt'
alias l='d; ls -Fhtlr'
alias proxy='cat -n /etc/apt/apt.conf'
alias proxyUiet='sudo cp /etc/apt/aptUiet.conf /etc/apt/apt.conf'
alias c='chaudhary.sh'    #the c c++ compilation script in /usr/games
alias d='date'
alias dfh='df -h'
alias ack='ack-grep'
alias cd..='cd ..'
alias aria2cm='aria2c -c -x 16'
#alias cmk='mkdir $1 && cd ./$1'
alias mymakehere='cp /home/chaudhary/Makefile ./'

alias cdsfd='cd ~/open/sfd'
alias cdop='cd ~/open'
alias cdos='cd ~/code/os/'
alias cdsok='cd ~/open/sok'
alias cdcpp='cd ~/code/cpp/'
alias cdja='cd ~/code/java/'
alias cdal='cd ~/code/algo/'
alias cdpy='cd ~/code/python'
alias cdli='cd ~/code/linux'
alias cdk='cd ~/kernel'
alias cdtor='cd /home/chaudhary/kernel/git_linux_repo/linux_torvalds'
alias cdd='cd ~/code'
alias cdc='cd ~/code/c'
alias cdcdp='cd ~/code/codpro'
alias cdcf='cd ~/code/codpro/chef'
alias cdfor='cd ~/code/codpro/forces'
alias cdqt='cd ~/code/qt'
alias cdds='cd ~/code/ds/dshome/dsadv'
alias cdre='cd ~/code/ds/dshome/revision'
alias cdsc='cd ~/code/scripts'
alias cdht='cd ~/code/html'

alias cddw='cd ~/Downloads/Web.July13'

if [ -f ~/.dev_aliases.sh ]; then
    . ~/.dev_aliases.sh
fi

#When I know the file I want to edit is the most recent file in a directory
alias vew='vi `ls -t * | head -1 `'

#When I know the file I want to edit contains a unique keyword.
#This is actually in a little shell script call ed vg where the
#keyword is passed as parameter $1

#/bin/sh
#name vg
#vi.exe $(grep -isl $1 *) &

#some variations
alias vp='vi `ls -t *.@(pl|cgi)| head -1 `'
alias vc='vi `ls -t *.@(c|cpp|h|py)| head -1 `'

#execute the most recent script (I call this from within VIM with a mapped button)
alias xew='`ls -t *.pl | head -1 `'

## Keeping things organized
#alias ls='ls --color=auto'
#alias ll='ls -l'
#alias la='ls -A'
#alias rm='mv -t ~/.local/share/Trash/files'
#alias cp='cp -i'
#alias mv='mv -i'
#alias mkdir='mkdir -p -v'
#alias df='df -h'
#alias du='du -h -c'

# some more ls aliases
#alias ls='ls -hF --color'    # add colors for filetype recognition
#alias lx='ls -lXB'        # sort by extension
#alias lk='ls -lSr'        # sort by size
#alias la='ls -Al'        # show hidden files
#alias lr='ls -lR'        # recursice ls
#alias lt='ls -ltr'        # sort by date
#alias lm='ls -al |more'        # pipe through 'more'
#alias tree='tree -Cs'        # nice alternative to 'ls'
#alias ll='ls -l'        # long listing
#alias l='ls -hF --color'    # quick listing
#alias lsize='ls --sort=size -lhr' # list by size
alias lsd='ls -l | grep "^d"'   #list only directories
alias dn='OPTIONS=$(\ls -F | grep /$); select s in $OPTIONS; do cd $PWD/$s; break;done'

alias acki='ack --ignore-dir=build' 
