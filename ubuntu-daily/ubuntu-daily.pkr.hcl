packer {
  required_version = ">= 1.8.6"
  required_plugins {
    vmware = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-iso" "ubuntu_server" {
  vm_name       = "ubuntu-2023-04-12"
  guest_os_type = "arm-ubuntu-64"
  version       = "16"
  headless      = false
  memory        = 8172
  cpus          = 2
  cores         = 2
  disk_size     = 81920
  sound         = true
  disk_type_id  = 0
  
  iso_urls =[
    "file:/Users/yhuang/iso/jammy-live-server-arm64.iso"
    // "https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/jammy-live-server-arm64.iso"
  ]
  iso_checksum = "sha256:12eed04214d8492d22686b72610711882ddf6222b4dc029c24515a85c4874e95"
  iso_target_path   = "/Users/yhuang/iso"
  output_directory  = "artifacts"
  snapshot_name     = "clean"  
  http_directory    = "http"
  ssh_username      = var.ssh_username
  ssh_password      = var.ssh_password
  ssh_wait_timeout  = "1800s"
  shutdown_command  = "sudo shutdown -P now"

  boot_wait    = "5s"
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
    "firmware"          = "efi"
    "virtualHW.version" = 20
    "svga.autodetect"   = true
    "usb_xhci.present"  = true
    "sound.present"     = false
  }
}

build {
  sources = [
    "sources.vmware-iso.ubuntu_server"
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
    output              = "boxes/${var.box_basename}.{{.Provider}}.box"
  } 
}
