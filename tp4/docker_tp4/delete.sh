#!/bin/bash
echo "Borro lo creado"

#Ejecutar con sudo.

docker rm -f dockertp4_r1_1 dockertp4_r2_1 dockertp4_r3_1 dockertp4_r4_1 dockertp4_r5_1

docker rm -f dockertp4_r6_1 dockertp4_r7_1 dockertp4_r8_1

docker rm -f dockertp4_h11_1 dockertp4_h12_1 dockertp4_h13_1 dockertp4_h14_1


docker network prune
