

  variable "proxmox_host" {
    default = "pve"
  }
  variable "template_name" {
    default = "templatka8g"
  }

  variable "hostnames"{
    description = "new VMs names"
    type = list(string)
    default = ["k3master", "k3worker1", "k3worker2", "bastion"]
    }
  variable "ips" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["192.168.1.111", "192.168.1.112", "192.168.1.113", "192.168.1.114"]
  }

  variable "ips1" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["10.10.0.2", "10.10.0.3", "10.10.0.4", "10.10.0.5"]
  }
