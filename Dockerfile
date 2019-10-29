FROM ubuntu:18.04
LABEL maintainer="scott@opendcim.org"

RUN apt-get update

COPY tzscript.sh /usr/local/bin
RUN /usr/local/bin/tzscript.sh
RUN apt-get -y install mariadb-client libapache2-mod-webauthldap apache2 \
  php php-mbstring php-snmp php-gd php-mysql php-zip \
  php-xml php-gettext locales graphviz && rm -rf /var/lib/apt/lists/* && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  a2enmod rewrite authnz_ldap && rm /var/www/html/index.html
ENV LANG en_US.utf8

COPY dcim/ /var/www/html/
COPY dcim/db.inc.php-dist /var/www/html/db.inc.php
# Use a different installer for the containers - automatic, and requiring the db to be new or at least at 19.01
COPY dcim/container-install.php /var/www/html/install.php
COPY 000-default.conf /etc/apache2/sites-available/
COPY 100-opendcim.ini /etc/php/7.2/apache2/conf.d

RUN mkdir -p /var/www/html/vendor/mpdf/ttfontdata && mkdir -p /var/www/html/assets && chown -R www-data:www-data /var/www/html && \
  chmod 775 /var/www/html/assets /var/www/html/pictures /var/www/html/drawings /var/www/html/vendor/mpdf/ttfontdata

CMD apachectl -D FOREGROUND
