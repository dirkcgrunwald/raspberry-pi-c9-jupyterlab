#!/bin/sh

##
## Update the network configurations
##
model=$(cat /sys/firmware/devicetree/base/model)
echo "It's a $model"

/bin/rm -f /etc/network/interfaces.d/*

##
## This is done to avoid throwing an error which terminates the script
## if the directory is empty
##
srcdir="/boot/does-not-exist7636784"
custdir="/boot/customize/network-interfaces.d"

test -f "$custdir/wpa_supplicant.conf" && \
    (cp "$custdir/wpa_supplicant.conf" /etc/wpa_supplicant && \
	    chmod ugo+r /etc/wpa_supplicant/wpa_supplicant.conf )

if [ "$model" = "Raspberry Pi 2 Model B Rev 1.1" ]; then
    srcdir="$custdir/pi-2b"
elif [ "$model" = "Raspberry Pi Zero W Rev 1.1" ]; then
    srcdir="$custdir/pi-zero-w"
elif [ "$model" = "Raspberry Pi 3 Model B Plus Rev 1.3" ]; then
    srcdir="$custdir/pi-3b"

fi

if [ -d "$srcdir" ]; then
    for file in $(find "$srcdir" -maxdepth 1 -type f -printf "%p\n" ) ; do
	echo "file is $file"
	cp $file /etc/network/interfaces.d
    done
fi

/bin/systemctl restart networking

