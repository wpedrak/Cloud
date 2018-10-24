# pick ami
# Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-0bbe6b35405ecebdb
# nano instance
# add security rule allowing port 80
# on my PC:
ssh -i cloud2018.pem ubuntu@34.217.73.223
# via ssh
sudo apt update
# apache
sudo apt install apache2 apache2-utils
# php
sudo apt install php php-mysql libapache2-mod-php php-cli php-cgi php-gd

sudo chown -R ubuntu /var/www
sudo chmod -R g+rw /var/www
cd /var/www/html/
vim index.php
# paste index.php