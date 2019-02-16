# Building the image

## Prerequisites

- some kind of Linux distro (tested on Arch Linux and Ubuntu)
- docker
- git

## Download development container

All the compiling is done inside a running container in order to mitigate
differences between different Linux distributions.

> All the commands are expected to be run in some kind of work directory, e.g.
> `/home/user/work`

First, we need to pull it from docker hub:
```sh
docker pull lpnplant/openwrt-docker
```

We can also build it manually using the Dockerfile from our
[repository](https://github.com/lpn-plant/openwrt_docker).

We will need the script to start the image:
```sh
git clone https://github.com/lpn-plant/openwrt_docker.git
```

## Build

First, let's clone the repository:

```sh
git clone https://github.com/lpn-plant/openwrt.git
```

Let's start the container:
```sh
./openwrt_docker/scripts/run_docker.sh openwrt
```

And inside the container:
```sh
./scripts/feeds update luci
./scripts/feeds install luci luci-app-watchcat luci-app-lorawan
cp configs/apu_config .config
make oldconfig
make
```

> * `luci-app-watchcat` is LuCI service widget for watchcat
> * `luci-app-lorawan` is LuCI service widget for LoRaWAN configuration

This should be the compilation output:
```
 make[1] world
 make[2] toolchain/compile
 make[2] package/cleanup
 make[3] -C toolchain/binutils compile
 make[3] -C toolchain/gdb compile
 make[3] -C toolchain/fortify-headers compile
 make[3] -C toolchain/yasm compile

 ...

 make[2] package/install
 make[2] target/install
 make[3] -C target/linux install
 make[2] package/index
 make[2] checksum
```

After the build, the images are available in `bin/targets/x86/64-glibc`.
