#!/usr/bin/env bash -e

BENTO_DIR="${HOME}/workspace/bento"

OS="rockylinux"
MAJOR_NUMBER="9"
MINOR_NUMBER="4"
VERSION="${MAJOR_NUMBER}.${MINOR_NUMBER}"
ARCH=aarch64

PACKER_VARS="${BENTO_DIR}/os_pkrvars/${OS}/${OS}-${MAJOR_NUMBER}-${ARCH}.pkrvars.hcl"
VM_NAME="rocky${MAJOR_NUMBER}-${MINOR_NUMBER}"
BUILDS_DIR="${BENTO_DIR}/builds"
BOX_ARTIFACT_NAME="${OS}-${VERSION}-${ARCH}.vmware.box"
BOX_NAME="rocky-${VERSION}-${ARCH}"

echo -e "\e[38;5;39m================================#\e[0m"
echo -e "\e[38;5;39m   Image Building with Packer   #\e[0m"
echo -e "\e[38;5;39m================================#\e[0m"

packer build \
  -only=vmware-iso.vm \
  -var-file=${PACKER_VARS}\
  -var "vm_name=${VM_NAME}" \
  -var "headless=true" \
  -var "cpus=1" \
  -var "memory=2048" \
  -var "disk_size=16384" \
  -force ${BENTO_DIR}/packer_templates

echo -e "\e[38;5;39m===============================#\e[0m"
echo -e "\e[38;5;39m   Box Building with Vagrant   #\e[0m"
echo -e "\e[38;5;39m===============================#\e[0m"
vagrant box add --force ${BUILDS_DIR}/${BOX_ARTIFACT_NAME} --name ${BOX_NAME}

mkdir -p boxes
cp ${BUILDS_DIR}/${BOX_ARTIFACT_NAME} boxes/${BOX_ARTIFACT_NAME}

echo -e "\e[38;5;39m===================#\e[0m"
echo -e "\e[38;5;39m       Done!       #\e[0m"
echo -e "\e[38;5;39m===================#\e[0m"