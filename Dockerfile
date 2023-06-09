FROM alpine:latest

MAINTAINER anton@belodedenko.me

RUN apk add --no-cache\
      sniproxy curl vim wget bash iputils bind-tools\
      iproute2 util-linux net-tools tcpdump mtr iftop\
      iperf iptables psmisc socat jq lsof ca-certificates\
      findutils sipcalc grep openntpd ip6tables openssl\
      procps gawk coreutils libev udns libressl

WORKDIR /root

ADD functions ./
ADD sniproxy.conf.template /etc/sniproxy.conf
ADD run.sh ./
RUN chmod +x ./run.sh
ENTRYPOINT ["sh", "./run.sh"]
