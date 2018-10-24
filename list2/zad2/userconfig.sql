CREATE DATABASE wp_myblog;
-- 35.185.54.253 is ip of wp host, not db host
GRANT ALL PRIVILEGES ON wp_myblog.* TO 'wp_user'@'35.185.54.253';
ALTER USER 'wp_user'@'35.185.54.253' IDENTIFIED BY '1234pass';
FLUSH PRIVILEGES;
EXIT;