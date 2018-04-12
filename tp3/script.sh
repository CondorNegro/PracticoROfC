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
ip link add name veth-ns21-1 type veth peer name veth-ns21-2

#Conecto un extremo del veth peer a ns2.1
echo "Conecto un extremo del veth peer a ns2.1"
ip link set veth-ns21-1 netns ns2.1

#Agrego interfaces a bridge. (enp0s3 y el otro extremo del veth peer).
echo "Agrego interfaces a bridge"
brctl addif br-externo enp0s3 veth-ns21-2

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
ip netns exec ns2.1 ip -6 addr add 2001:aaaa:bbbb:bbbb::21/64 dev veth-ns21-1
ip -6 addr add 2001:aaaa:bbbb:bbbb::1 dev veth-ns21-2

#Cambio de MTU a interfaz de ns2.1 que se dirige al bridge.
echo "Cambio de MTU"
ip netns exec ns2.1 ip link set veth-ns21-1 mtu 500

#Levanto interfaces
echo "Levanto interfaces"
ip link set up dev veth-ns21-2
ip netns exec ns2.1 ip link set up dev veth-ns21-1
ip netns exec ns2.1 ip link set up dev lo








 
