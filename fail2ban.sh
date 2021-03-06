#!/bin/bash
##############################
#----------------------------#
# Basic SSH Fail2Ban Log     #
# Reader with sorted output  #
#----------------------------#
#-Set Fail2Ban log path here-#
#----------------------------#
F2B=/var/log/fail2ban.log
#----------------------------#
##############################
#Fallback
DEF=/var/log/fail2ban.log
#TERM COL
COL_RED=$(tput setaf 1)
COL_GRN=$(tput setaf 2)
COL_YLW=$(tput setaf 3)
COL_BLE=$(tput setaf 4)
COL_RST=$(tput sgr0)
pkg=fail2ban
git=http://github.com/NullDev/Fail2Ban-Log-Viewer
frc=0
this=$(basename $BASH_SOURCE)
purge=0
function cls {
   XA=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
   YA=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)
   printf "\033c" #Clear
   printf "\e[8;${XA};${YA}t" #Maximize
   printf "\e[5t" #Focus
   #Maximize formats the window very weird when it's minimized again - also doesnt work on CLI only environments
}
function padding {
   if [[ ${#this} = 10 ]]; then printf "${COL_YLW} +" && yes "-" | head -126 | tr -d "\n"
   elif [[ ${#this} > 10 ]]; then
      let dif="100 - (10 - ${#this})"
      printf "${COL_YLW} +" && yes "-" | head -$dif | tr -d "\n" && printf "+"
   elif [[ ${#this} < 10 ]]; then
      let dif="100 + (10 + ${#this})"
      printf "${COL_YLW} +" && yes "-" | head -$dif | tr -d "\n" && printf "+"
   fi
}
function logo {
   printf "\n\n"
   printf "                      ___.-------.___\n                  _.-\' ___.--;--.___ \`-._\n               .-\' _.-\'  ${COL_BLE}/  .+.  \\${COL_RST}  \`-._ \`-.\n"
   printf "             .\' .-\'      ${COL_BLE}|-|-o-|-|${COL_RST}      \`-. \`.\n            (_ <O__      ${COL_BLE}\  \`+\'  /${COL_RST}      __O> _)\n"
   printf "              \`--._\`\`-..__${COL_BLE}\`._|_.\'${COL_RST}__..-\'\'_.--\'\n                    \`\`--._________.--\'\'\n\n"
   printf "          ${COL_YLW}______    _ _ ${COL_BLE} _____ ${COL_YLW}______\n"
   printf "          ${COL_YLW}|  ___|  (_) |${COL_BLE}/ __  \\${COL_YLW}| ___ \ \n          ${COL_YLW}| |_ __ _ _| |${COL_BLE}\`\' / /\'${COL_YLW}| |_/ / __ _ _ ___  \n"
   printf "          ${COL_YLW}|  _/ _\` | | |${COL_BLE}  / /  ${COL_YLW}| ___ \/ _\` | \'_  \ \n"
   printf "          ${COL_YLW}| || (_| | | |${COL_BLE}./ /___${COL_YLW}| |_/ / (_| | | | |\n          ${COL_YLW}\_| \__,_|_|_|${COL_BLE}\_____/${COL_YLW}\____/ \__,_|_| |_|"
   printf "\n\n${COL_RST}"
}
function main {
   echo -e $'\nLoading...'
   cls
   logo
   if [ ! -f $F2B ]; then
      if [ ! -f $DEF ]; then
         if [[ $frc != 1 ]]; then
            printf "\n${COL_YLW}#########\n${COL_YLW}# ${COL_RED}ERROR ${COL_YLW}#\n${COL_YLW}#########\n\n${COL_RST}"
            printf "File not found!\nCheck the path in the script\n\nOr do you want me to search for the log? [y/n]\n\n${COL_RST}"
            stty_cfg=$(stty -g)
            stty raw -echo ; input=$(head -c 1) ; stty $stty_cfg
            if echo "$input" | grep -iq "^y" ;then
               printf " ${COL_YLW}Searching... (Could take some time)${COL_RST}\n"
               LOC=$(find / -type f -iname "fail2ban.log")
               if [ "$LOC" '!=' '' ]; then
                  printf "\n ${COL_YLW}########\n ${COL_YLW}# ${COL_BLE}INFO ${COL_YLW}#\n ${COL_YLW}########\n\n"
                  printf " ${COL_GRN}File was found at %s!\n${COL_RST}" $LOC
                  F2B=$LOC
               else
                  printf "\n ${COL_YLW}###########\n${COL_YLW} # ${COL_RED}WARNING ${COL_YLW}#\n${COL_YLW} ###########\n\n${COL_RST}"
                  printf " File was not found!\n"
                  exit 0
               fi
            else
               exit 0
            fi
         else
            printf "\n ${COL_YLW}###########\n ${COL_YLW}# ${COL_RED}WARNING ${COL_YLW}#\n ${COL_YLW}###########\n\n${COL_RST}"
            printf " File path incorrect. Forcing end!\n"
            exit 0
         fi
      else
         printf "\n ${COL_YLW}########\n ${COL_YLW}# ${COL_BLE}INFO ${COL_YLW}#\n ${COL_YLW}########\n\n${COL_RST}"
         printf " Loaction '%s' not found.\n${COL_GRN}But file was found at %s\n(Default Path)\n${COL_RST}" $F2B $DEF
         F2B=$DEF
      fi
    fi
    cont=$(<$F2B)
    if [[ -z "${cont// }" ]]; then
        cls
        logo
        if [[ $purge = 1 ]]; then
           printf "\n${COL_YLW} ########\n ${COL_YLW}# ${COL_BLE}INFO ${COL_YLW}#\n ${COL_YLW}########\n\n"
           printf " ${COL_GRN}Seems like the log is already empty! Nothing to clear.\n\n${COL_RST}"
        else
           printf "\n${COL_YLW} ########\n ${COL_YLW}# ${COL_BLE}INFO ${COL_YLW}#\n ${COL_YLW}########\n\n"
           printf " ${COL_GRN}Seems like the log is empty!\n\n${COL_RST}"
        fi
	exit 0
    fi
    printf "\n${COL_YLW}+" && yes "-" | head -40 | tr -d "\n" && printf "+\n${COL_YLW}| ${COL_GRN}FAIL2BAN IP ADRESS REPORT ${COL_RST}- "
    printf "${COL_BLE}by NullDev ${COL_YLW}|\n"
    printf "+" && yes "-" | head -40 | tr -d "\n" && printf "+\n\n${COL_RST}"
    printf "${COL_YLW}" && yes "#" | head -24 | tr -d "\n" && printf "\n${COL_YLW}#   ${COL_BLE}HOSTNAME ${COL_RST}AND ${COL_BLE}IP    "
    printf "${COL_YLW}#\n${COL_YLW}#----------------------#\n${COL_YLW}# ${COL_GRN}Format:              ${COL_YLW}#\n"
    printf "# ${COL_GRN}AMOUNT HOSTNAME (IP) ${COL_YLW}#\n${COL_YLW}########################\n\n${COL_RST}"
    awk '($(NF-1) = /Ban/){print $NF,"("$NF")"}' $F2B | sort | logresolve | uniq -c | sort -n
    printf "${COL_YLW}\n${COL_YLW}" && yes "#" | head -24 | tr -d "\n" && printf "\n${COL_YLW}#    ${COL_BLE}IP ${COL_RST}AND ${COL_BLE}EXPLOIT    "
    printf "${COL_YLW}#\n${COL_YLW}#----------------------#\n${COL_YLW}# ${COL_GRN}Format:              ${COL_YLW}#\n${COL_YLW}#"
    printf " ${COL_GRN}AMOUNT IP [EXPLOIT]  ${COL_YLW}#\n" && yes "#" | head -24 | tr -d "\n" && printf "\n\n${COL_RST}"
    grep "Ban " $F2B | awk -F[\ \:] '{print $10,$8}' | sort | uniq -c | sort -n
    printf "\n"
    if [[ $purge = 1 ]]; then
       printf "\n${COL_YLW} ###########\n ${COL_YLW}# ${COL_RED}WARNING ${COL_YLW}#\n ${COL_YLW}###########\n\n${COL_RST}"
       printf " ${COL_RED}PURGING LOGFILE NOW${COL_RST}..."
       truncate -s 0 $F2B > /dev/null
       printf "\n\n ${COL_GRN}LOG FILE PURGED!${COL_RST}\n\n"
       exit 0
    fi
}
printf "\n" && yes "-" | head -66 | tr -d "\n" && printf "\n"
if [ "${*}" = "--help" ] || [ "${*}" = "-h" ] || [ "${*}" = "-?" ]; then
   cls
   logo
   printf "\n\n${COL_YLW} ########\n${COL_YLW} # ${COL_GRN}HELP ${COL_YLW}#\n${COL_YLW} ########\n\n"
   padding
   printf "\n ${COL_YLW}|${COL_RST} ./${this} --path   | -p PATH     :     Sets the path for the Log                                ${COL_YLW}|${COL_RST}"
   printf "\n ${COL_YLW}|${COL_RST} ./${this} --help   | -h | -?     :     Displays this help menu                                  ${COL_YLW}|${COL_RST}"
   printf "\n ${COL_YLW}|${COL_RST} ./${this} --force  | -f          :     Forces the start and doesn't ask for user input          ${COL_YLW}|${COL_RST}"
   printf "\n ${COL_YLW}|${COL_RST} ./${this} --github | -g          :     Displays and open's (if possible) the GitHub link        ${COL_YLW}|${COL_RST}"
   printf "\n ${COL_YLW}|${COL_RST} ./${this} --clear  | -c          :     Purges the Log file after displaying it                  ${COL_YLW}|${COL_RST}\n"
   padding && printf "${COL_RST}\n"
   printf "\n ${COL_BLE}[${COL_GRN}Here will be more soon${COL_BLE}]${COL_RST}\n\n\n"
   exit 0
fi
if [ "${*}" = "--github" ] || [ "${*}" = "-g" ]; then
	printf "\nLink to the GitHub:\n\n"
	printf "${git}\n\n"
	if which xdg-open > /dev/null; then
		xdg-open $git > /dev/null
	elif which gnome-open > /dev/null; then
		gnome-open $git > /dev/null
	fi
	exit 0
fi
if [ "${*}" = "--force" ] || [ "${*}" = "-f" ]; then
   printf "\n${COL_YLW}########\n${COL_YLW}# ${COL_BLE}INFO ${COL_YLW}#\n${COL_YLW}########\n\n"
   printf "${COL_GRN}Forcing start!${COL_RST}\n"
   frc=1
   shift
fi
if [ "${*}" = "--clear" ] || [ "${*}" = "-c" ]; then
   purge=1
   main
   shift
fi
if [[ $frc != 1 ]]; then
   cls
   logo
   f2b_ok=$(dpkg-query -W --showformat='${Status}\n' $pkg|grep "install ok installed")
   if [ "" == "$f2b_ok" ]; then
      printf "\n${COL_YLW}" yes "#" | head -11 | tr -d "\n" && printf "\n${COL_YLW}# ${COL_RED}WARNING ${COL_YLW}#\n${COL_YLW}"
      yes "#" | head -11 | tr -d "\n"
      printf "\n\n ${COL_BLE}Fail2Ban is not installed on this system. If there is stil a log, you can continue.\n ${COL_BLE}Do you want to continue? [y/n]${COL_RST}"
      stty_cfg_t=$(stty -g)
      stty raw -echo ; input_t=$(head -c 1) ; stty $stty_cfg_t
      if echo "$input_t" | grep -iq "^n" ;then
         exit 0
      fi
   fi
fi
#This is a pretty weird way to do it but it works
if [[ ! -z "$@" ]]; then
   cls
   logo
   if [[ "$@" != "-p"* ]]; then
      if [[ "$@" != "--path"* ]]; then
         printf "\n${COL_YLW} ###########\n ${COL_YLW}# ${COL_RED}WARNING ${COL_YLW}#\n ${COL_YLW}###########\n\n"
         printf " ${COL_BLE}You entered an Invalid argument. Ignoring...\n${COL_RST}"
      fi
   fi
fi
while [[ $# -gt 1 ]]
do
   arg="$1"
   case $arg in
      -p|--path)
         F2B="$2"
         printf "\n ${COL_YLW}########\n ${COL_YLW}# ${COL_BLE}INFO ${COL_YLW}#\n ${COL_YLW}########\n\n"
         printf " ${COL_GRN}Path has been set to '${COL_BLE}%s${COL_GRN}'\n${COL_RST}" $F2B
         shift
      ;;
      --default)
         DEFAULT=YES
      ;;
      *)
         #Null
         shift
      ;;
   esac
   shift
done
cls
main
exit 0
