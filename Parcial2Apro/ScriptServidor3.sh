yum install bind-utils bind-libs bind-* -y
yum install vim -y
sudo cp /var/named/named.empty /var/named/troyanos.com.fwd
sudo chmod 755 troyanos.com.fwd
sudo cp /var/named/troyanos.com.fwd /var/named/troyanos.com.rev