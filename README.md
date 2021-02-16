# [caddy-docker-proxy-webdav](https://github.com/VS-X/caddy-docker-proxy-webdav)

A container image of Caddy with docker-proxy and webdav plugins built-in.

More information in the respective plugins:  
caddy-docker-proxy: https://github.com/lucaslorentz/caddy-docker-proxy  
caddy-webdav: https://github.com/mholt/caddy-webdav

## Example use

Docker-compose file:

```yaml
version: "2.4"

networks:
  web:
    external: true

volumes:
  caddy_data:

services:
  caddy:
    image: ghcr.io/vs-x/caddy-docker-proxy-webdav
    container_name: caddy
    restart: always
    ports:
      - 80:80
      - 443:443
      - 2019:2019
    networks:
      - web
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /path/to/caddy/Caddyfile:/etc/caddy/Caddyfile:ro
      - /path/to/caddy/logs:/var/log/caddy
      - /path/to/caddy/sites:/opt/sites
      # this volume is needed to keep the certificates
      # otherwise, new ones will be re-issued upon restart
      - caddy_data:/data
    environment:
      CADDY_DOCKER_CADDYFILE_PATH: /etc/caddy/Caddyfile
```

Caddyfile:

```
{
  email email@example.com # email for ACME
  order webdav before file_server # Important, webdav plugin should be ordered before file_server
}

webdav.example.com {
  encode zstd gzip # optional compression
  basicauth { # optional auth
    example-user HASHED_PASSWORD
  }
  webdav {
    root /opt/sites/Webdav-Site
  }
}

```
