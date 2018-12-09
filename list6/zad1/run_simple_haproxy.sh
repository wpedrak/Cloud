#!/bin/bash

sudo docker run -d --name simple-haproxy -p 8080:80 -v "$PWD"/haproxy_config:/usr/local/etc/haproxy:ro haproxy