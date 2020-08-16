FROM ubuntu:latest

LABEL "name"="Site Deployer"
LABEL "maintainer"="Nathan Myles <nmyles@nathanmyles.com>"
LABEL "version"="0.1.0"

LABEL "com.github.actions.name"="Site Deployer"
LABEL "com.github.actions.description"="Build a hugo blog, and deploy it"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="#E0EBF5"

RUN \
  apt-get update && \
  apt-get install -y ca-certificates openssl wget sshpass && \
  update-ca-certificates && \
  rm -rf /var/lib/apt

RUN wget https://github.com/gohugoio/hugo/releases/download/v0.74.3/hugo_0.74.3_Linux-64bit.deb
RUN dpkg -i hugo_0.74.3_Linux-64bit.deb

RUN mkdir ~/.ssh
RUN echo '|1|Vv2eHwhG56hA7aPZW9i/9oHgcgA=|F8V/FZp2SOdh+WJ9hP01Jbcobyc= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFjDE2sDVlaHhXudMMsLEuJvY+nBuTbwLGpQkLaJ5oxIR9vXinw/2dSzqnDAlrmJ1ZgWKQnvPh7Mz770Hp/sobU=' >> ~/.ssh/known_hosts

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]