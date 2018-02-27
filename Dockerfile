FROM nginx:alpine

COPY html /usr/share/nginx/html

LABEL traefik.enable="true"

