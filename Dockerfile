FROM alpine:3.15
MAINTAINER Temuri Takalandze <me@abgeo.dev>

ARG KUBE_VERSION="v1.25.3"

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache --update openssl curl ca-certificates && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$KUBE_VERSION/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/entrypoint.sh"]

CMD ["version", "--output", "json"]
