#!/usr/bin/perl

# This script just plots the turtle dates at every x spacing...
#
# Written 8/5/04 by EAH

use Dateutil;
use Getopt::Std;
#getopts('J:');

$infile = $ARGV[0];
$spacer = $ARGV[1];
#$psfile = $ARGV[2];
open(INFILE, $infile) or die "Cannot open file $infile";
open(OUTFILE, ">temp.txt");

#print("pstext temp.txt -J${opt_J} -R -O -K >> $psfile\n");

$count = 0;
while ($line = <INFILE>) {
   chomp($line);
   ($eday,$time,$lon,$lat,$code) = split(" ",$line);
   $cday = Dateutil::e2d($eday);
   $lon = $lon + 0.25;
   $lat = $lat + 0.25;
   $mod = $count % $spacer;
   if (($mod) eq 0 or $count eq 1) {
      print OUTFILE "$lon $lat 12 0 -Helvetica 0 $cday\n";
#      print "$lon $lat 12 0 -Helvetica 0 $cday\n";
   }
   $count++;
}
print OUTFILE "$lon $lat 12 0 -Helvetica 0 $cday\n";
close(OUTFILE);
#system("pstext temp.txt -J$opt_J -R -O -K >> $psfile");
