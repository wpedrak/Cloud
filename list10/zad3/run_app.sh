#!/bin/bash

sudo docker run -d --name front -p 3000:3000 -e DB_IP='35.204.186.169' -e DB_PASSWORD='12345' -e WRITER_IP='127.0.0.1' -e READER_IP='127.0.0.1' wpedrak/front

sudo docker run -d --name writer -p 4000:4000 -e DB_IP='35.204.186.169' -e DB_PASSWORD='12345' -e WRITER_IP='127.0.0.1' -e READER_IP='127.0.0.1' wpedrak/writer

sudo docker run -d --name reader -p 5000:5000 -e DB_IP='35.204.186.169' -e DB_PASSWORD='12345' -e WRITER_IP='127.0.0.1' -e READER_IP='127.0.0.1' wpedrak/reader
