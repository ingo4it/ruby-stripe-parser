
FROM mysql:latest 

    image: mysql:latest
    volumes: 
COPY ./docker/mysql/settings.cnf /etc/mysql/conf.d
COPY ./docker/mysql/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint-initdb.d/db.sh
WORKDIR /docker-entrypoint-initdb.d
ENTRYPOINT ["/docker-entrypoint.sh"]
