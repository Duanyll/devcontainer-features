#!/bin/sh
set -e

echo "Activating feature 'mirrors'"

ALPINE=${ALPINE:-http://dl-cdn.alpinelinux.org/alpine}
UBUNTU=${UBUNTU:-http://archive.ubuntu.com/ubuntu}
DEBIAN=${DEBIAN:-http://deb.debian.org/debian}

# remove trailing slashes
ALPINE=$(echo $ALPINE | sed 's:/*$::')
UBUNTU=$(echo $UBUNTU | sed 's:/*$::')
DEBIAN=$(echo $DEBIAN | sed 's:/*$::')

replace_apt_sources() {
    echo "Replacing apt source $1 with $2"
    # If we have /etc/apt/sources.list
    if [ -f /etc/apt/sources.list ]; then
        sed -i "s%$1%$2%g" /etc/apt/sources.list
    fi
    # If we have /etc/apt/sources.list.d/*
    if [ -d /etc/apt/sources.list.d ]; then
        if [ "$(ls -A /etc/apt/sources.list.d)" ]; then
            for file in /etc/apt/sources.list.d/*; do
                sed -i "s%$1%$2%g" $file
            done
        else
            echo "No files found in /etc/apt/sources.list.d/"
        fi
    else
        echo "/etc/apt/sources.list.d/ directory does not exist"
    fi
}

set_apt_retry() {
    echo "Setting apt to retry failed downloads"
    cp ./retry.conf /etc/apt/apt.conf.d/99-retry
}

# If we are in alpine
if [ -f /etc/alpine-release ]; then
    echo "Setting Alpine Linux download source to ${ALPINE}"
    alpine_version=$(cat /etc/alpine-release | cut -d '.' -f 1,2)
    echo "Alpine version: ${alpine_version}"
    echo "${ALPINE}/v${alpine_version}/main" > /etc/apk/repositories
    echo "${ALPINE}/v${alpine_version}/community" >> /etc/apk/repositories
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" = "ubuntu" ]; then
        echo "Setting Ubuntu download source to ${UBUNTU}"
        replace_apt_sources "http://archive.ubuntu.com/ubuntu" "${UBUNTU}"
        set_apt_retry
    elif [ "$ID" = "debian" ]; then
        echo "Setting Debian download source to ${DEBIAN}"
        replace_apt_sources "http://deb.debian.org/debian" "${DEBIAN}"
        set_apt_retry
    else 
        echo "Unknown OS: $ID, did not set mirrors"
    fi
else
    echo "Unknown OS, did not set mirrors"
fi

# if the PIP option is set, set the pip mirror
if [ -n "$PIP" ]; then
    echo "Setting pip mirror to $PIP"
    echo "[global]" > /etc/pip.conf
    echo "index-url = $PIP" >> /etc/pip.conf
    # if the url does not begin with https, we neet to add the trusted host
    if ! echo $PIP | grep -q "^https"; then
        echo "trusted-host = $(echo $PIP | cut -d '/' -f 3)" >> /etc/pip.conf 
    fi
fi