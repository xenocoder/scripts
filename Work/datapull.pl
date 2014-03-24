#!/usr/bin/perl
#
# datapull.pl - 
#
# finds data that matches in a remote sensing file given year,mon,day,lon,lat <data>
# output are the lon and lat columns.
#
# This is useful for pulling out specific weeks/months of data to overlay
# on remotely sensed data.
#
# VERSION: 
#   0.10 (08/03/06 - EAH)
#   - Alpha testing release...
#

#**********************************************************
# Default variables and dependencies
#**********************************************************
use Getopt::Std;
use Time::Local;
use Time::Local 'timelocal_nocheck';
use File::Basename;

#***********************************************************
# CHECK ARGS, RETURN USAGE
#***********************************************************

$opt_o = 0;

my $USAGE = <<END;
$0 -o outfile datafile rsfile
  datafile    - The datafile to match
              Form: Year Month Day Lon Lat <other fields>
  rsfile      - The rsfile to find data in (e.g. RS2006001_2006031_sst.grd)
  -o outfile  : An outfile to write to (default is STDOUT)
END

getopts("o:");
die "$USAGE" unless (@ARGV >= 2);

die "Cannot open input file $ARGV[0]\n$USAGE" if (! -e $ARGV[0]);
die "Cannot access file $ARGV[1]\n$USAGE" if (! -e $ARGV[1]);
@data = `cat $ARGV[0]`;

#**********************************************************
# Load in data to match
#**********************************************************
$count = 0;
foreach $line (@data) {
   chomp($line);
   ($year, $month, $day, $lon, $lat) = split(" ", $line);
   next if ($year =~ /\D+/); #Skip if header line
   $eptime = timelocal(0,0,0,$day,$month-1,$year); 
   $index{$count} = $eptime;
   push @origdata, $line; #to send back out later
   push @lons, $lon;
   push @lats, $lat;
   $backtime = localtime($eptime);
#   print("Lon $lon LAT $lat $month $day $year $eptime $backtime\n");
   $count++;
}

#**********************************************************
# Go through RS files to match data
#**********************************************************
open(OUTFILE, ">$opt_o") if ($opt_o ne 0);

$sfile = basename($ARGV[1]);
$stime = timelocal_nocheck(0,0,0,substr($sfile,6,3),0,substr($sfile,2,4));
$etime = timelocal_nocheck(0,0,0,substr($sfile,14,3),0,substr($sfile,10,4));
$ttime = localtime($stime);
$ftime = localtime($etime);
@matches = grep { $index{$_} >= $stime && $index{$_} <= $etime } keys %index;

#match the data by time
foreach $match (sort @matches) {
   $backtime = localtime($index{$match});
#   print("$match $lons[$match] $lats[$match] $index{$match} $backtime\n");
   if ($opt_o eq 0) {
      print "$lons[$match] $lats[$match]\n";
   } else {
      print OUTFILE "$lons[$match] $lats[$match]\n";
   }
   #print OUTFILE "$origdata[$match]\n";
}

close(OUTFILE) if ($opt_o ne 0);

#**********************************************************
# Clean Up
#**********************************************************
#system("rm grdtrackin.tmp");
#system("rm ${opt_d}_matched.tmp");
#system("rm origdata.tmp");
#system("rm temp.tmp");
