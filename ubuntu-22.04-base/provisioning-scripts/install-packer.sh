#!/usr/bin/env bash

# https://releases.hashicorp.com/packer/

APPLICATION="packer"
VERSION="1.13.1"
ARCHIVE="${APPLICATION}_${VERSION}_linux_arm64.zip"

wget https://releases.hashicorp.com/${APPLICATION}/${VERSION}/${ARCHIVE}

unzip ${ARCHIVE} -d /usr/local/bin/hashicorp
rm -f /usr/local/bin/hashicorp/LICENSE.txt
rm -f ${ARCHIVE}
