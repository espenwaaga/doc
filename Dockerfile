FROM python:3.11-buster as builder
WORKDIR /src
RUN pip install poetry
COPY pyproject.toml poetry.lock main.py mkdocs.yml ./
COPY custom_theme_overrides ./custom_theme_overrides
COPY docs ./docs
COPY .git ./.git
RUN poetry install --no-dev --no-interaction --ansi --remove-untracked
RUN for TENANT in nav dev-nais ssb tenant; do TENANT=$TENANT poetry run mkdocs build -d out/$TENANT;  done

FROM busybox:latest
ENV PORT=8080

COPY --from=builder ./src/out /www

HEALTHCHECK CMD nc -z localhost $PORT
ENV TENANT=tenant

# Create a basic webserver and run it until the container is stopped
CMD echo "httpd started" && trap "exit 0;" TERM INT; httpd -v -p $PORT -h /www/$TENANT -f & wait
