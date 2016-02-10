#!/bin/bash

if [ $USER != 'root' ]; then
    echo 'You must be root!'
    exit 1
fi

if [ ! -d /usr/lib/systemd ]; then
    echo 'Systemd must be installed!'
    exit 1
fi

if [ ! -d /etc/nagios ]; then
    echo 'Nagios not installed!'
    exit 1
fi

DIR=/etc/nhra

echo 'Installing dependencies...'
yum install -y python-pip mongodb mongodb-server
pip install flask pymongo

echo 'Configuring...'
mkdir $DIR
cp nhra $DIR/.
cp nhra.conf $DIR/.
cp nhra.service /usr/lib/systemd/system/.
cp templates $DIR/.
cp LICENSE $DIR/.
cp README.md $DIR/.
touch /var/log/nhra.log

echo 'Enabling services...'
systemctl daemon-reload
systemctl enable nhra
systemctl enable mongod
systemctl start mongod

echo 'Done.'
echo 'To start NHRA, type:'
echo '$ systemctl start nhra'
echo '---'
echo 'NHRA runs on port 5000, make sure your firewall is set to allow TCP traffic on that port'
echo 'Enjoy!'