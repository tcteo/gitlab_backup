FROM alpine:3.16
RUN apk add --no-cache git glab curl jq bash
COPY main.sh /main.sh
COPY git_askpass.sh /git_askpass.sh
RUN mkdir /data

# set up a fake homedir
RUN mkdir -p /home/fake
RUN chmod a+rwx /home/fake
ENV HOME /home/fake
WORKDIR /home/fake

VOLUME ["/data"]
ENTRYPOINT ["/main.sh"]