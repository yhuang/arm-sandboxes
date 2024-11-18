#!/usr/bin/env bash

# https://releases.hashicorp.com/vault/

APPLICATION="vault"
VERSION="1.16.0"
ARCHIVE="${APPLICATION}_${VERSION}_linux_arm64.zip"

wget https://releases.hashicorp.com/${APPLICATION}/${VERSION}/${ARCHIVE}

unzip ${ARCHIVE} -d /usr/local/bin/hashicorp
rm -f /usr/local/bin/hashicorp/LICENSE.txt
rm -f ${ARCHIVE}