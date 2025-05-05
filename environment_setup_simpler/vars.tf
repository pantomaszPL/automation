

  variable "proxmox_host" {
    default = "pve"
  }
  variable "template_name" {
    default = "templatka8g"
  }

  variable "hostnames"{
    description = "tool names"
    type = list(string)
    default = ["tool"]
    }

  variable  "k3hostnames"{
    description = "k3 names"
    type = list(string)
    default = ["master", "worker1", "worker2"]
  }   



  variable "ipstool" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["192.168.1.112"]
  }




  variable "k3ips" {
    description = "k3 ips"
    type = list(string)
    default = ["192.168.1.113", "192.168.1.114", "192.168.1.115"]

  }
