#export SHELL=`which zsh`
#[ -z "$ZSH_VERSION" ] && exec $SHELL -l #NOTE: Executes zsh if available
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi

if [ -x /usr/libexec/path_helper ]; then
	eval `/usr/libexec/path_helper -s`
fi

if [ "${BASH-no}" != "no" ]; then
	[ -r /etc/bashrc ] && . /etc/bashrc
fi

# FIXME: add checks

source ~/.bashrc
[ -d $HOME/android-sdk/platform-tools ] && export PATH=$PATH:$HOME/android-sdk/platform-tools
[ -d $HOME/android-sdk/tools ] && export PATH=$PATH:$HOME/android-sdk/tools
#Hierarchy Viewer Variable 
export ANDROID_HVPROTO=ddm
[ -d $HOME/phabricator/arcanist/bin ] && export PATH=$PATH:$HOME/phabricator/arcanist/bin
