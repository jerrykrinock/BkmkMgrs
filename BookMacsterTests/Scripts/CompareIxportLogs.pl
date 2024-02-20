#!/usr/bin/perl

use strict ;

use Date::Parse ;
use File::Spec ;
use File::Temp ;
use IPC::Run ;
use Storable ;
use File::Util ;
use List::Util qw[min max];


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

my $error = 0 ;
my $iLine = 1 ;
my @changes1 ;
my @changes2 ;
while (my $line1 = <TEXT1>) {
	my $line2 = <TEXT2> ;

	my $found ;
	do {
		# Ignore the lists of added children and added tags, because their order is nondetermininstic, and due to truncating the list, corresponding lists in the two files may even show different items.
		$line1 =~ s/(Add|Delete)\s+(\d+)\s+(Children|Tags)\s+\(.+\)\n/\1 \2 \3\n/ ;
		$line2 =~ s/(Add|Delete)\s+(\d+)\s+(Children|Tags)\s+\(.+\)\n/\1 \2 \3\n/ ;
		# $1 is the first match, Add|Delete
		$found = $1 ;
	} while ($found) ;
	
	if (($line1 =~ m/CHANGE/) && ($line1 =~ m/CHANGE/)) {
		push (@changes1, $line1) ;
		push (@changes2, $line2) ;
	}
	elsif ($line1 ne $line2) {
		$error = sprintf "Unequal lines at line $iLine\n$line1$line2" ;
		chomp ($error) ;
		last ;
	}
	else {
		# Orderize and compare CHANGES which have been collected in the previous several lines
		@changes1 = sort(@changes1) ;
		@changes2 = sort(@changes2) ;
		for (my $i=0; $i<@changes1; $i++) {
			my $change1 = $changes1[$i] ;
			my $change2 = $changes2[$i] ;
			if ($change1 ne $change2) {
				# Some versions of BookMacster may or may not truncate CHANGES with ellipses, and the truncation length may also be different.  To filter out those changes, we split each of the two changes into a prefix (before the ellipsis) and a suffix (after the eliipsis) and compare the shortest common string between the two.
				my ($prefix1, $suffix1) = split ('…', $change1) ;
				my ($prefix2, $suffix2) = split ('…', $change2) ;
				my $prefixLen1 ;
				my $suffixLen1 ;
				if (defined($suffix1)) {
					$prefixLen1 = length($prefix1) ;
					$suffixLen1 = length($suffix1) ;
				}
				else {
					$prefixLen1 = length($prefix1) ;
				}
				my $prefixLen2 ;
				my $suffixLen2 ;
				if (defined($suffix2)) {
					$prefixLen2 = length($prefix2) ;
					$suffixLen2 = length($suffix2) ;
				}
				else {
					$prefixLen2 = length($prefix2) ;
				}
				my $prefixLen = min($prefixLen1, $prefixLen2) ;
				my $suffixLen ;
				if ($suffixLen1 && $suffixLen2) {
					$suffixLen = min($suffixLen1, $suffixLen2) ;
				}
				elsif ($suffixLen1) {
					$suffixLen = $suffixLen1 ;
				}
				elsif ($suffixLen2) {
					$suffixLen = $suffixLen2 ;
				}
				
				$prefix1 = substr($prefix1, 0, $prefixLen) ;
				$prefix2 = substr($prefix2, 0, $prefixLen) ;
				if ($suffixLen) {
					$suffix1 = substr($change1, -$suffixLen) ;
					$suffix2 = substr($change2, -$suffixLen) ;
				}
				
				# Re-compare.  Note that if there were no ellipses, $prefix1 and $prefix2 will be the entire strings $change1 or $change2.
				if (($prefix1 ne $prefix2) || ($suffix1 != $suffix2)) {
					my $beginRange = $iLine - @changes1 ;
					my $endRange = $iLine - 1 ;
					$error = sprintf "Unequal CHANGE in line range $beginRange:$endRange\n   $change1\n$   change2" ;
					chomp ($error) ;
					last ;
				}
			}
		}
		if ($error) {
			last ;
		}
		
		# Empty the changes arrays so they will be ready for next group of changes
		@changes1 = () ;
		@changes2 = () ;
	}
	
	$iLine++ ;
}

exit $error ;