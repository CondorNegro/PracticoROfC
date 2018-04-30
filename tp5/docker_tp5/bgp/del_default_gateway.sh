#!/bin/bash


echo "Borro default gateways asignados por Docker"

docker exec -it bgp_r3_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_r3_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_r4_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_r4_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_r9_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_r9_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_r5_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_r5_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_r5_1 ip -6 route del fe80::/64 dev eth2
docker exec -it bgp_r6_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_r6_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_r6_1 ip -6 route del fe80::/64 dev eth2
docker exec -it bgp_r7_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_r7_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_r7_1 ip -6 route del fe80::/64 dev eth2
docker exec -it bgp_r8_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_r8_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_r8_1 ip -6 route del fe80::/64 dev eth2
docker exec -it bgp_b1_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_b1_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_b1_1 ip -6 route del fe80::/64 dev eth2
docker exec -it bgp_b1_1 ip -6 route del fe80::/64 dev eth3
docker exec -it bgp_b1_1 ip -6 route del fe80::/64 dev eth4
docker exec -it bgp_b2_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_b2_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_b2_1 ip -6 route del fe80::/64 dev eth2
docker exec -it bgp_b2_1 ip -6 route del fe80::/64 dev eth3
docker exec -it bgp_b2_1 ip -6 route del fe80::/64 dev eth4
docker exec -it bgp_b3_1 ip -6 route del fe80::/64 dev eth0
docker exec -it bgp_b3_1 ip -6 route del fe80::/64 dev eth1
docker exec -it bgp_b3_1 ip -6 route del fe80::/64 dev eth2
