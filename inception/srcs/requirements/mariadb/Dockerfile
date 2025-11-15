#Base inage
FROM debian:bookworm

#Set environmental variable inside of the image
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
     && apt-get install -y --no-install-recommends \
     mariadb-server mariadb-client ca-certificates bash tini \
     && rm -rf /var/lib/apt/lists/*

#Config + entrypoint
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init-mariadb.sh /usr/local/bin/init-mariadb.sh
RUN chmod +x /usr/local/bin/init-mariadb.sh

VOLUME ["/var/lib/mysql"]
EXPOSE 3306

#tini handles proper signals for PID1
ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["/usr/local/bin/init-mariadb.sh"]
