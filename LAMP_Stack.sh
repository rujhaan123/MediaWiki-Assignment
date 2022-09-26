#!/bin/bash

# Check if running as root  
if [ "$(id -u)" != "0" ]; then  
  echo -e "\n This script must be run as root" 
  echo -e "Try change to user root: sudo su -- or sudo su - userroot" 
  echo -e "sudo su -- " 
  echo -e "sudo su - [root username]"   
fi

update() {
  # Update system repos
  echo -e "\n Updating package repositories..."
  sudo useradd ans
  sudo yum install wget -y
  sudo yum install centos-release-scl -y
  sudo yum install yum-utils -y
  sudo yum-config-manager --enable remi-php70  -y
  sudo yum-config-manager --enable remi-php73 -y
  sudo yum install httpd24-httpd rh-php73 rh-php73-php rh-php73-php-mbstring rh-php73-php-mysqlnd rh-php73-php-gd rh-php73-php-xml mariadb-server mariadb -y
  sudo yum install httpd -y
  sudo yum install expect -y
  # sudo apt-get upgrade # upgrade to new versions
}

installMySQL() {
  # MySQL
  sudo systemctl start mariadb
  sudo yum install expect -y
  MYSQL_ROOT_PASSWORD=abcd1234 # for now used passwd directly in script otherwise not recommended, use openssl or gpg to encrypt.

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

  echo "$SECURE_MYSQL"
  sudo systemctl enable mariadb
  sudo systemctl enable httpd
  
}

installMediaWiki() {
  cd /home/ans
  wget https://releases.wikimedia.org/mediawiki/1.38/mediawiki-1.38.2.tar.gz
  wget https://releases.wikimedia.org/mediawiki/1.38/mediawiki-1.38.2.tar.gz.sig
  gpg --verify mediawiki-1.38.2.tar.gz.sig mediawiki-1.38.2.tar.gz
  
  cd /var/www
  tar -zxf /home/ans/mediawiki-1.38.2.tar.gz
  ln -s mediawiki-1.38.2/ mediawiki
  
  sed -i '
  /DocumentRoot/tS
  /<Directory/tS
  t
  :S
  s#"/var/www/html"#"/var/www/"#
' /etc/httpd/conf/httpd.conf

  sed -i 's/index.html/index.html index.html.var index.php/' /etc/httpd/conf/httpd.conf
  
  
  cd /var/www
  ln -s mediawiki-1.38.2/ mediawiki
  chown -R apache:apache /var/www/mediawiki-1.38.2
  
  service httpd restart
}



firewall(){
	sudo firewall-cmd --permanent --zone=public --add-service=http
	sudo firewall-cmd --permanent --zone=public --add-service=https
	sudo systemctl restart firewalld
}


selinux(){
	getenforce
	restorecon -FR /var/www/mediawiki-1.38.2/
	restorecon -FR /var/www/mediawiki
	ls -lZ /var/www/
}

# RUN
update
installMySQL
installMediaWiki
firewall
selinux
