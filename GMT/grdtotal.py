#!/usr/bin/python
#################################################
# grdtotal.py is a script to summate all of the 
# non-NAN values in a GMT grd file
#
# imports: os, sys, array modules
#
# call: grdtotal.py <file>
#
# return: the total value of all the gridpoints
# in the file
#
# Version: 1.0 by EAH on 09JUL2007
#################################################

import os, sys,array

infile = sys.argv[1]

os.system('grd2xyz -S -ZTLf ' + infile + ' > grdtotal_bin.tmp')
file = open('grdtotal_bin.tmp', 'rb')
bytes = file.read()
numbytes = len(bytes)/4 # 4 bytes per point

file = open('grdtotal_bin.tmp', 'rb')
arr = array.array('f')
arr.read(file, numbytes)

sum = 0

for value in arr:
    sum = sum + value

print sum

os.remove('grdtotal_bin.tmp')
