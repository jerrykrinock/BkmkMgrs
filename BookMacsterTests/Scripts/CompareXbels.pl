#!/usr/bin/perl

use strict ;

use Date::Parse ;
use File::Spec ;
use File::Temp ;
use IPC::Run ;
use Storable ;
use File::Util ;

# The following is added for debugging, per this recommendation:
# http://groups.google.com/group/comp.lang.perl.misc/browse_thread/thread/41f9217de9321e7c#
require Carp; 
$SIG{INFO} = sub { Carp::cluck("SIGINFO") }; 
$SIG{QUIT} = sub { Carp::confess("SIGQUIT") }; 
# So that if this program gets stuck, you can press ^T to get a backtrace, and ^\ to get a backtrace and kill the program.

# Sometimes this is necessary for modules in this directory to be found at compile time when running on my Mac:
use lib '/Users/jk/Documents/Programming/Scripts' ;

use SSYUtils2 ;

my $numberOfArguments = $#ARGV + 1 ;
my $path1 = $ARGV[0] ;
my $path2 = $ARGV[1] ;

open (TEXT1, $path1) ;
open (TEXT2, $path2) ;

my $toleranceSeconds = 1000 ;
my $error = 0 ;
my $iLine = 1 ;
while (my $line1 = <TEXT1>) {
	my $line2 = <TEXT2> ;

	my $done = 0 ;
	my $diffSeconds = 0 ;
	do {
		# Extract the values of the 'added' and 'modification' times, and also remove them from the $line1 and $line2.  The reason for removing them is so that the following comparison of $line1 and $line2 will result in equality.  Not only may the dates be different, but also the order of the three attributes 'added', 'modified', and 'href' may be different in the two files, and this is not significant.  If we eliminate two of them, then the order must be the same because there is only one way to order one attribute.
		$line1 =~ s/(added)="(\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d[-+]\d+)"// ;
		my $addDate1 = str2time($2) ;
		$line1 =~ s/(modified)="(\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d[-+]\d+)"// ;
		my $modDate1 = str2time($2) ;
		$line2 =~ s/(added)="(\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d[-+]\d+)"// ;
		my $addDate2 = str2time($2) ;
		$line2 =~ s/(modified)="(\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d[-+]\d+)"// ;
		my $modDate2 = str2time($2) ;

		if ($addDate1 || $addDate2) {
			$diffSeconds = abs($addDate2 - $addDate1) ;
			if ($diffSeconds > $toleranceSeconds) {
				# Break out of loop.  Can't use 'last' in 'do'
				$done = 1 ;
			}
			else {
				$diffSeconds = 0 ;
			}
		}

		if ($modDate1 || $modDate2) {
			$diffSeconds = abs($modDate2 - $modDate1) ;
			if ($diffSeconds > $toleranceSeconds) {
				# Break out of loop.  Can't use 'last' in 'do'
				$done = 1 ;
			}
			else {
				$diffSeconds = 0 ;
			}
		}
		
		if (($addDate1==0) && ($addDate1==0) && ($modDate1==0) && ($modDate1==0)) {
			$done = 1 ;
			# Even though we have corrected the order of the attributes, there can still be differences in whitespace, since each non-first attribute was preceded by a space.  So we need to collapse consecutive spaces
			my $collapses = 0 ;
			do {
				$collapses = $line1 =~ s/  / / ;
			} while ($collapses > 0) ;
			do {
				$collapses = $line2 =~ s/  / / ;
			} while ($collapses > 0) ;
			# Also, there could be a whitespace at the end of the attributes, before the closing >
			do {
				$collapses = $line1 =~ s/" >/">/ ;
			} while ($collapses > 0) ;
			do {
				$collapses = $line2 =~ s/" >/">/ ;
			} while ($collapses > 0) ;
		}
	} while (!$done) ;
	if ($diffSeconds > 0) {
		$error = sprintf "Excessive time difference $diffSeconds seconds at line $iLine" ;
		last ;
	}
	
	if ($line1 ne $line2) {
		$error = sprintf "Unequal lines at line $iLine\n$line1$line2" ;
		chomp ($error) ;
		last ;
	}
	
	$iLine++ ;
}

exit $error ;