#!/usr/bin/env bash

DOT_SSH_DIR="$HOME_DIR/.ssh"
AUTHORIZED_KEYS="$HOME_DIR/.ssh/authorized_keys"

mkdir ${DOT_SSH_DIR} && chmod 700 ${DOT_SSH_DIR}
mv /tmp/authorized_keys ${AUTHORIZED_KEYS}
chmod 600 ${AUTHORIZED_KEYS}
chown -R vagrant:vagrant $HOME_DIR

getent group docker || groupadd docker
getent group wheel || groupadd wheel

usermod -aG docker,wheel vagrant
