#! /bin/ksh

# Shell script in place of aliases to shorten the chmod (+-) 
# commands.
#
# Taken from Unix Power Tools by EAH on 09/09/97.
#
# Calling structure is: cx filename, or similar.

case "$0" in 
     *cx)  chmod +x "$@" ;;
     *cw)  chmod +w "$@" ;;
     *c-w) chmod -w "$@" ;;
     *)    print "Usage: c[x, w, -w] filename"
esac


