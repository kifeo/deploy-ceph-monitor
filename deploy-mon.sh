#!/bin/sh

## as reference
id=$1

## check argument
if [ $# -eq 0 ]
then
	echo "No argument provided, indicate the node id"
	exit
fi

DIRECTORY=/var/lib/ceph/mon/ceph-proxmox$1
TMP=tmp
PUBLIC_ADDR=10.0.10.1$1

## perform the commands on the node
ssh proxmox$1 << EOF

echo ''
echo 'creating ceph monitor on proxmox$1 with IP $PUBLIC_ADDR'
echo ''

## check if monitor already exists
if [[ -d $DIRECTORY ]]
then
	echo "monitor already exists, exiting"
	exit
fi

## else create the monitor

## create /var/lib/ceph/mon/ceph-proxmox$1
echo 'creating $DIRECTORY folder\n'
mkdir $DIRECTORY

## create tmp folder
echo "creating $TMP folder"
mkdir $TMP

## get keyring
echo "getting keyring"
ceph auth get mon. -o $TMP/keyring

## get getmap
echo "getting getmap"
ceph mon getmap -o $TMP/getmap

## create monitor
echo "creating monitor"
ceph-mon -i proxmox$1 --mkfs --monmap $TMP/getmap --keyring $TMP/keyring

## start monitor
echo "starting monitor"
ceph-mon -i proxmox$1 --public-addr $PUBLIC_ADDR

## delete $TMP folder
echo "delete $TMP"
rm -Rf $TMP

echo ''
echo 'job done; now edit the ceph.conf and add the monitor entry'
echo "
###
[mon.proxmox$1]
        host = proxmox$1
        addr = $PUBLIC_ADDR:6789
###
"

EOF
