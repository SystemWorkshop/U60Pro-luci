#!/bin/sh

sleep 1

BASE=/data/overlay
WORK=$BASE/work

DIRS="
bin
sbin
lib
usr/bin
usr/sbin
usr/lib
usr/libexec
usr/share
www
"

for d in $DIRS; do
    mkdir -p $BASE/$d
    mkdir -p $WORK/$d
done

mkdir -p $BASE/usr/lib
cp -a /usr/lib/opkg $BASE/usr/lib/ 2>/dev/null


mount_overlay() {
    SRC=$1
    mountpoint -q /$SRC && umount /$SRC 2>/dev/null

    mount -t overlay overlay \
        -o lowerdir=/$SRC,upperdir=$BASE/$SRC,workdir=$WORK/$SRC \
        /$SRC
}

for d in $DIRS; do
    mount_overlay $d
done
