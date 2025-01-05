FROM public.ecr.aws/docker/library/alpine:3.21

ENV CONCURRENCY_KIT_VERSION 0.7.2
ENV DNSPERF_VERSION 2.14.0

RUN apk add --no-cache                                                        \
        bind                                                                  \
        bind-dev                                                              \
        g++                                                                   \
        json-c-dev                                                            \
        krb5-dev                                                              \
        libcap-dev                                                            \
        libxml2-dev                                                           \
        make                                                                  \
        nghttp2-dev                                                           \
        openssl-dev

WORKDIR /opt

# http://concurrencykit.org/
ADD https://github.com/concurrencykit/ck/archive/refs/tags/${CONCURRENCY_KIT_VERSION}.tar.gz /opt/
RUN tar -zxf /opt/${CONCURRENCY_KIT_VERSION}.tar.gz -C /opt/ \
 && cd ck-${CONCURRENCY_KIT_VERSION} \
 && ./configure && make install clean && cd .. \
 && rm -rvf ck-${CONCURRENCY_KIT_VERSION} \
 && rm -rvf /opt/${CONCURRENCY_KIT_VERSION}.tar.gz

# https://www.dns-oarc.net/tools/dnsperf
ADD https://www.dns-oarc.net/files/dnsperf/dnsperf-${DNSPERF_VERSION}.tar.gz /opt/
RUN tar -zxf /opt/dnsperf-${DNSPERF_VERSION}.tar.gz -C /opt/ \
 && cd /opt/dnsperf-${DNSPERF_VERSION} \
 && ./configure && make install distclean && cd .. \
 && rm -rvf /opt/dnsperf-${DNSPERF_VERSION} \
 && rm -rvf /opt/dnsperf-${DNSPERF_VERSION}.tar.gz

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
