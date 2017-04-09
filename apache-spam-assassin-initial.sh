#!/bin/bash
# This script enables Apache Spam Assassin on a cPanel server

# PATH Variable
PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# Enable Spam Assassin by default on all cPanel accounts
sed -i s/skipspamassassin=1/skipspamassassin=0/g /var/cpanel/cpanel.config
sed -i s/skipspambox=1/skipspambox=0/g /var/cpanel/cpanel.config
/usr/local/cpanel/whostmgr/bin/whostmgr2 –updatetweaksettings
