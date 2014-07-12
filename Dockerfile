############################################################
# Dockerfile to build MultiFaucet container images
# Based on Centos 7 with PHP Apache and MySQL/MariaDB
############################################################

# Set the base image to Centos
FROM tuaris/centos-lamp
MAINTAINER Daniel Morante

# Download MultiFaucet
ADD ./multifaucet/ /var/www/html/

# Pre-Configure MultiFaucet
ADD ./do-config.sh /tmp/do-config.sh
RUN /bin/sh /tmp/do-config.sh

##################### INSTALLATION END #####################
EXPOSE 80
CMD ["/usr/sbin/init"]