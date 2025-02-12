# Release info:
# - https://github.com/DNS-OARC/dnsperf/releases/tag/v2.14.0
# - https://dev.dns-oarc.net/packages/
# - https://launchpad.net/~dns-oarc/+archive/ubuntu/dnsperf

FROM public.ecr.aws/lts/ubuntu:24.04_stable AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Etc/UTC"

RUN apt update \
 && apt install software-properties-common --no-install-recommends -y \
 && add-apt-repository ppa:dns-oarc/dnsperf \
 && apt update \
 && apt install dnsperf --no-install-recommends -y \
 && apt clean

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
