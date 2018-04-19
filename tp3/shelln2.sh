#!/bin/bash
ip netns add ns2.1
ip netns add ns2.2
ip netns add ns2.3
ip netns add ns2.4
ip netns add ns2.5
ip netns add ns2.6

brctl addbr br-externo1


ip link add name ns1-1-e1 type veth peer name br-externo-1-e1
ip link set ns1-1-e1 netns ns2.1
brctl addif br-externo1 br-externo-1-e1
brctl addif br-externo1 enp2s0


ip netns exec ns2.1 ip -6 addr add 2001:aaaa:bbbb:bbb0::21/64 dev ns1-1-e1
ip -6 addr add 2001:aaaa:bbbb:bbb0::22/64 dev br-externo-1-e1
###################ip -6 addr add 2001:aaaa:bbbb:bbb0::12/64 dev br-externo1

ip link set dev br-externo1 up

ip link add name ns1-1-e2 type veth peer name ns1-2-e1
ip link set ns1-1-e2 netns ns2.1
ip link set ns1-2-e1 netns ns2.2

ip link add name ns1-1-e3 type veth peer name ns1-3-e1
ip link set ns1-1-e3 netns ns2.1
ip link set ns1-3-e1 netns ns2.3

ip link add name ns1-1-e4 type veth peer name ns1-4-e1
ip link set ns1-1-e4 netns ns2.1
ip link set ns1-4-e1 netns ns2.4

ip link add name ns1-3-e2 type veth peer name ns1-4-e2
ip link set ns1-3-e2 netns ns2.3
ip link set ns1-4-e2 netns ns2.4

ip link add name ns1-3-e3 type veth peer name ns1-5-e1
ip link set ns1-3-e3 netns ns2.3
ip link set ns1-5-e1 netns ns2.5

ip link add name ns1-4-e3 type veth peer name ns1-6-e1
ip link set ns1-4-e3 netns ns2.4
ip link set ns1-6-e1 netns ns2.6


#Loopback ns2.2
ip link add ns2.2lo type dummy
ip link set ns2.2lo netns ns2.2
ip netns exec ns2.2 ip link set up dev ns2.2lo
ip netns exec ns2.2 ip addr add 2001:aaaa:bbbb:bbb7::1/64 dev ns2.2lo




#Levantamos todas las interfaces
ip link set dev br-externo-1-e1 up

ip netns exec ns2.1 ip link set dev lo up
ip netns exec ns2.1 ip link set dev ns1-1-e1 up
ip netns exec ns2.1 ip link set dev ns1-1-e2 up
ip netns exec ns2.1 ip link set dev ns1-1-e3 up
ip netns exec ns2.1 ip link set dev ns1-1-e4 up

ip netns exec ns2.2 ip link set dev lo up
ip netns exec ns2.2 ip link set dev ns1-2-e1 up

ip netns exec ns2.3 ip link set dev lo up
ip netns exec ns2.3 ip link set dev ns1-3-e1 up
ip netns exec ns2.3 ip link set dev ns1-3-e2 up
ip netns exec ns2.3 ip link set dev ns1-3-e3 up

ip netns exec ns2.4 ip link set dev lo up
ip netns exec ns2.4 ip link set dev ns1-4-e1 up
ip netns exec ns2.4 ip link set dev ns1-4-e2 up
ip netns exec ns2.4 ip link set dev ns1-4-e3 up

ip netns exec ns2.5 ip link set dev lo up
ip netns exec ns2.5 ip link set dev ns1-5-e1 up

ip netns exec ns2.6 ip link set dev lo up
ip netns exec ns2.6 ip link set dev ns1-6-e1 up


#Asignamos direccion ipv6 a cada interfaz 
ip netns exec ns2.1 ip -6 addr add 2001:aaaa:bbbb:bbbd::1/64 dev ns1-1-e2
ip netns exec ns2.1 ip -6 addr add 2001:aaaa:bbbb:bbbf::2/64 dev ns1-1-e3
ip netns exec ns2.1 ip -6 addr add 2001:aaaa:bbbb:bbbc::2/64 dev ns1-1-e4

ip netns exec ns2.2 ip -6 addr add 2001:aaaa:bbbb:bbbd::2/64 dev ns1-2-e1

ip netns exec ns2.3 ip -6 addr add 2001:aaaa:bbbb:bbbf::1/64 dev ns1-3-e1
ip netns exec ns2.3 ip -6 addr add 2001:aaaa:bbbb:bbbe::1/64 dev ns1-3-e2
ip netns exec ns2.3 ip -6 addr add 2001:aaaa:bbbb:bbba::2/64 dev ns1-3-e3

ip netns exec ns2.4 ip -6 addr add 2001:aaaa:bbbb:bbbc::1/64 dev ns1-4-e1
ip netns exec ns2.4 ip -6 addr add 2001:aaaa:bbbb:bbbe::2/64 dev ns1-4-e2
ip netns exec ns2.4 ip -6 addr add 2001:aaaa:bbbb:bbbb::2/64 dev ns1-4-e3

ip netns exec ns2.5 ip -6 addr add 2001:aaaa:bbbb:bbba::1/64 dev ns1-5-e1

ip netns exec ns2.6 ip -6 addr add 2001:aaaa:bbbb:bbbb::1/64 dev ns1-6-e1


#Habilito forwarding
ip netns exec ns2.1 sysctl -w net.ipv6.conf.all.forwarding=1
ip netns exec ns2.2 sysctl -w net.ipv6.conf.all.forwarding=1
ip netns exec ns2.3 sysctl -w net.ipv6.conf.all.forwarding=1
ip netns exec ns2.4 sysctl -w net.ipv6.conf.all.forwarding=1


#Ruteo estatico

#Hosts
ip netns exec ns2.5 route -A inet6 add default gw 2001:aaaa:bbbb:bbba::2 dev ns1-5-e1
ip netns exec ns2.6 route -A inet6 add default gw 2001:aaaa:bbbb:bbbb::2 dev ns1-6-e1

#Routers
#ip netns exec ns2.1 route -A inet6 add default gw 2001:aaaa:bbbb:bbb0::1  dev veth-ns11br-1
ip netns exec ns2.2 route -A inet6 add default gw 2001:aaaa:bbbb:bbbd::1
ip netns exec ns2.3 route -A inet6 add 2001:aaaa:bbbb:bbbb::0/64 gw 2001:aaaa:bbbb:bbbe::2
ip netns exec ns2.3 route -A inet6 add default gw 2001:aaaa:bbbb:bbbf::2
ip netns exec ns2.4 route -A inet6 add 2001:aaaa:bbbb:bbba::0/64 gw 2001:aaaa:bbbb:bbbe::1
ip netns exec ns2.4 route -A inet6 add default gw 2001:aaaa:bbbb:bbbc::2

ip netns exec ns2.1 route -A inet6 add 2001:aaaa:bbbb:bbba::0/64 gw 2001:aaaa:bbbb:bbbf::1
ip netns exec ns2.1 route -A inet6 add 2001:aaaa:bbbb:bbb7::0/64 gw 2001:aaaa:bbbb:bbbd::2
ip netns exec ns2.1 route -A inet6 add 2001:aaaa:bbbb:bbbb::0/64 gw 2001:aaaa:bbbb:bbbc::1
ip netns exec ns2.1 route -A inet6 add default gw 2001:aaaa:bbbb:bbb0::11




#Pings.
echo "Probando conectividad entre hosts..."
#sleep 10
#ip netns exec ns2.5 ping6 2001:aaaa:bbbb:bbb5::23 -I  veth-ns2325-2 -c 3
#ip netns exec ns2.6 ping6 2001:aaaa:bbbb:bbb6::24 -I  veth-ns2426-2 -c 3
#ip netns exec ns2.1 ping6 2001:aaaa:bbbb:bbb0::20 -I  veth-ns21br-1 -c 3
#ip netns exec ns2.1 ping6 2001:aaaa:bbbb:bbb0::21 -I  veth-ns21br-1 -c 3
#ip netns exec ns2.1 ping6 2001:aaaa:bbbb:bbb0::22 -I  veth-ns21br-1 -c 3
#ip netns exec ns2.1 ping6 2001:aaaa:bbbb:bbb0::10 -I  veth-ns21br-1 -c 3
#ip netns exec ns2.2 ping6 2001:aaaa:bbbb:bbb1::21 -I  veth-ns2122-2 -c 3
#ip netns exec ns2.3 ping6 2001:aaaa:bbbb:bbb2::21 -I  veth-ns2123-2 -c 3
#ip netns exec ns2.3 ping6 2001:aaaa:bbbb:bbb4::24 -I  veth-ns2324-1 -c 3
#ip netns exec ns2.4 ping6 2001:aaaa:bbbb:bbb3::21 -I  veth-ns2124-2 -c 3
#ip netns exec ns2.4 ping6 2001:aaaa:bbbb:bbb5::25 -I  veth-ns2324-2 -c 3
#ip netns exec ns2.5 ping6 2001:aaaa:bbbb:bbb2::21 -I  veth-ns2325-2 -c 3
#ip netns exec ns2.6 ping6 2001:aaaa:bbbb:bbb3::21 -I  veth-ns2426-2 -c 3
#ip netns exec ns2.6 ping6 2001:aaaa:bbbb:bbb5::25 -I  veth-ns2426-2 -c 3



#Cambio de MTU a interfaz de ns2.1 que se dirige al bridge.
echo "Cambio de MTU"
ip netns exec ns2.1 ip link set ns1-1-e1 mtu 1280