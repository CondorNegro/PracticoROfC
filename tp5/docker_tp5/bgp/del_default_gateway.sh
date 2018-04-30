#!/bin/bash


echo "Borro default gateways asignados por Docker"

docker exec -it bgp_r1_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_r1_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_r2_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_r2_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_b1_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_b1_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_b2_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_b2_1 ip -6 route del fe80::/64 dev eth1
