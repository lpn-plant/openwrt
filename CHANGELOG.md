# Changelog

## [Unreleased](https://github.com/lpn-plant/openwrt/compare/v18.06.1.2...lpnGate)

---
## 2019-02-16: [18.06.1.2](https://github.com/lpn-plant/openwrt/compare/v18.06.1.1...v18.06.1.2)

### Add

* `watchcat` package
* `BUILDING.md` file - build instructions

### Change

* use https instead of git source for `libmpsse`, `lora-gateway`, `packet-forwarder` packages
* luci: use v1.1.0
    * add luci-app-watchcat - used to reboot gateway when no internet connection
    * add luci-app-lorawan - used to configure packet-forwarder and gateway EUI
* datafs default size reduced to 64MB
* `packet-forwarder`: triggers config reload (app restart) when uci config changed
* `packet-forwarder`: by default set TTN host to router.eu.thethings.network

### Fixes

* make ext_storage resize dynamic (device agnostic). Boot device doesn't have to be on sda
* `packet-forwarder`: sets gateway_ID in uci config if empty

## 2019-01-22: [18.06.1.1](https://github.com/lpn-plant/openwrt/compare/v1.7.0...v18.06.1.1)

* rebased to 18.06.1
* changed versioning scheme to use openwrt's main version
* fixed build issue in `package/lpn/config`
* use glibc
* fix downloading glibc sources

## 2019-01-20: [1.7.0](https://github.com/lpn-plant/openwrt/compare/1961cdfb57c647530fc3b5729e1b5569e6fa98b0...v1.7.0)

* first public version
