#!/bin/bash
# This file runs the other necessary scripts for initial cPanel installations
# It assumes cPanel has been installed, but nothing configured

# PATH
PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# Ask for other variables
#echo "Enter the contact email address"
#read CONTACT

# Setup cPanel like you would with the setup wizard
#sed -i '/'"CONTACTEMAIL="'/c\'"CONTACTEMAIL= "$CONTACT""'' ./skip_install_wizard.sh
bash skip_install_wizard.sh

# Install CSF/Iptables
bash csf-iptables-install.sh

# Optimize CSF
bash csfopt-initial.sh

# Install Maldet
bash maldet-install.sh

# Install/optimize sysstat
bash sysstat-install.sh

# Update Repositories
bash update.sh

# Install Root Kit checker
bash root-kit-setup.sh

# Enable Apache Spam Assassin
bash apache-spam-assassin-initial.sh

# Install Zabbix
bash zabbix-agent-install.sh
