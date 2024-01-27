#! /bin/bash
# Script to implement https://www.redhat.com/sysadmin/fedora-iot-raspberry-pi

# Find your wifi key and run 
# export WIFI_KEY=XXXXX
# before running this script

if [ -z "$WIFI_KEY" ]
then
      echo "\$WIFI_KEY is empty"
      echo "set with 'export WIFI_KEY=XXXXX'"
      exit 1
fi

WIFI_AP=SKYSJJ2E

# sshkey to use
KEY=/home/anton/.ssh/id_ed25519.pub

# wifi config to use stored in /etc/NetworkManager/system-connections
CONN=wifi01.nmconnection

# Location of the image
IMG=/home/anton/Downloads/Fedora-IoT-39.20231103.1-20231103.1.aarch64.raw.xz

#use `lsblk` command to see the name of the disk 
MOUNT=/dev/sda3

arm-image-installer \
--image=$IMG \
--target=rpi4 \
--media=/dev/sda \
--addkey=$KEY \
--resizefs \
-y

# sleep 1m
#read in template one line at the time, and replace variables
touch /tmp/$CONN 
while read line
do
    eval echo "$line" >> /tmp/$CONN
done < "./wifi01.nmconnection.template"

#use lsblk command to see the name of the disk
echo mounting $MOUNT 
mount $MOUNT /mnt
cd /mnt

NW_LOCATION=`find . -wholename *0/etc/NetworkManager/system-connections`
# find the connection you wish to use in /etc/NetworkManager/system-connections/ and copy it over 
echo "copying /tmp/$CONN"
echo "to $NW_LOCATION/$CONN"
cp /tmp/$CONN $NW_LOCATION/$CONN


echo "chmod $NW_LOCATION/$CONN"
chmod 600 $NW_LOCATION/$CONN

cd
umount /mnt

# boot the image and run 
# # rpm-ostree upgrade
# # systemctl reboot
# useradd -g anton -G wheel -m -u 1000 anton
# mkdir /home/anton/.ssh
# chmod 700 /home/anton/.ssh
# touch /home/anton/.ssh/authorized_keys
# chmod 600 /home/anton/.ssh/authorized_keys
# chown -R anton:anton /home/anton/.ssh/
