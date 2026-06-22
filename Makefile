OPENWRT_24_VERSION ?= 24.10.7
OPENWRT_25_VERSION ?= 25.12.4
TARGET ?= x86
SUBTARGET ?= 64
DOCKER ?= docker
DOCKER_PLATFORM ?= linux/amd64
DIST_DIR ?= $(CURDIR)/dist

.PHONY: all build-24.10 build-25.12 clean

all: build-24.10 build-25.12

build-24.10:
	$(DOCKER) build \
		--platform $(DOCKER_PLATFORM) \
		--progress plain \
		--build-arg OPENWRT_VERSION=$(OPENWRT_24_VERSION) \
		--build-arg TARGET=$(TARGET) \
		--build-arg SUBTARGET=$(SUBTARGET) \
		-t cup-off-coffee-builder:$(OPENWRT_24_VERSION)-$(TARGET)-$(SUBTARGET) .
	mkdir -p $(DIST_DIR)/$(OPENWRT_24_VERSION)
	rm -f $(DIST_DIR)/$(OPENWRT_24_VERSION)/cup_off_coffee_*.ipk \
		$(DIST_DIR)/$(OPENWRT_24_VERSION)/luci-app-cup-off-coffee_*.ipk
	$(DOCKER) run --rm \
		--platform $(DOCKER_PLATFORM) \
		-v "$(DIST_DIR)/$(OPENWRT_24_VERSION):/output" \
		cup-off-coffee-builder:$(OPENWRT_24_VERSION)-$(TARGET)-$(SUBTARGET)

build-25.12:
	$(DOCKER) build \
		--platform $(DOCKER_PLATFORM) \
		--progress plain \
		--build-arg OPENWRT_VERSION=$(OPENWRT_25_VERSION) \
		--build-arg TARGET=$(TARGET) \
		--build-arg SUBTARGET=$(SUBTARGET) \
		-t cup-off-coffee-builder:$(OPENWRT_25_VERSION)-$(TARGET)-$(SUBTARGET) .
	mkdir -p $(DIST_DIR)/$(OPENWRT_25_VERSION)
	rm -f $(DIST_DIR)/$(OPENWRT_25_VERSION)/cup_off_coffee-*.apk \
		$(DIST_DIR)/$(OPENWRT_25_VERSION)/luci-app-cup-off-coffee-*.apk
	$(DOCKER) run --rm \
		--platform $(DOCKER_PLATFORM) \
		-v "$(DIST_DIR)/$(OPENWRT_25_VERSION):/output" \
		cup-off-coffee-builder:$(OPENWRT_25_VERSION)-$(TARGET)-$(SUBTARGET)

clean:
	rm -rf $(DIST_DIR)
