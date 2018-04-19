#!/bin/bash
ip netns add ns1.1
ip netns add ns1.2
ip netns add ns1.3
ip netns add ns1.4
ip netns add ns1.5
ip netns add ns1.6

brctl addbr br-externo1


ip link add name ns1-1-e1 type veth peer name br-externo-1-e1
ip link set ns1-1-e1 netns ns1.1

brctl addif br-externo1 br-externo-1-e1
brctl addif br-externo1 enx000ec6f9390a


ip netns exec ns1.1 ip -6 addr add 2001:aaaa:bbbb:bbb0::11/64 dev ns1-1-e1
ip -6 addr add 2001:aaaa:bbbb:bbb0::12/64 dev br-externo-1-e1
###################ip -6 addr add 2001:aaaa:bbbb:bbb0::12/64 dev br-externo1

ip link set dev br-externo1 up

ip link add name ns1-1-e2 type veth peer name ns1-2-e1
ip link set ns1-1-e2 netns ns1.1
ip link set ns1-2-e1 netns ns1.2

ip link add name ns1-1-e3 type veth peer name ns1-3-e1
ip link set ns1-1-e3 netns ns1.1
ip link set ns1-3-e1 netns ns1.3

ip link add name ns1-1-e4 type veth peer name ns1-4-e1
ip link set ns1-1-e4 netns ns1.1
ip link set ns1-4-e1 netns ns1.4

ip link add name ns1-3-e2 type veth peer name ns1-4-e2
ip link set ns1-3-e2 netns ns1.3
ip link set ns1-4-e2 netns ns1.4

ip link add name ns1-3-e3 type veth peer name ns1-5-e1
ip link set ns1-3-e3 netns ns1.3
ip link set ns1-5-e1 netns ns1.5

ip link add name ns1-4-e3 type veth peer name ns1-6-e1
ip link set ns1-4-e3 netns ns1.4
ip link set ns1-6-e1 netns ns1.6


ip link add ns1.2lo type dummy
ip link set ns1.2lo netns ns1.2
ip netns exec ns1.2 ip link set up dev ns1.2lo
ip netns exec ns1.2 ip addr add 2001:aaaa:aaaa:aaa7::1/64 dev ns1.2lo


#Levantamos todas las interfaces
ip link set dev br-externo-1-e1 up

ip netns exec ns1.1 ip link set dev lo up
ip netns exec ns1.1 ip link set dev ns1-1-e1 up
ip netns exec ns1.1 ip link set dev ns1-1-e2 up
ip netns exec ns1.1 ip link set dev ns1-1-e3 up
ip netns exec ns1.1 ip link set dev ns1-1-e4 up

ip netns exec ns1.2 ip link set dev lo up
ip netns exec ns1.2 ip link set dev ns1-2-e1 up

ip netns exec ns1.3 ip link set dev lo up
ip netns exec ns1.3 ip link set dev ns1-3-e1 up
ip netns exec ns1.3 ip link set dev ns1-3-e2 up
ip netns exec ns1.3 ip link set dev ns1-3-e3 up

ip netns exec ns1.4 ip link set dev lo up
ip netns exec ns1.4 ip link set dev ns1-4-e1 up
ip netns exec ns1.4 ip link set dev ns1-4-e2 up
ip netns exec ns1.4 ip link set dev ns1-4-e3 up

ip netns exec ns1.5 ip link set dev lo up
ip netns exec ns1.5 ip link set dev ns1-5-e1 up

ip netns exec ns1.6 ip link set dev lo up
ip netns exec ns1.6 ip link set dev ns1-6-e1 up


#Asignamos direccion ipv6 a cada interfaz 
ip netns exec ns1.1 ip -6 addr add 2001:aaaa:aaaa:aaad::1/64 dev ns1-1-e2
ip netns exec ns1.1 ip -6 addr add 2001:aaaa:aaaa:aaaf::2/64 dev ns1-1-e3
ip netns exec ns1.1 ip -6 addr add 2001:aaaa:aaaa:aaac::2/64 dev ns1-1-e4

ip netns exec ns1.2 ip -6 addr add 2001:aaaa:aaaa:aaad::2/64 dev ns1-2-e1

ip netns exec ns1.3 ip -6 addr add 2001:aaaa:aaaa:aaaf::1/64 dev ns1-3-e1
ip netns exec ns1.3 ip -6 addr add 2001:aaaa:aaaa:aaae::1/64 dev ns1-3-e2
ip netns exec ns1.3 ip -6 addr add 2001:aaaa:aaaa:aaaa::2/64 dev ns1-3-e3

ip netns exec ns1.4 ip -6 addr add 2001:aaaa:aaaa:aaac::1/64 dev ns1-4-e1
ip netns exec ns1.4 ip -6 addr add 2001:aaaa:aaaa:aaae::2/64 dev ns1-4-e2
ip netns exec ns1.4 ip -6 addr add 2001:aaaa:aaaa:aaab::2/64 dev ns1-4-e3

ip netns exec ns1.5 ip -6 addr add 2001:aaaa:aaaa:aaaa::1/64 dev ns1-5-e1

ip netns exec ns1.6 ip -6 addr add 2001:aaaa:aaaa:aaab::1/64 dev ns1-6-e1


#Habilito forwarding
ip netns exec ns1.1 sysctl -w net.ipv6.conf.all.forwarding=1
ip netns exec ns1.2 sysctl -w net.ipv6.conf.all.forwarding=1
ip netns exec ns1.3 sysctl -w net.ipv6.conf.all.forwarding=1
ip netns exec ns1.4 sysctl -w net.ipv6.conf.all.forwarding=1


#Ruteo estatico

#Hosts
ip netns exec ns1.5 route -A inet6 add default gw 2001:aaaa:aaaa:aaaa::2 dev ns1-5-e1
ip netns exec ns1.6 route -A inet6 add default gw 2001:aaaa:aaaa:aaab::2 dev ns1-6-e1

#Routers
#ip netns exec ns1.1 route -A inet6 add default gw 2001:aaaa:bbbb:bbb0::1  dev veth-ns11br-1
ip netns exec ns1.2 route -A inet6 add default gw 2001:aaaa:aaaa:aaad::1
ip netns exec ns1.3 route -A inet6 add 2001:aaaa:aaaa:aaab::0/64 gw 2001:aaaa:aaaa:aaae::2
ip netns exec ns1.3 route -A inet6 add default gw 2001:aaaa:aaaa:aaaf::2
ip netns exec ns1.4 route -A inet6 add 2001:aaaa:aaaa:aaaa::0/64 gw 2001:aaaa:aaaa:aaae::1
ip netns exec ns1.4 route -A inet6 add default gw 2001:aaaa:aaaa:aaac::2

ip netns exec ns1.1 route -A inet6 add 2001:aaaa:aaaa:aaaa::0/64 gw 2001:aaaa:aaaa:aaaf::1
ip netns exec ns1.1 route -A inet6 add 2001:aaaa:aaaa:aaab::0/64 gw 2001:aaaa:aaaa:aaac::1
ip netns exec ns1.1 route -A inet6 add 2001:aaaa:aaaa:aaa7::0/64 gw 2001:aaaa:aaaa:aaad::2
ip netns exec ns1.1 route -A inet6 add default gw 2001:aaaa:bbbb:bbb0::21

echo "cambio de MTU"
ip netns exec ns1.1 ip link set ns1-1-e1 mtu 1280