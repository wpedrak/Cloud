#!/bin/bash

sudo docker run -d --name api -p 3000:3000 -e SECRET='top, top secret' wpedrak/simple-node-api

