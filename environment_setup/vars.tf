

  variable "proxmox_host" {
    default = "pve"
  }
  variable "template_name" {
    default = "templatka8g"
  }

  variable "hostnames"{
    description = "jumps names"
    type = list(string)
    default = ["jump"]
    }

  variable  "hostnames1"{
    description = "tools names"
    type = list(string)
    default = ["tool"]
  }   



  variable "ipsjumpexternal" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["192.168.1.111"]
  }

  variable "ipstoolexternal" {
    description = "ips due to hostnames"
    type = list(string)
    default = ["192.168.1.112"]
  }



  variable "ipsjumpinternal" {
    description = "internal ips for jump"
    type = list(string)
    default = ["10.10.0.2"]
  }

  variable "ipstoolinternal" {
    description = "interlnal ips for tool"
    type = list(string)
    default = ["10.10.0.3"]
  }


  variable "k3ips" {
    description = "k3 ips"
    type = list(string)
    default = ["10.10.0.4", "10.10.0.5", "10.10.0.6"]

  }
