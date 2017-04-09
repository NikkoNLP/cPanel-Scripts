#!/bin/bash
# This script installs sysstat for preformance tracking and sets it to track each minute

# PATH Variable
PATH="/sbin:/bin:/usr/sbin:/usr/bin"
OS=`if [ -f "/etc/centos-release" ]; then
      cat /etc/centos-release
    else
      cat /etc/os-release | grep "^NAME=" | cut -d"=" -f2 | cut -d"\"" -f2
    fi`

# Install sysstat (CentOS)
if [[ "$OS" = *"release "* ]]; then
   yum -y install sysstat
   sed -i s/10/2/g /etc/cron.d/sysstat
   service sysstat restart
   chkconfig sysstat on
fi

# Install sysstat (Ubuntu)
if [ "$OS" == "Ubuntu" ]; then
   apt-get -y install sysstat
   sed -i s/false/true/g /etc/default/sysstat
   sed -i s%5-55/10%*/2%g /etc/cron.d/sysstat
   service sysstat restart
fi
