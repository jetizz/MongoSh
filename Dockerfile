FROM mongo:8.0.3

RUN mkdir /var/mongosh && mkdir /var/mongosh/scripts
WORKDIR /var/mongosh
ADD https://raw.githubusercontent.com/jetizz/Scriptorium/master/wait-for-it.sh ./wait-for-it.sh
COPY ["./entrypoint.sh", "/var/mongosh"]
COPY ["./run.sh", "/var/mongosh"]
RUN chmod +x /var/mongosh/*.sh
ENTRYPOINT ["/bin/bash", "/var/mongosh/entrypoint.sh"]
