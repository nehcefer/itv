# 🖥️ ITV-IAC — Automated IT Node Deployment

> Diploma project — Bachelor's degree  

---

## 🏠 My Lab — "Megatron"

This is my real homelab used as the hardware base for this diploma project.

| # | Component | Details |
|---|-----------|---------|
| 1 | **HP EliteDesk G5** | CPU: AMD Ryzen 3400G |
| | | RAM: DDR4 12GB 2444MHz (4GB + 8GB) |
| | | Storage: SSD 120GB *(RAID upgrade planned)* |
| | | GPU: AMD Radeon Vega 11 (integrated) |
| 2 | **Mikrotik Router** | Network routing & switching |
| 3 | **Storage** | NAS / file storage unit |
| 4 | **UPS** | Power backup / protection |

> *Why "Megatron"? Because it transforms raw hardware into a fully automated IT node* 🤖

---

## 📋 Project Overview

This project implements a fully automated deployment of an Information and Telecommunication Node (ITN/ІТВ) using Infrastructure as Code (IaC) tools.

Instead of spending hours manually configuring servers — run one script and get a fully working node in minutes.

**Hypervisor:** Proxmox VE 9.1.7  
**IaC Tools:** Terraform + Ansible  
**Containers:** LXC on Debian 12  

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│           HP EliteDesk G5 "Megatron"                │
│              Proxmox VE 9.1.7                       │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐   │
│  │ CT 101   │  │ CT 102   │  │    CT 103        │   │
│  │ DNS      │  │ DHCP     │  │    VPN           │   │
│  │ Pi-hole  │  │ dnsmasq  │  │    WireGuard     │   │
│  └──────────┘  └──────────┘  └──────────────────┘   │
│                                                     │
│  ┌──────────────────┐  ┌──────────────────────────┐ │
│  │ CT 104           │  │ CT 105                   │ │
│  │ Monitoring       │  │ Logging                  │ │
│  │ Zabbix + Grafana │  │ Loki + Promtail          │ │
│  └──────────────────┘  └──────────────────────────┘ │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐   │
│  │ CT 106   │  │ CT 107   │  │    CT 108        │   │
│  │ Files    │  │ NTP      │  │    Proxy         │   │
│  │ Samba    │  │ chrony   │  │    Nginx         │   │
│  └──────────┘  └──────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────────┘
         │                              │
    LAN1 (Management)             LAN2 (future WAN)
         │
    Mikrotik Router
         │
      Network
```

---

## 📁 Repository Structure

```
itv-iac/
├── README.md
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.ini
│   ├── site.yml
│   └── roles/
│       ├── common/
│       ├── dns/
│       ├── dhcp/
│       ├── vpn/
│       ├── monitoring/
│       ├── logging/
│       ├── fileserver/
│       ├── ntp/
│       └── proxy/
├── scripts/
│   └── itv-deploy.sh
└── docs/
    ├── architecture.md
    └── diagrams/
```

---

## 🚀 Quick Start

```bash
git clone https://github.com/nehcefer/itv.git
cd itv
chmod +x scripts/itv-deploy.sh
./scripts/itv-deploy.sh
```

```
+=========================================================+
|     ITV -- Automated Deployment  v1.0                  |
|     HP EliteDesk G5  |  Proxmox VE 9.1.7               |
+=========================================================+
|  [*]  1.  DNS            Pi-hole / BIND9               |
|  [*]  2.  DHCP           dnsmasq                       |
|  [*]  3.  VPN            WireGuard                     |
|  [*]  4.  Monitoring     Zabbix + Grafana              |
|  [*]  5.  Logging        Loki + Promtail               |
|  [*]  6.  File Server    Samba                         |
|  [*]  7.  NTP            chrony                        |
|  [*]  8.  Reverse Proxy  Nginx                         |
+---------------------------------------------------------+
|  [D] Deploy   [Q] Quit                                 |
+=========================================================+
```

---

## 🛠️ Services

| CT | Service | Software | RAM |
|----|---------|----------|-----|
| 101 | DNS | Pi-hole / BIND9 | 256 MB |
| 102 | DHCP | dnsmasq | 128 MB |
| 103 | VPN | WireGuard | 128 MB |
| 104 | Monitoring | Zabbix + Grafana | 1536 MB |
| 105 | Logging | Loki + Promtail | 512 MB |
| 106 | File Server | Samba | 256 MB |
| 107 | NTP | chrony | 256 MB |
| 108 | Reverse Proxy | Nginx | 128 MB |

**Total:** ~3.2 GB / 12 GB available

---

## ⚙️ Stack

| Layer | Technology |
|-------|-----------|
| Hypervisor | Proxmox VE 9.1.7 |
| Provisioning | Terraform 1.14 |
| Configuration | Ansible 2.19 |
| Containers | LXC — Debian 12 |
| Version Control | Git + GitHub |

---

## 📊 Results

| Method | Deployment Time | Reproducibility |
|--------|----------------|-----------------|
| Manual | ~4 hours | Low |
| This project | ~5 minutes | 100% |

---

## 👤 Author

**nehcefer** 
