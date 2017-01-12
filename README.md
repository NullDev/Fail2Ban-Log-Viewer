# Fail2Ban Log Viewer

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
