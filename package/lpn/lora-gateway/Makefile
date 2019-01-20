#
# Copyright (C) 2018 LPN Plant
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=lora_gateway
PKG_VERSION:=5.1.1L
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:lpn-plant/$(PKG_NAME).git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Package/lora-gateway/Default
  TITLE:=Semtech lora-gateway package. LPN Plant's fork
  URL:=https://github.com/lpn-plant/lora_gateway
endef

define Package/lora-gateway
$(call Package/lora-gateway/Default)
	SECTION:= lpn
	CATEGORY:= LPN packages
	SUBMENU:= Libraries
	DEPENDS:= +libftdi1 +libmpsse
endef

define Package/lora-gateway/config
	source "$(SOURCE)/Config.in"
endef

define Package/lora-gateway/description
  lora-gateway is a library to build a gateway based on
  a Semtech LoRa multi-channel RF receiver (a.k.a. concentrator).
endef

TARGET_CFLAGS += $(FPIC) -O2 -Wall -Wextra -std=c99 -Iinc -I. -lm -DLIBFTDI1=1

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/lora-gateway
	$(CP) $(PKG_BUILD_DIR)/libloragw/inc/* $(1)/usr/include/lora-gateway
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libloragw/libloragw.* $(1)/usr/lib/
endef

define Package/lora-gateway/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libloragw/libloragw.so $(1)/usr/lib/

ifeq ($(CONFIG_LORA_GW_INSTALL_TEST),y)
        $(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libloragw/test* $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/util_pkt_logger/util_pkt_logger $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/util_spi_stress/util_spi_stress $(1)/usr/bin
endif
endef

$(eval $(call BuildPackage,lora-gateway))
