#!/bin/sh

MAX_TEST_SECONDS="${MAX_TEST_SECONDS:-60}"
DNS_SERVER_ADDR="${DNS_SERVER_ADDR:-10.100.0.10}"
MAX_QPS="${MAX_QPS:-1000}"

if [ ! -f /opt/records.txt ]; then
  echo "missing records file"
  exit 1
fi

while true; do
  dnsperf \
    -l ${MAX_TEST_SECONDS} \
    -s ${DNS_SERVER_ADDR} \
    -Q ${MAX_QPS} \
    -d /opt/records.txt
done
