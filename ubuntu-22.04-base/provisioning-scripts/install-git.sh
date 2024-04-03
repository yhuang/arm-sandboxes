#!/usr/bin/env bash

# https://mirrors.edge.kernel.org/pub/software/scm/git/

APPLICATION="git"
VERSION="2.44.0"
ARCHIVE="${APPLICATION}-${VERSION}.tar.xz"

wget https://mirrors.edge.kernel.org/pub/software/scm/${APPLICATION}/${ARCHIVE}

tar xvf ${ARCHIVE}
cd ${APPLICATION}-${VERSION}

./configure
make
make install

cd ..
rm -fr ${APPLICATION}-${VERSION}
rm -f ${ARCHIVE}