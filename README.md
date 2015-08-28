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

Services Info
---------------------
---------------------


### RabbitMQ
Используется для очереди задач. Процедура настройки для Ubuntu:
* необходимо установить ``` sudo apt-get install rabbitmq-server ```
* добавить пользователя lk ``` sudo rabbitmqctl add_user lk gfhflbuvf ```
* добавить пользователю lk все права ``` sudo rabbitmqctl set_permissions lk ".*" ".*" ".*" ```
* перезапустить Rabbit ``` sudo service rabbitmq-server restart ```

### Supervisor
Используется для управления процессами в памяти 
* установить supervisor (можно через python-pip)
* В конфигурационный файл добавить такие блоки, каждый блок является описанием для каждого из воркеров

```
[program:test]
command=php -f /var/www/yii worker/test 
process_name=bonus_%(process_num)s
numprocs=1
stdout_logfile=/var/log/lk_workers.log
stderr_logfile=/var/log/lk_workers_error.log
autostart=true
autorestart=true

[program:pm]
command=php -f /var/www/yii worker/pm 
process_name=bonus_%(process_num)s
numprocs=1
stdout_logfile=/var/log/lk_workers.log
stderr_logfile=/var/log/lk_workers_error.log
autostart=true
autorestart=true 
```
* закрыть supervisord
* открыть supervisord передав в параметр ``` -с /путь_до_конфиг_файла.conf ``` 

Для контроля работы supervisord есть консольная утилита ``` supervisorctl ```
команды ``` help, status, restart <all|proccess> ```

