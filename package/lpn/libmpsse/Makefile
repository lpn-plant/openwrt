#
# Copyright (C) 2018 LPN Plant
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libmpsse
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:lpn-plant/$(PKG_NAME).git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

PKG_FIXUP:=1
MAKE_PATH:=src

define Package/libmpsse/Default
	TITLE:=MPSSE lib for FTDI chips
	URL:=https://github.com/lpn-plant/libmpsse
endef

define Package/libmpsse
$(call Package/libmpsse/Default)
	SECTION:= lpn
	CATEGORY:= LPN packages
	SUBMENU:= Libraries
	DEPENDS:=+libftdi1
endef

define Package/libmpsse/description
  MPSSE lib for FTDI chips.
endef

CONFIGURE_ARGS += \
        --disable-python

define Build/Compile
	( cd $(PKG_BUILD_DIR)/src; ./configure $(CONFIGURE_ARGS) )
	$(call Build/Compile/Default,)
endef


define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/mpsse.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/src/libmpsse.* $(1)/usr/lib/
endef

define Package/libmpsse/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/libmpsse.so $(1)/usr/lib
endef

$(eval $(call BuildPackage,libmpsse))
