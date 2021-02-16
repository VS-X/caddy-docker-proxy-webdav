#!/bin/bash

set -e

go get -u github.com/caddyserver/xcaddy/cmd/xcaddy

CGO_ENABLED=0 xcaddy build \
    --output artifacts/binaries/linux/caddy \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin/v2 \
    --with github.com/mholt/caddy-webdav

chmod +x artifacts/binaries/linux/caddy