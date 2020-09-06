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
ADD . /bot

RUN mix local.hex --force && mix deps.get

CMD ["mix", "test"]
