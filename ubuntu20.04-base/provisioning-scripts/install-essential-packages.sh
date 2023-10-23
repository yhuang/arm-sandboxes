#!/usr/bin/env bash

apt-get install -q -y \
  autoconf \
  build-essential \
  bzip2 \
  g++ \
  gcc \
  gnupg2 \
  jq \
  linux-headers-$(uname -r) \
  make \
  net-tools \
  nfs-common \
  nfs-kernel-server \
  ntp \
  python3-pip \
  selinux-policy-dev \
  unzip

ln -s /usr/bin/python3 /usr/bin/python