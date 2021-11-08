sudo -i
yum install vim -y
yum install httpd -y
cd /var/www/html/
vim index.html
-------
Place your html page here
-------
#systemctl httpd restart
 