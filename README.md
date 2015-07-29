Образ сервера для DEV
=============================

Контейнер latest  для разработки

Installation
------------

Add mysqlDump 
------------
mysqldump -uroot --all-databases >.../all.sql
Copy dump in sites/databases/tmp/all.sql

Add php5 and nginx configs
-------------
Copy /etc/php5/* and /etc/nginx/* into sites/nginx/tmp/ and sites/php5/tmp/ 


```bash
docker build -t emilasp/deb.nginx.fpm.mdb ./
```
Create Interactive
--------------------------

```bash
docker run -it  -p 127.0.0.1:80:80 -p 2022:22 --name server  --volume /var/www:/var/www  emilasp/deb.nginx.fpm.mdb start_services
```
create Background

```bash
docker run -d -p 127.0.0.1:80:80  --name dev.server emilasp/deb.nginx.fpm.mdb
```


Run conteiner
--------------------------

```bash
docker start dev.server
```

Attach conteiner
--------------------------

```bash
docker attach dev.server
```

Remove conteiner
--------------------------

```bash
docker rm dev.server
```

View run conteiners
--------------------------

```bash
docker ps
```

Install docker on debian 8(testing)
--------------------------

```bash
aptitude install docker.io
```	
