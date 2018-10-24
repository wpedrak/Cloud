CREATE DATABASE wp_myblog;
GRANT ALL PRIVILEGES ON wp_myblog.* TO 'wp_user'@'ip of wp';
ALTER USER 'wp_user'@'ip of wp' IDENTIFIED BY '1234pass';
FLUSH PRIVILEGES;
EXIT;