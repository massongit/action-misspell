FROM debian:bullseye-slim

ENV REVIEWDOG_VERSION=v0.17.5

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN arch=$(uname -m) && \
      case $arch in \
        x86_64) arch="amd64" ;; \
        x86) arch="386" ;; \
        i686) arch="386" ;; \
        i386) arch="386" ;; \
        aarch64) arch="arm64" ;; \
        armv5*) arch="arm5" ;; \
        armv6*) arch="arm6" ;; \
        armv7*) arch="arm7" ;; \
      esac && \
      echo ${arch} && exit 1
RUN wget -O - -q https://raw.githubusercontent.com/client9/misspell/master/install-misspell.sh | sh -s -- -b /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
