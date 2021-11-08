#Load balancer using apache module mod_proxy_balancer + Load Testing with JMeter.

## Table of contents 
1. [Project description] (#project description)
2. [Technologies] (#technologies)
3. [installation] (#installation)
4. [Functioning] (#functioning)
5. [Questions raised] (#questions raised)
6. [Copyright] (#copyright)
###Project description
***
In this practice and development of the final project of the Telematic Services course, 
the installation and configuration of the load balancer will be carried out using the 
mod_proxy_balancer module. In this file you will find step by step how to carry out its 
installation and the commands to be carried out.

 > The httpd itself does not generate content or host data, instead the content is 
obtained from one or more backend servers, which normally have no direct connection 
to external networks. When httpd receives a request from a client, it proxies this 
request to one of these backend servers, which handles the request, generates the 
content and then sends this content back to httpd, which then generates the final 
HTTP response that is sent. back to the customer

The reasons for implementing this balancer are due to security, high availability, 
load balancing, and centralized authentication / authorization. It is critical in 
these implementations that the architecture and design of the backend infrastructure 
are isolated and protected from the outside; As far as the client is concerned, 
the reverse proxy is the sole source of all content.

####Technologies
A list of technologies used within the project:
* [Vagrant] (www.vagrantup.com) : Version 2.2.18
* [VirtualBox] (www.virtualbox.org) : Version 6.1.28
* [Apache server] (www.httpd.apache.org) : Version 2.4.51
* [CentOS] (www.centos.org/download) : Version 7.9
* Apache JMeter (www.jmeter.apache.org) : Version 5.4.1

 
##### Installation
The following are the commands used to install the load balancer and recommended utilities 
to complement this process
To carry out the installation we verify that we have the VirtualBox virtualizer and the 
vagrant tool. Later we create a folder where we want to install the configuration and place 
the attached vagrantfile in the project folder inside.
***
Vagrantfile
***
Vagrant.configure("2") do |config|
config.vm.define :balanceador do |balanceador|
balanceador.vm.box = "JuanSebastianMontoya/balanceador"
balanceador.vm.network :private_network, ip: "192.168.50.30"
balanceador.vm.hostname = "balanceador"
end

config.vm.define :balanceador2 do |balanceador2|
balanceador2.vm.box = "JuanSebastianMontoya/balanceador"
balanceador2.vm.network :private_network, ip: "192.168.50.40"
balanceador2.vm.hostname = "balanceador2"
end

config.vm.define :maquina1 do |maquina1|
maquina1.vm.box = "JuanSebastianMontoya/maquina1"
maquina1.vm.network :private_network, ip: "192.168.50.10"
maquina1.vm.hostname = "maquina1"
end

config.vm.define :maquina2 do |maquina2|
maquina2.vm.box = "JuanSebastianMontoya/maquina2"
maquina2.vm.network :private_network, ip: "192.168.50.20"
maquina2.vm.hostname = "maquina2"
end
end
***

When the file has been copied we give the command "vagrant up"
C:\users\jsm21\Desktop> mkdir project
C:\users\jsm21\Desktop> cd project
C:\users\jsm21\Desktop\project> vagrant up
>Here the machines begin to be installed
>When the installation of the machines is finished we will see that we have four of them in progress
C:\users\jsm21\Desktop\project>vagrant global-status


***
**Balancer by request**
C:\users\jsm21\Desktop\project> vagrant ssh balanceador
```
#sudo -i
#yum install vim -y
#yum install httpd httpd-manual -y
#systemctl start httpd
#systemctl enable httpd
#grep -i listen /etc/httpd/conf/httpd.conf
#httpd -M | grep proxy
#httpd -M | grep requests
#service firewalld start
#firewall-cmd --permanent --add-service=http
#firewall-cmd --reload
#rm /etc/httpd/conf.d/welcome.conf
#systemctl restart httpd
#cd /etc/httpd/conf.d/
#vim vhost_default_00.conf
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
     	       ProxySet lbmethod=byrequests
    	</Proxy>
        ProxyPreserveHost On
    	ProxyPass /balancer-manager !
    	ProxyPass / balancer://cluster1
        ProxyPassReverse / balancer://cluster1
</VirtualHost>
***Save the file
#systemctl restart httpd



***
**Balanceador 2 by traffic**
C:\users\jsm21\Desktop\project> vagrant ssh balanceador2
```
#sudo -i
#yum install vim -y
#yum install httpd httpd-manual -y
#systemctl start httpd
#systemctl enable httpd
#grep -i listen /etc/httpd/conf/httpd.conf
#httpd -M | grep proxy
#httpd -M | grep requests
#service firewalld start
#firewall-cmd --permanent --add-service=http
#firewall-cmd --reload
#rm /etc/httpd/conf.d/welcome.conf
#systemctl restart httpd
#cd /etc/httpd/conf.d/
#vim vhost_default_00.conf
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
#systemctl restart httpd

***
**Machine 1**
C:\users\jsm21\Desktop\project> vagrant ssh maquina1
```
#sudo -i
#yum install vim -y
#yum install httpd -y
#cd /var/www/html/
#vim index.html
-------
Place your html page here
-------
#systemctl httpd restart
 
 
***
**Machine 2**
C:\users\jsm21\Desktop\project> vagrant ssh maquina2
```
#sudo -i
#yum install vim -y
#yum install httpd -y
#cd /var/www/html/
#vim index.html
-------
Place your html page here
-------
#systemctl httpd restart

######Functioning
To put the balancers into operation and see how they resolve the requests of both 
machines, it is necessary to go to your browser of choice and place the IP assigned 
to the balancers, which are 192.168.50.30 (byrequest) and 192.168.50.40 (bytraffic). 
At this point you should redirect the requests and perform the balancing
To view statistics, reports and related data, we recommend using JMeter.

#######Questions raised
A list of frequently asked questions
**What other balancing algorithms can be used?**
mod_lbmethod_byrequests
mod_lbmethod_bytraffic
mod_lbmethod_bybusyness
mod_lbmethod_heartbeat
**¿Can you see the requests directly in the balancer?**
Yes, they can be seen directly in the balancer, for this we put the ip of the balancer, 
192.168.50.30/balancer-manager. In this route we will be shown an administrator and we can 
see how the requests have been resolved according to the chosen algorithms

########Copyright
This work was carried out by the students:
Kevin Alexis Gallego Albarracin
Mauricio Flores Apraez
Brayan Andres Hinestroza Boya
Juan Sebastian Montoya Franco
of the Telematic Services course
