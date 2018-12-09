#!/bin/bash

for (( i=1; i<=$1; i++ ))
do  
    sudo docker run -dit --name simple-server-$i -p 808$i:80 -v "$PWD"/html:/usr/local/apache2/htdocs httpd
done
