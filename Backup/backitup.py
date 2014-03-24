#!/usr/bin/env python
# This is just a simple script to backup files to an external drive
#
# written 7/27/07 by EAH
# 
# Uses: datetime, os, sys
import datetime, os, sys

#################################################
#set some variables
#################################################
#drive to back up to
backupdrive = "/media/ACOMP\ LINUX" # USB drive

#directories to back up
directories = ['Artwork','bin','code','Documents','lib','papers','projects','talks','Templates','work']

#################################################
# Get the time and make the outfile
#################################################
today = datetime.date.today()
outfile = ("/home/ehowell/logs/backitup/%s_backitup.log"%(today))
file = open(outfile, 'w')

#################################################
# set timestamp in logfile
#################################################
nowtime = datetime.datetime.now()
file.write("Backing up of files commencing on: " + nowtime.ctime() + "\n")
file.close()

#################################################
# Cycle through directories backing up each one
#################################################
for directory in directories:
    nowtime = datetime.datetime.now()
    file = open(outfile, 'a')
    file.write("**************************************************************\n")
    file.write("Backing up directory " + directory + " on " + nowtime.ctime() + "\n")
    file.close()
    os.system("rsync -av /home/ehowell/" + directory + "/ " + backupdrive + "/" + directory + "/ >> " + outfile + "  2>&1")

#################################################
# Finish up and write timestamp
#################################################
file = open(outfile, 'a')
nowtime = datetime.datetime.now()
file.write("Backing up of files finished on: " + nowtime.ctime() + "\n")
file.close()
