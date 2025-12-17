terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc05"
    }
  }
}




provider "proxmox" {
    pm_api_url = "https://192.168.1.36:8006/api2/json"
    pm_api_token_id = "terraform-prov@pve!terraform-token"
    pm_api_token_secret = "08401cd0-c027-45d1-b2ba-14ba8eee77c5"
    pm_tls_insecure = true
}

resource "proxmox_lxc" "dns_server" {
  target_node  = "pve1"  # Change to your Proxmox node name
  hostname     = "dns-server"
  ostemplate   = "local:vztmpl/ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst"
  #ostemplate = "local:vztmpll/dns-server"
  password     = "tomek211"  # Change this
  unprivileged = true
  
  # Resources
  cores  = 1
  memory = 512
  swap   = 512

  # Root filesystem
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  # Network configuration
  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.1.35/24"
    gw     = "192.168.1.1"  # Change to your gateway
  }

  # SSH key (optional but recommended)
  ssh_public_keys = <<-EOT

   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz70fWQiuaOjwFUMOhmgDzpOvMX5tZpdScmzHj1sfh1zcuCpM/V7ayG4q2fzl6aIy9pEatOPyFo0B1TsL2StxndlBZRM/ewa4rzOozwRgVzGNpPxUqWrsjh3Rl1H1hTokq/jk7qSOPwHObFawBUlJzXN8/tEpeF1wBfozro9fBNUUUukl5hqjKwhXUyVc+3S8EOfq3BAUJFyj+Flnybfu/vciaXp9bAryB/P7XDq8PPZ4SWm/rVSO/5qYZwMZ+8//gT7tFeGbE6f+nQgACFYYQtbgVwySlS+AQB8FjI9OkvStAi+p4ZR0I5EQJxoAFAkH7n3klr8oFNGSxrUqUdeP35+z6TwleiBBtZ57XXYHFylaMCgo+d7vPnduMqoqhKZsJktfKzI723qNdz0T5dhYYWXyL7RJya6GmVzEv/grwWl6jIVBGdu7hKgQuBvH0oSEfXXpmUkBTipvAFAPokSNRtePJ5/6sHhyrIt22kWM4X2R4k2ljc2/NrowRfz7q8Hs= root@fedora-lap
   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCq4hZNTWjmOtPmTX1OWtfpa5T5eoMFYp53yfalAd+2FRyOn8I9YLZo7ZDOJWhiB9uJK8WBNuMRMa3I8xzkhkq7xVLJ1jjUz/6MUCs4EawWOYT1o8M9+ObtNJzzp+H2HEmJhzlJVMg65n3rVxnGaym+p/L5FK9EEzu24/bSG3JewzEZjlXMXqSVgEHVijDRJarMfLTlaoFtztOhTdJ9rENi2VKonFyOp/wYPzauHTSTcSnVGbMur4tJkKNEKmP64EKrlUcJ/x9hTA8Wdtz0wDex/BmkyxZOjqkCIH09AywulZwAOQ9vi8o4G/ZLfhbCQYV68gNmsSAsby4T7M0tjfQZP4ifwicBJ0ubFfgSkM+x2k4lwrlcCkuOQ2eNW4OT/VhGrROi6DIOQqEMC6KIk9WGlzChooDJJfWiv/DmfrNsPH1PKDRaLXs8UsOigkJ9jK6fTRvzpfhwO2sgwBD1mhoLu9f5PeujNvDvdw8L4fQesPqyoKE3OZSnaI6GPdjxqes= tomek@fedora-lap

  EOT

  # Start on boot
  onboot = true
  start  = true

  # Features
  features {
    nesting = true
  }


      provisioner "local-exec" {
        working_dir = "/home/tomek/automation/environment_setup_simpler/"
        command = "sleep 30 && ansible-playbook -v -i 192.168.1.35, ansible_dns_vm_config.yaml "
      }



}

output "lxc_ip" {
  value = "192.168.1.35"
}

output "lxc_id" {
  value = proxmox_lxc.dns_server.vmid
}







