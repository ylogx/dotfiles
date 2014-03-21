alias myhistory='cat ~/bashbackup.txt'
alias l='d; ls -ltrFhH'
alias la='d; ls -latrFhH'
alias proxy='cat -n /etc/apt/apt.conf'
#alias proxyNone='sudo sh -c \'echo -n "" > /etc/apt/apt.conf\''
alias proxyUiet='sudo cp /etc/apt/aptUiet.conf /etc/apt/apt.conf'
#alias c='chaudhary.sh'    #the c c++ compilation script in /usr/games
alias d='date'
alias dfh='df -h'
alias ack='ack-grep'
alias cd..='cd ..'
alias aria2cm='aria2c -c -x 16'
alias a='aria2c -c -x 16'
#alias cmk='mkdir $1 && cd ./$1'
alias mymakehere='cp /home/chaudhary/Makefile ./'

alias cdsfd='cd ~/open/sfd'
alias cdop='cd ~/open'
alias cdsok='cd ~/open/sok'
alias cdd='cd ~/code'
alias cdai='cd ~/code/ai'
alias cdal='cd ~/code/algo/'
alias cdc='cd ~/code/c'
alias cdcpp='cd ~/code/cpp/'
alias cdcdp='cd ~/code/codpro'
alias cdcf='cd ~/code/codpro/chef'
alias cdfor='cd ~/code/codpro/forces'
alias cdds='cd ~/code/ds/dshome/dsadv'
alias cdk='cd ~/code/linux/kdevelop'
alias cdkde='cd ~/kde/'
alias cdke='cd ~/kernel'
alias cdkc='cd ~/code/linux/kdev-clang'
alias cdkp='cd ~/code/linux/kdevplatform'
alias cdpi='cd ~/code/pi'
alias cdre='cd ~/code/ds/dshome/revision'
alias cdht='cd ~/code/html'
alias cdja='cd ~/code/java/'
alias cdli='cd ~/code/linux'
alias cdos='cd ~/code/os/'
alias cdpy='cd ~/code/python'
alias cdqt='cd ~/code/qt'
alias cdsc='cd ~/code/scripts'
alias cdu='cd ~/code/scripts/universal'
alias cdtor='cd /home/chaudhary/kernel/git_linux_repo/linux_torvalds'

alias cddw='cd ~/Downloads/Web.July13'
alias cdv='cd ~/gre/vocab'
alias cdp='cd ~/Videos/Link\ to\ asdf_files'

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

#alias acki='ack --ignore-dir=build' 
alias acki='ack --ignore-dir=build --ignore-dir=doc' 
