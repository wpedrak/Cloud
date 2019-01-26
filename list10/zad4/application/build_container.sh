#!/bin/bash

cp reciever.py dockerize/app.py
sudo docker build -t wpedrak/long-calc ./dockerize
