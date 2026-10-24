# G0335D kernel reverse engineering / source recovery

## What was recovered

The stock boot image contains:

- compressed `Image.gz` (8,564,275 bytes) followed by an appended DTB blob
  (46,208,636 bytes)
- exact kernel config embedded via `IKCONFIG`

Extracted artifacts in this directory:

| File | Size | MD5 |
|---|---|---|
| `Image` | 26,468,864 | `E7F13B44ADC317C02866D9FD3A0DD6E7` |
| `dtb_all.bin` | 46,208,636 | `0584F146E4077533D14C99BBF52C8186` |
| `g0335d.dtb` | 408,446 | selected DTB (dtb_023 of 124) |
| `g0335d.dts` | 616,760 | decompiled G3S device tree |
| `config_g0335d` | 119,955 | exact 3.18.31 config |

`dtb_all.bin` contains **124 individual DTBs** (split by FDT magic/totalsize).
They were decoded with a small FDT parser and `dtc`.

## Selecting the G3S DTB

Live `/sys/firmware/devicetree/base` values on the phone:

```
model      = Qualcomm Technologies, Inc. MSM 8996pro v1.1 + PMI8996 MTP
compatible = qcom,msm8996-mtp, qcom,msm8996, qcom,mtp
qcom,msm-id   = 0x00000131 0x00010001
qcom,board-id = 0x00000008 0x00000000
qcom,pmic-id  = 0x00020009 0x00010013 ...
```

These match **`dtb_023.bin`** from the 124-DTB blob, which was copied to
`g0335d.dtb` and decompiled:

```bash
dtc -I dtb -O dts -o g0335d.dts g0335d.dtb
```

`g0335d.dts` contains the G3S board description, including the FT8716
1080p panel node, Synaptics touch node, Goodix fingerprint, charger, PMIC,
camera, and the msm8996pro CPU/regulator configuration.

## Kernel source

The kernel is:

```
Linux version 3.18.31-perf-g1104a04-00004-g7711dae
```

A C source tree cannot be fully reconstructed from a stripped kernel binary.
What can be recovered reliably is:

- the exact `.config` (`config_g0335d`)
- the exact board DTS (`g0335d.dts`)
- the symbol/driver set (via optional `vmlinux-to-elf` on a machine with PyPI access)

Use the Xiaomi Mi 5 (gemini) msm8996 source as the baseline:

```
https://github.com/LineageOS/android_kernel_xiaomi_msm8996  (branch cm-14.1)
```

Reference files extracted from that tree are in `reference/`:

- `gemini_defconfig`
- `gemini-msm8996pro-pmi8994-mtp.dts`
- `gemini-msm8996-mtp.dtsi`

The Mi 5 tree already contains `drivers/input/touchscreen/synaptics_dsx/`
(the G3S touch controller family) and the msm8996 clock/regulator/display
infrastructure.

## Suggested kernel bring-up

```bash
git clone --depth=1 -b cm-14.1 \
  https://github.com/LineageOS/android_kernel_xiaomi_msm8996 kernel/gree/msm8996-source
cd kernel/gree/msm8996-source

cp /path/to/G0335D/kernel/gree/msm8996/config_g0335d \
   arch/arm64/configs/g0335d_defconfig
cp /path/to/G0335D/kernel/gree/msm8996/g0335d.dts \
   arch/arm/boot/dts/qcom/g0335d.dts

# Add g0335d.dts to arch/arm/boot/dts/qcom/Makefile
make ARCH=arm64 g0335d_defconfig
make ARCH=arm64 -j$(nproc) Image.gz-dtb
```

The msm8996 QCOM DTS files live under **`arch/arm/boot/dts/qcom/`**
(not `arch/arm64/...`) in this kernel tree.

The important G3S-specific pieces to verify in the Mi 5 source:

- FT8716 1080×2160 panel node/commands (copy from `g0335d.dts`)
- Synaptics DSX touch node and firmware name `startup_fw_update.img`
- Goodix fingerprint (`goodix_fp` / `hbtp_vm`)
- GREE charger/PMIC and 18:9 panel timing
- `msm8996pro` CPU OPP tables

Until the new kernel boots, the device tree continues to use the proven
prebuilt `prebuilt/Image.gz-dtb`.
