use mysql;
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'yourpassword';
CREATE USER 'dahan'@'%' IDENTIFIED BY '123';
GRANT All privileges ON *.* TO 'dahan'@'%';