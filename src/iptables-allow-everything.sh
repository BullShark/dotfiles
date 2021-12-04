#!/bin/bash
 
iptables -F
iptables -X
iptables -Z
 
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

ip6tables -F
ip6tables -X
ip6tables -Z

ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT
