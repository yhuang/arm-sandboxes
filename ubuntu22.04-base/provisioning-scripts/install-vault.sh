#!/usr/bin/env bash

# https://releases.hashicorp.com/vault/

APPLICATION="vault"
VERSION="1.15.5"
ARCHIVE="${APPLICATION}_${VERSION}_linux_arm64.zip"

wget https://releases.hashicorp.com/${APPLICATION}/${VERSION}/${ARCHIVE}

unzip ${ARCHIVE} -d /usr/local/bin/hashicorp
rm -f ${ARCHIVE}