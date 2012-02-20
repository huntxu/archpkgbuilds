#!/usr/bin/perl -w
use strict;

my %ver;

sub update_hash_with_pkgname
{
    my $pkgname = shift;
    $_ = `repo/getver.sh $pkgname`;
    chomp;
    @_ = split;
    $ver{$_[0]} = "$_[1]-$_[2]";
    return;
}

open GITSTATUS, "git status -s |" || die "Could not read pipe from git status.\n";
while (<GITSTATUS>) {
    chomp;
    if (m{^[A|M]\s+([^/]+)/PKGBUILD$}) {
        update_hash_with_pkgname $1;
    }
    else {
        last if /^?.+/;
    }
}
close GITSTATUS;

{
    push @ARGV, "repo/versions";
    $^I = "";
    while (<>) {
        @_ = split /=/;
        if (exists $ver{$_[0]}) {
            $_[1] = $ver{$_[0]};
            print "$_[0]=$ver{$_[0]}\n";
            delete $ver{$_[0]};
        }
        else {
            print;
        }
    }
}

open VERSIONS, ">>repo/versions";
foreach (keys %ver) {
    print VERSIONS "$_=$ver{$_}\n";
}
close VERSIONS;

system "git add repo/versions";
