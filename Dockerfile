FROM bitwalker/alpine-elixir-phoenix:latest as releaser

WORKDIR /app

# Install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

COPY . .
ENV MIX_ENV=prod
RUN mix do deps.get --only $MIX_ENV, deps.compile

WORKDIR /app/apps/guest_portal
RUN MIX_ENV=prod mix compile
RUN npm install --prefix ./assets
RUN mix phx.digest

WORKDIR /app/apps/core
RUN MIX_ENV=prod mix compile

WORKDIR /app
RUN MIX_ENV=prod mix release

########################################################################

FROM bitwalker/alpine-elixir-phoenix:latest

EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod \
    SHELL=/bin/bash

WORKDIR /app
COPY --from=releaser app/_build/prod/rel/sswedding .
COPY ./start.sh .

CMD ["./start.sh"]
