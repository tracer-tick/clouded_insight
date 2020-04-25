#!/bin/bash -xe
apt update -y
apt upgrade -y

add-apt-repository ppa:ondrej/php
apt install apache2 python -y
apt install php libapache2-mod-php
apt install php-mysql php-gd
service apache2 reload

curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
chmod +x ./awslogs-agent-setup.py
wget https://raw.githubusercontent.com/tracer-tick/clouded_insight/master/misc/awslogs.conf
./awslogs-agent-setup.py -n -r us-east-2 -c awslogs.conf

service awslogs start
service apache2 start
systemctl enable awslogs
systemctl enable apache2


cd /var/www/html
echo "healthy" > healthy.html
wget https://wordpress.org/latest
tar -xzf latest
cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf latest
chmod -R 755 wp-content
chown -R apache:apache wp-content
echo -e "Options +FollowSymlinks\nRewriteEngine on\nrewriterule ^wp-content/uploads/(.*)\$ http://d2ac3fr0ueo8sh.cloudfront.net/\$1 [r=301,nc]" >> htaccess.txt
mv htaccess.txt .htaccess
wget https://raw.githubusercontent.com/tracer-tick/clouded_insight/master/misc/wp-config.php
echo -e "*/1 * * * * root aws s3 sync --delete /var/www/html/ s3://clouded-insight-wp-code" | sudo tee -a /etc/crontab

cd /etc/apache2/sites-enabled/000-default.conf
rm -f 000-default.conf
wget https://raw.githubusercontent.com/tracer-tick/clouded_insight/master/misc/000-default.conf
service apache2 reload


