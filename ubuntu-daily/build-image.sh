#!/usr/bin/env bash -e
# Set your variables as desired here:
HOSTNAME="ubuntu-daily"
USERNAME="vagrant"
PASSWORD="vagrant"
ENCRYPTED_PASSWORD='$6$oO2AduquZSwbacIt$zR.tGl0ra0OX7bY61P1ncqJIleJcgPSuNArOVVOTraleioxUCD7\/Mwq9dj4UtTFfVYeryKD6TTeZB8DIWumDE0'

# Let's make sure the ISO we're trying to use has the correct/current checksum:
DAILY_ISO_CHECKSUM=`curl https://cdimage.ubuntu.com/releases/22.04/release/SHA256SUMS | grep live-server-arm64.iso | awk '{print $1}'`

# Now do some search and replace to customize (I know this can be done with variables.pkrvars.hcl, but keeping things extra simple for now)
if [ `uname -s` == "Darwin" ]; then
  sed -i "" "s|iso_checksum = .*|iso_checksum = \"sha256:$DAILY_ISO_CHECKSUM\"|" "ubuntu-daily.pkr.hcl"
  sed -i "" "s|vm_name       = .*|vm_name       = \"${HOSTNAME}\"|" "ubuntu-daily.pkr.hcl"
  sed -i "" "s|    hostname: .*|    hostname: ${HOSTNAME}|g" "./http/user-data"
  sed -i "" "s|    password: .*|    password: ${ENCRYPTED_PASSWORD}|g" "./http/user-data"
else
  sed -i "s|iso_checksum = .*|iso_checksum = \"sha256:$DAILY_ISO_CHECKSUM\"|" "ubuntu-daily.pkr.hcl"
  sed -i "s|vm_name       = .*|vm_name       = \"${HOSTNAME}\"|" "ubuntu-daily.pkr.hcl"
  sed -i "s|    hostname: .*|    hostname: ${HOSTNAME}|g" "./http/user-data"
  sed -i "s|    password: .*|    password: ${ENCRYPTED_PASSWORD}|g" "./http/user-data"
fi

### Build an Ubuntu Server 22.04 LTS Template for VMware Fusion. ###
echo -e "\e[38;5;39m========================================================================#\e[0m"
echo -e "\e[38;5;39m      Building an Ubuntu Server LTS Daily Template for VMware Fusion... #\e[0m"
echo -e "\e[38;5;39m========================================================================#\e[0m"
PACKER_LOG=1 packer build -var "box_name=${HOSTNAME}" -var "ssh_username=${USERNAME}" -var "ssh_password=${PASSWORD}" -force .

vagrant box add --force boxes/${HOSTNAME}.vmware.box --name ${HOSTNAME}

echo -e "\e[38;5;39m========================================================================#\e[0m"
echo -e "\e[38;5;39m      Done!.............................................................#\e[0m"
echo -e "\e[38;5;39m========================================================================#\e[0m"