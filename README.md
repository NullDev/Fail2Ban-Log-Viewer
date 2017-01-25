# Fail2Ban Log Viewer

[![Build Status](https://travis-ci.org/NLDev/Fail2Ban-Log-Viewer.svg?branch=master)](https://travis-ci.org/NLDev/Fail2Ban-Log-Viewer)  [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/NLDev/Fail2Ban-Log-Viewer/master/LICENSE)

A small Bash script to print out the Fail2Ban log in a organized way.

##To get it working:

- Upload the script somewhere
- Log in to your SSH terminal
- make it executable with 
  `chmod +x fail2ban.sh`
- and finally launch it with
  `./fail2ban.sh`
  
That's it.

##Features:

- Display Hostname and IP
- Display IP and Auth Method used (For example SSH or Nginx Auth)
- Allows a user specified path inside the script
- Fallback path if user specified path fails
- Auto-Search feature if Fallback path and user path fail
- Use new path if file was found
- Check if Fail2Ban is installed
- Able to pass CLI Argument `-p` or `--path` to use a custom path for the log file at start.
  
  Example: `./fail2ban.sh -p /your/log/path.log` or `./fail2ban.sh --path /your/log/path.log`

- Able to handle unknown CLI Arguments, aswell as `--help`, `-h` or `-?`
  
  Example: `./fail2ban.sh --help`, `./fail2ban.sh -h` or `./fail2ban.sh -?`

- CLI Argument `--force` or `-f` which forces the start and doesn't prompt for input
- More comming soon!

<p align="center">
<strike>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strike> Main <strike>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strike><br>
<img src="https://raw.githubusercontent.com/NLDev/Fail2Ban-Log-Viewer/master/.src/scr1.png" />
<br><strike>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strike> Help <strike>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strike><br>
<img src="https://raw.githubusercontent.com/NLDev/Fail2Ban-Log-Viewer/master/.src/src2.png" />
</p>
