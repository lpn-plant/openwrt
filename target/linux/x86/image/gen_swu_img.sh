#!/bin/sh
#
# Copyright (C) 2018-2019 LPN PLant
#

PREINSTALL=preinstall.sh

# signing mode
MODE="RSA"

[ $# -lt 5 ] && {
    echo "SYNTAX: $0 <work_dir> <version> <hw_revision> <sign_key> <enc_key>"
    exit 1
}

if ! command -v openssl > /dev/null; then
    echo "OpenSSL required!"
    exit 1
fi

WORK_DIR=${1}
VERSION=${2}
HWREV=${3}
SIGN_KEY=${4}
ENC_KEY=${5}

[ -z "${SIGN_KEY}" ] || {
    [ -f "${SIGN_KEY}" ] || {
        echo "sign_key doesn't exist: ${SIGN_KEY}"
        exit 1
    }

    SIGN_KEY=$(readlink -e "$SIGN_KEY")
}

[ -z "${ENC_KEY}" ] || {
    [ -f "${ENC_KEY}" ] || {
        echo "enc_key doesn't exist: ${ENC_KEY}"
        exit 1
    }

    ENC_KEY=$(readlink -e "$ENC_KEY")
    . $ENC_KEY
}

cd ${WORK_DIR} || {
    echo "can't enter work dir: ${WORK_DIR}"
    exit 1
}

IMAGES="vmlinuz rootfs"

cat > $PREINSTALL << EOF
#!/bin/sh
umount /boot
mount -o remount,rw,noatime /boot
sysupgrade -b /boot/sysupgrade.tgz
mount -o remount,ro,noatime /boot
mount --bind /boot/boot /boot
mount -o remount,rw,noatime /boot
EOF

chmod +x $PREINSTALL

# encrypt images
for i in $IMAGES; do
    cp ${i} ${i}.tmp
    openssl enc -aes-256-cbc -in ${i}.tmp -out ${i} -K ${key} -iv ${iv} -S ${salt} || {
        echo "ERROR: openssl encryption failed"
        exit 1
    }
    rm -f ${i}.tmp
done

# compute the sha sums
ROOTFS_SHA256=$(sha256sum rootfs  | cut -f 1 -d ' ')
KERNEL_SHA256=$(sha256sum vmlinuz | cut -f 1 -d ' ')
PREINSTALL_SHA256=$(sha256sum $PREINSTALL | cut -f 1 -d ' ')

# create the sw-description file
cat > sw-description << EOF
software =
{
        version = "${VERSION}";

        hardware-compatibility: [ "${HWREV}" ];

        stable:
        {
                copy-1:
                {
                        images: (
                        {
                                filename = "rootfs";
                                device = "/dev/sda2";
                                sha256 = "${ROOTFS_SHA256}";
                                name = "rootfs";
                                version = "${VERSION}";
                                install-if-different = true;
                                encrypted = true;
                        }
                        );
                        files: (
                        {
                                filename = "vmlinuz";
                                path = "/boot/vmlinuz_0";
                                sha256 = "${KERNEL_SHA256}";
                                name = "kernel";
                                version = "${VERSION}";
                                install-if-different = true;
                                encrypted = true;
                        }
                        );
                        scripts: (
                        {
                                filename = "${PREINSTALL}";
                                type = "preinstall";
                                sha256 = "${PREINSTALL_SHA256}";
                        }
                        );
                        bootenv: (
                        {
                                name = "next";
                                value = "0";
                        },
                        {
                                name = "fback";
                                value = "1";
                        }
                        );
                };
                copy-2:
                {
                        images: (
                        {
                                filename = "rootfs";
                                device = "/dev/sda3";
                                sha256 = "${ROOTFS_SHA256}";
                                name = "rootfs";
                                version = "${VERSION}";
                                install-if-different = true;
                                encrypted = true;
                        }
                        );
                        files: (
                        {
                                filename = "vmlinuz";
                                path = "/boot/vmlinuz_1";
                                sha256 = "${KERNEL_SHA256}";
                                name = "kernel";
                                version = "${VERSION}";
                                install-if-different = true;
                                encrypted = true;
                        }
                        );
                        scripts: (
                        {
                                filename = "${PREINSTALL}";
                                type = "preinstall";
                                sha256 = "${PREINSTALL_SHA256}";
                        }
                        );
                        bootenv: (
                        {
                                name = "next";
                                value = "1";
                        },
                        {
                                name = "fback";
                                value = "0";
                        }
                        );
                };
        };
}
EOF

if [ -z "$SIGN_KEY" ]; then
    FILES="sw-description $PREINSTALL $IMAGES"
else
    FILES="sw-description sw-description.sig $PREINSTALL $IMAGES"
    # sign the sw-description file
    openssl dgst -sha256 -sign "$SIGN_KEY" sw-description > sw-description.sig || exit 1
fi

for i in $FILES; do
    echo $i; done | cpio -ov -H crc > lpngate_${VERSION}_hwrev-${HWREV}_update.swu

rm $PREINSTALL
