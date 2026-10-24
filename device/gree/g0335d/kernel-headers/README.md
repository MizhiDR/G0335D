# Kernel UAPI headers (stock 3.18.31)

This directory contains the kernel userspace headers exported by the stock
GREE G3S (G0335D) kernel build:

```
kernel/user/usr/include
```

from the vendor kernel source tree, copied verbatim.

## Why they are here

The device tree uses a prebuilt stock kernel (`TARGET_PREBUILT_KERNEL` in
`BoardConfig.mk`) and does not carry kernel sources, so the Android build
system never creates `$OUT/obj/KERNEL_OBJ/usr` (the normal
`make headers_install` output).

Some platform modules still depend on that path. In LineageOS 14.1
`system/core/sdcard/Android.mk` does:

```make
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_ADDITIONAL_DEPENDENCIES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
```

and `sdcard.c` includes `<linux/fuse.h>`. Without this directory the ninja
generation fails with:

```
ninja: error: '.../obj/KERNEL_OBJ/usr', needed by '.../libsdcard_intermediates/sdcard.o',
missing and no known rule to make it
```

## Build integration

The CI workflow installs these headers after `lunch`:

```bash
rm -rf "$OUT/obj/KERNEL_OBJ/usr"
mkdir -p "$OUT/obj/KERNEL_OBJ"
cp -r device/gree/g0335d/kernel-headers "$OUT/obj/KERNEL_OBJ/usr"
```

Do the same for a local build. Keep these headers in sync with the kernel
image in `kernel/gree/msm8996/prebuilt/Image.gz-dtb`.
