# nathanmyles.ca

This is code for my personal website located at http://nathanmyles.ca

This site is built using [Hugo](https://gohugo.io)

## Prerequisites

- [Docker](https://www.docker.com/)

## Running locally

`docker-compose up -d`

Site will be available at http://localhost:8080/

## Building the site

`hugo -D`
 
 This puts all the needed files into the `/public` directory. Copy the contents of that folder to the web server. 