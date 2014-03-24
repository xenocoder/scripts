#!/usr/bin/python
#################################################
# GRDAVERAGE          GMT SCRIPTS
#
# NAME
#       grdaverage
#
# SYNOPSIS
#       grdaverage [OPTION]... [FILE(S)]
#
# DESCRIPTION
#       grdaverge is a python script to make an
#       average of several GMT files.
#
#       options -G, -I, and -R MUST be given or the script will exit
#
#       -G outfile, --outfile=outfile
#           provide filename to write output to.
#           default is grdaverage_out.grd
#
#       -I inc, --increment=inc
#           provide increment size
#
#       -R range, --range=range
#           provide range to average over
#
#       -V, --verbose
#           verbose mode, print output to screen
#
# REQUIRES
#       optparse
#           OptionParser from python module optparse
#
#       os
#           The os python module
#
#       sys
#           The sys python module
#
# AUTHOR
#       Written by Evan Howell
#
# REPORTING BUGS
#       Report bugs to <evan.howell@noaa.gov>
#
# VERSION
#       1.0 (10JUL2007)
#           Initial coding of script
#
#################################################
# import necessary modules
#################################################
import os, sys
from optparse import OptionParser

#################################################
# Process command line options
#################################################
parser = OptionParser()
parser.add_option("-G", "--outfile", dest="filename", help="Provide outfile file for average", metavar="FILE")
parser.add_option("-I", "--increment", dest="inc", help="Provide increment size for average", metavar="INC")
parser.add_option("-R", "--range", dest="range", help="Provide range to cut data to", metavar="RANGE")
parser.add_option("-V", "--verbose", action="store_true", dest="verbose", default=False, help="don't print messages to terminal")
(options, args) = parser.parse_args()

errstr = "Error: -G <file>, -R <range>, and -I <increment> must be set, exiting..."

if options.filename and options.range and options.inc: # Make sure required options are set
    outfile = options.filename
    range = " -R" + options.range + " "
    inc = " -I" + options.inc + " "
    extra = ""
else:
    print errstr
    sys.exit()

# if less than 2 files then exit
if len(args) < 2:
    print "you need at least two files to average! Exiting..."
    sys.exit()

# if one file doesn't exist exit
for file in args:
    if os.path.isfile(file) == 0:
        print file, "does not exist, exiting..."
        sys.exit()

if options.verbose:
    print "Writing to file:", options.filename
    verbose = " -V "
else:
    verbose = ""

#Find out if files are Pixel or normal registration
value = os.popen("grdinfo " + args[0] + " | grep ixel").read()
if value:
    extra = extra + " -F "

#################################################
# go through files and pull binary data into
# one large file and blockmean
#################################################

binfile = "grdaverage_tmp.bin"
blkfile = "grdaverage_tmp.blk"

if os.path.isfile(binfile):
    os.remove(binfile)
    if options.verbose:
        print "Removing file:", binfile

for file in args: # cycle through all files and write to one temporary binary file
    os.system("grd2xyz " + verbose + range + file + " -bo -fg >> grdaverage_tmp.bin")

# Run blockmean on the temporary file
#print "blockmean ", binfile, "-bi -bo -fg " , verbose , inc , range , extra , " > " , blkfile 
os.system("blockmean " + binfile + " -bi -bo -fg " + verbose + inc + range + extra + " > " + blkfile) 

# Run xyz2grd on the blockmean outfile
#print "xyz2grd ", blkfile, "-bi -bo -fg " , verbose , inc , range , extra , " -G" , outfile 
os.system("xyz2grd " + blkfile + " -bi -bo -fg " + verbose + inc + range + extra + " -G" + outfile) 

#clean up and announce if verbose mode
if options.verbose:
    print "Removing temporary files..."
os.remove(binfile)
os.remove(blkfile)

if os.path.isfile(outfile) and options.verbose:
    print "final file", outfile, "was created..."
