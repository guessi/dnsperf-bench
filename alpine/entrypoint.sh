#!/bin/sh

MAX_TEST_SECONDS="${MAX_TEST_SECONDS:-60}"
DNS_SERVER_ADDR="${DNS_SERVER_ADDR:-8.8.8.8}"
MAX_QPS="${MAX_QPS:-1000}"

if [ ! -f /opt/records.txt ]; then
  cat > /opt/records.txt <<-EOF
www.google.com A
www.gmail.com A
chat.google.com A
mail.google.com A
drive.google.com A
docs.google.com A
meet.google.com A
sites.google.com A
plus.google.com A
EOF
fi

dnsperf -l ${MAX_TEST_SECONDS} \
        -s ${DNS_SERVER_ADDR} \
        -Q ${MAX_QPS} \
        -d /opt/records.txt
