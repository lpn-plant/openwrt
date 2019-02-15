#
# Copyright (C) 2018 - 2019 LPN Plant
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=packet_forwarder
PKG_VERSION:=4.0.1.2
PKG_RELEASE:=2

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/lpn-plant/$(PKG_NAME).git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Package/packet-forwarder/Default
	TITLE:=Semtech packet-forwarder package. LPN Plant's fork
	URL:=https://github.com/lpn-plant/packet_forwarder
endef

define Package/packet-forwarder
$(call Package/packet-forwarder/Default)
	SECTION:= lpn
	CATEGORY:= LPN packages
	DEPENDS:= +libftdi1 +libmpsse +lora-gateway
endef

define Package/packet-forwarder/config
	source "$(SOURCE)/Config.in"
endef

define Package/packet-forwarder/description
	packet-forwarder is a reference gateway implementation.
endef

define Package/packet-forwarder/conffiles
/etc/config/lora_pkt_fwd
endef

GLOBAL_CONF_PATH=/etc/lora/global_conf.json

LGW_PATH=$(STAGING_DIR)/usr/include/lora-gateway
TARGET_CFLAGS += -O2 -Wall -Wextra -std=c99 -Iinc -I. -I$(LGW_PATH) -DNOQSORT_R=1

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		GLOBAL_CONF_PATH=$(GLOBAL_CONF_PATH)
endef

define Package/packet-forwarder/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lora_pkt_fwd/lora_pkt_fwd $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/lora
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/lora_pkt_fwd/cfg/global_conf.json.PCB_E336.EU868.basic $(1)/$(GLOBAL_CONF_PATH)
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) files/lora_pkt_fwd.config $(1)/etc/config/lora_pkt_fwd
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/lora_pkt_fwd.init $(1)/etc/init.d/lora_pkt_fwd

ifeq ($(CONFIG_PACKET_FW_INSTALL_TEST),y)
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/util_ack/util_ack $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/util_sink/util_sink $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/util_tx_test/util_tx_test $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lora_pkt_fwd/*.sh $(1)/usr/bin
endif
endef

$(eval $(call BuildPackage,packet-forwarder))
