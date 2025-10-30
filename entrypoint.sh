#!/bin/sh

set -o errexit

DNSPERF_BINARY="/usr/bin/dnsperf"

DNS_SERVER_ADDR=$(/usr/bin/awk '/^nameserver/{print$2}' /etc/resolv.conf | head -n1)
if [ -z "${DNS_SERVER_ADDR}" ]; then
  echo "[error] No DNS server found in /etc/resolv.conf"
  exit 1
fi

${DNSPERF_BINARY} -h 2>&1 | head -n 2

echo

if [ ! -f "${DNSPERF_RECORDS_INPUT}" ]; then
  echo "[error] Missing records file: ${DNSPERF_RECORDS_INPUT}"
  exit 1
fi

echo "[debug] dnsperf benchmark start"
echo "[debug] DNS_SERVER_ADDR -> ${DNS_SERVER_ADDR}"
echo "[debug] EXTRA_ARGS -> ${EXTRA_ARGS}"
echo "[debug] DNSPERF_RECORDS_INPUT -> ${DNSPERF_RECORDS_INPUT}"

while true; do
  ${DNSPERF_BINARY} -s ${DNS_SERVER_ADDR} -d ${DNSPERF_RECORDS_INPUT} ${EXTRA_ARGS}
done
