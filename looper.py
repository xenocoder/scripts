#!/usr/bin/env python

outdir="/Users/ehowell/Sites/remnantsofreason/images/reviews"

import glob,os, os.path, sys

try:
    indir = sys.argv[1]
except IndexError:
    print "You must provide a directory!"
    sys.exit(0)

try:
    f = os.listdir(indir)
    f.sort
except IOError:
    print "The directory does not exist"

for dir in f:
    fulldir = '%s%s'%(indir,dir)
    if os.path.isdir(fulldir):
        albums = os.listdir(fulldir)
        for album in albums:
            fullalbum = '%s/%s'%(fulldir,album)
            if os.path.isdir(fullalbum):
                searcher = fullalbum + "/*.mp3"
                songs = glob.glob(searcher)
                if len(songs) > 0:
                    song = songs[0]
                    #print "~/Dropbox/pullArt.py \"%s\""%(song)
                    os.system("~/Dropbox/pullArt.py \"%s\""%(song))
