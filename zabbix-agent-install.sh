#!/bin/bash
# This script install the Zabbix agent
# It does NOT configure the host on the Zabbix server

# Define Variables
PATH="/sbin:/bin:/usr/sbin:/usr/bin"
HOST=`hostname`
OS=`if [ -f "/etc/centos-release" ]; then
      cat /etc/centos-release
    else
      cat /etc/os-release | grep "^NAME=" | cut -d"=" -f2 | cut -d"\"" -f2
    fi`

# Obtain and install repo based on distro
if [[ "$OS" = *"release 6"* ]]; then
   rpm -Uvh http://repo.zabbix.com/zabbix/3.2/rhel/6/x86_64/zabbix-release-3.2-1.el6.noarch.rpm
   yum install zabbix-agent --nogpgcheck -y
elif [[ "$OS" = *"release 7"* ]]; then
   rpm -Uvh http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
   yum install zabbix-agent --nogpgcheck -y
elif [ "$OS" == "Ubuntu" ]; then
   RELEASE=`lsb_release -r | awk '{print $2}' | cut -d"." -f1`
     if [ "$RELEASE" == "14" ]; then
         wget http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+trusty_all.deb
         dpkg -i zabbix-release_3.2-1+trusty_all.deb
         apt-get update
         apt-get install zabbix-agent -y
     elif [ "$RELEASE" == "16" ]; then
         wget http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+xenial_all.deb
         dpkg -i zabbix-release_3.2-1+xenial_all.deb
         apt-get update
         apt-get install zabbix-agent -y
     else
         echo "Cannot determine Ubuntu Distrubution"
         exit 2
     fi
else
    echo "Cannot determine whether this machine is Ubuntu or Centos"
    exit 3
fi

# Configure the zabbix_agentd.conf
# Create a backup of the original zabbix_agentd.conf
mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.old

# Create a new zabbix_agentd.conf
cp ./zabbix-agent-install-conf /etc/zabbix/zabbix_agentd.conf

# Input the hostname
sed -i '/'"Hostname="'/c\'"Hostname="$HOST""'' /etc/zabbix/zabbix_agentd.conf


# Start/Enable Zabbix Agent & give zabbix user sudo NOPASS perms
if [ "$OS" == "Ubuntu" ]; then
   service zabbix-agent restart
   update-rc.d zabbix-agent defaults
   echo "zabbix   ALL=NOPASSWD: ALL" >> /etc/sudoers
elif [[ "$OS" = *"release"* ]]; then
   service zabbix-agent restart
   chkconfig zabbix-agent on
   echo "zabbix    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
else
   echo "Unable to determine distrubution to start Zabbix-Agent install"
   exit 4
fi

echo ""
echo "Installation Process Complete :D"
echo "Check for errors above"
