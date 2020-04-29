#!/bin/bash -xe
apt update -y
apt upgrade -y

apt install php libapache2-mod-php php-mysql -y
apt install apache2 python awscli -y

curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
chmod +x ./awslogs-agent-setup.py
wget https://raw.githubusercontent.com/tracer-tick/clouded_insight/master/misc/awslogs.conf
./awslogs-agent-setup.py -n -r us-east-2 -c awslogs.conf

service awslogs start
service apache2 start
systemctl enable awslogs
systemctl enable apache2


echo -e "*/1 * * * * root aws s3 sync --delete s3://clouded-insight-wp-code /var/www/html/" | sudo tee -a /etc/crontab

cd /etc/apache2/sites-enabled/
rm -f 000-default.conf
wget https://raw.githubusercontent.com/tracer-tick/clouded_insight/master/misc/000-default.conf
service apache2 restart


