#!/bin/bash
# This script installs software that looks for root kits
# It also sets up a cron to look for root kits

# PATH
PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# Install chkrootkit
cd /root
wget ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit.tar.gz
tar -xvzf chkrootkit.tar.gz
cd chkrootkit-*
make sense


# Install rkhunter
# Rkhunter is currently downloading a file that it standard html?
#cd /root
#wget http://dfn.dl.sourceforge.net/sourceforge/rkhunter/rkhunter-1.4.2.tar.gz
#tar -xvzf rkhunter-*.tar.gz
#cd rkhunter-*
#./installer.sh --layout default --install command


# Setup Cron
echo "1 0 * * * /root/chkrootkit-*/chkrootkit" >> /etc/crontab
#echo "10 0 * * * /root/rkhunter-*/files/rkhunter -c" >> /etc/crontab

