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
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A INPUT -p TCP --dport ssh -j ACCEPT

# Allow Postfix (Don't become a spam relay)
#iptables -A INPUT -p tcp --dport 25 -j ACCEPT
#ip6tables -A INPUT -p TCP --dport 25 -j ACCEPT

# Allow Apache
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
ip6tables -A INPUT -p TCP --dport http -j ACCEPT

# Allow AdGuard Home
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
ip6tables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
ip6tables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
ip6tables -A INPUT -p tcp --dport 8080 -j ACCEPT

# Mumble Server
iptables -A INPUT -p tcp --dport 64738 -j ACCEPT
ip6tables -A INPUT -p tcp --dport 64738 -j ACCEPT
iptables -A INPUT -p udp --dport 64738 -j ACCEPT
ip6tables -A INPUT -p udp --dport 64738 -j ACCEPT

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

