FROM alpine:3.13 as alpine
RUN apk add -U --no-cache ca-certificates

# Image starts here
FROM scratch

EXPOSE 80 443 2019
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

WORKDIR /
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY artifacts/binaries/linux/caddy /bin/

ENTRYPOINT ["/bin/caddy"]

CMD ["docker-proxy"]