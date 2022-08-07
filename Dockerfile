FROM alpine:3.16
RUN apk add --no-cache git glab curl jq bash
COPY main.sh /main.sh
RUN mkdir /data

# set up a fake homedir
RUN mkdir /home
RUN chmod a+rwx /home
ENV HOME /home
WORKDIR /home

VOLUME ["/data"]
ENTRYPOINT ["/main.sh"]