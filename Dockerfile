# syntax=docker/dockerfile:1
FROM alpine:3.19

RUN apk add --no-cache ca-certificates

COPY .buildkite /app/.buildkite

CMD ["/bin/sh", "-c", "echo Namespace remote builder demo && ls -R /app"]
