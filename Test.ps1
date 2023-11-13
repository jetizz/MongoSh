# docker build . -t jetiz/mongosh:6.0.2
# docker push jetiz/mongosh:6.0.2

# TEST 
#docker build . -t jetiz/mongosh:local
#docker run -it --rm -v $PWD/test/scripts:/opt/init --entrypoint bash jetiz/mongosh:local
#docker run -it --rm -v $PWD/test/scripts:/opt/init jetiz/mongosh:local --env 



docker network create foonet
docker run -it --rm --net="host" -p 27017:27017 mongo:6.0.2
docker run -it --rm --net="host" -v $PWD/test/scripts:/opt/init -e SERVER_NAME='localhost' -e DB_NAME='foo' jetiz/mongosh:local
docker run -it --rm --net="host" -v $PWD/test/scripts:/opt/init -e SERVER_NAME='localhost' -e DB_NAME='foo' --entrypoint bash jetiz/mongosh:local