#alias cdbuild='cd /home/chaudhary/code/linux/kmix/build'
#alias cdsrc='cd /home/chaudhary/code/linux/kmix/qmpris'
#alias cdkg='cd /home/chaudhary/code/linux/kmix/github'
alias cdde='cd /home/chaudhary/code/linux/kmix/demo/demo'
alias cdqm='cd /home/chaudhary/code/linux/kmix/qmpris'

##Juk project
alias cdjuk='cd /home/chaudhary/code/linux/juk'
alias cdbuild='cd /home/chaudhary/code/linux/juk/build'
alias mymakejuk='mkdir build; cd ./build && rm -rfv ./*; cmake -DCMAKE_BUILD_PREFIX=$HOME/kde -DCMAKE_BUILD_TYPE=debugfull -DCMAKE_INSTALL_PREFIX=$HOME/kde ../ ; make'
alias cdlm='cd ~/code/android/studioWorkspace/LazyMusic'
alias cdlms='cd ~/code/android/studioWorkspace/LazyMusic/app/src/main/java/com/peplet/lazymusic'
alias cdlmr='cd ~/code/android/studioWorkspace/LazyMusic/app/src/main/res'
alias cdlo='cd ~/code/android/studioWorkspace/LogMeIn'
alias cdlos='cd ~/code/android/studioWorkspace/LogMeIn/app/src/main/java/in/shubhamchaudhary/logmein'

#diff-lines() {
    #local path=
    #local line=
    #while read; do
        #esc=$'\033'
        #if [[ $REPLY =~ ---\ (a/)?.* ]]; then
            #continue
        #elif [[ $REPLY =~ \+\+\+\ (b/)?([^[:blank:]$esc]+).* ]]; then
            #path=${BASH_REMATCH[2]}
        #elif [[ $REPLY =~ @@\ -[0-9]+(,[0-9]+)?\ \+([0-9]+)(,[0-9]+)?\ @@.* ]]; then
            #line=${BASH_REMATCH[2]}
        #elif [[ $REPLY =~ ^($esc\[[0-9;]+m)*([\ +-]) ]]; then
            #echo "$path:$line:$REPLY"
            #if [[ ${BASH_REMATCH[2]} != - ]]; then
                #((line++))
            #fi
        #fi
    #done
#}
