#!/bin/bash


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   echo " do a sudo su"
   exit 1
fi

REQUIRED_PKG="curl"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
   apt-get --yes install $REQUIRED_PKG
fi


REQUIRED_PKG="zerotier-one"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
   sudo curl -s https://install.zerotier.com | sudo bash
fi




curl -O https://s3-us-west-1.amazonaws.com/key-networks/deb/ztncui/1/x86_64/ztncui_0.8.6_amd64.deb

chmod +x ztncui_*

sudo apt install ./ztncui_*

sudo sh -c "echo 'HTTPS_PORT=3443' > /opt/key-networks/ztncui/.env"

sudo sh -c "echo 'NODE_ENV=production' >> /opt/key-networks/ztncui/.env"

sudo systemctl restart ztncui
