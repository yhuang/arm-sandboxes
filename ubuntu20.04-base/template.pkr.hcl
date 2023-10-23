packer {
  required_version = ">= 1.8.6"
  required_plugins {
    vmware = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

source "vagrant" "ubuntu" {
  communicator     = "ssh"
  provider         = "vmware_desktop"
  source_path      = var.source_box_path
  output_dir       = var.target_boxes_directory
  box_name         = var.source_box_name
  teardown_method  = "destroy"
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_wait_timeout = "1800s"
}

build {
  name = var.build_name

  sources = [
    "sources.vagrant.ubuntu"
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
      "provisioning-scripts/configure-sshd-options.sh",

      "provisioning-scripts/install-essential-packages.sh",
      "provisioning-scripts/create-hashicorp-directory.sh",
      "provisioning-scripts/install-packer.sh",
      "provisioning-scripts/install-vault.sh",
      "provisioning-scripts/install-terraform.sh",
      "provisioning-scripts/install-go.sh",
      "provisioning-scripts/install-python-packages.sh",
      "provisioning-scripts/install-aws-cli.sh",
      "provisioning-scripts/install-google-cloud-cli.sh",
    ]
  }

  provisioner "shell" {
    scripts = [
      "provisioning-scripts/install-rvm.sh",
    ]
  }

  provisioner "shell" {
    execute_command  = "echo ${var.ssh_password} | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
    valid_exit_codes = [ 0, 1 ]
    scripts          = [
      "provisioning-scripts/clean-up.sh"
    ]
  }
}
