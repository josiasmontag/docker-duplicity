# Duplicity Cron Runner

This is MySQL/MariaDB support for [Tecnativa/docker-duplicity](https://github.com/Tecnativa/docker-duplicity).

## Available images

Each of the built-in [flavors][flavors] is separated into a specific docker image:

- [`docker-duplicity-mysql`](https://github.com/orgs/josiasmontag/packages/container/package/docker-duplicity-mysql)
- [`docker-duplicity-mysql-s3`](https://github.com/orgs/josiasmontag/packages/container/package/docker-duplicity-mysql-s3)


### MySQL (`docker-duplicity-mysql`)

The same behaviour as in [PostgreSQL](https://github.com/Tecnativa/docker-duplicity#postgresql-docker-duplicity-postgres) but for
MySQL/MariaDB databases. Make sure you run this image in a fashion similar to this
`docker-compose.yaml` definition:

```yaml
services:
  db:
    image: mariadb:10.5
    environment:
      MARIADB_DATABASE: mydb
      MARIADB_USER: myuser
      MARIADB_PASSWORD: mypass
  backup:
    image: ghcr.io/josiasmontag/docker-duplicity-mysql
    hostname: my.mysql.backup
    environment:
      # MySQL connection
      MYSQL_HOST: db 
      MYSQL_PASSWORD: mypass 
      MYSQL_USER: myuser 

      # Additional configurations for Duplicity
      AWS_ACCESS_KEY_ID: example amazon s3 access key
      AWS_SECRET_ACCESS_KEY: example amazon s3 secret key
      DST: boto3+s3://mybucket/myfolder
      PASSPHRASE: example backkup encryption secret
```

It will make [dumps automatically][Dockerfile]:

```
# Makes postgres dumps for all databases except to mysql, performance_schema & information_schema.
# They are uploaded by JOB_300_WHEN
JOB_200_WHEN=daily weekly
```


## Credits

* Javinator9889 ([PR for MySQL support](https://github.com/Tecnativa/docker-duplicity/pull/70))
* Tecnativa ([Tecnativa/docker-duplicity](https://github.com/Tecnativa/docker-duplicity))