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
#Check for help here
if [ "${@}" = "--help" -o "${@}" = "-h" -o "${@}" = "-?" ]
# ...
fi
while [[ $# -gt 1 ]]
do
arg="$1"
# Not in use
if [ $1 == "-h" || $1 == "--help" || $1 == "-?" ]; then
printf "### HELP ###\n\n--path | -p PATH     :     Sets the path for the Log\n--help | -h | -?     :     Displays this help menu"
exit
fi
case $arg in
   -p|--path)
      F2B="$2"
      printf "\n${COL_YLW}########\n# ${COL_BLE}INFO ${COL_YLW}#\n########\n\n${COL_GRN}Path has been set to %s${COL_RST}\n" $F2B
      shift 
   ;;
   --default)
      DEFAULT=YES
   ;;
   *)
      printf "You entered an Invalid argument. Ignoring...\n" #Not in use
   ;;
esac
shift
done
echo -e $'\nLoading...'
################
# --- test --- #
if [[ ! "$#" = 0 ]]; then #Not in use / Not Working
   if [[ $F2B != $DEF ]]; then
      if [[ $_tmpF2B != $2 ]]; then
         printf "\n${COL_YLW}########\n# ${COL_BLE}INFO ${COL_YLW}#\n########\n\n${COL_GRN}"
         printf "The path in the script was changed to '%s'. Using it.\n" $F2B
      fi
   fi
fi
# --- test --- #
################
if [ ! -f $F2B ]; then
   if [ ! -f $DEF ]; then
      printf "\n${COL_YLW}#########\n# ${COL_RED}ERROR ${COL_YLW}#\n#########\n\n${COL_RST}File not found!\nCheck the path in the script\n\nOr do you want me to search for the log? [y/n]\n\n"
      stty_cfg=$(stty -g)
      stty raw -echo ; input=$(head -c 1) ; stty $stty_cfg
      if echo "$input" | grep -iq "^y" ;then
         printf "${COL_YLW}Searching... (Could take some time)${COL_RST}\n"
         LOC=$(find / -type f -iname "fail2ban.log")
         if [ "$LOC" '!=' '' ]; then
            printf "\n${COL_YLW}########\n# ${COL_BLE}INFO ${COL_YLW}#\n########\n\n${COL_GRN}File was found at %s!\n${COL_RST}" $LOC
            F2B=$LOC
         else
            printf "\n${COL_YLW}###########\n# ${COL_RED}WARNING ${COL_YLW}#\n###########\n\n${COL_RST}File was not found!\n"
            exit
         fi
      else
         exit
      fi
   else
      printf "\n${COL_YLW}########\n# ${COL_BLE}INFO ${COL_YLW}#\n########\n\n${COL_RST}Loaction %s not found.\n${COL_GRN}But file was found at %s\n(Default Path)\n${COL_RST}" $F2B $DEF
      F2B=$DEF
   fi
fi
printf "${COL_YLW}\n+----------------------------------------+\n| ${COL_GRN}FAIL2BAN IP ADRESS REPORT ${COL_RST}- ${COL_BLE}by NullDev ${COL_YLW}|\n"
printf "+----------------------------------------+\n\n${COL_RST}"
printf "${COL_YLW}########################\n#   ${COL_BLE}HOSTNAME AND IP    ${COL_YLW}#\n#----------------------#\n# ${COL_GRN}Format:              ${COL_YLW}#\n"
printf "# ${COL_GRN}AMOUNT HOSTNAME (IP) ${COL_YLW}#\n########################\n\n${COL_RST}"
awk '($(NF-1) = /Ban/){print $NF,"("$NF")"}' $F2B | sort | logresolve | uniq -c | sort -n
printf "${COL_YLW}\n########################\n#    ${COL_BLE}IP AND EXPLOIT    ${COL_YLW}#\n#----------------------#\n# ${COL_GRN}Format:              ${COL_YLW}#\n#"
printf " ${COL_GRN}AMOUNT IP [EXPLOIT]  ${COL_YLW}#\n########################\n\n${COL_RST}"
grep "Ban " $F2B | awk -F[\ \:] '{print $10,$8}' | sort | uniq -c | sort -n
printf "\n"
exit
