#!/bin/bash -xe
yum update -y
yum install httpd php php-mysql awslogs -y
wget https://raw.githubusercontent.com/tracer-tick/Abusing-AWS-IMDS-v1/master/misc/awslogs.conf
mv awslogs.conf /etc/awslogs/
systemctl start awslogsd
systemctl start httpd
systemctl enable awslogsd.service
systemctl enable httpd.service


cd /var/www/html
echo "healthy" > healthy.html
wget https://wordpress.org/wordpress-5.1.1.tar.gz
tar -xzf wordpress-5.1.1.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf wordpress-5.1.1.tar.gz
chmod -R 755 wp-content
chown -R apache:apache wp-content
echo -e "Options +FollowSymlinks\nRewriteEngine on\nrewriterule ^wp-content/uploads/(.*)\$ http://d2ac3fr0ueo8sh.cloudfront.net/\$1 [r=301,nc]" >> htaccess.txt
mv htaccess.txt .htaccess

cd /etc/httpd/conf
rm -f httpd.conf

# change httpd configuration file
# restart service
