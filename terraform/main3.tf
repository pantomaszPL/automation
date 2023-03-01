  terraform {
    required_providers {
      proxmox = {
        source = "telmate/proxmox"
        version = ">2.9.6"
        }
    }

  }

  provider "proxmox"{
    pm_api_url = "https://192.168.1.32:8006/api2/json"
    pm_api_token_id = "terraform-prov@pve!terraform-token"
    pm_api_token_secret = "7cff8927-7130-4883-9df4-3ba895670a32"
    pm_tls_insecure = true


  }
  resource "proxmox_vm_qemu" "test_server"{
    count = length(var.hostnames)
    name = var.hostnames[count.index]
    target_node = var.proxmox_host
    clone = var.template_name

 #basic vm config
    agent = 1
    os_type = "cloud-init"
    cores = 2
    sockets = 1
    cpu = "host"
    memory = 2048
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"
    disk {
      slot = 0
      size = "10G"
      type = "scsi"
      storage = "usbdisk"
      iothread = 0
    }
    network {
      model = "virtio"
      bridge = "vmbr0"
    }
    ipconfig0  = "ip=${var.ips[count.index]}/24,gw=192.168.1.1"
    ssh_user = "root"
   # sshkeys =
    provisioner "local-exec" {
      working_dir = "/home/tomek/git/terraform/ansible"
      command = "ansible-playbook -i ${var.ips[count.index]}, tf_ans_config_vm.yml"
}
    }
