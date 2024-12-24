#!/bin/bash

ARCH=$(uname -a)
CPU=$(cat /proc/cpuinfo | grep -c ^processor /proc/cpuinfo)
VCPU=$(nproc)
MEMORY=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3, $2, $3*100/$2}')
DISK=$(df -h --total | awk '/total/{printf "%s/%s (%s)", $3, $2, $5}')
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.1f%%", $2+$4}')
LAST_BOOT=$(who -b | awk '{print $3, $4}')
LVM_USE=$(lsblk | grep -q "lvm" && echo "yes" || echo "no")
TCP_CONNECTIONS=$(ss -s | grep -oP '(?<=estab )[0-9]+')
USER_LOG=$(who | wc -l)
IP_ADDRESS=$(hostname -I | awk '{print $1}')
MAC_ADDRESS=$(ip link show| awk '/ether/ {print $2}')
SUDO_CMDS=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

MESSAGE="
# Architecture: $ARCH
# CPU physical: $CPU
# vCPU: $VCPU
# Memory Usage: $MEMORY
# Disk Usage: $DISK
# CPU load: $CPU_LOAD
# Last boot: $LAST_BOOT
# LVM use: $LVM_USE
# Connections TCP: $TCP_CONNECTIONS ESTABLISHED
# User log: $USER_LOG
# Network: IP $IP_ADDRESS ($MAC_ADDRESS)
# Sudo: $SUDO_CMDS cmd
"

wall "$MESSAGE" 2>/dev/null
