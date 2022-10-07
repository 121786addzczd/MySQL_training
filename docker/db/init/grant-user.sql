CREATE USER 'test_user'@'%' IDENTIFIED BY 'pass';
GRANT ALL PRIVILEGES ON docker_php_batch_db.* TO 'test_user'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
