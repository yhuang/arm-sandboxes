#!/usr/bin/env bash

AWSCLI_V2_ARCHIVE="awscliv2.zip"

curl https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip -o ${AWSCLI_V2_ARCHIVE}
unzip ${AWSCLI_V2_ARCHIVE}
./aws/install
