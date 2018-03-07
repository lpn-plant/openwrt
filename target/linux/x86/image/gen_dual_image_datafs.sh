#!/usr/bin/env bash
# Copyright (C) 2018 LPN PLant

set -x
[ $# == 6 -o $# == 7 ] || {
    echo "SYNTAX: $0 <file> <kernel size> <kernel directory> <rootfs size> <rootfs image> <data size> [<align>]"
    exit 1
}

OUTPUT="$1"
KERNELSIZE="$2"
KERNELDIR="$3"
ROOTFSSIZE="$4"
ROOTFSIMAGE="$5"
DATASIZE="$6"
ALIGN="$7"

rm -f "$OUTPUT"

head=16
sect=63

# create partition table
set `ptgen -o "$OUTPUT" -h $head -s $sect -p ${KERNELSIZE}m -p ${ROOTFSSIZE}m -p ${ROOTFSSIZE}m -p ${DATASIZE}m ${ALIGN:+-l $ALIGN} ${SIGNATURE:+-S 0x$SIGNATURE}`

KERNELOFFSET="$(($1 / 512))"
KERNELSIZE="$2"
ROOTFSOFFSET="$(($3 / 512))"
ROOTFSSIZE="$(($4 / 512))"
ROOTFS2OFFSET="$(($5 / 512))"
ROOTFS2SIZE="$(($6 / 512))"
DATAOFFSET="$(($7 / 512))"
DATASIZE="$8"

[ -n "$PADDING" ] && dd if=/dev/zero of="$OUTPUT" bs=512 seek="$ROOTFSOFFSET" conv=notrunc count="$ROOTFSSIZE"
dd if="$ROOTFSIMAGE" of="$OUTPUT" bs=512 seek="$ROOTFSOFFSET" conv=notrunc

[ -n "$PADDING" ] && dd if=/dev/zero of="$OUTPUT" bs=512 seek="$ROOTFS2OFFSET" conv=notrunc count="$ROOTFS2SIZE"
dd if="$ROOTFSIMAGE" of="$OUTPUT" bs=512 seek="$ROOTFS2OFFSET" conv=notrunc

make_ext4fs -J -l "$KERNELSIZE" "$OUTPUT.kernel" "$KERNELDIR"
dd if="$OUTPUT.kernel" of="$OUTPUT" bs=512 seek="$KERNELOFFSET" conv=notrunc
rm -f "$OUTPUT.kernel"

make_ext4fs -J -l "$DATASIZE" "$OUTPUT.data" "$KERNELDIR"
dd if="$OUTPUT.data" of="$OUTPUT" bs=512 seek="$DATAOFFSET" conv=notrunc
rm -f "$OUTPUT.data"
