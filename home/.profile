
if [ -x /usr/libexec/path_helper ]; then
	eval `/usr/libexec/path_helper -s`
fi

if [ "${BASH-no}" != "no" ]; then
	[ -r /etc/bashrc ] && . /etc/bashrc
fi

# FIXME: add checks

source ~/.bashrc
export PATH=$PATH:~/android-sdk/platform-tools
export PATH=$PATH:~/android-sdk/tools
