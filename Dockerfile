#FROM nginx:latest
#COPY ./out/nav /usr/share/nginx/html/nav 
FROM busybox:latest
ENV PORT=8080

COPY ./out /www

HEALTHCHECK CMD nc -z localhost $PORT

# Create a basic webserver and run it until the container is stopped
CMD echo "httpd started" && trap "exit 0;" TERM INT; httpd -v -p $PORT -h /www/$TENANT -f & wait
