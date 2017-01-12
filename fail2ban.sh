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
DEF=/var/log/fail2ban.log
echo -e $'\nLoading...'
if [ ! -f $F2B ]; then
if [ ! -f $DEF ]; then
printf "\n#########\n# ERROR #\n#########\n\nFile not found!\nCheck the path in the script\n\n"
exit
else
printf "\n########\n# INFO #\n########\n\nFile was found at %s\n(Default Path)\n" $DEF
F2B=$DEF
fi
fi
printf "\n+---------------------------------------+\n| FAIL2BAN IP ADRESS REPORT - by Shadow |\n+---------------------------------------+\n\n"
printf "########################\n#   HOSTNAME AND IP    #\n#----------------------#\n# Format:              #\n# AMOUNT HOSTNAME (IP) #\n########################\n\n"
awk '($(NF-1) = /Ban/){print $NF,"("$NF")"}' $F2B | sort | logresolve | uniq -c | sort -n
printf "\n########################\n#    IP AND EXPLOIT    #\n#----------------------#\n# Format:              #\n# AMOUNT IP [EXPLOIT]  #\n########################\n\n"
grep "Ban " $F2B | awk -F[\ \:] '{print $10,$8}' | sort | uniq -c | sort -n
printf "\n"
exit
