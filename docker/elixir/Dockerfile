FROM elixir:1.10.4

ENV MIX_HOME=/opt/mix

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y \
    mecab \
    libmecab-dev \
    mecab-ipadic \
    mecab-ipadic-utf8

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && bin/install-mecab-ipadic-neologd -n -y --asuser -p /usr/local/lib/mecab/dic/ipadic

WORKDIR /bot
ADD mix.exs /bot
ADD .env /bot
ADD config /bot/config

RUN mix local.rebar --force && mix local.hex --force && mix deps.get

ADD lib /bot/lib
ADD test /bot/test

RUN mix compile

CMD ["mix", "run", "--no-halt"]
