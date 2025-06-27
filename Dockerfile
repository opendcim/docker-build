FROM ubuntu:22.04
LABEL maintainer="scott@opendcim.org"

# Fix the broken apt scripts in Ubuntu 22.04 docker image
RUN sed -i -e 's/^APT/# APT/' -e 's/^DPkg/# DPkg/' \
      /etc/apt/apt.conf.d/docker-clean

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV LANG en_US

RUN apt update
## preesed tzdata, update package index, upgrade packages and install needed software
RUN truncate -s0 /tmp/preseed.cfg; \
    echo "tzdata tzdata/Areas select US" >> /tmp/preseed.cfg; \
    echo "tzdata tzdata/Zones/Europe select New_York" >> /tmp/preseed.cfg; \
    debconf-set-selections /tmp/preseed.cfg && \
    rm -f /etc/timezone /etc/localtime 


RUN apt -y install locales-all tzdata mariadb-client apache2 \
  php php-mbstring php-snmp php-gd php-mysql php-zip php-curl php-ldap php-redis \
  php-xml php-php-gettext locales graphviz && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
  dpkg-reconfigure tzdata && a2enmod rewrite && \
  rm /var/www/html/index.html


#  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
COPY dcim/ /var/www/html/
COPY dcim/db.inc.php-dist /var/www/html/db.inc.php
# Use a different installer for the containers - automatic, and requiring the db to be new or at least at 19.01
RUN rm /var/www/html/install.php && ln -s /var/www/html/container-install.php /var/www/html/install.php
COPY 000-default.conf /etc/apache2/sites-available/
COPY 100-opendcim.ini /etc/php/8.1/apache2/conf.d

RUN mkdir -p /var/www/html/vendor/mpdf/ttfontdata && mkdir -p /var/www/html/assets && chown -R www-data:www-data /var/www/html && \
  chmod -R 775 /var/www/html/assets /var/www/html/vendor/mpdf/ttfontdata && rm -f /var/log/apache2/*.log && \
  ln -s /dev/stderr /var/log/apache2/error.log && ln -s /dev/stdout /var/log/apache2/access.log

CMD apachectl -D FOREGROUND
