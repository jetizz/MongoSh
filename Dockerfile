FROM mongo:6.0.2

RUN mkdir /opt/init
WORKDIR /opt
ADD https://raw.githubusercontent.com/jetizz/Scriptorium/master/wait-for-it.sh ./wait-for-it.sh
COPY ["./entrypoint.sh", "/opt"]
COPY ["./run.sh", "/opt"]
ENTRYPOINT ["/bin/bash", "/opt/entrypoint.sh"]