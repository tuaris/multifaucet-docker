############################################################
# Dockerfile to build MultiFaucet container images
# Based on Centos 7
############################################################

# Set the base image to Centos
FROM centos
MAINTAINER Daniel Morante

# Udate and Install Required RPM Packages
RUN yum update -y
RUN yum install httpd -y
RUN yum install mariadb-server mariadb -y
RUN yum install php php-mysqli -y

# Enable and Run Apache
RUN systemctl enable httpd.service

# Enable MySQL/MariaDB
RUN systemctl enable mariadb.service

# Download MultiFaucet
ADD ./multifaucet/ /var/www/html/

# Pre-Configure MultiFaucet
ADD ./do-config.sh /tmp/do-config.sh
RUN /bin/sh /tmp/do-config.sh

# Make configuration and cold wallet directory writable so the user can continue withe the web installer
RUN chown -R apache:apache /var/www/html/config/ && chmod -R 700 /var/www/html/config/ && chcon -Rt httpd_sys_content_rw_t /var/www/html/config/ && chown -R apache:apache /var/db/multifaucet/ && chmod -R 700 /var/db/multifaucet/ && chcon -Rt httpd_sys_content_rw_t /var/db/multifaucet/

#Open port 80 on Firewall
RUN firewall-cmd --permanent --add-port=80/tcp

##################### INSTALLATION END #####################
EXPOSE 80

RUN echo "To complete the installation go to http://`ip addr show | grep -E '^\s*inet' | grep -m1 global | awk '{ print $2 }' | sed 's|/.*||'`/install.php"

CMD ["systemctl start httpd.service && "]