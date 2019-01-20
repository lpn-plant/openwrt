#
# Copyright (C) 2018 LPN Plant
#


include $(TOPDIR)/rules.mk

PKG_NAME:=get-serial
PKG_RELEASE:=2
PKG_BUILD_DIR:=$(BUILD_DIR)/get-serial
PKG_MAINTAINER:=Kamil Wcislo <kamil.wcislo@lpnplant.io>

include $(INCLUDE_DIR)/package.mk

define Package/get-serial/description
 Simple utility to get serial from the APU mainboard.
 Uses MAC address of the eth0.
endef

define Package/get-serial
	SECTION:= lpn
	CATEGORY:= LPN packages
	TITLE:= Get serial for APU device
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

TARGET_CFLAGS += -Wall

define Build/Compile
	$(TARGET_CC) $(TARGET_CPPFLAGS) $(TARGET_CFLAGS) -o $(PKG_BUILD_DIR)/get-serial get-serial.c $(TARGET_LDFLAGS)
endef

define Package/get-serial/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/get-serial $(1)/usr/bin/get-serial
endef

$(eval $(call BuildPackage,get-serial))
