

  variable "proxmox_host" {
    default = "pve"
  }
  variable "template_name" {
    default = "templatka8g"
  }

  variable "hostnames"{
    description = "new VMs names"
    type = list(string)
    default = ["k3master", "k3worker1", "k3worker2"]
    }
  variable "ips" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["192.168.1.111", "192.168.1.112", "192.168.1.113"]
  }
