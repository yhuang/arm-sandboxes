#!/usr/bin/env bash

curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

ROOT_TERRAFORM_VERSIONS=/root/.terraform.versions
VAGRANT_TERRAFORM_VERSIONS=/home/vagrant/.terraform.versions
USR_LOCAL_BIN=/usr/local/bin
TFSWITCH=$USR_LOCAL_BIN/tfswitch

chgrp vagrant $USR_LOCAL_BIN
chmod 775 $USR_LOCAL_BIN

mkdir $ROOT_TERRAFORM_VERSIONS
mkdir $VAGRANT_TERRAFORM_VERSIONS
chgrp vagrant $ROOT_TERRAFORM_VERSIONS
chmod 775 $ROOT_TERRAFORM_VERSIONS

TERRAFORM_0_11=0.11.15
TERRAFORM_0_15=0.15.5
TERRAFORM_1_5_6=1.5.6
TERRAFORM_1_6_2=1.6.2

$TFSWITCH $TERRAFORM_0_11
$TFSWITCH $TERRAFORM_0_15
$TFSWITCH $TERRAFORM_1_5_6
$TFSWITCH $TERRAFORM_1_6_2

chgrp vagrant $ROOT_TERRAFORM_VERSIONS/*
cp $ROOT_TERRAFORM_VERSIONS/* $VAGRANT_TERRAFORM_VERSIONS/
chown -R vagrant:vagrant $VAGRANT_TERRAFORM_VERSIONS

chgrp vagrant $USR_LOCAL_BIN/terraform
