FROM ubuntu:18.04

MAINTAINER Dylan Leahy <dylan@adr3nalin3.net>

ENV TZ Australia/Perth
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
EXPOSE 80
EXPOSE 443



RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apache2 php php-dom php-curl curl composer zip unzip && rm -rf /var/lib/apt/lists/*
ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_PID_FILE  /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2
ENV APACHE_LOG_DIR   /var/log/apache2
RUN a2enmod ssl
run a2ensite default-ssl.conf
RUN mkdir -p $APACHE_RUN_DIR
RUN mkdir -p $APACHE_LOCK_DIR
RUN mkdir -p $APACHE_LOG_DIR
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]

RUN rm -rf /var/www/html/* && mkdir /var/www/html/proxy
RUN composer create-project athlon1600/php-proxy-app:dev-master /var/www/html/proxy
RUN chown -R www-data:www-data /var/www/html
