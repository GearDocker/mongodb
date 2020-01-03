FROM ubuntu:16.04
MAINTAINER Gary Leong <gwleong@gmail.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    apt-get update && \
    apt-get install -y pwgen wget curl git-core build-essential scons devscripts lintian dh-make \
    libpcre3 libpcre3-dev libboost-dev libboost-date-time-dev libboost-filesystem-dev \
    libboost-program-options-dev libboost-system-dev libboost-thread-dev \
    libpcap-dev libreadline-dev libssl-dev rng-tools libcurl3 openssl apt-transport-https

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
RUN apt-get update 

RUN apt-get install -y mongodb-org

RUN openssl req -newkey rsa:2048 -new -x509 -subj "/C=US/ST=California/L=SanFrancisco/O=Dis/CN=www.selfsigned.com" -days 1024 -nodes -out mongodb.crt -keyout mongodb.key && \
    bash -c 'cat mongodb.crt mongodb.key > /etc/ssl/mongodb.pem'

ENV AUTH yes
ENV JOURNALING yes

ADD run.sh /run.sh
ADD init.sh /init.sh
ADD set_mongodb_password.sh /set_mongodb_password.sh
ADD mongod.conf /etc/mongod.conf

# We use external volumes
#RUN mkdir -p /data/db && /init.sh

EXPOSE 27017 28017

CMD ["/run.sh","-b0.0.0.0"]
