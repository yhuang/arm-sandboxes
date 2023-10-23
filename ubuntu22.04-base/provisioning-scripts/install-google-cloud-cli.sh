#!/usr/bin/env bash

apt-get install -q -y \
apt-transport-https \
ca-certificates \
gnupg

GOOGLE_CLOUD_KEYRING="/usr/share/keyrings/cloud.google.gpg"

echo "deb [signed-by=${GOOGLE_CLOUD_KEYRING}] https://packages.cloud.google.com/apt cloud-sdk main" | \
  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  apt-key --keyring ${GOOGLE_CLOUD_KEYRING} add -

apt-get update -q -y && apt-get install -q -y google-cloud-cli