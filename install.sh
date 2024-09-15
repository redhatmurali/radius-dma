#!/bin/bash

#================== Step 1: Disabling Firewall ==================
echo "Disabling Firewall and SELinux..."

# Disable firewalld
yum -y install iptables-services nano
systemctl stop iptables
chkconfig iptables off

# Disable SELinux
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0

systemctl stop firewalld
systemctl disable firewalld

echo "Firewall and SELinux disabled."

#================== Step 2: Installing Dependencies ==================
echo "Installing dependencies..."

# Enable EPEL repository and install required packages
yum install -y epel-release
yum install -y mc wget crontabs make gcc libtool-ltdl curl mysql-devel net-snmp net-snmp-utils \
php php-mysql php-gd php-snmp php-process ntp sendmail sendmail-cf alpine mutt mariadb-server mariadb \
php-mcrypt cronie phpmyadmin net-tools psmisc glibc.i686 libgcc_s.so.1

# Start and enable MariaDB
systemctl start mariadb.service
systemctl enable mariadb.service

echo "Dependencies installed."

#================== Step 3: MySQL Configuration ==================
echo "Configuring MySQL..."

# Run mysql_secure_installation script to set root password
mysql_secure_installation

# Start and enable Apache HTTPD
systemctl start httpd.service
systemctl enable httpd.service

echo "MySQL configured and HTTPD started."

#================== Step 4: Adding IONCUBE module in PHP ==================
echo "Adding IONCUBE to PHP..."

# Download and install IONCUBE
wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -xvzf ioncube_loaders_lin_x86-64.tar.gz
mv ioncube/ioncube_loader_lin_5.4.so /usr/lib64/php/modules/
chmod 777 /usr/lib64/php/modules/ioncube_loader_lin_5.4.so

# Add IONCUBE to php.ini
echo "zend_extension = /usr/lib64/php/modules/ioncube_loader_lin_5.4.so" >> /etc/php.ini

# Restart HTTPD to apply changes
systemctl restart httpd.service

# Verify PHP version
php -v

echo "IONCUBE module added."

#================== Step 5: Download FreeRADIUS ==================
echo "Downloading FreeRADIUS..."

# Create temp directory and download FreeRADIUS
mkdir -p ~/temp && cd ~/temp
wget http://www.dmasoftlab.com/download/freeradius-server-2.2.0-dma-patch-2.tar.gz
tar -xvzf freeradius-server-2.2.0-dma-patch-2.tar.gz
cd freeradius-server-2.2.0

# Compile and install FreeRADIUS
./configure
make
make install

# Start FreeRADIUS in debug mode (CTRL+C to stop)
radiusd -X

echo "FreeRADIUS installed."

#================== Step 6: Create MySQL Databases ==================
echo "Creating MySQL databases for RADIUS..."

mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE radius;
CREATE DATABASE conntrack;
CREATE USER 'radius'@'localhost' IDENTIFIED BY 'radius123';
CREATE USER 'conntrack'@'localhost' IDENTIFIED BY 'conn123';
GRANT ALL ON radius.* TO 'radius'@'localhost';
GRANT ALL ON conntrack.* TO 'conntrack'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "Databases created."

#================== Step 7: Download & Install RADIUS Manager ==================
echo "Installing RADIUS Manager..."

cd ~/temp

# Copy radiusmanager-4.1.6.gz to temp directory before running script
# Unzip the radius manager installation package
tar zxvf radiusmanager-4.1.6.gz
cd radiusmanager-4.1.6

# Set permissions and run installation script
chmod 755 install.sh
./install.sh <<EOF
1
1
/var/www/html
localhost
radius
radius123
localhost
conntrack
conn123
root
apache
y
y
y
y
EOF

# Restart services
systemctl restart httpd.service
systemctl restart mariadb.service
systemctl restart radiusd

echo "RADIUS Manager installed successfully."

# Reboot the server
reboot
