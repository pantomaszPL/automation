

  variable "proxmox_host" {
    default = "pve"
  }
  variable "template_name" {
    default = "templatka8g"
  }

  variable "hostnames"{
    description = "new VMs names"
    type = list(string)
    default = ["bastion"]
    }

  variable  "hostnames1"{
    description = "k3 names"
    type = list(string)
    default = ["tool"]
  }   



  variable "ipsjump" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["192.168.1.111"]
  }

  variable "ipstool" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["192.168.1.112"]
  }



  variable "ips1" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["10.10.0.2", "10.10.0.3"]
  }

  variable "ips2" {
    description = "k3 ips"
    type = list(string)
    default = ["10.10.0.4", "10.10.0.5", "10.10.0.6"]

  }
