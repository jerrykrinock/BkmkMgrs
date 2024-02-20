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

my $tolerance100nsTicks = 1000e7 ; # 1000 seconds
my $error = 0 ;
my $iLine = 1 ;
while (my $line1 = <TEXT1>) {
	my $line2 = <TEXT2> ;

	my $date1 ;
	my $date2 ;
	my $diff100nsTicks = 0 ;
	do {
		$line1 =~ s/"(date_added|date_modified)"\s+:\s+"(\d+)"/"\1" : "000"\n/ ;
		$date1 = $2 ;
		$line2 =~ s/"(date_added|date_modified)"\s+:\s+"(\d+)"/"\1" : "000"\n/ ;
		$date2 = $2 ;
		if ($date1 || $date2) {
			$diff100nsTicks = abs($date2 - $date1) ;
			if ($diff100nsTicks > $tolerance100nsTicks) {
				# Break out of loop.  Can't use 'last' in 'do'
				$date1 = 0 ;
			}
			else {
				$diff100nsTicks = 0 ;
			}
		}
	} while ($date1 > 0) ;
	if ($diff100nsTicks > 0) {
		my $diffSeconds = $diff100nsTicks/1e7 ;
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