terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}




provider "proxmox" {
    pm_api_url = "https://192.168.1.32:8006/api2/json"
    pm_api_token_id = "terraform-prov@pve!terraform-token"
    pm_api_token_secret = "7cff8927-7130-4883-9df4-3ba895670a32"
    pm_tls_insecure = true
}




resource "proxmox_vm_qemu" "cloudinit-jump" {
  #vmid        = 100
  count       = length(var.hostnames)
  name        = var.hostnames[count.index]
  target_node = "pve"
  agent       = 1
  cores       = 2
  memory      = 2048
  boot        = "order=scsi0" # has to be the same as the OS disk of the template
  clone       = "templatka8g" # The name of the template
  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot = true

  # Cloud-Init configuration
  #cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=${var.ipsjumpexternal[count.index]}/24,gw=192.168.1.1"
  ipconfig1  = "ip=${var.ipsjumpinternal[count.index]}/24"
  skip_ipv6  = true
  ciuser     = "root"
  cipassword = "tomek211"
  #sshkeys    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/Pjg7YXZ8Yau9heCc4YWxFlzhThnI+IhUx2hLJRxYE Cloud-Init@Terraform"

  # Most cloud-init images require a serial device for their display
  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
        disk {
          storage = "usbdisk"
          # The size of the disk should be at least as big as the disk in the template. If it's smaller, the disk will be recreated
          size    = "9G" 
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide2 {
        cloudinit {
          storage = "usbdisk"
        }
      }
    }
  }

  network {
    id = 0
    bridge = "vmbr0"
    model  = "virtio"

  }

  network {
    id = 1
    bridge = "vmbr1"
    model = "virtio"
  }


   sshkeys = <<EOF
   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz70fWQiuaOjwFUMOhmgDzpOvMX5tZpdScmzHj1sfh1zcuCpM/V7ayG4q2fzl6aIy9pEatOPyFo0B1TsL2StxndlBZRM/ewa4rzOozwRgVzGNpPxUqWrsjh3Rl1H1hTokq/jk7qSOPwHObFawBUlJzXN8/tEpeF1wBfozro9fBNUUUukl5hqjKwhXUyVc+3S8EOfq3BAUJFyj+Flnybfu/vciaXp9bAryB/P7XDq8PPZ4SWm/rVSO/5qYZwMZ+8//gT7tFeGbE6f+nQgACFYYQtbgVwySlS+AQB8FjI9OkvStAi+p4ZR0I5EQJxoAFAkH7n3klr8oFNGSxrUqUdeP35+z6TwleiBBtZ57XXYHFylaMCgo+d7vPnduMqoqhKZsJktfKzI723qNdz0T5dhYYWXyL7RJya6GmVzEv/grwWl6jIVBGdu7hKgQuBvH0oSEfXXpmUkBTipvAFAPokSNRtePJ5/6sHhyrIt22kWM4X2R4k2ljc2/NrowRfz7q8Hs= root@fedora-lap
   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCq4hZNTWjmOtPmTX1OWtfpa5T5eoMFYp53yfalAd+2FRyOn8I9YLZo7ZDOJWhiB9uJK8WBNuMRMa3I8xzkhkq7xVLJ1jjUz/6MUCs4EawWOYT1o8M9+ObtNJzzp+H2HEmJhzlJVMg65n3rVxnGaym+p/L5FK9EEzu24/bSG3JewzEZjlXMXqSVgEHVijDRJarMfLTlaoFtztOhTdJ9rENi2VKonFyOp/wYPzauHTSTcSnVGbMur4tJkKNEKmP64EKrlUcJ/x9hTA8Wdtz0wDex/BmkyxZOjqkCIH09AywulZwAOQ9vi8o4G/ZLfhbCQYV68gNmsSAsby4T7M0tjfQZP4ifwicBJ0ubFfgSkM+x2k4lwrlcCkuOQ2eNW4OT/VhGrROi6DIOQqEMC6KIk9WGlzChooDJJfWiv/DmfrNsPH1PKDRaLXs8UsOigkJ9jK6fTRvzpfhwO2sgwBD1mhoLu9f5PeujNvDvdw8L4fQesPqyoKE3OZSnaI6GPdjxqes= tomek@fedora-lap
   EOF

         provisioner "local-exec" {
        working_dir = "/home/tomek/automation/environment_setup/"
        command = "sleep 500 && ansible-playbook -i inventory  tf_vmsetup.yaml"
      }

}




resource "proxmox_vm_qemu" "cloudinit-tool" {
  #vmid        = 100
  count       = length(var.hostnames1)
  name        = var.hostnames1[count.index]
  target_node = "pve"
  agent       = 1
  cores       = 2
  memory      = 3072
  boot        = "order=scsi0" # has to be the same as the OS disk of the template
  clone       = "templatka8g" # The name of the template
  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot = true

  # Cloud-Init configuration
  #cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=${var.ipstoolexternal[count.index]}/24,gw=192.168.1.1"
  ipconfig1  = "ip=${var.ipstoolinternal[count.index]}/24"
  skip_ipv6  = true
  ciuser     = "root"
  cipassword = "tomek211"
  #sshkeys    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/Pjg7YXZ8Yau9heCc4YWxFlzhThnI+IhUx2hLJRxYE Cloud-Init@Terraform"

  # Most cloud-init images require a serial device for their display
  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
        disk {
          storage = "usbdisk"
          # The size of the disk should be at least as big as the disk in the template. If it's smaller, the disk will be recreated
          size    = "9G" 
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide2 {
        cloudinit {
          storage = "usbdisk"
        }
      }
    }
  }

  network {
    id = 0
    bridge = "vmbr0"
    model  = "virtio"

  }

  network {
    id = 1
    bridge = "vmbr1"
    model = "virtio"
  }


    sshkeys = <<EOF
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz70fWQiuaOjwFUMOhmgDzpOvMX5tZpdScmzHj1sfh1zcuCpM/V7ayG4q2fzl6aIy9pEatOPyFo0B1TsL2StxndlBZRM/ewa4rzOozwRgVzGNpPxUqWrsjh3Rl1H1hTokq/jk7qSOPwHObFawBUlJzXN8/tEpeF1wBfozro9fBNUUUukl5hqjKwhXUyVc+3S8EOfq3BAUJFyj+Flnybfu/vciaXp9bAryB/P7XDq8PPZ4SWm/rVSO/5qYZwMZ+8//gT7tFeGbE6f+nQgACFYYQtbgVwySlS+AQB8FjI9OkvStAi+p4ZR0I5EQJxoAFAkH7n3klr8oFNGSxrUqUdeP35+z6TwleiBBtZ57XXYHFylaMCgo+d7vPnduMqoqhKZsJktfKzI723qNdz0T5dhYYWXyL7RJya6GmVzEv/grwWl6jIVBGdu7hKgQuBvH0oSEfXXpmUkBTipvAFAPokSNRtePJ5/6sHhyrIt22kWM4X2R4k2ljc2/NrowRfz7q8Hs= root@fedora-lap
     ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCq4hZNTWjmOtPmTX1OWtfpa5T5eoMFYp53yfalAd+2FRyOn8I9YLZo7ZDOJWhiB9uJK8WBNuMRMa3I8xzkhkq7xVLJ1jjUz/6MUCs4EawWOYT1o8M9+ObtNJzzp+H2HEmJhzlJVMg65n3rVxnGaym+p/L5FK9EEzu24/bSG3JewzEZjlXMXqSVgEHVijDRJarMfLTlaoFtztOhTdJ9rENi2VKonFyOp/wYPzauHTSTcSnVGbMur4tJkKNEKmP64EKrlUcJ/x9hTA8Wdtz0wDex/BmkyxZOjqkCIH09AywulZwAOQ9vi8o4G/ZLfhbCQYV68gNmsSAsby4T7M0tjfQZP4ifwicBJ0ubFfgSkM+x2k4lwrlcCkuOQ2eNW4OT/VhGrROi6DIOQqEMC6KIk9WGlzChooDJJfWiv/DmfrNsPH1PKDRaLXs8UsOigkJ9jK6fTRvzpfhwO2sgwBD1mhoLu9f5PeujNvDvdw8L4fQesPqyoKE3OZSnaI6GPdjxqes= tomek@fedora-lap
    EOF

    #         provisioner "local-exec" {
    #   working_dir = "/home/tomek/git/terraform/terraform_ansible/ansible"
    #   command = "sleep 500 && ansible-playbook -i 192.168.1.112, tf_ans_config_vm.yml"
    # }

}

