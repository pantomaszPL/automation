

  variable "proxmox_host" {
    default = "pve"
  }
  variable "template_name" {
    default = "9000"
  }
  
  variable "hostnames"{
    description = "new VMs names"
    type = list(string)
    default = ["vm1"]
    }
  variable "ips" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["192.168.1.111"]
  }  
    
  
