#!/bin/bash

sudo docker network create -d bridge br0

sudo docker network connect br0 simple-haproxy
sudo docker network connect br0 simple-server-1
sudo docker network connect br0 simple-server-2