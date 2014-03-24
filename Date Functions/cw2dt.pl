#!/usr/bin/perl

use Time::Local;
use Time::Local 'timelocal_nocheck';

if ($ARGV[0] =~ /^[A-Z]/) {
   $outtime1 = timelocal_nocheck(0,0,0,substr($ARGV[0],6,3),0,substr($ARGV[0],2,4));
   $outtime2 = timelocal_nocheck(0,0,0,substr($ARGV[0],14,3),0,substr($ARGV[0],10,4));
} else {
   $outtime1 = timelocal_nocheck(0,0,0,substr($ARGV[0],4,3),0,substr($ARGV[0],0,4));
   $outtime2 = timelocal_nocheck(0,0,0,substr($ARGV[0],12,3),0,substr($ARGV[0],8,4));
}

($sec1,$min1,$hour1,$mday1,$mon1,$year1) = localtime($outtime1);
$year1+=1900;
$mon1++;

print("$year1 $mon1 $mday1\n");
