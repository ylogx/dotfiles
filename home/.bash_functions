# vim: set filetype=shell
## FUNCTIONS
yolo() {
    curl -s whatthecommit.com/index.txt
}
command_exists() {
    hash $1 2>/dev/null
    return;
}
check_and_run() {
    if command_exists $1; then
        "$@"
    fi
}
check_and_run_bg() {
    if command_exists $1; then
        ( "$@" & )  #parens help it run in subshell so that "Done" msg is not printed
    fi
}

# Fuzzy find last used branch and switch to it
function fgbr() {
  local branches branch
  branches=$(git for-each-ref --sort=-committerdate refs/heads/ --format="(%(authordate:short)) %(refname:short) (%(committerdate:relative))") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
           git checkout $(echo "$branch" | sed -E 's/\(.*\) | \(.*\)$//g')
}

get_fortune_cookies() {
    if command_exists fortune; then
        echo "Fortune Cookies:";
        if command_exists cowsay; then
            fortune | cowsay
        else
            fortune
        fi;
    fi;
}

print_date_cal() {
    cal;
    echo -ne "Today is "; date
    if [[ `date +"%d%m"` == 0101 ]]; then       #if [[ `date +"%D"` =~ 01/01* ]];
        echo "Hey man, I forgot"; figlet "Happy New Year"; echo "$USER";
    elif [[ `date +"%d%m"` == 2603 ]]; then
        figlet "Happy Birthday"
    fi;
}

print_system_status_linux() {
    #echo -e "-------------------------------System Information----------------------------"
    echo "\tSystem Status"
    echo "\t============="
    echo -e "Hostname:\t\t"`hostname` "("`vserver=$(lscpu 2>/dev/null | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi`")"
    if [[ -f "/sys/class/dmi/id/chassis_vendor" ]]; then
      echo -en "Laptop:\t\t\t"`cat /sys/class/dmi/id/chassis_vendor`
      if [[ -f "/sys/class/dmi/id/product_name" ]]; then
        echo " `cat /sys/class/dmi/id/product_name`"
      else
        echo
      fi
    fi
    #echo -e "Version:\t\t"`cat /sys/class/dmi/id/product_version`
    #echo -e "Serial Number:\t\t"`cat /sys/class/dmi/id/product_serial`
    hash hostnamectl 2>/dev/null && echo -e "Operating System:\t"`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`
    echo -e "Kernel:\t\t\t"`uname -r` `arch`
    [[ -f "/proc/cpuinfo" ]] && echo -e "Processor Name:\t\t"`awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'`
    #echo -e "Active User:\t\t"`w | cut -d ' ' -f1 | grep -v USER | xargs -n1`
    echo -e "Active User:\t\t${USER}"
    echo -e "Up Since:\t\t"`uptime | awk '{print $3,$4}' | sed 's/,//'`
    echo -e "System Main IP:\t\t"`hash ipconfig 2>/dev/null && ipconfig getifaddr en0 || hostname -I`
    #echo ""
    #echo -e "-------------------------------CPU/Memory Usage------------------------------"
    if hash free 2>/dev/null; then
      echo -e "Memory Usage:\t\tMain "`free | awk '/Mem/{printf("%.2f%"), $3/$2*100}' 2>/dev/null`"%" "and Swap "`free | awk '/Swap/{printf("%.2f%"), $3/$2*100}' 2>/dev/null`"%"
      #echo -e "Swap Usage:\t\t"`free | awk '/Swap/{printf("%.2f%"), $3/$2*100}' 2>/dev/null`"%"
    fi
    [[ -f "/proc/stat" ]] && echo -e "CPU Usage:\t\t"`cat /proc/stat | awk '/cpu/{printf("%.2f%\n"), ($2+$4)*100/($2+$4+$5)}' 2>/dev/null |  awk '{print $0}' | head -1`"%"
    #echo ""
    #echo -e "-------------------------------Disk Usage >80%-------------------------------"
    #df -Ph | sed s/%//g | awk '{ if($5 > 80) print $0;}'
    #echo ""
}

print_system_status() {
    echo -e "Status of $HOSTNAME: "

    ##### Main Memory #####
    echo -en "\t";
    free -ht | head -3 | tail -n 1 | awk '{printf "Main Memory\t:\t" $3 " used & " $4 " free"}'
    #free --old -ht | head -2 | tail -n 1 | awk '{printf " out of " $2}'; echo "";

    ##### Storage #####
    echo -e "";
    echo -en "\t"; df -h / | tail -n 1 | awk '{print "Root " $1 "\t:\t" $5 " full & " $4 " still available."}' ;

    ##### IP #####
    #echo -en "\tIP Address \t:\t"; /sbin/ifconfig wlp3s0 | awk /'inet / {print $2}' | sed -e s/addr:/''/  || /sbin/ifconfig wlan0 || echo "" #dubious, gotta test
    echo -en "\tIP Address \t:\t"; /sbin/ifconfig wlp3s0 | awk /'inet / {print $2}' | sed -e s/addr:/''/  || /sbin/ifconfig wlan0 || echo "" #dubious, gotta test

    ##### Uptime #####
    echo -en "\tThe system has been up for ";
    perl -e 'my $uptime = `uptime`; if ($uptime =~ /^\s+\S+\s+up\s+(\S+\s+\S+,\s+\S+),/) { printf $1; } else { print "uptime gave me a weird format!"; }'
    # echo -e "" #echo -ne "Up time:"; uptime | awk /'up/' #`uptime | awk {'print $3 $4'}`
}

welcome_message() {
    # customize this first message with a message of your choice.
    # this will display the username, date, time, a calendar, the amount of users, and the up time.
    # Gotta love ASCII art with figlet
    check_and_run figlet "Welcome, " $USER;
    #echo -e "";

    print_date_cal

    #if [[ "${PLATFORM}" == "Linux" ]]; then
    #  print_system_status_linux
    #else
    #  print_system_status
    #fi
    echo -e "";
    print_system_status_linux

    echo "";
    # check_and_run_bg ansiweather;
    get_fortune_cookies
}

# Speaks a message on ios when a server comes back up
speakwhenup() { [ "$1" ] && PHOST="$1" || return 1; until ping -c1 -W2 $PHOST >/dev/null 2>&1; do sleep 5s; done; say "$PHOST is up" >/dev/null 2>&1; }

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

function ooo(){
  while :; do clear; echo O_o; sleep 1; clear; echo o_O; sleep 1; done
}

randpw(){
  < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-128};
  echo;
}

file_ext() {
  # TODO: If not $1; $1 = .
  find $1 -type f -name "*.*" | grep -o -E "\.[^\.]+$" | grep -o -E "[[:alpha:]]{3,6}" | awk '{print tolower($0)}' | sort | uniq -c | sort -n
}
aliasc() {
  alias | grep "^${1}=" | awk -F= '{ print $2 }' | sed "s/^'//" | sed "s/'$//"
}

# Usage: about python; tells detail about file or binary, trys to look up in the path if not a file
about () {
  if [ -f "${1}" ] ; then
    file -pk "${1}"
    my_hex_dump "${1}"
    hash exa || ls -ltrha --color "${1}" && exa -lsnew "${1}"
  else
    type $1
    #which $1
    #filename_for_about_binary="$(which ${1})"

    where $1
    filename_for_about_binary="$(where ${1} | tail -1)"
    file -pk "${filename_for_about_binary}"

    if [ -f "${filename_for_about_binary}" ]; then
      my_hex_dump "${filename_for_about_binary}"
      hash bat && bat -r 1:25 "${filename_for_about_binary}"
      hash exa || ls -ltrha --color "${filename_for_about_binary}" && exa -lsnew "${filename_for_about_binary}"
    fi
  fi
}

my_hex_dump () {
  filename_for_hexdump="${1}"

  hash hexyl && hexyl -n=256 "${filename_for_hexdump}"
  hash hexyl && hexyl -s=-128 "${filename_for_hexdump}"

  hash hexyl || xxd "${filename_for_hexdump}" | head -25
  hash hexyl || xxd "${filename_for_hexdump}" | tail -5

  echo "For full hex dump, use:"
  echo "  hexyl ${filename_for_hexdump} | less"
}

dush () {
  # file_to_size=$(find "${1}" -mindepth 1 -maxdepth 1 | grep -v "^\.*$")
  # for i in ${file_to_size}; do

  for i in $(find "${1}" -mindepth 1 -maxdepth 1 | grep -v "^\.*$"); do
    hash diskus 2>/dev/null && echo "$(diskus $i)\t\t$i" || du -s $i | head -1;
  done # | sort -n
}

# vim: set ft=shell:
