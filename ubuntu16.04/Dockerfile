FROM ubuntu:16.04
ENV DNSPERF_VERSION 2.1.0.0-1

RUN apt update                                                             && \
    apt install -y --no-install-recommends                                    \
        bind9                                                                 \
        g++                                                                   \
        libbind-dev                                                           \
        libcap-dev                                                            \
        libgeoip-dev                                                          \
        libjson-c-dev                                                         \
        libkrb5-dev                                                           \
        libssl-dev                                                            \
        libxml2-dev                                                           \
        make

ADD http://wwwns.akamai.com/dnsperf-src-${DNSPERF_VERSION}.tar.gz /opt/
RUN tar -zxf /opt/dnsperf-src-${DNSPERF_VERSION}.tar.gz -C /opt/


RUN cd /opt/dnsperf-src-${DNSPERF_VERSION}/                                && \
    ./configure                                                            && \
    make install distclean
