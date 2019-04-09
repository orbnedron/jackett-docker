FROM orbnedron/mono-alpine
MAINTAINER orbnedron

# Define version of Jackett
ARG VERSION=0.11.200

# Install applications and some dependencies
RUN apk add --no-cache  --virtual=.package-dependencies curl tar gzip && \
#    apk add --no-cache curl-dev
    curl -L -o /tmp/jackett.tar.gz https://github.com/Jackett/Jackett/releases/download/v${VERSION}/Jackett.Binaries.Mono.tar.gz && \
    tar xzf /tmp/jackett.tar.gz -C /tmp/ && \
    mkdir -p /opt && \
    mv /tmp/Jackett /opt/jackett && \
    cp /usr/lib/mono/4.5/Facades/System.Runtime.InteropServices.RuntimeInformation.dll /opt/jackett/ && \
    rm -rf /var/tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    apk del .package-dependencies

# Add start file
ADD start.sh /start.sh
RUN chmod 755 /start.sh

# Publish volumes, ports etc
VOLUME ["/config", "/media/downloads"]
EXPOSE 9117
WORKDIR /media/downloads

# Define default start command
CMD ["/start.sh"]

