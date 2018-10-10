FROM debian:stretch-slim
MAINTAINER orbnedron

# Define version of Jackett
ARG VERSION=0.10.273

# Other Arguments
ARG DEBIAN_FRONTEND=noninteractive

# Add start file
ADD start.sh /start.sh
RUN chmod 755 /start.sh

# Install mono
RUN apt-get update -q \
    && apt-get install -qy gnupg2 \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb http://download.mono-project.com/repo/debian stable-stretch main" > /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update -q \
    && apt-get install -qy libmono-cil-dev ca-certificates-mono libmono-system-runtime-interopservices-runtimeinformation4.0-cil

# Install applications and some dependencies
RUN apt-get update -q \
    && apt-get install -qy procps libcurl4-openssl-dev curl \
    && curl -L -o /tmp/jackett.tar.gz https://github.com/Jackett/Jackett/releases/download/v${VERSION}/Jackett.Binaries.Mono.tar.gz \
    && tar xzf /tmp/jackett.tar.gz -C /tmp/ \
    && mv /tmp/Jackett /opt/jackett \
    && cp /usr/lib/mono/4.5/System.Runtime.InteropServices.RuntimeInformation.dll /opt/jackett/ \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/tmp/* \
    && rm -rf /tmp/*

# Publish volumes, ports etc
VOLUME ["/config", "/media/downloads"]
EXPOSE 9117
WORKDIR /media/downloads

# Define default start command
CMD ["/start.sh"]

