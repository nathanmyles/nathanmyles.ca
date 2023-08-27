FROM ubuntu:latest
LABEL authors="nathanmyles"

RUN apt-get update && apt-get install -y wget

RUN wget https://github.com/gohugoio/hugo/releases/download/v0.74.3/hugo_0.74.3_Linux-64bit.deb
RUN dpkg -i hugo_0.74.3_Linux-64bit.deb

WORKDIR /site

COPY . .

EXPOSE 8080

ENTRYPOINT ["hugo", "server", "-D", "--bind=0.0.0.0", "-p", "8080"]