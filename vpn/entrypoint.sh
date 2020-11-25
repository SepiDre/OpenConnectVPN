#!/bin/bash

# Exit on any script failures
set -e -o pipefail

# Do not run haproxy without REMOTE_ADDR
if [[ ! -n "${REMOTE_RPD}" ]]; then
  echo "Environment variable REMOTE_ADDR is not set."
else
  # Tweak haproxy config
  sed -i /etc/haproxy/haproxy.cfg \
      -e "s|REMOTE_RPD|${REMOTE_RPD}|g"\
      -e "s|REMOTE_DEV|${REMOTE_DEV}|g"\
      -e "s|REMOTE_DEVMON|${REMOTE_DEVMON}|g"\
      -e "s|REMOTE_PRDMON|${REMOTE_PRDMON}|g"\
      -e "s|REMOTE_TSTMON|${REMOTE_TSTMON}|g"\
      -e "s|REMOTE_DEVCLIENT|${REMOTE_DEVCLIENT}|g"\
      -e "s|REMOTE_TSTCLIENT|${REMOTE_TSTCLIENT}|g"\
      -e "s|REMOTE_PRDCLIENT|${REMOTE_PRDCLIENT}|g"
  # Run haproxy daemon
  exec haproxy -f /etc/haproxy/haproxy.cfg &
#   exec su-exec root haproxy -f /etc/haproxy/haproxy.cfg &
fi

exec echo ${OC_PASSWORD:?'missing OC_PASSWORD variable'} | openconnect $OC_SERVER -u $OC_USER --passwd-on-stdin --servercert=$OC_FINGERPRINT