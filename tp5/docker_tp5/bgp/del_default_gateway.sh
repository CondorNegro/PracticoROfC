#!/bin/bash


echo "Borro default gateways asignados por Docker"

docker exec -it bgp_h11_1 ip -6 route del default
docker exec -it bgp_h12_1 ip -6 route del default
docker exec -it bgp_h13_1 ip -6 route del default
docker exec -it bgp_h14_1 ip -6 route del default
docker exec -it bgp_r3_1 ip -6 route del default
docker exec -it bgp_r4_1 ip -6 route del default
docker exec -it bgp_r9_1 ip -6 route del default
docker exec -it bgp_r5_1 ip -6 route del default
docker exec -it bgp_r6_1 ip -6 route del default
docker exec -it bgp_r7_1 ip -6 route del default
docker exec -it bgp_r8_1 ip -6 route del default
docker exec -it bgp_b1_1 ip -6 route del default
docker exec -it bgp_b2_1 ip -6 route del default
docker exec -it bgp_b3_1 ip -6 route del default

echo "Asigno nuevo default gw"
docker exec -it bgp_h11_1 ip -6 route add default via 2001:a115::5
docker exec -it bgp_h13_1 ip -6 route add default via 2001:a137::7
docker exec -it bgp_h12_1 ip -6 route add default via 2001:b612::6
docker exec -it bgp_h14_1 ip -6 route add default via 2001:b814::8


