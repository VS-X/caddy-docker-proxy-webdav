FROM golang:alpine as builder

RUN apk add -U --no-cache ca-certificates git
RUN go get -u github.com/caddyserver/xcaddy/cmd/xcaddy 
RUN CGO_ENABLED=0 xcaddy build \
  --output artifacts/binaries/linux/caddy \
  --with github.com/lucaslorentz/caddy-docker-proxy/plugin/v2 \
  --with github.com/mholt/caddy-webdav \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/porech/caddy-maxmind-geolocation
RUN chmod +x artifacts/binaries/linux/caddy

# Image starts here
FROM scratch

EXPOSE 80 443 2019
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

WORKDIR /
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/artifacts/binaries/linux/caddy /bin/

ENTRYPOINT ["/bin/caddy"]

CMD ["docker-proxy"]
