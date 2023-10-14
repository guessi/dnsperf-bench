#!/bin/sh

DNSPERF_BINARY="/usr/local/bin/dnsperf"

# -----------------------------------------------------------------------------
# Command output of "dnsperf --help"
# -----------------------------------------------------------------------------
#
# DNS Performance Testing Tool
# Version 2.13.1
#
# Usage: dnsperf [-f family] [-m mode] [-s server_addr] [-p port]
#                [-a local_addr] [-x local_port] [-d datafile] [-c clients]
#                [-T threads] [-n maxruns] [-l timelimit] [-b buffer_size]
#                [-t timeout] [-e] [-E code:value] [-D]
#                [-y [alg:]name:secret] [-q num_queries] [-Q max_qps]
#                [-S stats_interval] [-u] [-B] [-v] [-W] [-h] [-H] [-O]
#   -f address family of DNS transport, inet or inet6 (default: any)
#   -m set transport mode: udp, tcp, dot or doh (default: udp)
#   -s the server to query (default: 127.0.0.1)
#   -p the port on which to query the server (default: udp/tcp 53, DoT 853 or DoH 443)
#   -a the local address from which to send queries
#   -x the local port from which to send queries (default: 0)
#   -d the input data file (default: stdin)
#   -c the number of clients to act as
#   -T the number of threads to run
#   -n run through input at most N times
#   -l run for at most this many seconds
#   -b socket send/receive buffer size in kilobytes
#   -t the timeout for query completion in seconds (default: 5)
#   -e enable EDNS 0
#   -E send EDNS option
#   -D set the DNSSEC OK bit (implies EDNS)
#   -y the TSIG algorithm, name and secret (base64)
#   -q the maximum number of queries outstanding (default: 100)
#   -Q limit the number of queries per second
#   -S print qps statistics every N seconds
#   -u send dynamic updates instead of queries
#   -B read input file as TCP-stream binary format
#   -v verbose: report each query and additional information to stdout
#   -W log warnings and errors to stdout instead of stderr
#   -h print this help
#   -H print long options help
#   -O set long options: <name>=<value>
#
# -----------------------------------------------------------------------------

ADDRESS_FAMILY="${ADDRESS_FAMILY:-any}"
TRANSPORT_MODE="${TRANSPORT_MODE:-udp}"
DNS_SERVER_ADDR="${DNS_SERVER_ADDR:-10.100.0.10}"
DNS_SERVER_PORT=${DNS_SERVER_PORT:-53}
DNSPERF_RECORDS_INPUT="/opt/records.txt"
MAX_CLIENTS="${MAX_CLIENTS:-1}"
MAX_THREADS="${MAX_THREADS:-1}"
MAX_TEST_SECONDS="${MAX_TEST_SECONDS:-60}"
TIMEOUT_FOR_QUERY="${TIMEOUT_FOR_QUERY:-5}"
MAX_QPS="${MAX_QPS:-1000}"

${DNSPERF_BINARY} -h 2>&1 | head -n 2

if [ ! -f "${DNSPERF_RECORDS_INPUT}" ]; then
  echo "missing records file"
  exit 1
fi

echo "[debug] bench start"

while true; do
  ${DNSPERF_BINARY} \
    -f ${ADDRESS_FAMILY} \
    -m ${TRANSPORT_MODE} \
    -s ${DNS_SERVER_ADDR} \
    -p ${DNS_SERVER_PORT} \
    -d ${DNSPERF_RECORDS_INPUT} \
    -c ${MAX_CLIENTS} \
    -T ${MAX_THREADS} \
    -l ${MAX_TEST_SECONDS} \
    -t ${TIMEOUT_FOR_QUERY} \
    -Q ${MAX_QPS}
done
