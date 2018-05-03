#!/bin/bash


echo "Borro default gateways asignados por Docker"

docker exec -it dockertp4_h11_1 ip -6 route del default
docker exec -it dockertp4_h12_1 ip -6 route del default
docker exec -it dockertp4_h13_1 ip -6 route del default
docker exec -it dockertp4_h14_1 ip -6 route del default
docker exec -it dockertp4_r3_1 ip -6 route del default
docker exec -it dockertp4_r4_1 ip -6 route del default
docker exec -it dockertp4_r5_1 ip -6 route del default
docker exec -it dockertp4_r6_1 ip -6 route del default
docker exec -it dockertp4_r7_1 ip -6 route del default
docker exec -it dockertp4_r8_1 ip -6 route del default
docker exec -it dockertp4_r1_1 ip -6 route del default
docker exec -it dockertp4_r2_1 ip -6 route del default

echo "Asigno nuevo default gw"
docker exec -it dockertp4_h11_1 ip -6 route add default via 2001:a115::5
docker exec -it dockertp4_h13_1 ip -6 route add default via 2001:a137::7
docker exec -it dockertp4_h12_1 ip -6 route add default via 2001:b612::6
docker exec -it dockertp4_h14_1 ip -6 route add default via 2001:b814::8
