packer {
  required_version = ">= 1.8.6"
  required_plugins {
    vmware = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-vmx" "ubuntu_base" {
  vm_name       = var.box_name
  headless      = false

  source_path       = var.source_path
  output_directory  = var.output_directory
  snapshot_name     = "clean"  
  http_directory    = "http"
  ssh_username      = var.ssh_username
  ssh_password      = var.ssh_password
  ssh_wait_timeout  = "1800s"
  shutdown_command  = "sudo shutdown -P now"

  boot_wait    = "10s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]

  disk_adapter_type    = "nvme"

  vmx_data = {
    "firmware"          = "efi"
    "svga.autodetect"   = true
    "usb_xhci.present"  = true
    "sound.present"     = false
  }
}

build {
  sources = [
    "sources.vmware-vmx.ubuntu_base"
  ]

  provisioner "shell" {
    expect_disconnect = true
    pause_before      = "10s"
    execute_command   = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
    inline            = [
      "rm -rf /var/cache/apt",
      "apt-get clean all",
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update -q -y",
      "apt-get upgrade -q -y",
      "reboot"
    ]
  }

  provisioner "shell" {
    expect_disconnect = true
    pause_before      = "10s"
    execute_command   = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
    inline            = [
      "sleep 30"
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "HOME_DIR=${var.user_home_dir}"
    ]
    execute_command  = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
    scripts          = [
      "provisioning-scripts/install-essential-packages.sh",
      "provisioning-scripts/install-go.sh",
      "provisioning-scripts/install-python-packages.sh",
      "provisioning-scripts/create-hashicorp-directory.sh",
      "provisioning-scripts/install-aws-cli.sh",
      "provisioning-scripts/install-google-cloud-cli.sh",
      "provisioning-scripts/install-packer.sh",
      "provisioning-scripts/install-terraform.sh",
      "provisioning-scripts/install-vault.sh"
    ]
  }

  provisioner "shell" {
    scripts = [
      "provisioning-scripts/install-rvm.sh"
    ]
  }

  provisioner "shell" {
    execute_command  = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
    valid_exit_codes = [ 0, 1 ]
    scripts          = [
      "provisioning-scripts/clean-up.sh"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "boxes/${var.box_name}.{{.Provider}}.box"
  } 
}
