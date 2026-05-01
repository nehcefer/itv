#!/bin/bash
ITV_DIR="/opt/itv-iac"
ANSIBLE_DIR="/opt/itv-ansible"
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; WHITE='\033[1;37m'; NC='\033[0m'

declare -A SERVICES NAMES IPS VMIDS RAM
SERVICES=([dns]=0 [dhcp]=0 [vpn]=0 [monitoring]=0 [logging]=0 [fileserver]=0 [ntp]=0 [proxy]=0)
NAMES=([dns]="DNS           (Pi-hole / BIND9)" [dhcp]="DHCP          (dnsmasq)" [vpn]="VPN           (WireGuard)" [monitoring]="Моніторинг    (Zabbix + Grafana)" [logging]="Логування     (Loki + Promtail)" [fileserver]="Файл-сервер   (Samba)" [ntp]="NTP           (chrony)" [proxy]="Reverse Proxy (Nginx)")
IPS=([dns]="192.168.92.101" [dhcp]="192.168.92.102" [vpn]="192.168.92.103" [monitoring]="192.168.92.104" [logging]="192.168.92.105" [fileserver]="192.168.92.106" [ntp]="192.168.92.107" [proxy]="192.168.92.108")
VMIDS=([dns]=101 [dhcp]=102 [vpn]=103 [monitoring]=104 [logging]=105 [fileserver]=106 [ntp]=107 [proxy]=108)
RAM=([dns]=256 [dhcp]=128 [vpn]=128 [monitoring]=1536 [logging]=512 [fileserver]=256 [ntp]=64 [proxy]=128)
ORDER=(dns dhcp vpn monitoring logging fileserver ntp proxy)

draw_menu() {
    clear
    echo -e "${CYAN}ІТВ — Автоматизоване розгортання v1.0${NC}"
    echo ""
    echo -e "${WHITE}Оберіть сервіси для розгортання:${NC}"
    echo ""
    local i=1
    for svc in "${ORDER[@]}"; do
        if [ "${SERVICES[$svc]}" -eq 1 ]; then
            echo -e "  ${GREEN}[✓] ${i}. ${NAMES[$svc]}${NC}"
        else
            echo -e "  ${RED}[ ]${NC} ${i}. ${NAMES[$svc]}"
        fi
        ((i++))
    done
    echo ""
    local total_ram=0 count=0
    for svc in "${ORDER[@]}"; do
        if [ "${SERVICES[$svc]}" -eq 1 ]; then
            total_ram=$((total_ram + RAM[$svc])); ((count++))
        fi
    done
    echo -e "${YELLOW}Обрано: ${count}/8  |  RAM: ~${total_ram} MB / 16384 MB${NC}"
    echo ""
    echo -e "${WHITE}[1-8]${NC} Увімк/вимк  ${WHITE}[A]${NC} Всі  ${WHITE}[N]${NC} Жодного"
    echo -e "${GREEN}[D]${NC} Розгорнути  ${RED}[Q]${NC} Вийти"
    echo ""
    echo -ne "${WHITE}Ваш вибір: ${NC}"
}

generate_terraform() {
    mkdir -p "$ITV_DIR"
    cat > "$ITV_DIR/main.tf" << 'TFEOF'
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
TFEOF

    for svc in "${ORDER[@]}"; do
        [ "${SERVICES[$svc]}" -eq 0 ] && continue
        cat >> "$ITV_DIR/main.tf" << TFEOF

resource "proxmox_virtual_environment_container" "${svc}" {
  node_name     = "pve"
  vm_id         = ${VMIDS[$svc]}
  description   = "ITV: ${svc}"
  start_on_boot = true

  initialization {
    hostname = "itv-${svc}"
    ip_config {
      ipv4 {
        address = "${IPS[$svc]}/24"
        gateway = "192.168.92.1"
      }
    }
    user_account {
      password = "itv-${svc}-2024"
    }
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = ${RAM[$svc]}
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
TFEOF
    done
    echo -e "${GREEN}✓ main.tf згенеровано${NC}"
}

generate_ansible_inventory() {
    mkdir -p "$ANSIBLE_DIR"
    echo "[itv]" > "$ANSIBLE_DIR/inventory.ini"
    for svc in "${ORDER[@]}"; do
        [ "${SERVICES[$svc]}" -eq 0 ] && continue
        echo "itv-${svc} ansible_host=${IPS[$svc]} ansible_user=root ansible_password=itv-${svc}-2024" >> "$ANSIBLE_DIR/inventory.ini"
    done
    echo -e "${GREEN}✓ Ansible inventory згенеровано${NC}"
}

run_deployment() {
    local count=0
    for svc in "${ORDER[@]}"; do [ "${SERVICES[$svc]}" -eq 1 ] && ((count++)); done
    if [ "$count" -eq 0 ]; then
        echo -e "\n${RED}✗ Оберіть хоча б один сервіс!${NC}"; sleep 2; return
    fi
    clear
    echo -e "${CYAN}Розгортання ІТВ розпочато...${NC}"

    echo -e "\n${YELLOW}► Генерація конфігурації...${NC}"
    generate_terraform
    generate_ansible_inventory

    echo -e "\n${YELLOW}► Ініціалізація Terraform...${NC}"
    cd "$ITV_DIR" && terraform init -upgrade > /tmp/tf-init.log 2>&1
    [ $? -ne 0 ] && { echo -e "${RED}✗ Помилка init${NC}"; cat /tmp/tf-init.log; read -n 1; return; }
    echo -e "${GREEN}✓ Ініціалізовано${NC}"

    echo -e "\n${YELLOW}► terraform apply...${NC}"
    terraform apply -auto-approve 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}✓ Розгортання успішно завершено!${NC}"
    else
        echo -e "\n${RED}✗ Помилка розгортання${NC}"
    fi
    echo -e "\n${WHITE}Натисніть будь-яку клавішу...${NC}"; read -n 1
}

while true; do
    draw_menu
    read -r -n 1 key
    key=$(echo "$key" | tr '[:lower:]' '[:upper:]')
    case $key in
        1) svc=${ORDER[0]} ;; 2) svc=${ORDER[1]} ;; 3) svc=${ORDER[2]} ;;
        4) svc=${ORDER[3]} ;; 5) svc=${ORDER[4]} ;; 6) svc=${ORDER[5]} ;;
        7) svc=${ORDER[6]} ;; 8) svc=${ORDER[7]} ;;
        A) for s in "${ORDER[@]}"; do SERVICES[$s]=1; done; continue ;;
        N) for s in "${ORDER[@]}"; do SERVICES[$s]=0; done; continue ;;
        D) run_deployment; continue ;;
        Q) clear; echo -e "${CYAN}До побачення!${NC}\n"; exit 0 ;;
        *) continue ;;
    esac
    [ "${SERVICES[$svc]}" -eq 0 ] && SERVICES[$svc]=1 || SERVICES[$svc]=0
done