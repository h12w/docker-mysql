FROM debian:latest
MAINTAINER Hǎiliàng Wáng <w@h12.me>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install vim -q -y && \
    apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" mysql-server

RUN sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
RUN sed -i "s/key_buffer.*/key_buffer_size = 16M/" /etc/mysql/my.cnf

RUN mysqld --initialize-insecure=on; exit 0

COPY grant.sql .
RUN service mysql start && \
    mysql --protocol=socket -uroot <  grant.sql

EXPOSE 3306
ENTRYPOINT mysqld
