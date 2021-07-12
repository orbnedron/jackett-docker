# Jackett docker image

<img src="https://badgen.net/docker/pulls/orbnedron/jackett"> <a href="https://hub.docker.com/repository/docker/orbnedron/jackett"><img src="https://badgen.net/badge/icon/docker?icon=docker&label"/></a> <a href="https://travis-ci.org/github/orbnedron/jackett-docker"><img src="https://badgen.net/travis/orbnedron/jackett-docker?icon=travis&label=build"/></a>

# Important notice
 
Versions of this docker image published after 2020-06-15 does not run Jackett as root anymore, this might cause permission errors.

# About

This is a Docker image for [Jackett](https://github.com/Jackett/Jackett) - implements the Torznab (with nZEDb category numbering) and TorrentPotato APIs

# Build 

To build Jackett container you can execute:
```bash
docker build --build-arg JACKETT_VERSION=$JACKETT_VERSION -t jackett .
```

*```$JACKETT_VERSION``` is version of Jackett you want to install.*

# Run

### Run via Docker CLI client

To run it (with image on docker hub) :

```bash
docker run -d -p 9117:9117 \
    -v <download path>:/media/downloads \
    -v <config path>:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e JACKETT_USER_ID=`id -u $USER` -e JACKETT_GROUP_ID=`id -g $USER`
    --restart unless-stopped \
    --name jackett \
    orbnedron/jackett
```

Open a browser and point it to [http://my-docker-host:9117](http://my-docker-host:9117)

### Run via Docker Compose

You can also run the Jackett container by using [Docker Compose](https://www.docker.com/docker-compose).

If you've cloned the [git repository](https://github.com/orbnedron/jackett-docker) you can build and run the Docker container locally (without the Docker Hub):

```bash
docker-compose up -d
```

If you want to use the Docker Hub image within your existing Docker Compose file you can use the following YAML snippet:

```yaml
version: "3.8"
services:
  jackett:
    image: "orbnedron/jackett"
    container_name: "jackett"
    volumes:
        - './data/config:/config'
        - './data/downloads:/media/downloads'
    ports:
        - 9117:9117
    restart: 'unless-stopped'
#    environment:
#      - JACKETT_USER_ID=1000
#      - JACKETT_GROUP_ID=1000
```

## Configuration

### Volumes

Please mount the following volumes inside your Jackett container:

* `/media/downloads`: Directory for downloaded files (e.g. manually downloaded files)
* `/config`: Directory for configuration files

