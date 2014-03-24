#!/usr/bin/perl

use Time::Local;
use Time::Local 'timelocal_nocheck';

if ($ARGV[0] =~ /^[A-Z]/) {
   $outtime = timelocal_nocheck(0,0,0,substr($ARGV[0],6,3),0,substr($ARGV[0],2,4));
} else {
   $outtime = timelocal_nocheck(0,0,0,substr($ARGV[0],4,3),0,substr($ARGV[0],0,4));
}
$backtime = localtime($outtime);

print("$outtime $backtime\n");
print("$outtime\n");
