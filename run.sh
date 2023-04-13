#!/usr/bin/env bash

# import common functions
CDW=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
[ -f ${CDW}/functions ] && source ${CDW}/functions

# set environment from linked container information
RESOLVER_IP=$(grep caching-resolver /etc/hosts |  head -n 1 | awk '{print $1}')

if [ -z ${RESOLVER_IP} ]; then
    RESOLVER_IP=8.8.8.8
fi

if [ -z ${EXTERNAL_IP} ];
then
  echo "External IP not set - trying to get IP by myself"
  export EXTERNAL_IP=$(curl -f icanhazip.com)
fi
echo "[INFO] Using $EXTERNAL_IP - Point your DNS settings to this address"

# update sniproxy config
printf "Setting sniproxy resolver to ${RESOLVER_IP}\n"
sed -i -r "s/nameserver ([0-9]{1,3}+\.[0-9]{1,3}+\.[0-9]{1,3}+\.[0-9]{1,3})/nameserver ${RESOLVER_IP}/" /etc/sniproxy.conf

# launch sniproxy
$(which sniproxy) -c /etc/sniproxy.conf -f
