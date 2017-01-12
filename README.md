# Fail2Ban Log Viewer

##Note: This is the InDev branche. Do not use that for anything but testing / improving!
##This file can contain errors.

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
- Fallback path if user specified path fails
- Search feature if Fallback path and user path fail
- Able to pass CLI Argument `-p` or `--path` to use a custom path for the log file at start.
  
  Example: `./fail2ban.sh -p /your/log/path.log` or `./fail2ban.sh --path /your/log/path.log`
