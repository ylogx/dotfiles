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
    local now=$(date +"%d%m %c")
    cal
    echo "Today is ${now#* }"
    local dm=${now%% *}
    if [[ "$dm" == "0101" ]]; then
        check_and_run figlet "Happy New Year"; echo "$USER";
    elif [[ "$dm" == "2603" ]]; then
        check_and_run figlet "Happy Birthday"
    fi
}

# Gather system data in parallel, then print in order
print_system_status_fast() {
    local tmpdir=$(mktemp -d)
    trap "command rm -rf $tmpdir" EXIT

    # Run all data-gathering in a subshell to suppress job control notifications
    (
        { hostname; } > "$tmpdir/hostname" 2>/dev/null &
        { uname -r; } > "$tmpdir/kernel" 2>/dev/null &
        { arch; } > "$tmpdir/arch" 2>/dev/null &
        { uptime | awk '{print $3,$4}' | sed 's/,//'; } > "$tmpdir/uptime" 2>/dev/null &
        { fortune 2>/dev/null; } > "$tmpdir/fortune" &

        if [[ "$PLATFORM" == "Mac" ]]; then
            { sysctl -n machdep.cpu.brand_string; } > "$tmpdir/cpu" 2>/dev/null &
            { sw_vers -productVersion; } > "$tmpdir/os" 2>/dev/null &
            { ipconfig getifaddr en0 2>/dev/null || echo "N/A"; } > "$tmpdir/ip" &
            { vm_stat | awk '/Pages free|Pages active|Pages inactive|Pages speculative|Pages wired|Pages occupied by compressor/ {gsub(/\./,"",$NF); a[NR]=$NF} END {
                total=0; for(i in a) total+=a[i];
                used=total-a[1]-a[4]; # total minus free minus speculative
                pct=(used*100)/total;
                printf "%.0f%% of ~%.0fGB\n", pct, (total*16384/1073741824)
            }'; } > "$tmpdir/mem" 2>/dev/null &
        else
            { [[ -f /proc/cpuinfo ]] && awk -F: '/^model name/{gsub(/^[ \t]+/,"",$2); print $2; exit}' /proc/cpuinfo || echo "Unknown"; } > "$tmpdir/cpu" 2>/dev/null &
            { hash hostnamectl 2>/dev/null && hostnamectl | awk -F: '/Operating System/{gsub(/^[ \t]+/,"",$2); print $2}' || uname -o; } > "$tmpdir/os" 2>/dev/null &
            { hostname -I 2>/dev/null | awk '{print $1}' || echo "N/A"; } > "$tmpdir/ip" &
            if hash free 2>/dev/null; then
                { free -h | awk '/^Mem:/{print $3 " used / " $2 " total"}'; } > "$tmpdir/mem" 2>/dev/null &
            else
                echo "N/A" > "$tmpdir/mem" &
            fi
        fi

        wait
    )

    # Read all results using builtins (no subprocess overhead)
    local v_hostname v_os v_kernel v_arch v_cpu v_mem v_uptime v_ip v_fortune
    read -r v_hostname < "$tmpdir/hostname"
    read -r v_os < "$tmpdir/os"
    read -r v_kernel < "$tmpdir/kernel"
    read -r v_arch < "$tmpdir/arch"
    read -r v_cpu < "$tmpdir/cpu"
    read -r v_mem < "$tmpdir/mem"
    read -r v_uptime < "$tmpdir/uptime"
    read -r v_ip < "$tmpdir/ip"
    v_fortune=$(<"$tmpdir/fortune")

    # Print collected data in order
    echo "\tSystem Status"
    echo "\t============="
    echo -e "Hostname:\t\t${v_hostname}"
    echo -e "OS:\t\t\t$([[ "$PLATFORM" == "Mac" ]] && echo "macOS ${v_os}" || echo "${v_os}")"
    echo -e "Kernel:\t\t\t${v_kernel} ${v_arch}"
    echo -e "CPU:\t\t\t${v_cpu}"
    echo -e "Memory:\t\t\t${v_mem}"
    echo -e "Active User:\t\t${USER}"
    echo -e "Up Since:\t\t${v_uptime}"
    echo -e "System Main IP:\t\t${v_ip}"

    if [[ -n "$v_fortune" ]]; then
        echo ""
        echo "Fortune Cookie:"
        echo "$v_fortune"
    fi

    command rm -rf "$tmpdir"
    trap - EXIT
}

welcome_message() {
    check_and_run figlet "Welcome, " $USER;
    print_date_cal
    echo ""
    print_system_status_fast
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
    hash eza || ls -ltrha --color "${1}" && eza -lsnew "${1}"
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
      hash eza || ls -ltrha --color "${filename_for_about_binary}" && eza -lsnew "${filename_for_about_binary}"
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
