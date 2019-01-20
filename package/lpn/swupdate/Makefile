#
# Copyright (C) 2018 LPN Plant
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/version.mk

PKG_NAME:=swupdate
PKG_VERSION:=2018.03
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/sbabic/swupdate/archive
PKG_HASH:=19156bb30c3517a0ff9c918a38062df3cfa70f02f8162da4971a2f47d108688e

PKG_INSTALL:=1

PKG_LICENSE:=GPLv2
PKG_LICENSE_FILES:=

PKG_MAINTAINER:=Kamil Wcislo <kamil.wcislo@lpnplant.io>

include $(INCLUDE_DIR)/package.mk

define Package/swupdate
	TITLE:=Embedded Software Update utility
	SECTION:= lpn
	CATEGORY:= LPN packages
	URL:= https://github.com/sbabic/swupdate
	DEPENDS:= +libconfig +libjson-c +libarchive +libcurl +zlib +libopenssl
endef

define Package/swupdate/description
  Utility to reliable update embedded devices.
endef

define Build/Configure
	rm -f $(PKG_BUILD_DIR)/.config
	$(CP) ./defconfig $(PKG_BUILD_DIR)/.config
	$(MAKE) -C $(PKG_BUILD_DIR) oldconfig
endef

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		TARGET_CFLAGS="$(TARGET_CFLAGS)" \
		TARGET_CXXFLAGS="$(TARGET_CXXFLAGS)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		all
endef

define Package/swupdate/conffiles
	/etc/swu/swupdate.cfg
	/etc/config/swupdate
endef

define Package/swupdate/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/swupdate $(1)/usr/sbin/swupdate
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tools/progress $(1)/usr/sbin/swupdate_progress
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) files/etc/sw-versions $(1)/etc/sw-versions
	$(INSTALL_DATA) files/etc/hwrevision $(1)/etc/hwrevision
	$(INSTALL_DIR) $(1)/etc/swu
	$(INSTALL_DATA) files/etc/swu/swupdate.cfg $(1)/etc/swu/swupdate.cfg
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) files/etc/config/swupdate $(1)/etc/config/swupdate
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/etc/init.d/* $(1)/etc/init.d/

	$(VERSION_SED_SCRIPT) \
		$(1)/etc/swu/swupdate.cfg \
		$(1)/etc/sw-versions \
		$(1)/etc/hwrevision
endef

$(eval $(call BuildPackage,swupdate))
