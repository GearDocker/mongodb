FROM mongo:3.6.2-jessie

#RUN openssl req -newkey rsa:2048 -new -x509 -subj "/C=US/ST=California/L=SanFrancisco/O=Dis/CN=www.selfsigned.com" -days 1024 -nodes -out mongodb.crt -keyout mongodb.key && \
#    bash -c 'cat mongodb.crt mongodb.key > /etc/ssl/mongodb.pem'

RUN mkdir -p /etc/ssl
WORKDIR /etc/ssl

RUN openssl genrsa -out SelfCA.key 2048 && \
    openssl req -x509 -subj "/C=US/ST=California/L=SanFrancisco/O=Dis/CN=www.selfsigned.com" -new -nodes -key SelfCA.key -sha256 -days 1024 -out SelfCA.pem && \
    openssl genrsa -out mongodb.key 2048 && \
    openssl req -subj "/C=US/ST=California/L=SanFrancisco/O=Dis/CN=www.selfsigned.com" -new -key mongodb.key -out mongodb.csr && \
    openssl x509 -req -in mongodb.csr -CA SelfCA.pem -CAkey SelfCA.key -CAcreateserial -out mongodb.pem -days 1024 -sha256

VOLUME /data/db

ENV AUTH yes
ENV STORAGE_ENGINE wiredTiger
ENV JOURNALING yes

WORKDIR /
ADD run.sh /run.sh
ADD set_mongodb_password.sh /set_mongodb_password.sh
ADD mongod.conf /etc/mongod.conf

EXPOSE 27017 28017

CMD ["/run.sh"]

#CMD ["/run.sh","-b0.0.0.0"]
