# Release info:
# - https://dev.dns-oarc.net/packages/
# - https://launchpad.net/~dns-oarc/+archive/ubuntu/dnsperf
# - https://codeberg.org/DNS-OARC/dnsperf/releases

# Note:
# dnsperf on GitHub have been marked as archived, related commits:
# - https://github.com/DNS-OARC/dnsperf/commit/23622d6982f07d5e8102fdeef5c404aa40651776
# - https://codeberg.org/DNS-OARC/dnsperf/pulls/276/files

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
