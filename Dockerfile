FROM debian:bookworm-slim

ARG OPENWRT_VERSION=24.10.7
ARG TARGET=x86
ARG SUBTARGET=64

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	bison build-essential ca-certificates file flex gawk gettext git libelf-dev \
	libncurses-dev libssl-dev pkg-config python3 python3-setuptools rsync swig \
	time unzip wget zlib1g-dev zstd \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN set -eux; \
	base_url="https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/${TARGET}/${SUBTARGET}/"; \
	sdk_file="$(wget -qO- "$base_url" | grep -o 'href="[^"]*openwrt-sdk[^"]*\.tar\.zst"' | head -n 1 | cut -d '"' -f 2)"; \
	test -n "$sdk_file"; \
	wget -O /tmp/openwrt-sdk.tar.zst "${base_url}${sdk_file}"; \
	mkdir /sdk; \
	tar --zstd -xf /tmp/openwrt-sdk.tar.zst --strip-components=1 -C /sdk; \
	rm /tmp/openwrt-sdk.tar.zst

WORKDIR /sdk
RUN ./scripts/feeds update -a && \
	./scripts/feeds install luci-base coreutils-base64 jq

COPY package/cup_off_coffee package/cup_off_coffee
COPY package/luci-app-cup-off-coffee package/luci-app-cup-off-coffee

RUN make defconfig && \
	make -j"$(nproc)" package/cup_off_coffee/compile V=s && \
	make -j"$(nproc)" package/luci-app-cup-off-coffee/compile V=s

COPY scripts/export-artifacts.sh /usr/local/bin/export-artifacts
RUN chmod 0755 /usr/local/bin/export-artifacts

VOLUME ["/output"]
ENTRYPOINT ["/usr/local/bin/export-artifacts"]
