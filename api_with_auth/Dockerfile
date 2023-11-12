FROM elixir:latest
RUN mix local.hex
RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client git
ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY . .
RUN mix deps.get
RUN mix deps.compile
RUN mix compile
EXPOSE 4000
CMD ["sh", "/app/entrypoint.sh"]