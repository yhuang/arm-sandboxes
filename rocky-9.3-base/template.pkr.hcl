packer {
  required_version = ">= 1.10.1"
  required_plugins {
    vmware = {
      version = ">= 1.0.11"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

source "vagrant" "rocky_base" {
  communicator = "ssh"
  source_path  = var.source_path
  provider     = "vmware_desktop"

  output_dir = var.output_dir
  box_name   = var.box_name

  insert_key = true

  skip_add = true
}

build {
  name    = var.build_name
  sources = ["source.vagrant.rocky_base"]

  provisioner "shell" {
    expect_disconnect = true
    pause_before      = "10s"
    execute_command   = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
    inline            = [
      "rm -rf /var/cache/dnf",
      "dnf clean all",
      "dnf -y update",
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
    execute_command  = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E bash -eux '{{.Path}}'"
    valid_exit_codes = [ 0, 1 ]
    scripts          = [
      "provisioning-scripts/clean-up.sh"
    ]
  }
}
