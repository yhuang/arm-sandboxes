#!/usr/bin/env bash

apt-get install -q -y \
  autoconf \
  autotools-dev \
  build-essential \
  bzip2 \
  g++ \
  gcc \
  gettext \
  gnupg2 \
  jq \
  libcurl4-openssl-dev \
  libssl-dev \
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