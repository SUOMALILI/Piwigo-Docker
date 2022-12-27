# Piwigo Docker

#### PIWIGO_RELEASE=2.10.2

Base on the [jobec dockerfile](https://piwigo.org/forum/viewtopic.php?id=30502&p=2). I add videojs plugin and keep the plugin folder locked for security consideration. If you want to update piwigo and plugins, you can build your own image by `docker build piwigo `.

#### Plugin List

> VideoJs 2.9b
>
> GThumb+ 2.8.a
>
> RV Thumbnail Scroller 2.7.a
>
> Share Album 1.4
>
> EXIF View 2.9.a
>
> piwigo-openstreetmap 2.9a
>
> Social Connect 2.2.5
>
> Bootstrap Darkroom 2.4.4



# Usage

#### Piwigo

use my build or change the docker file and build  by yourself. 

```shell
docker run -d \
  --name=piwigo \
  -e TZ=Asia/Shanghai \
  -p 8380:80 \
  -p 8300:8080 \
  -v /yourGallery:/var/www/galleries \
  --restart unless-stopped \
  1074550119/piwigo:2.10.0
```

you can use `docker inspect piwigo` to check the volume of config.

#### Mariadb

piwigo need a database, you can use mysql or mariadb. Here is the example:

```shell
docker run -d \
  --name=mariadb \
  -v /yourDBFolder/:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=piwigo \
  -e MYSQL_DATABASE=piwigo \
  -e MYSQL_USER=piwigo \
  -e MYSQL_PASSWORD=piwigo \
  --restart unless-stopped \
  mariadb:latest
```

you can use `docker inspect mariadb` to check the ip address of mariadb.
