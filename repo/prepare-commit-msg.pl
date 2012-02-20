#!/usr/bin/perl -w
use strict;

my %add;
my %del;

open VERSIONDIFF, "git diff --cached repo/versions|"
    || die "Could not read pipe from git diff.\n";
foreach(<VERSIONDIFF>) {
    if (/^\+{1}([^=]+)=(.*)/) {
        $add{$1} = $2;
    }
    elsif (/^-{1}([^=]+)=(.*)/) {
        $del{$1} = $2;
    }
}
close VERSIONDIFF;

my $commit_msg;
my $n = 0;
foreach (keys %add) {
    if (exists $del{$_}) {
        $commit_msg .= "$_: $del{$_} -> $add{$_}\\n";
        delete $add{$_};
        delete $del{$_};
        $n++;
    } 
}
foreach (keys %add) {
    $commit_msg .= "Added $_: $add{$_}\\n";
    $n++;
}
foreach (keys %del) {
    $commit_msg .= "Deleted $_: $del{$_}\\n";
    $n++;
}

if ($n>0) {
    $commit_msg = "Updated $n package(s).\\n\\n$commit_msg";
    system("sed", "-i", "1i$commit_msg", $ARGV[0]);
}
