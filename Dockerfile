FROM        golang:alpine3.16 AS build
WORKDIR     /go/src/github.com/adnanh/webhook
ENV         WEBHOOK_VERSION 2.8.0
RUN         apk add --update -t build-deps curl libc-dev gcc libgcc
RUN         curl -L --silent -o webhook.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz && \
  tar -xzf webhook.tar.gz --strip 1 &&  \
  go get -d && \
  go build -o /usr/local/bin/webhook && \
  apk del --purge build-deps && \
  rm -rf /var/cache/apk/* && \
  rm -rf /go

FROM        alpine:3.16
COPY        --from=build /usr/local/bin/webhook /usr/local/bin/webhook
RUN         apk --no-cache add curl
WORKDIR     /opt/webhook
ADD         relay.sh .
ADD         hooks.json .
VOLUME      ["/opt/webhook"]
EXPOSE      9000
ENTRYPOINT  ["/usr/local/bin/webhook"]
CMD         ["-template", "-hooks=/opt/webhook/hooks.json"]
