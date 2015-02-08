Образ сервера для DEV
=============================

Контейнер latest  для разработки

Installation
------------
```bash
docker build -t emilasp/deb.nginx.fpm.mdb ./
```
Run Interactive
--------------------------

```bash
docker run -it  -p 127.0.0.1:80:80 --volume /var/www/sites:/var/www/sites  emilasp/deb.nginx.fpm.mdb /bin/bash
```

Run Background
--------------------------

```bash
docker run -d -p 127.0.0.1:80:80 emilasp/deb.nginx.fpm.mdb
```
	
