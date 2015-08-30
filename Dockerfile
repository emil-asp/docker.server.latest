FROM debian:jessie
MAINTAINER emilasp <emilasp@mail.ru>
 
# Configure my repo to use my custom Nginx with modsec
 #RUN mkdir -p /usr/local/src
# RUN cd /bin/bash
    
    ENV DEBIAN_FRONTEND noninteractive
    #export DEBIAN_FRONTEND='noninteractive'

#main apt
    RUN apt-get update && apt-get -y upgrade && \
        dpkg --print-architecture && \
        apt-get install -y --force-yes debconf-utils && \
        apt-get install -y --force-yes apt-utils && \
        apt-get install -y --force-yes aptitude net-tools procps dialog && \
        apt-get install -y --force-yes wget vim htop tar curl console-cyrillic

#
    RUN echo "\ndeb http://httpredir.debian.org/debian jessie main contrib non-free\ndeb-src http://httpredir.debian.org/debian jessie main contrib non-free\ndeb http://httpredir.debian.org/debian jessie-updates main contrib non-free\ndeb-src http://httpredir.debian.org/debian jessie-updates main contrib non-free\ndeb http://security.debian.org/ jessie/updates main\ndeb-src http://security.debian.org/ jessie/updates main"  > /etc/apt/sources.list

    RUN cat /etc/apt/sources.list
    RUN apt-get update && apt-get -y upgrade

    #RUN echo "\ndeb http://security.debian.org/ jessie/updates main contrib non-free"  | tee -a  /etc/apt/sources.list
    #RUN echo "\ndeb-src http://security.debian.org/ jessie/updates main contrib non-free"  | tee -a  /etc/apt/sources.list

    RUN echo "\nnameserver 8.8.8.8\nnameserver 8.8.4.4"  >> /etc/resolv.conf

# install php5-fpm
   RUN apt-get install -y --force-yes php5-cli php5-common php5-gd php5-fpm php5-cgi php5-fpm php-pear php5-mcrypt php5-mysql memcached php5-memcached php-pear php5-curl redis-server php5-redis php-apc php5-pgsql

# install xdebug
   RUN apt-get install -y --force-yes  php5-xdebug
   #&& \
   #echo "\n[Xdebug]" | tee -a /etc/php5/fpm/php.ini && \
   #echo "\nxdebug.idekey = \"PHPSTORM\"" | tee -a /etc/php5/fpm/php.ini && \
   #echo "\nxdebug.remote_enable = 1" | tee -a /etc/php5/fpm/php.ini && \
   #echo "\nxdebug.remote_handler = \"dbgp\"" | tee -a /etc/php5/fpm/php.ini && \
   #echo "\nxdebug.remote_port = 9001" | tee -a /etc/php5/fpm/php.ini && \
   #echo "\nxdebug.remote_connect_back=on" | tee -a /etc/php5/fpm/php.ini

# install mariadb
   #RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
   #    apt-get -y install software-properties-common && \
   #    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
   #    echo "\ndeb http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu trusty main" | tee -a /etc/apt/sources.list && \
   #    apt-get update && \
   #    apt-get -y install mariadb-server-10.0

# install nginx
   RUN aptitude install nginx-full -y

# pre settings
   RUN rm /etc/nginx/sites-enabled/default && \
       mkdir -p /var/www && \
       mkdir /var/www/logs/ && \
       mkdir /var/www/sites/ && \
       mkdir /var/www/sites/composer/ && \
       mkdir /var/www/tmp

# install git
   RUN apt-get install -y --force-yes git git-core rsync
   RUN git config --global user.email "emil@amulex.ru" && git config --global user.name "emilasp"
#  WORKDIR /app

# Install composer && global asset plugin (Yii 2.0 requirement)
    RUN bash -c "wget http://getcomposer.org/composer.phar && mv composer.phar /usr/bin/composer && chmod +x /usr/bin/composer" && \
        composer global require "fxp/composer-asset-plugin:1.0.0-beta4"
    #ADD config.json /var/www/sites/composer/config.json
   

# install optimize tools mysql
   #RUN aptitude install apache2-utils percona-toolkit -y
 
# tell Nginx to stay foregrounded
    #ADD nginx.conf /etc/nginx/nginx.conf
    #RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Install HHVM
#	RUN wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
#	RUN echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list
#	RUN apt-get update
#	RUN apt-get install -y hhvm

# Create required directories
	RUN mkdir -p /var/log/supervisor
	RUN mkdir -p /etc/nginx
	RUN mkdir -p /var/run/php5-fpm
	RUN mkdir -p /var/run/hhvm

# Add configuration files
	ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
	ADD php.ini /etc/php5/fpm/conf.d/40-custom.ini

# Install RabbitMQ
    RUN apt-get install -y --force-yes rabbitmq-server

# Install Supervisor
    RUN apt-get install -y --force-yes supervisor

# Add site
   ENV SITE_NAME site.ru
   
   #RUN echo $SITE_NAME
   
   ADD create.site.sh /usr/bin/
   ADD site.conf.tmplt /etc/nginx/sites-available/ 
   ADD pool.conf.tmplt /etc/php5/fpm/pool.d/
   #RUN /usr/bin/create.site.sh $SITE_NAME
   
   #RUN ln -s /etc/nginx/sites-available/$SITE_NAME /etc/nginx/sites-enabled/


# Other

   ADD other.sh /usr/bin/
   RUN /usr/bin/other.sh
   ADD start_services /usr/bin/

# Add SSH entry
	RUN apt-get install -y --force-yes openssh-server
	RUN mkdir /root/.ssh
	RUN mkdir /var/run/sshd
	RUN echo 'root:screencast' |chpasswd
	CMD /usr/sbin/sshd -D
	ADD keys/docker_rsa.pub /tmp/rsa_public_key
	RUN cat /tmp/rsa_public_key >> /root/.ssh/authorized_keys && rm -f /tmp/rsa_public_key

#Postresql
#initdb -D /usr/local/pgsql/data
#sudo cp ./postgresql-9.2.2/contrib/start-scripts/linux /etc/init.d/postgres
#sudo update-rc.d postgres defaults
#
	RUN apt-get -y --force-yes install postgresql postgresql-client postgresql-contrib  php5-pgsql phppgadmin wwwconfig-common
	#RUN useradd --no-create-home postgres
	#RUN chown -R postgres:postgres /usr/local/pgsql


# Locale

	#RUN apt-get -y --force-yes install locale
	#RUN dpkg-reconfigure locales
	#ENV LANG=ru_RU.utf8

# import sites

   #RUN mkdir /tmp/docker_tmp/
   #RUN mkdir /tmp/docker_tmp/bases
   #RUN mkdir /tmp/docker_tmp/php5
   #RUN mkdir /tmp/docker_tmp/php5/pool.d
   #RUN mkdir /tmp/docker_tmp/nginx
   #RUN mkdir /tmp/docker_tmp/nginx/sites-available
#
   #ADD sites/databases/tmp/* /tmp/docker_tmp/bases/
   #ADD sites/php5/tmp/fpm/* /tmp/docker_tmp/php5/
   #ADD sites/php5/tmp/fpm/pool.d/* /tmp/docker_tmp/php5/pool.d/
   #ADD sites/nginx/tmp/sites-available/* /tmp/docker_tmp/nginx/sites-available/
   #ADD sites/nginx/tmp/*  /tmp/docker_tmp/nginx/
#
   #ADD addSites /usr/bin/
   #RUN /usr/bin/addSites
#
   #RUN service php5-fpm restart
   #RUN service nginx restart


# Install CodeSniffer
    RUN pear install PHP_CodeSniffer

# Install Code Sniffer
	RUN apt-get install -y --force-yes php-codesniffer

# Run
       
    #ENTRYPOINT ["/usr/sbin/nginx -g","daemon off;"]
        
	#CMD /usr/sbin/nginx -g "daemon off;"
	#CMD ["nginx", "-g", "daemon off;"]
	#CMD [ "service nginx reload" ] 
	
	CMD [ "service php5-fpm start" ]
	WORKDIR /var/www
	CMD [ "service nginx start" ]
	#CMD [ "/etc/init.d/nginx start" ]


# expose HTTP
     EXPOSE 80
     EXPOSE 8080
     EXPOSE 443
     EXPOSE 9001
# expose mysql
     EXPOSE 3306

# expose postgreSQl
     EXPOSE 5432

# expose ssh
     EXPOSE 22

# Expose volumes
	VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

	CMD ["/usr/bin/supervisord"]
