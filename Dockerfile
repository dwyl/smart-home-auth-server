FROM elixir:1.10.4

# Install external deps
RUN apt-get update \
  && curl -sL https://deb.nodesource.com/setup_12.x | bash \
  && apt-get install -y apt-utils \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && apt-get install -y postgresql-client inotify-tools

RUN mix local.hex --force \
  && mix local.rebar --force

WORKDIR /app
ADD mix.exs mix.lock /app/
RUN mix deps.get
RUN mix deps.compile

ADD assets/package.json assets/package-lock.json assets/
RUN cd assets/ && \
  npm install

ADD . /app

CMD ["/app/entrypoint.sh"]