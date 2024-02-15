#!/usr/bin/env bash

GOOGLE_CLOUD_KEYRING="/usr/share/keyrings/cloud.google.gpg"

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

apt-get update -q -y && apt-get install -q -y google-cloud-cli