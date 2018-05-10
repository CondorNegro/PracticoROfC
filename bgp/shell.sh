#!/bin/bash
echo "Borro lo creado"

#Ejecutar con sudo.

docker rm -f bgp_b1_1 bgp_b2_1 bgp_b3_1
docker rm -f bgp_r3_1 bgp_r4_1 bgp_r5_1

docker rm -f bgp_r6_1 bgp_r7_1 bgp_r8_1 bgp_r9_1

docker rm -f bgp_h11_1 bgp_h12_1 bgp_h13_1 bgp_h14_1 



docker network prune


echo "Creo containers."


docker-compose up




