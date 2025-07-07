#!/usr/bin/env bash

chown -R vagrant:vagrant $HOME_DIR

getent group docker || groupadd docker
getent group wheel || groupadd wheel

usermod -aG docker,wheel vagrant
