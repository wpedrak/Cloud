#!/bin/bash

sudo docker login --username=wpedrak

sudo docker tag wpedrak/long-calc wpedrak/long-calc:$1

sudo docker push wpedrak/long-calc