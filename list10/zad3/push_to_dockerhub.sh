#!/bin/bash

sudo docker login --username=wpedrak

sudo docker tag wpedrak/front wpedrak/front:$1
sudo docker tag wpedrak/writer wpedrak/writer:$1
sudo docker tag wpedrak/reader wpedrak/reader:$1
sudo docker push wpedrak/front
sudo docker push wpedrak/writer
sudo docker push wpedrak/reader