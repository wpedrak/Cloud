# pick ami
# Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-0bbe6b35405ecebdb
# nano instance
# add security rule allowing port 80
# on my PC:
ssh -i cloud2018.pem ubuntu@ip.of.instance
# via ssh
sudo apt update
# apache
sudo apt install apache2 apache2-utils
# php
sudo apt install php php-mysql libapache2-mod-php php-cli php-cgi php-gd
# wordpress
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo rsync -av wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
# klient mySQL
sudo apt-get install mysql-client
# ip of db host
mysql --host=35.239.234.137 --user=root --password
#setup wordpress
cd /var/www/html/
sudo mv wp-config-sample.php wp-config.php
sudo vim wp-config.php
# /** The name of the database for WordPress */
# define('DB_NAME', 'wp_myblog');

# /** MySQL database username */
# define('DB_USER', 'wp_user');

# /** MySQL database password */
# define('DB_PASSWORD', '1234pass');

# /** MySQL hostname */ this is ip of db host
# define('DB_HOST', '35.239.234.137');

# don't get ugly apache 'hello world' page
sudo mv index.html index2.html