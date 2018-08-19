FROM alpine:3.8
ENV DNSPERF_VERSION 2.1.0.0-1

RUN apk add --no-cache                                                        \
        bind                                                                  \
        bind-dev                                                              \
        g++                                                                   \
        json-c-dev                                                            \
        libcap-dev                                                            \
        libxml2-dev                                                           \
        make                                                                  \
        openssl-dev

# https://www.akamai.com/us/en/products/network-operator/measurement-tools.jsp
ADD http://wwwns.akamai.com/dnsperf-src-${DNSPERF_VERSION}.tar.gz /opt/
RUN tar -zxf /opt/dnsperf-src-${DNSPERF_VERSION}.tar.gz -C /opt/

RUN cd /opt/dnsperf-src-${DNSPERF_VERSION}/                                && \
    ./configure                                                            && \
    make install distclean

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
