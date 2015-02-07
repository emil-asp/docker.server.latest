FROM debian:jessie
MAINTAINER emilasp <emilasp@mail.ru>
 
# Configure my repo to use my custom Nginx with modsec
 #RUN mkdir -p /usr/local/src
# RUN cd /bin/bash
 
    #RUN apt-get update && apt-get install -y  
  
    #RUN apt-get clean
    #RUN apt-get -f install
    #RUN apt-get autoclean


    # add repo for packages
    #RUN echo "\ndeb http://mirror.yandex.ru/debian/ testing main contrib non-free" | tee  /etc/apt/sources.list && \
    #echo "\ndeb-src http://mirror.yandex.ru/debian/ testing main contrib non-free" | tee -a /etc/apt/sources.list && \
    #echo "\ndeb http://security.debian.org/ testing/updates main contrib non-free" | tee -a /etc/apt/sources.list && \
    #echo "\ndeb-src http://security.debian.org/ testing/updates main contrib non-free" | tee -a /etc/apt/sources.list && \
    #echo "\ndeb http://mirror.yandex.ru/debian/ testing-updates main contrib non-free" | tee -a /etc/apt/sources.list && \
    #echo "\ndeb-src http://mirror.yandex.ru/debian/ testing-updates main contrib non-free" | tee -a /etc/apt/sources.list
   
   
   
    
    env DEBIAN_FRONTEND noninteractive

    RUN apt-get update 
    RUN apt-get -y upgrade
    RUN dpkg --print-architecture
    RUN apt-get install -y --force-yes debconf-utils
    RUN apt-get install -y --force-yes apt-utils
    RUN apt-get install -y --force-yes aptitude net-tools procps dialog
    RUN apt-get install -y --force-yes wget vim htop tar curl

    #RUN echo "\ndeb http://packages.dotdeb.org wheezy all" > /etc/apt/sources.list
    #RUN wget http://www.dotdeb.org/dotdeb.gpg && cat dotdeb.gpg | apt-key add -
    #RUN aptitude update && aptitude -y upgrade


# install php5-fpm
   RUN apt-get install -y --force-yes php5-cli php5-common php5-gd php5-fpm php5-cgi php5-fpm php-pear php5-mcrypt redis-server 



# install xdebug
   RUN aptitude -y install php5-xdebug
# install mariadb
   RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
   RUN apt-get -y install software-properties-common
   RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
   RUN echo "\ndeb http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu trusty main" | tee -a /etc/apt/sources.list
   RUN apt-get update

#RUN apt-cache show mysql-common | grep Version
#RUN apt-cache show libmysqlclient18 | grep Version

RUN apt-get -y install mariadb-server-10.0







# install nginx
   RUN aptitude install nginx-full -y
   RUN rm /etc/nginx/sites-enabled/default 


# 
  RUN mkdir -p /var/www && mkdir /var/www/logs/ && mkdir /var/www/sites/ && mkdir /var/www/sites/composer/ && mkdir /var/www/tmp

#  WORKDIR /app



# Install composer && global asset plugin (Yii 2.0 requirement)
    RUN bash -c "wget http://getcomposer.org/composer.phar && mv composer.phar /var/www/sites/composer && chmod +x /var/www/sites/composer/composer.phar"
    #ADD config.json /var/www/sites/composer/config.json
    RUN /var/www/sites/composer/composer.phar global require "fxp/composer-asset-plugin:1.0.0-beta4"

    
# tell Nginx to stay foregrounded
    #ADD nginx.conf /etc/nginx/nginx.conf
    #RUN echo "daemon off;" >> /etc/nginx/nginx.conf


# Add site
   ENV SITE_NAME=site.ru
   
   #RUN echo $SITE_NAME
   
   ADD create.site.sh /usr/bin/
   ADD site.conf.tmplt /etc/nginx/sites-available/
   ADD pool.conf.tmplt /etc/php5/fpm/pool.d/
   #RUN mv /etc/nginx/sites-available/site.conf.tmplt /etc/nginx/sites-available/$SITE_NAME
   #RUN mv /etc/php5/fpm/pool.d/pool.conf.tmplt /etc/php5/fpm/pool.d/$SITE_NAME
   RUN /usr/bin/create.site.sh $SITE_NAME
   
   #RUN ln -s /etc/nginx/sites-available/$SITE_NAME /etc/nginx/sites-enabled/

# Other

   ADD other.sh /usr/bin/
   RUN /usr/bin/other.sh
   
RUN echo "\n[Xdebug]" | tee -a /etc/php5/fpm/php.ini && \
echo "\nxdebug.idekey = \"PHPSTORM\"" | tee -a /etc/php5/fpm/php.ini && \
echo "\nxdebug.remote_enable = 1" | tee -a /etc/php5/fpm/php.ini && \
echo "\nxdebug.remote_handler = \"dbgp\"" | tee -a /etc/php5/fpm/php.ini && \
echo "\nxdebug.remote_port = 9001" | tee -a /etc/php5/fpm/php.ini && \
echo "\nxdebug.remote_connect_back=on" | tee -a /etc/php5/fpm/php.ini
         
# expose HTTP
     EXPOSE 80
     EXPOSE 8080
     EXPOSE 443
     EXPOSE 9001 
# expose mysql
      EXPOSE 3306
       
# Run
       
        #ENTRYPOINT ["/usr/sbin/nginx -g","daemon off;"]
        
	#CMD /usr/sbin/nginx -g "daemon off;"
	#CMD ["nginx", "-g", "daemon off;"]
	#CMD [ "service nginx reload" ] 
	
	CMD [ "service php5-fpm start" ]
	
	WORKDIR /etc/nginx
	CMD [ "nginx" ]
	#CMD [ "/etc/init.d/nginx start" ]
