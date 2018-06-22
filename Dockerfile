FROM ubuntu:16.04
USER root

#root passwort
ARG sshpass=root

WORKDIR /root

RUN apt-get -y update && \
    apt-get -y install \
	subversion \ 
    openssh-server \
	supervisor \
    vim \
    nano \
    software-properties-common \
    python-software-properties \
    wget \
    git 

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update && apt-get -y upgrade && \
    apt-cache pkgnames | grep php7.1

RUN DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y \
	php7.1-opcache \
	php7.1-fpm \
	php7.1 \
	php7.1-common \
	php7.1-gd \
	php7.1-mysql \
	php7.1-imap \
	php7.1-cli \
	php7.1-cgi \
	php-pear \
	php-auth \
	php7.1-mcrypt \
	mcrypt \
	imagemagick \
	libruby \
	php7.1-curl \
	php7.1-intl \
	php7.1-pspell \
	php7.1-recode \
	php7.1-sqlite3 \
	php7.1-tidy \
	php7.1-xmlrpc \
	php7.1-xsl \
	memcached \
	php-memcache \
	php-imagick \
	php-gettext \
	php7.1-zip \
	php7.1-mbstring \
	php7.1-soap \
	php7.1-opcache \
	php7.1-json \
	php7.1-ldap \
	command-not-found

RUN apt-get install apache2 libapache2-mod-php7.1 -y

RUN mkdir /var/run/sshd
RUN sed -i.bak s/PermitRootLogin\ prohibit-password/PermitRootLogin\ yes/g  /etc/ssh/sshd_config
RUN echo "root:$sshpass" | chpasswd

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 80 3306 

CMD ["/usr/bin/supervisord"]

VOLUME ["/var/lib/mysql", "/var/log/mysql", "/var/log/apache2"]
