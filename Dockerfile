FROM lucascardo12/api_mongodb

WORKDIR /app

ADD pubspec.* /app/
RUN pub get
ADD . /app/
RUN pub get --offline

CMD []
ENTRYPOINT ["/usr/bin/dart", "bin/server.dart"]


# docker build -t lucascardo12/api_mongodb:latest -f Dockerfile .
# docker login -u lucascardo12 -p fuckyuo12 docker.io
# docker push lucascardo12/api_mongodb:latest 
# docker run --name api -d -p 8080:8080 lucascardo12/api_mongodb:latest
# docker exec -it mongodb bash 
# --network=my-net -itd