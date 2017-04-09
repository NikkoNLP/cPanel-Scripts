#!/bin/bash

# Path Variable
PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# Functions
funcReplace () {
   sed -i '/'"$1"'/c\'"$2"'' /etc/csf/csf.conf
}

funcGrep () {
   grep "$1" /etc/csf/csf.conf
}

# Make a csf.conf backup
cp /etc/csf/csf.conf /etc/csf/csf.bak

### Make Changes ###
# 1. Set the csf deny limit to 1000 IPs
funcReplace "DENY_IP_LIMIT = " 'DENY_IP_LIMIT = "1000"'

# 2. Set the csf temp deny limit to 1000 IPs
funcReplace "DENY_TEMP_IP_LIMIT = " 'DENY_TEMP_IP_LIMIT = "1000"'

# 3. Prevent specific ports from being flooded (Syntax for port flood temp blocking: port;tcp/udp;[Max Conns];[In X Seconds])
funcReplace "PORTFLOOD = " 'PORTFLOOD = "80;tcp;300;3,110;tcp;200;3,143;tcp;200;3,465;tcp;200;3,993;tcp;200;3,995;tcp;200;3,443;tcp;300;3"'

# 4. Set connection limits on ports
funcReplace "CONNLIMIT = " 'CONNLIMIT = "21;200,25;200,80;700,110;200,143;200,443;700,465;200,587;200,993;200,995;200"'

# 5. Set csf deny limit to 
funcReplace "CT_LIMIT = " 'CT_LIMIT = "500"'

# 6. Prevent Port Scanning
funcReplace "PS_INTERVAL = " 'PS_INTERVAL = "120"'
funcReplace "PS_LIMIT = " 'PS_LIMIT = "10"'

# 7. Disable Emails
funcReplace "LF_EMAIL_ALERT =" 'LF_EMAIL_ALERT = "0"'
funcReplace "LF_SSH_EMAIL_ALERT =" 'LF_SSH_EMAIL_ALERT = "0"'
funcReplace "LF_SU_EMAIL_ALERT =" 'LF_SU_EMAIL_ALERT ="0"'
funcReplace "LF_WEBMIN_EMAIL_ALERT =" 'LF_WEBMIN_EMAIL_ALERT ="0"'
funcReplace "LF_CONSOLE_EMAIL_ALERT =" 'LF_CONSOLE_EMAIL_ALERT ="0"'
funcReplace "LT_EMAIL_ALERT =" 'LT_EMAIL_ALERT ="0"'
funcReplace "CT_EMAIL_ALERT =" 'CT_EMAIL_ALERT ="0"'
funcReplace "PS_EMAIL_ALERT =" 'PS_EMAIL_ALERT ="0"'

# Disable testing mode
funcReplace "TESTING = " 'TESTING = "0"'

csf -r
