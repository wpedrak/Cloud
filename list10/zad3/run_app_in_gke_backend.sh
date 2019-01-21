#!/bin/bash

kubectl create -f setup/back-deployment.yml 
kubectl create -f setup/back-service.yml
kubectl get services
