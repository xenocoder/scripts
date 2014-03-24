#!/bin/bash
myvar1=`system_profiler SPAirPortDataType | grep -e "Current Wireless Network:" | awk '{print $4}'`
myvar2=`system_profiler SPAirPortDataType | grep -e "Wireless Channel:" | awk '{print $3}'`
airtoggle="on"

if [ "$myvar1" == "" ]; then
    echo "Airport: NOT CONNECTED"
    airtoggle="off"
else
    echo "Airport : $myvar1 - $myvar2"
fi

#! /bin/bash

if [ "$airtoggle" == "off" ]; then
    myen0=`ifconfig en0 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`

    if [ "$myen0" != "" ]; then
        echo "Ethernet 0 : $myen0"
    else
        echo "Ethernet 0 : INACTIVE"
    fi

    myen1=`ifconfig en1 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`

    if [ "$myen1" != "" ]; then
    echo "Ethernet 1  : $myen1"
    else
    echo "Ethernet 1  : INACTIVE"
    fi
else

    myen2=`ifconfig en2 | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`

    if [ "$myen2" != "" ]; then
    echo "AirPort  : $myen2"
    else
    echo "Airport  : INACTIVE"
    fi
fi
eip=`curl --silent http://checkip.dyndns.org | awk '{print $6}' | cut -f 1 -d "<"`
echo "External IP: $eip"
