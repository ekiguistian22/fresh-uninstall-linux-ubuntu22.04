#!/bin/bash
# =====================================================
# RESET UBUNTU 22.04 ke kondisi hampir fresh install
# WARNING: Jalankan hanya jika benar-benar paham resikonya!
# Script by Eki Guistian
# =====================================================

echo ">>> Update repos"
sudo apt update

echo ">>> Install paket default minimal (ubuntu-desktop-minimal)"
sudo apt install --reinstall ubuntu-desktop-minimal -y

echo ">>> Remove semua aplikasi tambahan"
sudo apt autoremove --purge -y
sudo apt remove --purge $(dpkg --get-selections | grep -v deinstall | awk '{print $1}' | grep -v -E "ubuntu-desktop-minimal|bash|coreutils|dpkg|apt|systemd|login|sudo") -y || true

echo ">>> Bersihkan config lama"
sudo rm -rf /etc/* 2>/dev/null
sudo rm -rf /var/log/* 2>/dev/null
sudo rm -rf /var/cache/* 2>/dev/null
sudo rm -rf /tmp/* 2>/dev/null

echo ">>> Reset network"
sudo rm -rf /etc/netplan/*
sudo tee /etc/netplan/01-netcfg.yaml >/dev/null <<EOF
network:
  version: 2
  renderer: NetworkManager
EOF
sudo netplan apply

echo ">>> Reset home directory (hapus semua file user)"
sudo rm -rf /home/*

echo ">>> Bersihkan apt cache"
sudo apt clean
sudo apt autoremove -y

echo ">>> Selesai. Reboot diperlukan."
