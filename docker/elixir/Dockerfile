FROM elixir:1.10.4

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y \
    mecab \
    libmecab-dev \
    mecab-ipadic \
    mecab-ipadic-utf8

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && bin/install-mecab-ipadic-neologd -n -y --asuser

WORKDIR /bot
ADD . /bot

RUN mix deps.get

CMD ["mix", "run"]
