# Docker启动nginx+php-fpm环境

## 命令

```
# 启动
docker-compose up
# 暂停
ctrl+c 

# 后台启动
docker-compose up -d

# 暂停
docker-compose stop

# 启动
docker-compose start

# 删除
docker-compose down

```

## 配置文件

`default.conf`是nginx的配置文件  
工程文件放在data目录的app目录中  
工程的启动文件路径默认为`./data/app/public`  
若要修改则需要修改nginx的配置文件`default.conf`  
php的扩展则需要在Dockerfile中修改  
需要增加redis或者Mysql等则需要在docker-compose.yml里面修改


## 目录

|____docker
| |____Dockerfile
| |____default.conf
| |____docker-compose.yml
|____data
| |____host.access.log
| |____app
| | |____public
| | | |____index.php
| |____.gitignore

## 快速上手

```
git clone https://gogs.dongdavid.com/dongdavid/docker-lnmp.git
cd docker-lnmp
cd data
composer create-project topthink/think app
cd ../docker
docker-compose up
```

```
docker-composer down
rm -rf docker-lnmp
```

