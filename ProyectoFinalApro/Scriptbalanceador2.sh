sudo -i
yum install vim -y
yum install httpd httpd-manual -y
systemctl start httpd
systemctl enable httpd
grep -i listen /etc/httpd/conf/httpd.conf
httpd -M | grep proxy
httpd -M | grep requests
service firewalld start
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
rm /etc/httpd/conf.d/welcome.conf
systemctl restart httpd
cd /etc/httpd/conf.d/
vim vhost_default_00.conf
*** Put the following inside the file
<VirtualHost *:80>
    	ProxyRequests off
    	<Location /balancer-manager>
                SetHandler balancer-manager
                Require all granted
        </Location>
    	<Proxy balancer://cluster1>
                balancerMember http://192.168.50.10:80
                balancerMember http://192.168.50.20:80
 ProxySet lbmethod=bytraffic
    	</Proxy>
        ProxyPreserveHost On
    	ProxyPass /balancer-manager !
    	ProxyPass / balancer://cluster1
        ProxyPassReverse / balancer://cluster1
</VirtualHost>
***Save the file
systemctl restart httpd
