#!bin/bash


#Ejecutar en modo root todo el siguiente script:

ip netns

#Agrego namespace ns2.1
echo "Agrego namespace ns2.1"
ip netns add ns2.1

#Agrego bridge
echo "Agrego bridge"
brctl addbr br-externo

#Muestro informacion de que lo anterior se ejecuto correctamente.
echo "Info bridge"
/sbin/ifconfig br-externo
echo "Info namespaces"
ip netns

#Creo veth peer
echo "Creo veth peer"
ip link add name veth-ns21br-1 type veth peer name veth-ns21br-2

#Conecto un extremo del veth peer a ns2.1
echo "Conecto un extremo del veth peer a ns2.1"
ip link set veth-ns21br-1 netns ns2.1

#Agrego interfaces a bridge. (enp0s3 y el otro extremo del veth peer).
echo "Agrego interfaces a bridge"
brctl addif br-externo veth-ns21br-2 enp0s3

#Levanto bridge
echo "Levanto bridge"
ip link set dev br-externo up

#Muestro informacion de lo anterior.
echo "Info bridge"
brctl show
echo "Info ns2.1 links"
ip netns exec ns2.1 ip link

#Direccionamiento IPv6
echo "Direccionamiento IPv6"
ip netns exec ns2.1 ip -6 addr add 2001:aaaa:bbbb:bbb0::21/64 dev veth-ns21br-1
ip -6 addr add 2001:aaaa:bbbb:bbb0::1/64 dev veth-ns21br-2

#Cambio de MTU a interfaz de ns2.1 que se dirige al bridge.
echo "Cambio de MTU"
ip netns exec ns2.1 ip link set veth-ns21br-1 mtu 500

#Levanto interfaces
echo "Levanto interfaces"
ip link set up dev veth-ns21br-2
ip netns exec ns2.1 ip link set up dev veth-ns21br-1
ip netns exec ns2.1 ip link set up dev lo


#Muestro informacion de lo anterior.
echo "Info bridge"
brctl show
echo "Info ns2.1 links"
ip netns exec ns2.1 ip link


#Agrego namespaces restantes
echo "Agrego namespaces restantes"
ip netns add ns2.2
ip netns add ns2.3
ip netns add ns2.4
ip netns add ns2.5
ip netns add ns2.6
echo "Info namespaces"
ip netns


#Levanto interfaces de loopback
echo "Levanto interfaces de loopback"
ip netns exec ns2.2 ip link set up dev lo
ip netns exec ns2.3 ip link set up dev lo
ip netns exec ns2.4 ip link set up dev lo
ip netns exec ns2.5 ip link set up dev lo
ip netns exec ns2.6 ip link set up dev lo

#Creo veth peers restantes
echo "Creo veth peers restantes"
ip link add name veth-ns22lo-1 type veth peer name veth-ns22lo-2
ip link add name veth-ns2122-1 type veth peer name veth-ns2122-2
ip link add name veth-ns2123-1 type veth peer name veth-ns2123-2
ip link add name veth-ns2124-1 type veth peer name veth-ns2124-2
ip link add name veth-ns2325-1 type veth peer name veth-ns2325-2
ip link add name veth-ns2426-1 type veth peer name veth-ns2426-2
ip link add name veth-ns2324-1 type veth peer name veth-ns2324-2

#Conexiones.
echo "Conexiones"
ip link set veth-ns22lo-1 netns ns2.2
ip link set veth-ns2122-1 netns ns2.1
ip link set veth-ns2122-2 netns ns2.2
ip link set veth-ns2123-1 netns ns2.1
ip link set veth-ns2123-2 netns ns2.3
ip link set veth-ns2124-1 netns ns2.1
ip link set veth-ns2124-2 netns ns2.4
ip link set veth-ns2325-1 netns ns2.3
ip link set veth-ns2325-2 netns ns2.5
ip link set veth-ns2426-1 netns ns2.4
ip link set veth-ns2426-2 netns ns2.6
ip link set veth-ns2324-1 netns ns2.3
ip link set veth-ns2324-2 netns ns2.4

#Asignamiento IP.
echo "Asignamiento IP"
ip netns exec ns2.1 ip -6 addr add 2001:aaaa:bbbb:bbb1::21/64 dev veth-ns2122-1
ip netns exec ns2.1 ip -6 addr add 2001:aaaa:bbbb:bbb2::21/64 dev veth-ns2123-1
ip netns exec ns2.1 ip -6 addr add 2001:aaaa:bbbb:bbb3::21/64 dev veth-ns2124-1
ip netns exec ns2.2 ip -6 addr add 2001:aaaa:bbbb:bbb1::22/64 dev veth-ns2122-2
ip netns exec ns2.3 ip -6 addr add 2001:aaaa:bbbb:bbb2::23/64 dev veth-ns2123-2
ip netns exec ns2.3 ip -6 addr add 2001:aaaa:bbbb:bbb4::23/64 dev veth-ns2324-1
ip netns exec ns2.3 ip -6 addr add 2001:aaaa:bbbb:bbb5::23/64 dev veth-ns2325-1
ip netns exec ns2.4 ip -6 addr add 2001:aaaa:bbbb:bbb3::24/64 dev veth-ns2124-2
ip netns exec ns2.4 ip -6 addr add 2001:aaaa:bbbb:bbb4::24/64 dev veth-ns2324-2
ip netns exec ns2.4 ip -6 addr add 2001:aaaa:bbbb:bbb6::24/64 dev veth-ns2426-1
ip netns exec ns2.5 ip -6 addr add 2001:aaaa:bbbb:bbb5::25/64 dev veth-ns2325-2
ip netns exec ns2.6 ip -6 addr add 2001:aaaa:bbbb:bbb6::26/64 dev veth-ns2426-2
ip netns exec ns2.2 ip -6 addr add 2001:aaaa:bbbb:bbb7::1/64 dev veth-ns22lo-1

#Levantamiento de interfaces.
echo "Levantamiento de interfaces"
ip netns exec ns2.1 ip link set up dev veth-ns2122-1
ip netns exec ns2.1 ip link set up dev veth-ns2123-1
ip netns exec ns2.1 ip link set up dev veth-ns2124-1
ip netns exec ns2.2 ip link set up dev veth-ns2122-2
ip netns exec ns2.3 ip link set up dev veth-ns2123-2
ip netns exec ns2.4 ip link set up dev veth-ns2124-2
ip netns exec ns2.3 ip link set up dev veth-ns2325-1
ip netns exec ns2.4 ip link set up dev veth-ns2426-1
ip netns exec ns2.5 ip link set up dev veth-ns2325-2
ip netns exec ns2.6 ip link set up dev veth-ns2426-2
ip netns exec ns2.3 ip link set up dev veth-ns2324-1
ip netns exec ns2.4 ip link set up dev veth-ns2324-2
ip netns exec ns2.2 ip link set up dev veth-ns22lo-1



#IP forwarding de routers.
echo "IP forwarding en los routers"
ip netns exec ns2.1 sysctl -w net.ipv4.ip_forward=1
ip netns exec ns2.2 sysctl -w net.ipv4.ip_forward=1
ip netns exec ns2.3 sysctl -w net.ipv4.ip_forward=1
ip netns exec ns2.4 sysctl -w net.ipv4.ip_forward=1

#Ruteo estatico
echo "Ruteo estatico"
#ip netns exec ns2.2 route add default via 2001:aaaa:bbbb:bbb1:0:0:0:21
#ip netns exec ns2.3 route add -net6 2001:aaaa:bbbb:bbb6:0:0:0:0 netmask 64 via 2001:aaaa:bbbb:bbb4:0:0:0:24
#ip netns exec ns2.3 route add default via 2001:aaaa:bbbb:bbb2:0:0:0:21
#ip netns exec ns2.4 route add -net6 2001:aaaa:bbbb:bbb5:0:0:0:0 netmask 64 via 2001:aaaa:bbbb:bbb4:0:0:0:23
#ip netns exec ns2.4 route add default via 2001:aaaa:bbbb:bbb3:0:0:0:21
#ip netns exec ns2.2 route add default via 2001:aaaa:bbbb:bbb1:0:0:0:22

echo "Info ruteo"
ip netns exec ns2.1 route
ip netns exec ns2.2 route 
ip netns exec ns2.3 route 
ip netns exec ns2.4 route

#Pings.
echo "Probando conectividad entre hosts..."
sleep 10
ip netns exec ns2.5 ping6 2001:aaaa:bbbb:bbb5::23 -I  veth-ns2325-2 -c 3
ip netns exec ns2.6 ping6 2001:aaaa:bbbb:bbb6::24 -I  veth-ns2426-2 -c 3
ip netns exec ns2.1 ping6 2001:aaaa:bbbb:bbb0::1 -I  veth-ns21br-1 -c 3
ip netns exec ns2.2 ping6 2001:aaaa:bbbb:bbb1::21 -I  veth-ns2122-2 -c 3
ip netns exec ns2.3 ping6 2001:aaaa:bbbb:bbb2::21 -I  veth-ns2123-2 -c 3
ip netns exec ns2.4 ping6 2001:aaaa:bbbb:bbb3::21 -I  veth-ns2124-2 -c 3
ip netns exec ns2.5 ping6 2001:aaaa:bbbb:bbb2::21 -I  veth-ns2325-2 -c 3
ip netns exec ns2.6 ping6 2001:aaaa:bbbb:bbb3::21 -I  veth-ns2426-2 -c 3









 
