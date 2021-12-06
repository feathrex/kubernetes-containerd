FROM nginx:1.19.1

COPY files/nginx.index.html /usr/share/nginx/html/index.html
COPY files/nginx.script.sh /docker-entrypoint.d/nginx.script.sh
RUN chmod +x /docker-entrypoint.d//nginx.script.sh

ENTRYPOINT ["nginx", "-g", "daemon off;"]
