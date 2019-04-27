FROM ubuntu:18.04

ENV DNSPERF_VERSION 2.2.1

RUN apt update                                                             && \
    apt install -y --no-install-recommends                                    \
        bind9                                                                 \
        g++                                                                   \
        libbind-dev                                                           \
        libcap-dev                                                            \
        libfstrm-dev                                                          \
        libgeoip-dev                                                          \
        libjson-c-dev                                                         \
        libkrb5-dev                                                           \
        liblmdb-dev                                                           \
        libprotobuf-c-dev                                                     \
        libssl-dev                                                            \
        libxml2-dev                                                           \
        make

# https://www.dns-oarc.net/tools/dnsperf
ADD https://www.dns-oarc.net/files/dnsperf/dnsperf-${DNSPERF_VERSION}.tar.gz /opt/
RUN tar -zxf /opt/dnsperf-${DNSPERF_VERSION}.tar.gz -C /opt/

RUN cd /opt/dnsperf-${DNSPERF_VERSION}/                                    && \
    ./configure                                                            && \
    make install distclean

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
