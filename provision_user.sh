#!/bin/bash
AUSER=fuser
useradd $AUSER
mkdir /home/$AUSER/.ssh
chmod 700 /home/$AUSER/.ssh
cp /root/.ssh/authorized_keys /home/$AUSER/.ssh/authorized_keys
chmod 600 /home/$AUSER/.ssh/authorized_keys
chown -R $AUSER:$AUSER /home/$AUSER/.ssh/
