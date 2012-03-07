#!/usr/bin/perl -w
use strict;

my $localrepo = "hunt";
my $command   = "LANG=en_US.utf8 pacman";
my $cmp;

-e "./versions" || die "Could not find packages' version information!\n";
push @ARGV, "./versions";
while(<>) {
    @_ = split /=/;
    $_ = `$command -Qi $_[0]`;
    next if !$_;
    /Version[^:]+:\s+?(\S+)/s;
    $cmp = `vercmp $1 $_[1]`;
    if ($cmp == 0) {
        next;
    }
    elsif ( $cmp < 0) {
        print "Found new PKGBUILD of $_[0]: local $1, new $_[1]";
    }
}
