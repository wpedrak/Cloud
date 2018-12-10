#!/bin/bash

for (( i=1; i<=$1; i++ ))
do  
    sudo docker run -d --name api-$i -p 300$i:3000 -e SECRET="top, top secret - $i" wpedrak/simple-node-api
done
