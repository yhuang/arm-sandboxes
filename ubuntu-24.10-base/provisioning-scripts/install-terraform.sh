#!/usr/bin/env bash

curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

VAGRANT_TERRAFORM_VERSIONS=/home/vagrant/.terraform.versions
USR_LOCAL_BIN=/usr/local/bin
TFSWITCH=$USR_LOCAL_BIN/tfswitch

chgrp vagrant $USR_LOCAL_BIN
chmod 775 $USR_LOCAL_BIN

mkdir $VAGRANT_TERRAFORM_VERSIONS

TERRAFORM_VERSIONS=( "0.11.15" "0.15.5" "1.7.5" )

for VERSION in "${TERRAFORM_VERSIONS[@]}"
do
    $TFSWITCH $VERSION
done

chown -R vagrant:vagrant $VAGRANT_TERRAFORM_VERSIONS

chgrp vagrant $USR_LOCAL_BIN/terraform
