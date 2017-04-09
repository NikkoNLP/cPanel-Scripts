#!/bin/bash

# Define Variables
PATH="/sbin:/bin:/usr/sbin:/usr/bin"
OS=`if [ -f "/etc/centos-release" ]; then
      cat /etc/centos-release
    else
      cat /etc/os-release | grep "^NAME=" | cut -d"=" -f2 | cut -d"\"" -f2
    fi`

# Update system based on OS
if [[ "$OS" = *"release "* ]]; then
   yum update -y
   yum upgrade -y
elif [ "$OS" == "Ubuntu" ]; then
   apt-get update -y
   apt-get upgrade -y
fi
