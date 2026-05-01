terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://192.168.92.128:8006"
  api_token = "root@pam!terraform-token=570874e8-1b2e-4299-b3ce-6391f6478c6e"
  insecure  = true
}

resource "proxmox_virtual_environment_container" "dns" {
  node_name     = "pve"
  vm_id         = 101
  description   = "ITV: dns"
  start_on_boot = true

  initialization {
    hostname = "itv-dns"
    ip_config {
      ipv4 {
        address = "192.168.92.101/24"
        gateway = "192.168.92.1"
      }
    }
    user_account {
      password = "itv-dns-2024"
    }
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 256
  }

  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type             = "debian"
  }
}

resource "proxmox_virtual_environment_container" "dhcp" {
  node_name     = "pve"
  vm_id         = 102
  description   = "ITV: dhcp"
  start_on_boot = true

  initialization {
    hostname = "itv-dhcp"
    ip_config {
      ipv4 {
        address = "192.168.92.102/24"
        gateway = "192.168.92.1"
      }
    }
    user_account {
      password = "itv-dhcp-2024"
    }
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 128
  }

  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type             = "debian"
  }
}

resource "proxmox_virtual_environment_container" "vpn" {
  node_name     = "pve"
  vm_id         = 103
  description   = "ITV: vpn"
  start_on_boot = true

  initialization {
    hostname = "itv-vpn"
    ip_config {
      ipv4 {
        address = "192.168.92.103/24"
        gateway = "192.168.92.1"
      }
    }
    user_account {
      password = "itv-vpn-2024"
    }
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 128
  }

  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type             = "debian"
  }
}

resource "proxmox_virtual_environment_container" "monitoring" {
  node_name     = "pve"
  vm_id         = 104
  description   = "ITV: monitoring"
  start_on_boot = true

  initialization {
    hostname = "itv-monitoring"
    ip_config {
      ipv4 {
        address = "192.168.92.104/24"
        gateway = "192.168.92.1"
      }
    }
    user_account {
      password = "itv-monitoring-2024"
    }
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1536
  }

  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type             = "debian"
  }
}

resource "proxmox_virtual_environment_container" "logging" {
  node_name     = "pve"
  vm_id         = 105
  description   = "ITV: logging"
  start_on_boot = true

  initialization {
    hostname = "itv-logging"
    ip_config {
      ipv4 {
        address = "192.168.92.105/24"
        gateway = "192.168.92.1"
      }
    }
    user_account {
      password = "itv-logging-2024"
    }
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
  }

  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type             = "debian"
  }
}

resource "proxmox_virtual_environment_container" "fileserver" {
  node_name     = "pve"
  vm_id         = 106
  description   = "ITV: fileserver"
  start_on_boot = true

  initialization {
    hostname = "itv-fileserver"
    ip_config {
      ipv4 {
        address = "192.168.92.106/24"
        gateway = "192.168.92.1"
      }
    }
    user_account {
      password = "itv-fileserver-2024"
    }
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 256
  }

  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type             = "debian"
  }
}

resource "proxmox_virtual_environment_container" "ntp" {
  node_name     = "pve"
  vm_id         = 107
  description   = "ITV: ntp"
  start_on_boot = true

  initialization {
    hostname = "itv-ntp"
    ip_config {
      ipv4 {
        address = "192.168.92.107/24"
        gateway = "192.168.92.1"
      }
    }
    user_account {
      password = "itv-ntp-2024"
    }
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 64
  }

  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type             = "debian"
  }
}

resource "proxmox_virtual_environment_container" "proxy" {
  node_name     = "pve"
  vm_id         = 108
  description   = "ITV: proxy"
  start_on_boot = true

  initialization {
    hostname = "itv-proxy"
    ip_config {
      ipv4 {
        address = "192.168.92.108/24"
        gateway = "192.168.92.1"
      }
    }
    user_account {
      password = "itv-proxy-2024"
    }
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 128
  }

  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
    type             = "debian"
  }
}
