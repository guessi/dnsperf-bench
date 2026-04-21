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
 && apt install -y --no-install-recommends ca-certificates gpg curl \
 && curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x19D66B634E150C08984C4961474DB6112D0C6432" | gpg --dearmor -o /usr/share/keyrings/dns-oarc.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/dns-oarc.gpg] https://ppa.launchpadcontent.net/dns-oarc/dnsperf/ubuntu noble main" > /etc/apt/sources.list.d/dnsperf.list \
 && apt update \
 && apt install -y --no-install-recommends dnsperf \
 && apt purge -y --auto-remove ca-certificates gpg curl \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd -r dnsperf \
 && useradd -r -g dnsperf dnsperf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER dnsperf

ENTRYPOINT ["/entrypoint.sh"]
