FROM nginx:alpine

ADD html /usr/share/nginx/html

LABEL traefik.enable="true"

