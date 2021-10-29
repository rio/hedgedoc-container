FROM docker.io/library/node:lts-slim

RUN adduser --uid 10000 --disabled-password --system hedgedoc && \
    mkdir -p /var/lib/hedgedoc/db && \
    chown -R hedgedoc /var/lib/hedgedoc && \
    apt-get -qq update && \
    apt-get -qqy install --no-install-recommends ca-certificates wget git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/hedgedoc
USER hedgedoc

RUN wget -q -O- https://github.com/hedgedoc/hedgedoc/releases/download/1.9.0/hedgedoc-1.9.0.tar.gz | tar xzf - --strip-components 1 && yarn install --frozen-lockfile --production

ENV NODE_ENV=production
ENV CMD_DOMAIN=localhost
ENV CMD_URL_ADDPORT=true
ENV CMD_DB_URL=sqlite:/var/lib/hedgedoc/db/sqlite.db

CMD ["yarn", "start"]
