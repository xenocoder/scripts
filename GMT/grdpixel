#!/usr/bin/python
import sys,os

infile = sys.argv[1]

value=os.popen('grdinfo -C -M ' + infile).read()
values = value.split()

numpixels = int(values[9]) * int(values[10]) - int(values[15])
print numpixels
