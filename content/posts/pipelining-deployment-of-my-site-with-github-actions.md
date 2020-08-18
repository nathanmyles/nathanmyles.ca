+++
date = 2020-08-16T01:00:00Z
lastmod = 2020-08-16T01:00:00Z
author = "default"
title = "Pipelining deployment of my site with Github Actions"
feature = "/img/github.png"
tags = ["GitHub", "GitHub Actions"]
+++

Automate all the things! I've set up a pipeline to deploy this site using GitHub Actions. Deploying the site consists of
building the site using `hugo -D` and then `sftp`ing the files to my web hosting. I'll tell you how I did it here.

## Setting up GitHub configuration

First, I created a `.github` folder in my [repo](https://github.com/nathanmyles/nathanmyles.ca). This folder holds the 
configuration for the pipelines. Inside of it, I created `actions` and `workflows`. The `actions` folder holds the 
`deploy` action. The `workflows` folder holds the pipelines.

### Building the action

I decided to put all deploy code into a single action, since this is a simple pipeline. If things had been more 
complicated, I would have broken it into several actions. I also went with a Docker based action, to give myself the 
ability to install the tools needed to perform the deployment. I created a `deploy` folder under the `actions` folder. 
Then I started by adding a `Dockerfile` that sets up everything I needed.

```
FROM ubuntu:latest

LABEL "name"="Site Deployer"
LABEL "maintainer"="Nathan Myles <nmyles@nathanmyles.com>"
LABEL "version"="0.1.0"

RUN \
  apt-get update && \
  apt-get install -y ca-certificates openssl wget sshpass && \
  update-ca-certificates && \
  rm -rf /var/lib/apt

RUN wget https://github.com/gohugoio/hugo/releases/download/v0.74.3/hugo_0.74.3_Linux-64bit.deb
RUN dpkg -i hugo_0.74.3_Linux-64bit.deb

RUN mkdir ~/.ssh
RUN echo "|1|Vv2eHwhG56hA7aPZW9i/9oHgcgA=|F8V/FZp2SOdh+WJ9hP01Jbcobyc= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFjDE2sDVlaHhXudMMsLEuJvY+nBuTbwLGpQkLaJ5oxIR9vXinw/2dSzqnDAlrmJ1ZgWKQnvPh7Mz770Hp/sobU=" >> ~/.ssh/known_hosts

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
```

This installs a few dependencies I need, like `openssl` and `sshpass`, and then installs `hugo`. I need to download the 
`deb` file from the hugo repo to get an up to date version that will successfully build the site. I also added my 
hosting servers ssh fingerprint, so that the job can connect via sftp. Finally, I copy in the `entrypoint.sh` script and 
set it as the default entrypoint for the container.

Next, Let's talk about the `entrypoint.sh` script.

```
#!/bin/bash

set -e
set -x
set -o pipefail

if [[ -z "$GITHUB_WORKSPACE" ]]; then
  echo "Set the GITHUB_WORKSPACE env variable."
  exit 1
fi
cd "$GITHUB_WORKSPACE"

echo "Preparing to build blog..."
hugo -D
echo "Building is done."

echo "Copying over generated files..."
cd public
sshpass -e sftp "$1@home279202417.1and1-data.host" << !
  put -r .
  exit
!
echo "Copy is done."

exit 0
```

This script just `cd`s into the workspace directory, builds the hugo site, `cd`s into the `public` directory that is 
generated, and finally pushes all the files to the web server. I'm handing in the user which allows me to control if 
this is updating DEV or PROD. I use `sshpass -e` to supply the password to `sftp` via an environment variable to avoid 
having it exposed in the log output.

Finally, I needed an `action.yaml` file to define the metadata for the action.

```
name: 'Site Deployer'
description: 'Build a hugo blog, and deploy it'
inputs:
  user:
    description: 'deploy user'
    required: true
    default: 'u52708221-nmyles-dev'
runs:
  using: 'docker'
  image: 'Dockerfile'
  args:
    - ${{ inputs.user }}
```

This tells Github the `name` and `description` of the action, that it takes one input of `user`, and that it's a docker
action, built using the `Dockerfile` in this folder.

### Configuring the pipelines

Inside the `workflows` folder, I created two pipelines, one for `dev` and one for `master`. The two pipeline are almost 
the same, so I'll just show the `dev` pipeline.

```
name: CI-DEV

on:
  push:
    branches: [ dev ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so tbe job can access it
      - uses: actions/checkout@v2

      - name: Deploy
        uses: ./.github/actions/deploy
        with:
          user: 'u52708221-nmyles-dev'
        env:
          SSHPASS: ${{ secrets.SSHPASS_NMYLES_DEV }}
```

This tells GitHub the `name` of the pipeline, when it should be run, what type of machine to run it on, and what steps to
run. For this pipeline, I set it to run on pushes to `dev` (in the `master` pipeline, this is `master`). It's set to run
on ubuntu. The steps are: 1) check out the repo, 2) deploy it using my custom action. I provide the user which matches
the DEV environment and inject the secret containing the password into the `SSHPASS` environment variable. These also 
change in the `master` pipeline so that it deploys to PROD.

That's it! Now when I push to `dev`, the site is built and pushed to my DEV site. When I push to the `master` branch, it
deploys to PROD. If you have any questions, let me know! Happy automating!

