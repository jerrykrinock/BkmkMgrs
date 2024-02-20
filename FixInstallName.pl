#!/usr/bin/perl

=com
This script is a workaround for the bogus Load command which Xcode will insert
into an "archive" (aka "Release") build instead of the correct @rpath……,
which I noticed starting in summer 2022.
=cut

use strict;
use Cwd qw(getcwd);

my $BUILT_PRODUCTS_DIR = $ARGV[0];
my $EXECUTABLE_FOLDER_PATH = $ARGV[1];
my $TEMP_FILE_DIR = $ARGV[2];
my $EXECUTABLE_NAME = $ARGV[3];

# Test Data.  Uncomment to tes
# my $TEMP_FILE_DIR = "/Users/jk/Library/Developer/Xcode/DerivedData/BkmkMgrs-dgajrgxroulefweqxsvazigfeucy/Build/Intermediates.noindex/ArchiveIntermediates/Synkmark/IntermediateBuildFilesPath/BkmkMgrs.build/Release/BkmxAgent.build";

print "***  Will fix Bkmxwork install names in executable $EXECUTABLE_NAME ***\n";

chdir "$BUILT_PRODUCTS_DIR/$EXECUTABLE_FOLDER_PATH";
my $cwd = getcwd();
print "Changed to directory to:\n   $cwd\n";

$TEMP_FILE_DIR =~ /(BookMacster|Synkmark|Markster|Smarky)/;
my $mainApp = $1;
print "Parsed out name of mainApp = $mainApp\n";

my $part1 = "/Users/jk/Library/Developer/Xcode/DerivedData/BkmkMgrs-dgajrgxroulefweqxsvazigfeucy/Build/Intermediates.noindex/ArchiveIntermediates/";

my $part3 = "/IntermediateBuildFilesPath/BkmkMgrs.build/Release/Bkmxwork.build/Objects-normal/";

my $part5 = "/Binary/Bkmxwork";

my $arm64BadPath = $part1 . $mainApp . $part3 . "arm64" . $part5;

my $x86_64BadPath = $part1 . $mainApp . $part3 . "x86_64" . $part5;


my $replacement = "\@rpath/Bkmxwork.framework/Versions/A/Bkmxwork";

print "Will replace install name\n     $arm64BadPath\n  with:\n     $replacement\n";
print "Will replace install name\n     $x86_64BadPath\n  with:\n    $replacement\n";

`install_name_tool -change "$arm64BadPath" $replacement $EXECUTABLE_NAME`;
`install_name_tool -change "$x86_64BadPath" $replacement $EXECUTABLE_NAME`;

print "***  Did fix Bkmxwork install names in executable $EXECUTABLE_NAME ***\n";
