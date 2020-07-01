#FROM mcr.microsoft.com/dotnet/core/runtime-deps:3.1-alpine
FROM alpine:latest
MAINTAINER orbnedron

# Define version of Jackett
ARG JACKETT_VERSION

##   Install support applications
RUN apk add --no-cache gosu curl --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add --no-cache mediainfo tinyxml2  --repository http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    apk add --no-cache ca-certificates libc6-compat icu-libs krb5-libs libintl libssl1.1 libstdc++ lttng-ust numactl zlib procps && \
    # Download and install Jackett
    apk add --no-cache --virtual=.package-dependencies tar gzip jq && \
    if [ -z ${JACKETT_VERSION+x} ]; then \
    	JACKETT_VERSION=$(curl -sX GET https://api.github.com/repos/Jackett/Jackett/releases/latest \
    	| jq -r .tag_name); \
    fi && \
    curl -L -o /tmp/jackett.tar.gz https://github.com/Jackett/Jackett/releases/download/${JACKETT_VERSION}/Jackett.Binaries.LinuxAMDx64.tar.gz && \
    tar xzf /tmp/jackett.tar.gz -C /tmp/ && \
    mkdir -p /opt && \
    mv /tmp/Jackett /opt/jackett && \
    if [ ! -d "/config" ]; then \
        mkdir "/config"; \
    fi && \
    # Cleanup
    rm -rf /var/tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    apk del .package-dependencies

# Add start file
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Publish volumes, ports etc
VOLUME ["/config", "/media/downloads"]
EXPOSE 9117
WORKDIR /media/downloads

# Define default start command
CMD ["/opt/jackett/jackett", "--NoUpdates"]


