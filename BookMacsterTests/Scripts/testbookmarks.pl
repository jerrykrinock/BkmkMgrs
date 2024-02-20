#!/usr/bin/perl

use strict ;
use File::Util ;

my $fileUtil = File::Util->new() ;
my $home = $ENV{HOME};

my $nArgs = $#ARGV + 1 ;

if ($nArgs < 2) {
	print "Usage: testbookmarks.pl testName browser1 [browser2] [browser3] ...\n   testName = name of subdirectory in ../Test/Data/BrowserBookmarks/ from which bookmarks files should be copied\n   browser1, browser2, etc. may be browser names such as Camino, Chrome, Firefox, etc.  Simply
	'Firefox' gives 'ieri3hz1.default'.  To specify other Firefox profiles, use Firefox-<profile>, for example: 'Firefox-dev'." ;
	my $badArgsError = 65 ;
	exit($badArgsError) ;
}

my $testName = $ARGV[0] ;
my $i = 1 ;
# TODO: Why doesn't this work? ...
# my $sourceDir = "$0/../../Data/BrowserBookmarks/$testName" ;
my $sourceDir = "/Users/jk/Documents/Programming/Projects/BookMacster/Test/Data/BrowserBookmarks/$testName" ;
my @sourceFilenames = $fileUtil->list_dir($sourceDir,'--no-fsdots');
for($i=1; $i<$nArgs; $i++) {
	my $browserName = $ARGV[$i] ;
	my $destinDir ;
	my @auxDirsToRemove = () ;
	my @auxFilesToRemove = () ;
	my @sourceFiles = () ;
	# The = () empties out the array from previous iteration
	
	if (0) {
	}
	elsif ($browserName eq "Camino") {
		$destinDir = "$home/Library/Application Support/Camino" ;
		push(@auxFilesToRemove, "bookmarks.plist.bak") ;
	}
	elsif ($browserName eq "Chrome") {
		$destinDir = "$home/Library/Application Support/Google/Chrome/Default" ;
		push(@auxFilesToRemove, "Bookmarks.bak") ;
	}
	elsif ($browserName eq "Chromium") {
		$destinDir = "$home/Library/Application Support/Chromium/Default" ;
		push(@auxFilesToRemove, "Bookmarks.bak") ;
	}
	elsif ($browserName eq "Firefox") {
		$destinDir = "$home/Library/Application Support/Firefox/Profiles/ieri3hz1.default" ;
		push(@auxDirsToRemove, "bookmarkbackups") ;
		push(@auxFilesToRemove, "bookmarks.html", "places.sqlite-journal") ;
	}
	elsif ($browserName eq "Firefox-dev") {
		$destinDir = "$home/Library/Application Support/Firefox/Profiles/dev" ;
		push(@auxDirsToRemove, "bookmarkbackups") ;
		push(@auxFilesToRemove, "bookmarks.html", "places.sqlite-journal") ;
	}
	elsif ($browserName eq "iCab") {
		$destinDir = "$home/Library/Preferences/iCab" ;
	}
	elsif ($browserName eq "OmniWeb") {
		$destinDir = "$home/Library/Application Support/OmniWeb 5" ;
		push(@auxDirsToRemove, "ServerBookmarks") ;
		push(@auxFilesToRemove, "Bookmarks.html~", "Favorites.html~", "Published.html~") ;
	}
	elsif ($browserName eq "Opera") {
		$destinDir = "$home/Library/Opera" ;  # New location per Opera 11.x
	}
	elsif ($browserName eq "Safari") {
		$destinDir = "$home/Library/Safari" ;
	}
	elsif ($browserName eq "Shiira") {
		$destinDir = "$home/Library/Application Support/Shiira" ;
	}
	
	my $nCopied = 0 ;
	foreach my $sourceFilename (@sourceFilenames) {
		my @nameComponents = split(/\./, $sourceFilename) ;
		my $filenamePrefix = $nameComponents[0] ;
		# Strip the "-dev" from, for example, "Firefox-dev"
		my @namenameComponents = split (/-/, $browserName) ;
		my $browserNamePrefix = $namenameComponents[0] ;
		if ($filenamePrefix eq $browserNamePrefix) {
			my $lastComponent = @nameComponents - 1 ;
			my @otherComponents = @nameComponents[1..$lastComponent] ;
			my $destinFilename = join(".", @otherComponents) ;
			my $sourcePath = "$sourceDir/$sourceFilename" ;
			my $destinPath = "$destinDir/$destinFilename" ;
			systemDoOrDie("cp -p", "\"$sourcePath\"", "\"$destinPath\"") ;
			$nCopied++ ;
			# print "Copied: $sourcePath\n" ;			
			# print "    To: $destinPath\n" ;			
		}
	}
	print "Copied $nCopied files for $browserName\n" ;
	
	foreach my $auxDir (@auxDirsToRemove) {
		my $pathToRemove = "$destinDir/$auxDir" ;
		# Since nonexisting $pathToRemove is not a failure, we don't care about the return status, so we use simple backticks.
		my $command = "rm -Rf \"$pathToRemove\"" ;
		`$command` ;
		# print "Executed: $command\n" ;
	}
	
	foreach my $auxFile (@auxFilesToRemove) {
		my $pathToRemove = "$destinDir/$auxFile" ;
		my $command = "rm -f \"$pathToRemove\"" ;
		`$command` ;
		# print "Executed: $command\n" ;
	}
	
	
}

# This function allows glob expansion.  Spaces in arguments must be quoted or escaped.
sub systemDoOrDie {
    # First argument to this function should be the command
    # Subsequent arguments should be the space-separated "arguments" to the command
    # Each space makes a new argument, thus a command option such as
    #   -o /some/path
    # should be passed as two arguments, "-o" and "/some/path"
    # Of course, since perl flattens arrays passed to functions, all
    # or part of the arguments may be concatenated into array(s)
    
    # Recover the array argument, which perl has flattened
    my @sysargs ;
    while (my $arg = shift) {
    	push @sysargs, $arg ;
    }
    #push @sysargs, ">" ;
    #push @sysargs, "/dev/null" ;
    my $commandName = @sysargs[0] ;
    my $commandString = commandStringFromArray(@sysargs) ;
	# There are two ways to do this, and both work if there are no metacharacters such as the asterisk (*) in the command.  The first way is:
	# system(@sysargs) ; # Literally interprets and thus spoils operation of metacharacters
	# So, instead we use the second way:
	system($commandString) ; # Always works even if metacharacters.
	# $? seems to have the same value as the return value of system()
	# I use the former since it is more convenient.
	if ($? != 0) {
		die ("Failed with status=$? executing:\n   $commandString\nDied") ;
	}
	if ($? == -1) {
		die "Failed to execute:\n   $commandString\nError message:\n   $!\nDied";
	}
	elsif ($? & 127) {
		die "Failed while executing command:\n   $commandString\nFailed with signal %d, %s coredump.\n",
			($? & 127),  ($? & 128) ? 'with' : 'without', "\nDied" ;
	}
	
	return $? ;
}

sub commandStringFromArray {
    # Recover the array argument, which perl has flattened
    my @sysargs ;
	my $s ;
    while (my $someArg = shift) {
		$s .=  $someArg ;
		$s .= " " ;
	}
	
	return $s ;
}


