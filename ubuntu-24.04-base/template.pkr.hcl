# https://developer.hashicorp.com/packer/integrations/hashicorp/vmware
packer {
  required_version = ">= 1.1.0"
  required_plugins {
    vmware = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

source "vagrant" "ubuntu_base" {
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
  sources = ["source.vagrant.ubuntu_base"]

  provisioner "shell" {
    expect_disconnect = true
    pause_before      = "10s"
    execute_command   = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
    inline = [
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
    inline = [
      "sleep 30"
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "HOME_DIR=${var.user_home_dir}"
    ]
    execute_command = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E bash -eux '{{.Path}}'"
    scripts = [
      "provisioning-scripts/reset-motd.sh",
      "provisioning-scripts/configure-sshd-options.sh",
      "provisioning-scripts/configure-vagrant-user.sh",
      "provisioning-scripts/install-vagrant-user-bash-profile.sh",
      "provisioning-scripts/install-essential-packages.sh",
      "provisioning-scripts/install-git.sh",
      "provisioning-scripts/create-hashicorp-directory.sh",
      "provisioning-scripts/install-packer.sh",
      "provisioning-scripts/install-vault.sh",
      "provisioning-scripts/install-terraform.sh",
      "provisioning-scripts/install-go.sh",
      "provisioning-scripts/install-python-packages.sh",
      "provisioning-scripts/install-aws-cli.sh",
      "provisioning-scripts/install-google-cloud-cli.sh",
      "provisioning-scripts/install-claude-code.sh",
    ]
  }

  provisioner "shell" {
    scripts = [
      "provisioning-scripts/install-rvm.sh"
    ]
  }
  provisioner "shell" {
    execute_command  = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E bash -eux '{{.Path}}'"
    valid_exit_codes = [0, 1]
    scripts = [
      "provisioning-scripts/clean-up.sh"
    ]
  }

  post-processor "manifest" {
    output = "${var.output_dir}/${var.box_name}-manifest.json"
  }
}
