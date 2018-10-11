#!/usr/bin/env sh
set -e

echo "Jackett settings"
echo "===================="
echo
echo "  Config:     ${CONFIG:=/config}"
echo

# Define variables to use when starting application
CONFIG=${CONFIG:-/config}
XDG_CONFIG_HOME=${CONFIG}

echo "Starting Jackett..."
mono --debug /opt/jackett/JackettConsole.exe -d ${CONFIG} -t -l

