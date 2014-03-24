#!/bin/bash

# Get report from http://mkwc.ifa.hawaii.edu/vmap/current/index.cgi
#Don't forget PATHS to executables in Geektool!

/usr/local/bin/lynx http://mkwc.ifa.hawaii.edu/vmap/current/index.cgi -dump | grep "Honolulu" >> /Users/evan.howell/Dropbox/log/vogreport.log
# For MacPorts
#/opt/local/bin/lynx http://mkwc.ifa.hawaii.edu/vmap/current/index.cgi -dump | grep "Honolulu" >> /Users/evan.howell/Dropbox/log/vogreport.log
rawreport=`tail -n 1 /Users/evan.howell/Dropbox/log/vogreport.log`

city=`echo $rawreport | cut -d" " -f1`
rawdate=`echo $rawreport | cut -d" " -f2,3`
date=`date -j -f "%m/%d/%y %H:%M" "$rawdate" "+%b %d %Y %H:%M"`
echo "VOG report for `echo $rawreport | cut -d" " -f1` on $date"
echo -e "Aerosol Count:\t `echo $rawreport | cut -d" " -f4`"
echo -e "Air quality:\t `echo $rawreport | cut -d" " -f5`"
echo -e "Trend:\t\t `echo $rawreport | cut -d" " -f6`"
echo "15 `tail -n20 ~/Dropbox/log/vogreport.log | awk '{printf "%d ",$4}'`" | cat | /Users/evan.howell/Dropbox/bin/spark
