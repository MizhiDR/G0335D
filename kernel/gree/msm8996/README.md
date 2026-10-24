# G0335D kernel (prebuilt)

This directory contains the kernel used by the G0335D (GREE G3S) device tree.

## Source

- Extracted from the live `boot` partition (`/dev/block/bootdevice/by-name/boot`)
  of the connected phone.
- Linux version: `3.18.31-perf-g1104a04-00004-g7711dae`
- Architecture: arm64, Qualcomm msm8996pro (Snapdragon 821)
- Image format: `Image.gz` + appended DTB (`Image.gz-dtb`)

| File | Size | MD5 |
|---|---|---|
| `prebuilt/Image.gz-dtb` | 54,772,911 | `8ADCD964A29E71D5CCC225DC0E45EB5A` |
| gzip `Image` (decompressed) | 26,468,864 | `E7F13B44ADC317C02866D9FD3A0DD6E7` |
| appended DTB blob | 46,208,636 | `0584F146E4077533D14C99BBF52C8186` |
| `config_g0335d` | 119,955 | `A7600BF5CF78B37653574A56BB2788C9` |

`config_g0335d` is the exact kernel config extracted from the embedded
`IKCONFIG` section of the live kernel.

## Device tree usage

```make
TARGET_PREBUILT_KERNEL := kernel/gree/msm8996/prebuilt/Image.gz-dtb
```

## Building from source

A full G0335D kernel source tree is **not** included here. If you obtain the
GREE msm8996 source, start from `config_g0335d` and use:

```bash
export CROSS_COMPILE=aarch64-linux-android-
make ARCH=arm64 g0335d_defconfig   # or copy config_g0335d to arch/arm64/configs/
make ARCH=arm64 -j$(nproc)
```

The prebuilt kernel is sufficient for LineageOS 14.1 and TWRP builds.

## Reverse-engineered extras

- `Image` — uncompressed 3.18.31 kernel (`E7F13B44ADC317C02866D9FD3A0DD6E7`)
- `dtb_all.bin` — 124 concatenated DTBs from the stock boot image
- `g0335d.dtb` / `g0335d.dts` — the exact G3S board DTB/DTS selected by
  `msm-id=0x131/0x10001`, `board-id=0x8/0`, `pmic-id=0x20009/0x10013`
- `reference/` — Mi 5 (gemini) defconfig and DTS files used as baseline
- `REVERSE_ENGINEERING.md` — extraction method and kernel source bring-up notes

Kernel source baseline: `LineageOS/android_kernel_xiaomi_msm8996` (cm-14.1).
