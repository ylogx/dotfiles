# vim: set filetype=shell
## FUNCTIONS
check_and_run() {
    if hash $1 2>/dev/null; then
        "$@"
    fi
}
check_and_run_bg() {
    if hash $1 2>/dev/null; then
        ( "$@" & )  #parens help it run in subshell so that "Done" msg is not printed
    fi
}
welcome() {
    #------------------------------------------
    #------WELCOME MESSAGE---------------------
    # customize this first message with a message of your choice.
    # this will display the username, date, time, a calendar, the amount of users, and the up time.
    # clear
    # Gotta love ASCII art with figlet
    check_and_run figlet "Welcome, " $USER;     #toilet "Welcome, " $USER;
    echo -e ""; cal ;
    echo -ne "Today is "; date #date +"Today is %A %D, and it is now %R"
    if [[ `date +"%d%m"` == 0101 ]]; then       #if [[ `date +"%D"` =~ 01/01* ]];
        echo "Hey man, I forgot"; figlet "Happy New Year"; echo "$USER";
    elif [[ `date +"%d%m"` == 2603 ]]; then
        figlet "Happy Birthday"
    fi;
    echo -e "Status of $HOSTNAME: " 

    echo -en "\t";
    free -ht | head -3 | tail -n 1 | awk '{printf "Main Memory\t:\t" $3 " used & " $4 " free"}'
    #free --old -ht | head -2 | tail -n 1 | awk '{printf " out of " $2}'; echo "";

    echo -en "\t"; df -h / | tail -n 1 | awk '{print "Root " $1 "\t:\t" $5 " full & " $4 " still available."}' ; 

    echo -en "\tIP Address \t:\t"; /sbin/ifconfig wlp3s0 | awk /'inet / {print $2}' | sed -e s/addr:/''/  || /sbin/ifconfig wlan0 || echo "" #dubious, gotta test

    echo -en "\tThe system has been up for ";
    perl -e 'my $uptime = `uptime`; if ($uptime =~ /^\s+\S+\s+up\s+(\S+\s+\S+,\s+\S+),/) { printf $1; } else { print "uptime gave me a weird format!"; }'
#     echo -e "" #echo -ne "Up time:"; uptime | awk /'up/' #`uptime | awk {'print $3 $4'}`
    echo "";
#     check_and_run_bg ansiweather;
}
welcome;

# get IP adresses
#function my_ip() # get IP adresses
my_ip () { 
        MY_IP=$(/sbin/ifconfig wlan0 | awk "/inet/ { print $2 } " | sed -e s/addr://)
                #/sbin/ifconfig | awk /'inet addr/ {print $2}' 
        MY_ISP=$(/sbin/ifconfig wlan0 | awk "/P-t-P/ { print $3 } " | sed -e s/P-t-P://)
}

# get current host related info
ii () {
    echo -e "\nYou are logged on ${red}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${red}Users logged on:$NC " ; w -h
    echo -e "\n${red}Current date :$NC " ; date
    echo -e "\n${red}Machine stats :$NC " ; uptime
    echo -e "\n${red}Memory stats :$NC " ; free
    echo -en "\n${red}Local IP Address :$NC" ; /sbin/ifconfig wlan0 | awk /'inet addr/ {print $2}' | sed -e s/addr:/' '/ 
    #my_ip 2>&. ;
    #my_ip 2>&1 ;
    #echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:."Not connected"}
    #echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:."Not connected"}
    #echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP} #:."Not connected"}
    #echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP} #:."Not connected"}
    echo
}


# Easy extract
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

upinfo () {
echo -ne "${green}$HOSTNAME ${red}uptime is ${cyan} \t ";uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}

# Makes directory then moves into it
#function mkcdr {
mkcdr () {
    mkdir -p -v $1
    cd $1
}

function countdown(){
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ne `date +%s` ]; do 
     echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
   done
}
function stopwatch(){
  date1=`date +%s`; 
   while true; do 
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
   done
}
# vim: set ft=shell:

