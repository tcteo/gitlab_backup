FROM alpine:3.16
RUN apk add --no-cache git glab curl jq bash
COPY main.sh /main.sh

ENTRYPOINT ["/main.sh"]