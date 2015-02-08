Образ сервера для DEV
=============================

Контейнер latest  для разработки

Installation
------------
```bash
docker build -t emilasp/deb.nginx.fpm.mdb ./
```
Create Interactive
--------------------------

```bash
docer run -it  -p 127.0.0.1:80:80 --name dev.server  --volume /var/www/sites:/var/www/sites  emilasp/deb.nginx.fpm.mdb start_services
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

	
