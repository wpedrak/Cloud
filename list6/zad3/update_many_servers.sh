#!/bin/bash

sudo docker pull wpedrak/simple-node-api

for (( i=1; i<=$1; i++ ))
do  
    app_name=api-$i
    sudo docker stop $app_name
    sudo docker rm $app_name
    sudo docker run -d --name $app_name -p 300$i:3000 -e SECRET="top, top secret - $i" wpedrak/simple-node-api
done
