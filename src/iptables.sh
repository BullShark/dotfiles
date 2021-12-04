#!/bin/bash
 
iptables -F
iptables -X
iptables -Z
 
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
 
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# Allow SSH
iptables -A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP
ip6tables -A INPUT -p tcp --dport 22 -j DROP

# KDE Connect
iptables -A INPUT -p tcp -m state --state NEW --dport 1716 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --dport 1716 -j ACCEPT
iptables -A INPUT -p tcp --dport 1716 -j DROP
ip6tables -A INPUT -p tcp --dport 1716 -j DROP

# Samba (LAN)
iptables -A INPUT -p tcp -m state --state NEW --source 192.168.0.1/24 --dport 137 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --source 192.168.0.1/24 --dport 137 -j ACCEPT
iptables -A INPUT -p tcp --dport 137 -j DROP
ip6tables -A INPUT -p tcp --dport 137 -j DROP

iptables -A INPUT -p tcp -m state --state NEW --source 192.168.0.1/24 --dport 138 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --source 192.168.0.1/24 --dport 138 -j ACCEPT
iptables -A INPUT -p tcp --dport 138 -j DROP
ip6tables -A INPUT -p tcp --dport 138 -j DROP

iptables -A INPUT -p tcp -m state --state NEW --source 192.168.0.1/24 --dport 139 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --source 192.168.0.1/24 --dport 139 -j ACCEPT
iptables -A INPUT -p tcp --dport 139 -j DROP
ip6tables -A INPUT -p tcp --dport 139 -j DROP


# Allow Postfix (Don't become a spam relay)
iptables -A INPUT -p tcp -m state --state NEW --source 192.168.0.1/24 --dport 25 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --source 192.168.0.1/24 --dport 25 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW --source 127.0.0.1 --dport 25 -j ACCEPT
ip6tables -A INPUT -p tcp -m state --state NEW --source ::1 --dport 25 -j ACCEPT
iptables -A INPUT -p tcp --dport 25 -j DROP
ip6tables -A INPUT -p tcp --dport 25 -j DROP

# Allow Apache
#iptables -A INPUT -p tcp -m state --state NEW --dport 80 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j DROP
ip6tables -A INPUT -p tcp --dport 80 -j DROP

# Allow AdGuard Home
#iptables -A INPUT -p tcp -m state --state NEW --dport 53 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j DROP
ip6tables -A INPUT -p tcp --dport 53 -j DROP

#iptables -A INPUT -p udp -m state --state NEW --dport 53 -j ACCEPT
#ip6tables -A INPUT -p udp -m state --state NEW --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j DROP
ip6tables -A INPUT -p udp --dport 53 -j DROP

#iptables -A INPUT -p tcp -m state --state NEW --dport 8080 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j DROP
ip6tables -A INPUT -p tcp --dport 8080 -j DROP

# Netcat Reverse Shell
#iptables -A INPUT -p tcp -m state --state NEW --dport 1337 -j ACCEPT
#ip6tables -A INPUT -p tcp -m state --state NEW --dport 1337 -j ACCEPT
iptables -A INPUT -p tcp --dport 1337 -j DROP
ip6tables -A INPUT -p tcp --dport 1337 -j DROP

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
 
ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP 
ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
ip6tables -A INPUT -p udp -m conntrack --ctstate NEW -j REJECT --reject-with icmp6-port-unreachable
ip6tables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j REJECT --reject-with tcp-reset

