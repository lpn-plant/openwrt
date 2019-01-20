# Copyright (C) 2018-2019 LPN Plant

include $(TOPDIR)/rules.mk

PKG_NAME:=lpnGate-default-config
PKG_VERSION:=1
PKG_RELEASE:=2

PKG_MAINTAINER:=Kamil Wcislo <kamil.wcislo@lpnplant.io>
PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/package.mk

define Package/lpnGate-default-config
	SECTION:= lpn
	CATEGORY:= LPN packages
	TITLE:= lpnGate default configuration
endef

Build/Compile=

define Package/lpnGate-default-config/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/config/* $(1)/etc/config/
	$(INSTALL_DATA) ./files/crontabs/root $(1)/etc/crontabs/root
endef

$(eval $(call BuildPackage,lpnGate-default-config))
