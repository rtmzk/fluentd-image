FROM --platform=$BUILDPLATFORM ruby:3.2.2-slim as builder

COPY Gemfile /Gemfile

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends g++ gcc make && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'gem: --no-document' >> /etc/gemrc && \
    gem install --file /Gemfile


FROM --platform=$BUILDPLATFORM ruby:3.2.2-slim

COPY fluent.conf /etc/fluent/fluent.conf
COPY entrypoint.sh /entrypoint.sh
COPY --from=builder /usr/local/bundle/ /usr/local/bundle ·

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]
RUN apt-get update && \
    apt-get install -y --no-install-recommends libjemalloc2 && \
    apt-get clean -y && \
    ulimit -n 65536 && \
    rm -rf \
        /var/cache/debconf/* \
        /var/lib/apt/lists/* \
        /var/log/* \
        /var/tmp/* \
        rm -rf /tmp/*

EXPOSE 80

CMD ["/entrypoint.sh"]

