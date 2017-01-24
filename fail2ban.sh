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
git=http://github.com/NLDev/Fail2Ban-Log-Viewer
frc=0
function cls { 
	XA=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
	YA=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)
	printf "\033c" #Clear
	printf "\e[8;${XA};${YA}t" #Maximize
	printf "\e[5t" #Focus
   #Maximize formats the window very weird when it's minimized again.
   #But thats not fatal.
}
printf "\n------------------------------------------------------------------\n"
if [ "${*}" = "--help" ] || [ "${*}" = "-h" ] || [ "${*}" = "-?" ]; then
   cls
   printf "\n\n${COL_YLW}########\n${COL_YLW}# ${COL_GRN}HELP ${COL_YLW}#\n${COL_YLW}########\n\n${COL_RST}--path  | -p PATH     :"
   printf "     Sets the path for the Log\n--help  | -h | -?     :     Displays this help menu"
   printf "\n--force | -f          :     Forces the start and doesn't ask for user input\n"
   printf "--github | -g         :     Displays and open's (if possible) the GitHub link\n"
   printf "\n[Here will be more soon]\n\n\n"
   exit 0
fi
if [ "${*}" = "--github" ] || [ "${*}" = "-g" ]; then
	logo
	printf "Link to the GitHub:\n\n"
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
if [[ $frc != 1 ]]; then
   cls
   f2b_ok=$(dpkg-query -W --showformat='${Status}\n' $pkg|grep "install ok installed")
   if [ "" == "$f2b_ok" ]; then
      printf "\n${COL_YLW}###########\n${COL_YLW}# ${COL_RED}WARNING ${COL_YLW}#\n${COL_YLW}###########\n\n"
      printf "${COL_BLE}Fail2Ban is not installed on this system. If there is stil a log, you can continue.\n${COL_BLE}Do you want to continue? [y/n]${COL_RST}"
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
   if [[ "$@" != "-p"* ]]; then
      if [[ "$@" != "--path"* ]]; then
         printf "\n${COL_YLW}###########\n${COL_YLW}# ${COL_RED}WARNING ${COL_YLW}#\n${COL_YLW}###########\n\n"
         printf "${COL_BLE}You entered an Invalid argument. Ignoring...\n${COL_RST}"
      fi
   fi
fi
while [[ $# -gt 1 ]]
do
   arg="$1"
   case $arg in
      -p|--path)
         F2B="$2"
         printf "\n${COL_YLW}########\n${COL_YLW}# ${COL_BLE}INFO ${COL_YLW}#\n${COL_YLW}########\n\n"
         printf "${COL_GRN}Path has been set to '${COL_BLE}%s${COL_GRN}'\n${COL_RST}" $F2B
         shift 
      ;;
      --default)
         DEFAULT=YES
      ;;
      *)
         #Null
      ;;
   esac
   shift
done
echo -e $'\nLoading...'
cls
if [ ! -f $F2B ]; then
   if [ ! -f $DEF ]; then
      if [[ $frc != 1 ]]; then
         printf "\n${COL_YLW}#########\n${COL_YLW}# ${COL_RED}ERROR ${COL_YLW}#\n${COL_YLW}#########\n\n${COL_RST}"
         printf "File not found!\nCheck the path in the script\n\nOr do you want me to search for the log? [y/n]\n\n${COL_RST}"
         stty_cfg=$(stty -g)
         stty raw -echo ; input=$(head -c 1) ; stty $stty_cfg
         if echo "$input" | grep -iq "^y" ;then
            printf "${COL_YLW}Searching... (Could take some time)${COL_RST}\n"
            LOC=$(find / -type f -iname "fail2ban.log")
            if [ "$LOC" '!=' '' ]; then
               printf "\n${COL_YLW}########\n${COL_YLW}# ${COL_BLE}INFO ${COL_YLW}#\n${COL_YLW}########\n\n"
               printf "${COL_GRN}File was found at %s!\n${COL_RST}" $LOC
               F2B=$LOC
            else
               printf "\n${COL_YLW}###########\n${COL_YLW}# ${COL_RED}WARNING ${COL_YLW}#\n${COL_YLW}###########\n\n${COL_RST}"
               printf "File was not found!\n"
               exit 0
            fi
         else
            exit 0
         fi
      else
         printf "\n${COL_YLW}###########\n${COL_YLW}# ${COL_RED}WARNING ${COL_YLW}#\n${COL_YLW}###########\n\n${COL_RST}"
         printf "File path incorrect. Forcing end!\n"
         exit 0
      fi
   else
      printf "\n${COL_YLW}########\n${COL_YLW}# ${COL_BLE}INFO ${COL_YLW}#\n${COL_YLW}########\n\n${COL_RST}"
      printf "Loaction '%s' not found.\n${COL_GRN}But file was found at %s\n(Default Path)\n${COL_RST}" $F2B $DEF
      F2B=$DEF
   fi
fi
printf "\n${COL_YLW}+----------------------------------------+\n${COL_YLW}| ${COL_GRN}FAIL2BAN IP ADRESS REPORT ${COL_RST}- "
printf "${COL_BLE}by NullDev ${COL_YLW}|\n"
printf "+----------------------------------------+\n\n${COL_RST}"
printf "${COL_YLW}########################\n${COL_YLW}#   ${COL_BLE}HOSTNAME ${COL_RST}AND ${COL_BLE}IP    "
printf "${COL_YLW}#\n${COL_YLW}#----------------------#\n${COL_YLW}# ${COL_GRN}Format:              ${COL_YLW}#\n"
printf "# ${COL_GRN}AMOUNT HOSTNAME (IP) ${COL_YLW}#\n${COL_YLW}########################\n\n${COL_RST}"
awk '($(NF-1) = /Ban/){print $NF,"("$NF")"}' $F2B | sort | logresolve | uniq -c | sort -n
printf "${COL_YLW}\n${COL_YLW}########################\n${COL_YLW}#    ${COL_BLE}IP ${COL_RST}AND ${COL_BLE}EXPLOIT    "
printf "${COL_YLW}#\n${COL_YLW}#----------------------#\n${COL_YLW}# ${COL_GRN}Format:              ${COL_YLW}#\n${COL_YLW}#"
printf " ${COL_GRN}AMOUNT IP [EXPLOIT]  ${COL_YLW}#\n########################\n\n${COL_RST}"
grep "Ban " $F2B | awk -F[\ \:] '{print $10,$8}' | sort | uniq -c | sort -n
printf "\n"
exit 0
