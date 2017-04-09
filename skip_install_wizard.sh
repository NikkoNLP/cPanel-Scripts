#!/bin/bash
# This script skips the 'install wizard' portion of cPanel
# It also configures the server to set itself up like you would in the wizard

# Define Variables
PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# Disable the wizard from running
touch /etc/.whostmgrft

# Setup services that are traditionally setup through the wizard
# IMAP
/scripts/setupmailserver

# Name Servers
/scripts/setupnameserver

# FTP
/scripts/setupftpserver


# Configure all other settings
CONF="/etc/wwwacct.conf"
IPADDR=`ip addr | grep -A 4 eth0 | egrep "inet [1-9]" | awk '{print $2}' | cut -d"/" -f1`
CONTACTEMAIL=
HOSTNAME=`hostname`

echo "
ADDR "$IPADDR"
CONTACTEMAIL "$CONTACTEMAIL"
CONTACTPAGER
DEFMOD paper_lantern
ETHDEV eth0
HOMEDIR /home
HOMEMATCH home
HOST "$HOSTNAME"
LOGSTYLE combined
MINUID
NS ns1.dnsconfigure.com
NS2 ns2.dnsconfigure.com
NS3
NS4
NSTTL 3600
SCRIPTALIAS y
TTL 3600" > "$CONF"

# Verify the cPanel key
/usr/local/cpanel/cpkeyclt
