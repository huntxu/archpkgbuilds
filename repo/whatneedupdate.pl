#!/usr/bin/perl -w
use strict;

my $localrepo = "hunt";
my $command   = "LANG=en_US.utf8 pacman";
my $content;
my $cmp;

-e "./versions" || die "Could not find packages' version information!\n";
push @ARGV, "./versions";
while(<>) {
    @_ = split /=/;
    $content = `$command -Si $localrepo/$_[0]`;
    next if !$content;
    $content =~ /^Version[^:]+:\s+(\S+)$/;
    $cmp = `vercmp $_[1] $1`;
    if ($cmp == 0) {
        next;
    }
    elsif ( $cmp < 0) {
        print "Found new PKGBUILD of $_[0]: local $1, new $_[1]";
    }
}
