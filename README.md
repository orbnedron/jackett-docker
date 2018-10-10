# About

This is a Docker image for [Jackett](https://github.com/Jackett/Jackett) - implements the Torznab (with nZEDb category numbering) and TorrentPotato APIs

The Docker image currently supports:

* support for OpenSSL / HTTPS encryption

# Run

### Run via Docker CLI client

To run the Jackett container you can execute:

```bash
docker run --name jackett -v <download path>:/media/download -v <config path>:/config -p 9117:9117 orbnedron/jackett
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
jackett:
    image: "orbnedron/jackett"
    container_name: "jackett"
    volumes:
        - "<download path>:/media/downloads"
        - "<config path>:/config"
    ports:
        - "9117:9117"
    restart: always
```

## Configuration

### Volumes

Please mount the following volumes inside your Jackett container:

* `/media/downloads`: Directory for downloaded files (e.g. manually downloaded files)
* `/config`: Directory for configuration files

### Configuration file

By default the Jacket configuration is located on `/config`.
If you want to change this you've to set the `CONFIG` environment variable, for example:

```
CONFIG=/config
```
