# docker build . -t jetiz/mongosh:6.0.2
# docker push jetiz/rabbitmq:6.0.2

# TEST 
#docker build . -t jetiz/mongosh:local
#docker run -it --rm -v $PWD/test/scripts:/opt/init --entrypoint bash jetiz/mongosh:local
#docker run -it --rm -v $PWD/test/scripts:/opt/init jetiz/mongosh:local