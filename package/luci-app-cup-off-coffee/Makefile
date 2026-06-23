include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-cup-off-coffee
PKG_VERSION:=1.1.0
PKG_RELEASE:=5
PKG_LICENSE:=MIT
PKG_MAINTAINER:=cup_off_coffee maintainers
PKGARCH:=all
EXTRA_DEPENDS:=cup_off_coffee (>=1.1.0), luci-base (>=0), rpcd-mod-file (>=0)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-cup-off-coffee
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI support for cup_off_coffee
endef

define Package/luci-app-cup-off-coffee/description
 LuCI web interface for cup_off_coffee.
endef

define Build/Compile
endef

define Package/luci-app-cup-off-coffee/install
	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/cup_off_coffee
	$(INSTALL_DATA) ./htdocs/luci-static/resources/view/cup_off_coffee/settings.js \
		$(1)/www/luci-static/resources/view/cup_off_coffee/settings.js
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) ./root/usr/share/luci/menu.d/luci-app-cup-off-coffee.json \
		$(1)/usr/share/luci/menu.d/luci-app-cup-off-coffee.json
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./root/usr/share/rpcd/acl.d/luci-app-cup-off-coffee.json \
		$(1)/usr/share/rpcd/acl.d/luci-app-cup-off-coffee.json
endef

$(eval $(call BuildPackage,luci-app-cup-off-coffee))
