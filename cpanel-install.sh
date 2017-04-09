#!/bin/bash
# This script installs cPanel on a Centos Machine

# PATH Variable
PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# Other Variables
echo "What is the hostname of the server?"
echo "i.e. cloud.mydomain.com"
read HOSTNAME

# Install dependencies
yum -y install perl

# Set hostname
hostname "$HOSTNAME"

# Download and install the latest cPanel installation
cd /home
curl -o latest -L https://securedownloads.cpanel.net/latest
sh latest

# Install other options
./cpanel-addons.sh

# Open firewall to WHM/cPanel ports
funcReplace () {
   sed -i '/'"$1"'/c\'"$2"'' /etc/csf/csf.conf
}

funcReplace "TCP_IN = " 'TCP_IN = "20,21,22,25,53,80,110,143,443,465,587,943,993,995,1194,2083,2087,3306"'
funcReplace "TCP_OUT = " 'TCP_OUT = "20,21,22,25,53,80,110,113,443,587,943,993,995,1194,2083,2087,3306"'
csf -r


