#!/bin/sh

DNSPERF_BINARY="/usr/bin/dnsperf"

DNS_SERVER_ADDR=$(/usr/bin/awk '/^nameserver/{print$2}' /etc/resolv.conf)

${DNSPERF_BINARY} -h 2>&1 | head -n 2

if [ ! -f "${DNSPERF_RECORDS_INPUT}" ]; then
  echo "missing records file"
  exit 1
fi

echo "[debug] dnsperf benchmark start"
echo "[debug] DNS_SERVER_ADDR -> ${DNS_SERVER_ADDR}"
echo "[debug] EXTRA_ARGS -> ${EXTRA_ARGS}"
echo "[debug] DNSPERF_RECORDS_INPUT -> ${DNSPERF_RECORDS_INPUT}"

while true; do
  ${DNSPERF_BINARY} -s ${DNS_SERVER_ADDR} -d ${DNSPERF_RECORDS_INPUT} ${EXTRA_ARGS}
done
