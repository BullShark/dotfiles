#!/bin/bash
#set -x
#set -v

bullshark="70.123.216.149"
bullshark6="2603:8081:4c0e:700::3"
bullshark_hamachi="25.5.244.225"
drk="184.155.55.186"
lan="192.168.0.0/24"
lan6="fe80::/64"
localhost="127.0.0.0/8"
localhost6="::1"
local_net6="FC00::/7"
iface="enp3s0"

iptables -F
iptables -X
iptables -Z
 
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
 
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# Allow SSH (Limit to 2 connections)
iptables -A INPUT -p tcp -m state --state NEW -m connlimit --connlimit-above 2 --dport 22 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW -m connlimit --connlimit-above 2 --dport 22 -j ACCEPT

# KDE Connect
iptables -A INPUT -p tcp -m state --state NEW --dport 1716 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --dport 1716 -j ACCEPT

# Samba (LAN)
iptables -A INPUT -p tcp -m state --state NEW --source $lan --dport 137 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --source $lan6 --dport 137 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW --source $lan --dport 138 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --source $lan6 --dport 138 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW --source $lan --dport 139 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --source $lan6 --dport 139 -j ACCEPT

# WireGuard
#iptables -A INPUT -p udp -m state --state NEW --dport 5555 -j ACCEPT
#ip6tables -A INPUT -p udp -m state --state NEW --dport 5555 -j ACCEPT

# Allow Postfix (Don't become a spam relay)
#iptables -A INPUT -p tcp -m state --state NEW --source $bullshark --dport 25 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark6 --dport 25 -j ACCEPT
#iptables -A INPUT -p tcp -m state --state NEW --source $localhost --dport 25 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --source $localhost6 --dport 25 -j ACCEPT

# Dovecot
#iptables -A INPUT -p tcp -m state --state NEW --dport 143 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 143 -j ACCEPT
#iptables -A INPUT -p tcp -m state --state NEW --dport 993 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 993 -j ACCEPT

# Allow Apache (Limit to 15 connections)
#iptables -A INPUT -p tcp -m state --state NEW -m connlimit --connlimit-above 15 --dport 80 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW -m connlimit --connlimit-above 15 --dport 80 -j ACCEPT

# Apache HTTPS
#iptables -A INPUT -p tcp -m state --state NEW -m connlimit --connlimit-above 15 --dport 443 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW -m connlimit --connlimit-above 15 --dport 443 -j ACCEPT

# Python Flask
#iptables -A INPUT -p tcp -m state --state NEW --dport 5000 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 5000 -j ACCEPT

# Allow AdGuard Home
#iptables -A INPUT -p tcp -m state --state NEW --dport 53 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 53 -j ACCEPT
#iptables -A INPUT -p udp -m state --state NEW --dport 53 -j ACCEPT
#ip6tables -A INPUT -p udp -m state --state NEW --dport 53 -j ACCEPT
#iptables -A INPUT -p tcp -m state --state NEW --source $bullshark --dport 8080 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark6 --dport 8080 -j ACCEPT

# Mumble Server
#iptables -A INPUT -p tcp -m state --state NEW --dport 64738 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 64738 -j ACCEPT
#iptables -A INPUT -p udp -m state --state NEW --dport 64738 -j ACCEPT
#ip6tables -A INPUT -p udp -m state --state NEW --dport 64738 -j ACCEPT

# CraftBukkit
#iptables -A INPUT -p tcp -m state --state NEW --dport 25565 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 25565 -j ACCEPT
#iptables -A INPUT -p udp -m state --state NEW --dport 25565 -j ACCEPT
#ip6tables -A INPUT -p udp -m state --state NEW --dport 25565 -j ACCEPT

# Mysql (localhost only)
#iptables -A INPUT -p tcp -m state --state NEW --source $localhost --dport 3306 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --source $localhost6 --dport 3306 -j ACCEPT

# Postgresql (localhost only)
#iptables -A INPUT -p tcp -m state --state NEW -s $localhost --dport 5432 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW -s $localhost6 --dport 5432 -j ACCEPT

# Matrix
#iptables -A INPUT -p tcp -m state --state NEW --dport 8008 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 8008 -j ACCEPT

# Netcat Reverse Shell
#iptables -A INPUT -p tcp -m state --state NEW --source $bullshark --dport 1337 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --source $bullshark6 --dport 1337 -j ACCEPT

# Cockpit
#iptables -A INPUT -p tcp -m state --state NEW --dport 9090 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 9090 -j ACCEPT

# Webmin
#iptables -A INPUT -p tcp -m state --state NEW --dport 10000 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 10000 -j ACCEPT
#iptables -A INPUT -p udp -m state --state NEW --dport 10000 -j ACCEPT
#ip6tables -A INPUT -p udp -m state --state NEW --dport 10000 -j ACCEPT

# Log Blocked Traffic
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7
ip6tables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "ip6tables denied: " --log-level 7

# Log Any Forwarding Traffic
iptables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "iptables FORWARD denied: " --log-level 7
ip6tables -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "ip6tables FORWARD denied: " --log-level 7

# Block IPv6 in IPv4
iptables -A INPUT -p 41 -j DROP
iptables -A FORWARD -p 41 -j DROP

# Ping
iptables -A INPUT -p icmp --icmp-type 3 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 11 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 12 -j ACCEPT
iptables -A INPUT -p tcp --syn --dport 113 -j REJECT --reject-with tcp-reset
 
ip6tables -F
ip6tables -X
ip6tables -Z
 
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT

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

ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP 
ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
ip6tables -A INPUT -p udp -m conntrack --ctstate NEW -j REJECT --reject-with icmp6-port-unreachable
ip6tables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j REJECT --reject-with tcp-reset

