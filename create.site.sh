#!/bin/bash

# create site

set -o nounset
set -o errexit

# $1 - site name
# 

NGINX_PATTERN=SITE_NAME_PARAM

PHP5_FPM_PATTERN=SITE_NAME_PATTERN

cp /etc/nginx/sites-available/site.conf.tmplt /etc/nginx/sites-available/$1
cp /etc/php5/fpm/pool.d/pool.conf.tmplt /etc/php5/fpm/pool.d/$1.conf

ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/


sed -ri "s/$NGINX_PATTERN/$1/g" /etc/nginx/sites-available/$1

sed -ri "s/$PHP5_FPM_PATTERN/$1/g" /etc/php5/fpm/pool.d/$1.conf

echo "\n"$1 | tee -a /etc/hosts
