#!/usr/bin/perl
#
# datamatch.pl - 
#
# Attempts to match "point" remotely sensed data from GMT files given year,mon,day,lon,lat <data>
#
# VERSION: 
#   0.10 (08/02/06 - EAH)
#   - Alpha testing release...
#
#   0.11 (08/02/06 - EAH)
#   - Changed outfile from .out to .csv so openoffice calc would read it as a spreadsheet...
#   - Added -d " " option to paste the outfile so files would be space separated
#
#   0.20 (04/04/08 - EAH)
#   - Added a check in to make sure that the input data range was not greater than the 
#   - remote sensing grid's range. This was not matching data and not reporting the error

#**********************************************************
# Default variables and dependencies
#**********************************************************
use Getopt::Std;
use Time::Local;
use Time::Local 'timelocal_nocheck';
use File::Basename;
$opt_d = 0;
$opt_w = 0;

#**********************************************************
# Default directories - need to be changed on local system
#**********************************************************
$basedir = "/home/DATA";
#***********************************************************
# CHECK ARGS, RETURN USAGE
#***********************************************************

my $USAGE = <<END;
$0 -d <rsdatatype> -w datafile
  datafile    - The datafile to match
              Form: Year Month Day Lon Lat <other fields>
  -d rsdatatype  : The type of data to match
  -w : timestep is weekly
END

getopts("d:mw"); die $USAGE if ($opt_d eq 0 or $opt_d eq "");
&getdir; #Get the directory
die "$USAGE" unless (@ARGV >= 1);
@files = `ls $dir`; die "Directory $dir empty!" if ($files[0] eq ""); # Get the RS files.
print("type $type timestep $timestep Dir $dir\n");
die "Cannot open input file $ARGV[0]\n$USAGE" if (! -e $ARGV[0]);

###################################################################
#INITIAL CHECK TO MAKE SURE DATARANGE IS WITHIN BOUNDS OF GRDFILES!
$checkstatus = &checkranges;
die $checkstatus if ($checkstatus ne 0);
###################################################################

@data = `cat $ARGV[0]`;
$linenum = $#data+1;
print("there are $linenum lines to read\n");

#**********************************************************
# Default variables
#**********************************************************
$tempfile = "grdtrackin.tmp";
$matchedfile = "${opt_d}_matched.tmp";
$outfile = "origdata.tmp";
$finalfile = "datamatch_${opt_d}_${timestep}.csv";
system("rm $matchedfile") if ( -e $matchedfile );
system("rm $tempfile") if ( -e $tempfile );

#**********************************************************
# Load in data to match
#**********************************************************
$count = 0;
foreach $line (@data) {
   chomp($line);
   ($year, $month, $day, $lon, $lat) = split(" ", $line);
   $eptime = timelocal(0,0,0,$day,$month-1,$year); 
   $index{$count} = $eptime;
   push @origdata, $line; #to send back out later
   push @lons, $lon;
   push @lats, $lat;
#   $backtime = localtime($eptime);
#   print("Lon $lon LAT $lat $month $day $year $eptime $backtime\n");
   $count++;
}

#**********************************************************
# Go through RS files to match data
#**********************************************************
open(OUTFILE, ">$outfile");

# make date array for RS files
#$i = 0;
#foreach $file (@files) {
for $i (0..$#files) {
   $oldfile = $file;
   $lasttime = $etime;
   open(TEMPFILE, ">$tempfile");
   $file=@files[$i];
   chomp($file);
   $sfile = basename($file);
   $stime = timelocal_nocheck(0,0,0,substr($sfile,6,3),0,substr($sfile,2,4));
   $etime = timelocal_nocheck(0,0,0,substr($sfile,14,3),0,substr($sfile,10,4));
   $ttime = localtime($stime);
   $ftime = localtime($etime);
   die "You have a missing file around $oldfile ($etime) and  $file ($stime)" if ($i gt 1 and $stime ne $lasttime + 86400); #Die if not one day later than last file...
   @matches = grep { $index{$_} >= $stime && $index{$_} <= $etime } keys %index;

#match the data by time
   foreach $match (sort @matches) {
      $backtime = localtime($index{$match});
      #print("$match $lons[$match] $lats[$match] $index{$match} $backtime\n");
      print TEMPFILE "$lons[$match] $lats[$match]\n";
      print OUTFILE "$origdata[$match]\n";
   }

   close(TEMPFILE);
   if ( -s $tempfile ) {
      print("working on file $file from time $stime to $etime\n");   
      #print("grdtrack $tempfile -Q0 -G$file >> $matchedfile\n");
      system("grdtrack $tempfile -Q0.1 -Z -G$file >> $matchedfile");
   }
}

close(OUTFILE);

print("paste -d \" \" $outfile $matchedfile > $finalfile\n");
system("paste -d \" \" $outfile $matchedfile > temp.tmp"); #unsorted
system("sort +0 -1 +1 -2 +2 -3 -n temp.tmp > $finalfile"); #sort numerically by year, month, day
print("processed $count lines\n");

#**********************************************************
# Clean Up
#**********************************************************
system("rm grdtrackin.tmp");
system("rm ${opt_d}_matched.tmp");
system("rm origdata.tmp");
system("rm temp.tmp");


#**********************************************************
# Subroutines
#**********************************************************
sub getdir {
   $matchsuff = "*.grd";
   $timestep = "monthly"; #assume monthly;
   $type = $opt_d;
   $timestep = "weekly" if ($opt_w eq 1);

   if ($type eq "modis") {
      if ($timestep eq "weekly") {
         $timestep = "8day";
      } 
      $rsdir = "modis";
   } elsif ($type eq "seawifs") {
      $rsdir = "seawifs";
      $matchsuff = "*chla.grd";
   } elsif ($type eq "seawifsgrad") {
      $rsdir = "seawifs";
      $matchsuff = "*chla_gradient.grd";
   } elsif ($type eq "aviso") {
      $rsdir = "aviso";
      $matchsuff = "*ssh.grd";
   } elsif ($type eq "avisou") {
      $rsdir = "aviso";
      $matchsuff = "*u.grd";
   } elsif ($type eq "avisov") {
      $rsdir = "aviso";
      $matchsuff = "*v.grd";
   } elsif ($type eq "avisomag") {
      $rsdir = "aviso";
      $matchsuff = "*mag.grd";
   } elsif ($type eq "pathfinder") {
      $rsdir = "pathfinder/V4";
      $matchsuff = "*sst.grd";
   } elsif ($type eq "pathfindergrad") {
      $rsdir = "pathfinder/V4";
      $matchsuff = "*sst_dmag.grd";
   } elsif ($type eq "gac") {
      $rsdir = "gac";
   } elsif ($type eq "reynolds") {
      $rsdir = "reynolds";
      $matchsuff = "*sst.grd";
   } elsif ($type eq "reynoldsgrad") {
      $rsdir = "reynolds";
      $matchsuff = "*sst_gradient.grd";
   } else {
      die ("proper types are: modis seawifs aviso avisou avisov gac pathfinder reynolds");
   }
   $dir = "$basedir/$rsdir/$timestep/$matchsuff";
}

sub checkranges {
   my $checkstatus = 0;
   local $ranges = `awk '{print \$4,\$5}' $ARGV[0] | minmax -C`;
   chomp($ranges);
   (local $x1, local $x2, local $y1, local $y2) = split(" ", $ranges);
   local $gmtranges = `grdinfo -C $files[0]`;
   chomp($gmtranges);
   (local $gmtfile, local $gx1, local $gx2, local $gy1, local $gy2) = split(" ", $gmtranges);

   if ($x1 < $gx1 or $x2 > $gx2 or $y1 < $gy1 or $y2 > $gy2) {
      $checkstatus = "Data range $x1/$x2/$y1/$y2 outside of GMT range $gx1/$gx2/$gy1/$gy2, exiting...\n";
   } 
   return $checkstatus;
}
