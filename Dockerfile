FROM alpine:latest
MAINTAINER orbnedron

# Define version of Jackett
ARG JACKETT_VERSION

#   Install support applications
RUN apk add --no-cache mono gosu curl --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add --no-cache mediainfo tinyxml2 --repository http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    # Install ca-certificates
    apk add --no-cache --virtual=.build-dependencies ca-certificates && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    # Download and install Jackett
    apk add --no-cache --virtual=.package-dependencies tar gzip && \
    curl -L -o /tmp/jackett.tar.gz https://github.com/Jackett/Jackett/releases/download/${JACKETT_VERSION}/Jackett.Binaries.Mono.tar.gz && \
    tar xzf /tmp/jackett.tar.gz -C /tmp/ && \
    mkdir -p /opt && \
    mv /tmp/Jackett /opt/jackett && \
    # Fix dependency
    cp /usr/lib/mono/4.5/Facades/System.Runtime.InteropServices.RuntimeInformation.dll /opt/jackett/ && \
    ln -s /usr/lib/libmono-native.so.0 /usr/lib/libmono-native.so && \
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
CMD ["mono", "--debug", "/opt/jackett/JackettConsole.exe", "-d", "/config", "-t", "-l"]


