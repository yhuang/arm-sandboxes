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

TERRAFORM_VERSIONS=( "0.11.15" "0.15.5" "1.12.2" )

for VERSION in "${TERRAFORM_VERSIONS[@]}"
do
    $TFSWITCH $VERSION
done

# Find where tfswitch actually stored the files
if [ -n "$(ls /root/.terraform.versions/ 2>/dev/null)" ]; then
    TERRAFORM_SOURCE_DIR=/root/.terraform.versions
elif [ -n "$(ls /home/vagrant/.terraform.versions/ 2>/dev/null)" ]; then
    TERRAFORM_SOURCE_DIR=/home/vagrant/.terraform.versions
else
    echo "Error: Cannot find downloaded Terraform versions"
    exit 1
fi

# Only change ownership and copy if files exist and source is not the same as destination
if [ -n "$(ls $TERRAFORM_SOURCE_DIR/* 2>/dev/null)" ]; then
    chgrp vagrant $TERRAFORM_SOURCE_DIR/*
    if [ "$TERRAFORM_SOURCE_DIR" != "$VAGRANT_TERRAFORM_VERSIONS" ]; then
        cp $TERRAFORM_SOURCE_DIR/* $VAGRANT_TERRAFORM_VERSIONS/
    fi
fi

chown -R vagrant:vagrant $VAGRANT_TERRAFORM_VERSIONS

chgrp vagrant $USR_LOCAL_BIN/terraform