#!/bin/bash
# Suggested:
#   Put this in /etc/rsyslog.conf
#   And iptables logs will have it's own file
#   kern.warning /var/log/iptables.log 
#set -x
#set -v

##################################################################%%%%%%%%
# Global variables
##################################################################%%%%%%%%

bullshark="70.112.0.0/12"
bullshark6="2603:8000::/24"
bullshark_hamachi="25.0.0.0/8"
bullshark_5g_mobile="172.32.0.0/11"
bullshark_5g_mobile6="2607:fb90::/28"
drk="184.155.0.0/16"
lan="192.168.0.0/16" # 192.168.0.0–192.168.255.255
lan6="fe80::/64"
localhost="127.0.0.0/8"
localhost6="::1/128"
local_net6="fc00::/7"
iface="enp3s0"
#iface="eth0"

##################################################################%%%%%%%%
# IPv6
##################################################################%%%%%%%%

ip6tables -F
ip6tables -X
ip6tables -Z
 
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT

# Might get noisy (info message)
ip6tables -A INPUT -j LOG -m limit --limit 5/min --log-prefix "ip6tables INPUT: " --log-level 6 --log-tcp-sequence --log-tcp-options --log-ip-options --log-uid

# Anti-spoofing
ip6tables -A INPUT ! -i lo -s $lan6 -j DROP
ip6tables -A INPUT -i $ -s $local_net6 -j DROP
ip6tables -A FORWARD -s $lan6 -j DROP
ip6tables -A FORWARD -i $iface -s $local_net6 -j DROP

# Block tunnel prefixes
ip6tables -A INPUT -s 2002::/16 -j DROP
ip6tables -A INPUT -s 2001:0::/32 -j DROP
ip6tables -A FORWARD -s 2002::/16 -j DROP
ip6tables -A FORWARD -s 2001:0::/32 -j DROP

# This has already been done above and should come before the opening port rules
ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT -m comment --comment "Localhost lo interface"
ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP 

# Log Blocked Traffic (log level: kernel warning)
ip6tables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "ip6tables denied: " --log-level 4 --log-tcp-sequence --log-tcp-options --log-ip-options --log-uid

# Log Any Forwarding Traffic (log level: kernel warning)
ip6tables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "ip6tables FORWARD denied: " --log-level 4 --log-tcp-sequence --log-tcp-options --log-ip-options --log-uid

ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
ip6tables -A INPUT -p udp -m conntrack --ctstate NEW -j REJECT --reject-with icmp6-port-unreachable
ip6tables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j REJECT --reject-with tcp-reset

##################################################################%%%%%%%%
# IPv4
##################################################################%%%%%%%%

iptables -F
iptables -X
iptables -Z
 
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Might get noisy (info message)
iptables -A INPUT -j LOG -m limit --limit 5/min --log-prefix "iptables INPUT: " --log-level 6 --log-tcp-sequence --log-tcp-options --log-ip-options --log-uid
 
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT -m comment --comment "Localhost lo interface"

# Allow SSH
iptables -A INPUT -p tcp -m state --state NEW --source $bullshark --dport 22 -j ACCEPT -m comment --comment "SSH"
ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark6 --dport 22 -j ACCEPT -m comment --comment "SSH"
iptables -A INPUT -p tcp -m state --state NEW --source $bullshark_5g_mobile --dport 22 -j ACCEPT -m comment --comment "SSH"
ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark_5g_mobile6 --dport 22 -j ACCEPT -m comment --comment "SSH"
iptables -A INPUT -p tcp -m state --state NEW --source $drk --dport 22 -j ACCEPT -m comment --comment "SSH"

# KDE Connect (LAN)
iptables -A INPUT -p tcp -m state --state NEW --source $lan --destination $lan --dport 1716 -j ACCEPT -m comment --comment "KDE Connect"
ip6tables -A INPUT -p tcp -m state --state NEW --source $lan6 --destination $lan6 --dport 1716 -j ACCEPT -m comment --comment "KDE Connect"

# Samba (LAN)
iptables -A INPUT -p tcp -m state --state NEW --source $lan --destination $lan --dport 137 -j ACCEPT -m comment --comment "Samba"
ip6tables -A INPUT -p tcp -m state --state NEW --source $lan6 --destination $lan6 --dport 137 -j ACCEPT -m comment --comment "Samba"
iptables -A INPUT -p tcp -m state --state NEW --source $lan --destination $lan --dport 138 -j ACCEPT -m comment --comment "Samba"
ip6tables -A INPUT -p tcp -m state --state NEW --source $lan6 --destination $lan6 --dport 138 -j ACCEPT -m comment --comment "Samba"
iptables -A INPUT -p tcp -m state --state NEW --source $lan --destination $lan --dport 139 -j ACCEPT -m comment --comment "Samba"
ip6tables -A INPUT -p tcp -m state --state NEW --source $lan6 --destination $lan6 --dport 139 -j ACCEPT -m comment --comment "Samba"

# Avahi Daemon (Used by my TV)
iptables -A INPUT -p udp -m state --state NEW --source $lan --destination $lan --dport 5353 -j ACCEPT -m comment --comment "Avahi"
ip6tables -A INPUT -p udp -m state --state NEW --source $lan6 --destination $lan6 --dport 5353 -j ACCEPT -m comment --comment "Avahi"

# Android Debugger ADB
iptables -A INPUT -p tcp -m state --state NEW --source $lan --destination $lan --dport 5037 -j ACCEPT -m comment --comment "ADB"
ip6tables -A INPUT -p tcp -m state --state NEW --source $lan6 --destination $lan6 --dport 5037 -j ACCEPT -m comment --comment "ADB"

# WireGuard (Bullshark and Drk)
#iptables -A INPUT -p udp -m state --state NEW --source $bullshark --dport 5555 -j ACCEPT -m comment --comment "Wireguard"
#ip6tables -A INPUT -p udp -m state --state NEW --source $bullshark6 --dport 5555 -j ACCEPT -m comment --comment "Wireguard"
#iptables -A INPUT -p udp -m state --state NEW --source $drk --dport 5555 -j ACCEPT -m comment --comment "Wireguard"

# Allow Postfix (BullShark and LAN)
#iptables -A INPUT -p tcp -m state --state NEW --dport 25 -j ACCEPT -m comment --comment "Postfix"
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 25 -j ACCEPT -m comment --comment "Postfix"

# Dovecot (LAN and BullShark)
#iptables -A INPUT -p tcp -m state --state NEW --source $bullshark --dport 143 -j ACCEPT -m comment --comment "Dovecot"
#ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark6 --dport 143 -j ACCEPT -m comment --comment "Dovecot"
#iptables -A INPUT -p tcp -m state --state NEW --source $localhost --destination $localhost --dport 143 -j ACCEPT -m comment --comment "Dovecot"
#ip6tables -A INPUT -p tcp -m state --state NEW --source $localhost6 --destination $localhost6 --dport 143 -j ACCEPT -m comment --comment "Dovecot"
#iptables -A INPUT -p tcp -m state --state NEW --source $bullshark --dport 993 -j ACCEPT -m comment --comment "Dovecot"
#ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark6 --dport 993 -j ACCEPT -m comment --comment "Dovecot"
#iptables -A INPUT -p tcp -m state --state NEW --source $localhost --destination $localhost --dport 993 -j ACCEPT -m comment --comment "Dovecot"
#ip6tables -A INPUT -p tcp -m state --state NEW --source $localhost6 --destination $localhost6 --dport 993 -j ACCEPT -m comment --comment "Dovecot"

# Allow Apache
#iptables -A INPUT -p tcp -m state --state NEW --dport 80 -j ACCEPT -m comment --comment "Apache"
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 80 -j ACCEPT -m comment --comment "Apache"

# Apache HTTPS
#iptables -A INPUT -p tcp -m state --state NEW --dport 443 -j ACCEPT -m comment --comment "Apache HTTPS"
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 443 -j ACCEPT -m comment --comment "Apache HTTPS"

# Python Flask
#iptables -A INPUT -p tcp -m state --state NEW --dport 5000 -j ACCEPT -m comment --comment "Flask"
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 5000 -j ACCEPT -m comment --comment "Flask"

# Allow AdGuard Home (BullShark on the Web UI)
#iptables -A INPUT -p tcp -m state --state NEW --dport 53 -j ACCEPT -m comment --comment "Adguard Home"
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 53 -j ACCEPT -m comment --comment "Adguard Home"
#iptables -A INPUT -p udp -m state --state NEW --dport 53 -j ACCEPT -m comment --comment "Adguard Home"
#ip6tables -A INPUT -p udp -m state --state NEW --dport 53 -j ACCEPT -m comment --comment "Adguard Home"
#iptables -A INPUT -p tcp -m state --state NEW --source $bullshark --dport 8080 -j ACCEPT -m comment --comment "Adguard Home Web"
#ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark6 --dport 8080 -j ACCEPT -m comment --comment "Adguard Home Web"

# Mumble Server
#iptables -A INPUT -p tcp -m state --state NEW --dport 64738 -j ACCEPT -m comment --comment "Mumble"
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 64738 -j ACCEPT -m comment --comment "Mumble"
#iptables -A INPUT -p udp -m state --state NEW --dport 64738 -j ACCEPT -m comment --comment "Mumble"
#ip6tables -A INPUT -p udp -m state --state NEW --dport 64738 -j ACCEPT -m comment --comment "Mumble"

# CraftBukkit
#iptables -A INPUT -p tcp -m state --state NEW --dport 25565 -j ACCEPT -m comment --comment "Minecraft"
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 25565 -j ACCEPT -m comment --comment "Minecraft"
#iptables -A INPUT -p udp -m state --state NEW --dport 25565 -j ACCEPT -m comment --comment "Minecraft"
#ip6tables -A INPUT -p udp -m state --state NEW --dport 25565 -j ACCEPT -m comment --comment "Minecraft"

# Mysql (localhost only)
#iptables -A INPUT -p tcp -m state --state NEW --source $localhost --destination $localhost --dport 3306 -j ACCEPT -m comment --comment "Mysql"
#ip6tables -A INPUT -p tcp -m state --state NEW --source $localhost6 --destination $localhost6 --dport 3306 -j ACCEPT -m comment --comment "Mysql"

# Postgresql (localhost only)
#iptables -A INPUT -p tcp -m state --state NEW -s $localhost --dport 5432 -j ACCEPT -m comment --comment "PostgreSQL"
#ip6tables -A INPUT -p tcp -m state --state NEW -s $localhost6 --dport 5432 -j ACCEPT -m comment --comment "PostgreSQL"

# Matrix
#iptables -A INPUT -p tcp -m state --state NEW --dport 8008 -j ACCEPT -m comment --comment "Matrix"
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 8008 -j ACCEPT -m comment --comment "Matrix"

# Netcat Reverse Shell (BullShark)
#iptables -A INPUT -p tcp -m state --state NEW --source $bullshark --dport 1337 -j ACCEPT -m comment --comment "Netcat"
#ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark6 --dport 1337 -j ACCEPT -m comment --comment "Netcat"

# Cockpit (BullShark)
#iptables -A INPUT -p tcp -m state --state NEW --source $bullshark --dport 9090 -j ACCEPT -m comment --comment "Cockpit"
#ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark6 --dport 9090 -j ACCEPT -m comment --comment "Cockpit"

# Webmin (BullShark)
#iptables -A INPUT -p tcp -m state --state NEW --source $bullshark --dport 10000 -j ACCEPT -m comment --comment "Webmin"
#ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark6 --dport 10000 -j ACCEPT -m comment --comment "Webmin"
#iptables -A INPUT -p udp -m state --state NEW --source $bullshark --dport 10000 -j ACCEPT -m comment --comment "Webmin"
#ip6tables -A INPUT -p udp -m state --state NEW --source $bullshark6 --dport 10000 -j ACCEPT -m comment --comment "Webmin"

# Log Blocked Traffic (log level: kernel warning)
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 4 --log-tcp-sequence --log-tcp-options --log-ip-options --log-uid

# Log Any Forwarding Traffic (log level: kernel warning)
iptables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "iptables FORWARD denied: " --log-level 4 --log-tcp-sequence --log-tcp-options --log-ip-options --log-uid

# Block IPv6 in IPv4
iptables -A INPUT -p 41 -j DROP -m comment --comment "IPv6 in IPv4"
iptables -A FORWARD -p 41 -j DROP -m comment --comment "IPv6 in IPv4"

# Ping
iptables -A INPUT -p icmp --icmp-type 3 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 11 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 12 -j ACCEPT
iptables -A INPUT -p tcp --syn --dport 113 -j REJECT --reject-with tcp-reset
 
