#!/bin/bash

#This script needs lynx and internet

#Get current weather from weatherunderground!
lynx -dump http://www.wunderground.com/cgi-bin/findweather/hdfForecast?query=96813 | grep "APRSWXNET Honolulu HI,"

#VOG REPORT
# Get report from http://mkwc.ifa.hawaii.edu/vmap/current/index.cgi

lynx http://mkwc.ifa.hawaii.edu/vmap/current/index.cgi -dump | grep "Honolulu" >> /Users/ehowell/log/vogreport.log
rawreport=`tail -n 1 /Users/ehowell/log/vogreport.log`

city=`echo $rawreport | cut -d" " -f1`
rawdate=`echo $rawreport | cut -d" " -f2,3`
date=`date -j -f "%m/%d/%y %H:%M" "$rawdate" "+%b %d %Y %H:%M"`
echo "VOG report for `echo $rawreport | cut -d" " -f1` on $date"
echo -e "Aerosol Count:\t `echo $rawreport | cut -d" " -f4`"
echo -e "Air quality:\t `echo $rawreport | cut -d" " -f5`"
echo -e "Trend:\t\t `echo $rawreport | cut -d" " -f6`"
