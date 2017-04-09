#!/bin/bash

# Define PATH Variable
PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# Navigate to the correct directory
cd /usr/local/src/

# Grab the current version of Maldet
wget http://www.rfxn.com/downloads/maldetect-current.tar.gz

# Extract the tar.gz
tar -xzf maldetect-current.tar.gz

# Install Maldet
cd maldetect-* && sh ./install.sh

echo ""
echo "Maldet Installation Complete"
echo "Please Check for Errors above"
