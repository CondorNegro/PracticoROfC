#!/bin/bash
echo "Borro lo creado"

#Ejecutar con sudo.

docker rm -f bgp_r1_1 bgp_r2_1 bgp_b1_1 bgp_b2_1


docker network prune


echo "Creo containers."


docker-compose up




