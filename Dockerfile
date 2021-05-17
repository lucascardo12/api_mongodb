FROM lucascardo12/api_mongodb

WORKDIR /app

ADD pubspec.* /app/
RUN pub get
ADD . /app/
RUN pub get --offline

CMD []
ENTRYPOINT ["/usr/bin/dart", "bin/server.dart"]
