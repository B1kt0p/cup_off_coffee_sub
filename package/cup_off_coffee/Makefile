include $(TOPDIR)/rules.mk

PKG_NAME:=cup_off_coffee
PKG_VERSION:=1.1.0
PKG_RELEASE:=4
PKG_LICENSE:=MIT
PKG_MAINTAINER:=cup_off_coffee maintainers
PKGARCH:=all

include $(INCLUDE_DIR)/package.mk

define Package/cup_off_coffee
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Remnawave subscription updater for Podkop
  DEPENDS:=+curl +coreutils-base64 +jq
endef

define Package/cup_off_coffee/description
 Downloads a Remnawave subscription, orders VLESS and Hysteria2 links and updates Podkop UCI.
endef

define Build/Compile
endef

define Package/cup_off_coffee/conffiles
/etc/config/cup_off_coffee
endef

define Package/cup_off_coffee/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/cup_off_coffee $(1)/etc/config/cup_off_coffee
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/cup_off_coffee $(1)/etc/init.d/cup_off_coffee
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/cup_off_coffee-update $(1)/usr/bin/cup_off_coffee-update
	$(INSTALL_DIR) $(1)/usr/libexec/cup_off_coffee
	$(INSTALL_BIN) ./files/usr/libexec/cup_off_coffee/scheduler $(1)/usr/libexec/cup_off_coffee/scheduler
endef

$(eval $(call BuildPackage,cup_off_coffee))
