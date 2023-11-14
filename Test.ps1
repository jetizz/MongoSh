# docker build . -t jetiz/mongosh:1.0.0
# docker push jetiz/mongosh:1.0.0

# TEST 
#docker build . -t jetiz/mongosh:local
#docker run -it --rm -v $PWD/test/scripts:/opt/init --entrypoint bash jetiz/mongosh:local
#docker run -it --rm -v $PWD/test/scripts:/opt/init jetiz/mongosh:local --env 


docker run -it --rm --net="host" -p 27017:27017 mongo:1.0.0
docker run -it --rm --net="host" -v $PWD/test/scripts:/var/mongosh/scripts -e SERVER_NAME='localhost' -e SERVER_PORT='9500' -e DB_NAME='foo' jetiz/mongosh:local
docker run -it --rm --net="host" -v $PWD/test/scripts:/var/mongosh/scripts -e SERVER_NAME='localhost' -e SERVER_PORT='9500' -e DB_NAME='foo' --entrypoint bash jetiz/mongosh:local
