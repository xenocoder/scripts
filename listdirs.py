#!/usr/bin/env python
import os
maindirs=[]
outfile = open('albumlist.txt','w')
f = os.listdir('/Volumes/Big Bubba/Evan/mp3')
f.sort()
#for dir in f[0:10]:
for dir in f:
    if os.path.isdir(dir):
#        print dir
        f2 = os.listdir(dir)
        f2.sort
        for album in f2:
            subdir = '%s/%s'%(dir,album)
            if os.path.isdir(subdir):
                outfile.writelines('%s - %s\n'%(dir,album))
outfile.close()
