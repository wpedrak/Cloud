#!/bin/bash

sudo docker login --username=wpedrak
sudo docker tag wpedrak/simple-node-api wpedrak/simple-node-api:$1
sudo docker push wpedrak/simple-node-api