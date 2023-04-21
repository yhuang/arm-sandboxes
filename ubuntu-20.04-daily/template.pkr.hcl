packer {
  required_version = ">= 1.8.6"
  required_plugins {
    vmware = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-iso" "ubuntu_daily" {
  vm_name       = var.build_name
  guest_os_type = "arm-ubuntu-64"
  version       = 20
  headless      = false
  memory        = 4096
  cpus          = 1
  cores         = 2
  disk_size     = 16384
  disk_type_id  = 0
  
  iso_urls =[
    "${var.iso_file_path}",
    "https://cdimage.ubuntu.com/releases/focal/release/ubuntu-20.04.5-live-server-arm64.iso"
  ]
  iso_checksum = var.iso_checksum
  iso_target_path   = var.iso_target_path
  output_directory  = var.output_directory
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
  network_adapter_type = "vmxnet3"

  vmx_data = {
    "cpuid.coresPerSocket"    = "2"
    "ethernet0.pciSlotNumber" = "32"
    "svga.autodetect"         = true
    "usb_xhci.present"        = true
  }
}

build {
  name = var.build_name

  sources = [
    "sources.vmware-iso.ubuntu_daily"
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

  provisioner "file" {
    source      = "files/vagrant.pub"
    destination = "/tmp/authorized_keys"
  }

  provisioner "shell" {
    environment_vars = [
      "HOME_DIR=${var.user_home_dir}"
    ]
    execute_command  = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
    scripts          = [
      "provisioning-scripts/install-vagrant-user-bash-profile.sh",
      "provisioning-scripts/configure-vagrant-user.sh",
      "provisioning-scripts/configure-sshd-options.sh"
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
    output              = "boxes/${var.build_name}.{{.Provider}}.box"
  } 
}
