#!/bin/bash

source $1/PKGBUILD;
test -z $pkgbase && echo $pkgname $pkgver $pkgrel || echo $pkgbase $pkgver $pkgrel
