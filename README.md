# arm-sandboxes

#### Required Software
- [Git Large File Storage](https://git-lfs.github.com/)
- [VMware Fusion Pro](http://store.vmware.com/store?SiteID=vmware&Action=DisplayProductDetailsPage&productID=5124967100)
- [Packer](https://www.packer.io/downloads.html)
- [Packer Plugin for VMware](https://github.com/hashicorp/packer-plugin-vmware)
- [Vagrant](https://www.vagrantup.com/downloads.html)
- [Vagrant VMware Provider Plugin](https://www.vagrantup.com/docs/vmware/installation.html)
- [Vagrant Hostmanager Plugin](https://github.com/devopsgroup-io/vagrant-hostmanager)

#### Add the personal private key and Vagrant's private key to OS X Keychain

  1. Download Vagrant's [public SSH key](https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub) and [private SSH key](https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant).

  2. Put the SSH keys under `$HOME/.ssh` and set the appropriate permissions on Vagrant's private key.

  ```
  macOS$ chmod 400 $HOME/.ssh/vagrant
  ```

  3. Starting with OS X Leopard, ssh-agent is more tightly integrated with Keychain.  Securely storing the passphrases tied to all of a user's SSH keys in Keychain is now possible.  Once added, `ssh-agent` will automatically load them on boot.

  ```
  macOS$ ssh-add -K $HOME/.ssh/<your_private_key>
  macOS$ ssh-add -K $HOME/.ssh/vagrant
  ```

- [How to use Mac OS X Keychain with SSH keys?](http://superuser.com/questions/88470/how-to-use-mac-os-x-keychain-with-ssh-keys)

#### Create the `ubuntu-daily` Vagrant Machine

  1. Clone the `arm-sandboxes` repo.

  ```
  macOS$ git clone git@github.com:yhuang/arm-sandboxes.git
  macOS$ cd arm-sandboxes
  ```

  2. Download `jammy-live-server-arm64.iso` from a trusted source.  Create the `iso` directory under the `arm-sandboxes` top-level directory, and put the ISO file under the `iso` directory.

  3. The `required_plugins` specification for the `packer` block in the packer template `template.pkr.hcl` allows the Packer Plugin for VMware to be installed automatically.

  ```
  packer {
    required_version = ">= x.x.x"
    required_plugins {
        vmware = {
        version = ">= x.x.x"
        source  = "github.com/hashicorp/vmware"
        }
    }
  }
  ```

  Alternatively, the Packer Plugin for VMware can be installed manually:

  ```
  macOS$ packer plugins install github.com/hashicorp/vmware
  ```

  4. Build the `ubuntu-daily` machine image and Vagrant box.

  ```
  macOS$ cd ubuntu-<version>-daily
  macOS$ ./build-image.sh
  ```

  5. Build the `ubuntu-base Vagrant box.

  ```
  macOS$ cd ubuntu-<version>-base
  macOS$ ./build-image.sh
  ```

  6. Launch the `ubuntu-base` Vagrant box.

  ```
  macOS$ vagrant up
  ```

#### Log onto the `ubuntu-base` Vagrant Machine
Once up, the `ubuntu-base` Vagrant machine may be accessed via either `vagrant ssh`
```
macOS$ vagrant ssh
```

#### Set up the `ubuntu-base` Vagrant Machine
These steps assume the following about the host Mac OS X machine:

  1. The ssh keys to remote machines are stored under `$HOME/.pem/` on Mac OS X;

  ```
  vagrant@ubuntu-base% ln -s /host-data/.pem/ $HOME/.pem
  ```

  2. The public ssh key and private ssh key for the user on Mac OS X are `$HOME/.ssh/id_rsa.pub` and `$HOME/.ssh/id_rsa` respectively;

  ```
  vagrant@ubuntu-base% ln -s /host-data/.ssh/id_rsa.pub $HOME/.ssh/id_rsa.pub
  vagrant@ubuntu-base% ln -s /host-data/.ssh/id_rsa $HOME/.ssh/id_rsa
  vagrant@ubuntu-base% chmod 644 $HOME/.ssh/id_rsa.pub
  vagrant@ubuntu-base% chmod 600 $HOME/.ssh/id_rsa
  ```

  3. The service account tokens are exported as environmental variables in `$HOME/.credentials`; and

  ```
  vagrant@ubuntu-base% ln -s /host-data/.credentials .credentials
  vagrant@ubuntu-base% source $HOME/.bash_profile
  ```

  4. The project directories are under `$HOME/workspace/`.

  ```
  vagrant@ubuntu-base% ln -s /host-data/workspace/ $HOME/workspace
  ```
