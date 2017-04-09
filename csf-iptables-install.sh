#!/bin/bash
# This script installs iptables and csf
# This also disables firewalld (CentOS) and uninstalls ufw (Ubuntu)

# Define PATH Variable
PATH="/sbin:/bin:/usr/sbin:/usr/bin"
OS=`if [ -f "/etc/centos-release" ]; then
      cat /etc/centos-release
    else
      cat /etc/os-release | grep "^NAME=" | cut -d"=" -f2 | cut -d"\"" -f2
    fi`

# Navigate to the correct directory
cd /usr/src

# Remove old CSF file if it exists
rm -f csf.tgz

# Grab the CSF tgz
wget https://download.configserver.com/csf.tgz

# Extract the CSF tgz
tar -xzf csf.tgz

# Run the install script
cd csf && sh install.sh

# Verify CSF will will work on the server
WORKS=`perl /usr/local/csf/bin/csftest.pl | grep "RESULT: csf should function on this server"`
if [[ "$WORKS" = *"RESULT: csf should function"* ]]; then
   echo "RESULT: csf should function on this server"
else
   perl /usr/local/csf/bin/csftest.pl
   exit 1
fi

# Disable Firewalld if CentOS and UFW if Ubuntu
if [[ "$OS" = *"release 7"* ]]; then
   systemctl stop firewalld && systemctl disable firewalld
elif [ "$OS" == "Ubuntu" ]; then
   service ufw stop
   apt-get remove ufw -y
fi

# Take CSF out of testing mode
sed -i '/'"TESTING = "'/c\'"TESTING = \"0\""'' /etc/csf/csf.conf

# Set IGNORE_ALLOW to prevent IPs in csf.all from getting blocked
sed -i '/'"IGNORE_ALLOW = "'/c\'"IGNORE_ALLOW  = \"1\""'' /etc/csf/csf.conf

# Install iptables if its not already
if [[ "$OS" = *"release "* ]]; then
   yum install iptables -y
elif [ "$OS" == "Ubuntu" ]; then
   apt-get install iptables -y
fi

# Start/Enable csf, lfd, and iptables
if [[ "$OS" = *"release 7"* ]]; then
   csf -r
   systemctl restart lfd
   systemctl enable csf
   systemctl enable lfd
   systemctl enable iptables
elif [[ "$OS" = *"release 6"* ]]; then
   csf -r
   service lfd restart
   chkconfig csf on
   chkconfig lfd on
   chkconfig iptables on
elif [ "$OS" == "Ubuntu" ]; then
   csf -r
   service lfd restart
   update-rc.d csf defaults
   update-rc.d lfd defaults
fi

echo ""
echo "CSF/IPtables installation script complete"
echo "Please check for errors above"
