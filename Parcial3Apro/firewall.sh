sudo service firewalld start
sudo service NetworkManager stop
sudo chkconfig NetworkManager off
sudo firewall-cmd --zone=dmz --add-interface=eth1 --permanent
sudo firewall-cmd --zone=dmz --add-service=https --permanent
sudo firewall-cmd --zone=dmz --add-service=dns --permanent
sudo firewall-cmd --zone=internal --add-interface=eth2 --permanent
sudo firewall-cmd --permanent --zone=dmz --add-masquerade
sudo firewall-cmd --permanent --zone=internal --add-masquerade
sudo firewall-cmd --permanent --zone="dmz" --add-forward-port=port=8080:proto=tcp:toport=8080:toaddr=192.168.50.2
sudo service firewalld stop
sudo service firewalld start
