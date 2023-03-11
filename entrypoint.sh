#!/bin/sh

DNSPERF_BINARY="/usr/local/bin/dnsperf"
DNSPERF_RECORDS_INPUT="/opt/records.txt"

MAX_TEST_SECONDS="${MAX_TEST_SECONDS:-60}"
DNS_SERVER_ADDR="${DNS_SERVER_ADDR:-10.100.0.10}"
DNS_SERVER_PORT=${DNS_SERVER_PORT:-53}
TRANSPORT_MODE="${TRANSPORT_MODE:-udp}"
MAX_QPS="${MAX_QPS:-1000}"
MAX_CLIENTS="${MAX_CLIENTS:-1}"

${DNSPERF_BINARY} -h 2>&1 | head -n 2

if [ ! -f "${DNSPERF_RECORDS_INPUT}" ]; then
  echo "missing records file"
  exit 1
fi

while true; do
  ${DNSPERF_BINARY} \
    -c ${MAX_CLIENTS} \
    -l ${MAX_TEST_SECONDS} \
    -s ${DNS_SERVER_ADDR} \
    -p ${DNS_SERVER_PORT} \
    -m ${TRANSPORT_MODE} \
    -Q ${MAX_QPS} \
    -d ${DNSPERF_RECORDS_INPUT}
done
