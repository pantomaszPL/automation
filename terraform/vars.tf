

  variable "proxmox_host" {
    default = "pve"
  }
  variable "template_name" {
    default = "9000"
  }

  variable "hostnames"{
    description = "new VMs names"
    type = list(string)
    default = ["vm1", "vm2"]
    }
  variable "ips" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["192.168.1.111", "192.168.1.112"]
  }
