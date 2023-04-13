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
  vm_name       = "ubuntu-base"
  headless      = false

  source_path       = "vmx/ubuntu-daily.vmx"
  output_directory  = "artifacts"
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
    "virtualHW.version" = 20
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
      "sleep 60"
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
