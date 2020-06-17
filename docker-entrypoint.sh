#!/usr/bin/env sh
set -e
# Run commands in the Docker container with a particular UID and GID.
# The idea is to run the container like
#   docker run -i \
#     -v `pwd`:/work \
#     -e JACKETT_USER_ID=`id -u $USER` \
#     -e JACKETT_GROUP_ID=`id -g $USER` \
#     image-name bash
# where the -e flags pass the env vars to the container, which are read by this script.
# By setting copying this script to the container and setting it to the
# ENTRYPOINT, and subsequent commands run in the container will run as the user
# who ran `docker` on the host, and so any output files will have the correct
# permissions.

USER_ID=${JACKETT_USER_ID:-1000}
GROUP_ID=${JACKETT_GROUP_ID:-$USER_ID}

echo "Starting with UID : $USER_ID, GID: $GROUP_ID"
addgroup -g $GROUP_ID jackett
adduser --shell /bin/sh --uid $USER_ID --disabled-password --ingroup jackett jackett

XDG_CONFIG_HOME="/config"

if [ "$(id -u)" = "0" ]; then
  chown -R jackett:jackett /config
  chown -R jackett /opt/jackett
  set -- gosu jackett:jackett "$@"
fi

exec "$@"
