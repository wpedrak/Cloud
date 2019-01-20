#!/bin/bash

kubectl create -f setup/front-deployment.yml
kubectl create -f setup/front-service.yml
