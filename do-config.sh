#!/bin/bash

# Genorate random password
MULTIFAUCET_DB_PASS=`date | md5sum | head -c 8`

# Manually Run MySQL/MariaDB
cd '/usr' ; /usr/bin/mysqld_safe --datadir='/var/lib/mysql' &

# Wait a bit
sleep 5

# Create MySQL/MariaDB Database and User
mysql -e "CREATE DATABASE multifaucet;"
mysql -e "CREATE USER 'multifaucet'@'localhost' IDENTIFIED BY '${MULTIFAUCET_DB_PASS}';"
mysql -e "GRANT ALL ON multifaucet.* TO 'multifaucet'@'localhost';"

# Pre-Configure the database settings for MultiFaucet
echo "<?php" >> /var/www/html/config/db.conf.php
echo "define(\"DB_HOST\", \"localhost\");" >> /var/www/html/config/db.conf.php
echo "define(\"DB_NAME\", \"multifaucet\");" >> /var/www/html/config/db.conf.php
echo "define(\"DB_USER\", \"multifaucet\");" >> /var/www/html/config/db.conf.php
echo "define(\"DB_PASS\", \"${MULTIFAUCET_DB_PASS}\");" >> /var/www/html/config/db.conf.php
echo "define(\"TB_PRFX\", \"faucet_\");" >> /var/www/html/config/db.conf.php
echo "?>" >> /var/www/html/config/db.conf.php

# Genorate random password
MULTIFAUCET_WALLET_PASS=`date | md5sum | head -c 8`

# Pre-Configure a cold wallet storage file
mkdir -p /var/db/multifaucet/
echo "<?php" >> /var/www/html/config/wallet.conf.php
echo "define(\"PAYMENT_GW_RPC_USER\", \"admin\");" >> /var/www/html/config/wallet.conf.php
echo "define(\"PAYMENT_GW_RPC_PASS\", \"${MULTIFAUCET_WALLET_PASS}\");" >> /var/www/html/config/wallet.conf.php
echo "define(\"PAYMENT_GW_DATAFILE\", \"/var/db/multifaucet/balance.dat\");" >> /var/www/html/config/wallet.conf.php
echo "define(\"ADDRESS_VERSION\", \"0\");" >> /var/www/html/config/wallet.conf.php
echo "?>" >> /var/www/html/config/wallet.conf.php

# Make configuration directory writable so the user can continue withe the web installer
chown -R apache:apache /var/www/html/config/
chmod -R 700 /var/www/html/config/ 
#chcon -Rt httpd_sys_content_rw_t /var/www/html/config/ 

# Make cold wallet directory writable so the user can continue withe the web installer
chown -R apache:apache /var/db/multifaucet/ 
chmod -R 700 /var/db/multifaucet/ 
#chcon -Rt httpd_sys_content_rw_t /var/db/multifaucet/
