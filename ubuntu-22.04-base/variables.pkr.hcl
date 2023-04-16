variable "build_name" {
  type    = string
  default = "ubuntu-base"
}

variable "output_directory" {
  type = string
}

variable "source_path" {
  type = string
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "user_home_dir" {
  type    = string
  default = "/home/vagrant"
}