# Release info:
# - https://github.com/DNS-OARC/dnsperf/releases/tag/v2.14.0
# - https://dev.dns-oarc.net/packages/
# - https://launchpad.net/~dns-oarc/+archive/ubuntu/dnsperf

FROM public.ecr.aws/lts/ubuntu:24.04_stable

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Etc/UTC"

RUN apt update \
 && apt install software-properties-common --no-install-recommends -y \
 && add-apt-repository ppa:dns-oarc/dnsperf \
 && apt update \
 && apt install dnsperf --no-install-recommends -y \
 && apt clean \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd -r dnsperf \
 && useradd -r -g dnsperf dnsperf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER dnsperf

ENTRYPOINT ["/entrypoint.sh"]
