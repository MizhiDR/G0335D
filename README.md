# GREE G3S（G0335D）设备树

面向 **GREE G3S / G0335D** 的 Android 设备树，包含：

- LineageOS / CyanogenMod 14.1（Android 7.1.2）产品配置
- TWRP 9.0 产品配置（`omni_g0335d`）
- 从实机提取的 3.18.31 内核（prebuilt `Image.gz-dtb`）
- 完整 TWRP fstab、Android fstab、sepolicy、init、audio、wifi、keylayout 等配置
- 从实机提取 vendor blobs 的脚本

## 目录结构

```
G0335D/
├── device/gree/g0335d/        # 设备树（ROM + TWRP 共用）
│   ├── BoardConfig.mk
│   ├── device.mk
│   ├── lineage_g0335d.mk
│   ├── omni_g0335d.mk
│   ├── twrp.mk
│   ├── twrp.fstab
│   ├── rootdir/etc/fstab.qcom
│   └── ...
├── kernel/gree/msm8996/
│   ├── prebuilt/Image.gz-dtb
│   ├── config_g0335d
│   └── README.md
├── vendor/gree/g0335d/        # vendor blobs 生成位置（默认不含 blobs）
├── build/
│   ├── build_lineage.sh
│   └── build_twrp.sh
└── README.md
```

## 实机信息（2026-10 实测）

| 项目 | 值 |
|---|---|
| 型号 | GREE G3S / G0335D |
| SoC | Qualcomm msm8996pro，Snapdragon 821，4 核最高 2.19 GHz |
| GPU | Adreno 530 |
| 内存/存储 | 4 GB LPDDR4 / 64 GB UFS |
| 系统 | Android 7.1.2（HALO 2.1.9 A1，SDK 25） |
| 屏幕 | 5.99 英寸 TFT 全面屏，18:9，1080×2160，403 ppi |
| 显示 IC | Fitipower FT8716（`ft8716 1080p video mode dsi panel`） |
| 触控 | Synaptics DSX/DS5，I2C-12 0x4b，10 点，固件 `NX608-JDIA` / `DS5 R12.5.2` |
| 指纹 | Goodix（`goodix_fp`） |
| 内核 | Linux 3.18.31-perf，`Image.gz` + 追加 DTB |
| Treble | 不支持（无 vendor 分区，`/vendor -> /system/vendor`） |

## 分区（UFS）

| 分区 | 块设备 | 大小 |
|---|---|---|
| boot | `/dev/block/sde17` | 67,108,864 B（64 MiB） |
| recovery | `/dev/block/sde19` | **99,614,720 B（95 MiB）** |
| system | `/dev/block/sde18` | 3,221,225,472 B（3 GiB） |
| userdata | `/dev/block/sda9` | 59,212,771,328 B（约 55.15 GiB） |
| cache | `/dev/block/sda3` | 268,435,456 B（256 MiB） |
| persist | `/dev/block/sda2` | 33,554,432 B（32 MiB） |
| modem | `/dev/block/sde11` | 99,614,720 B（95 MiB） |

> 旧版 G0335D 设备树里 `BOARD_RECOVERYIMAGE_PARTITION_SIZE` 写的是 64 MiB，
> 与实际 recovery 分区 95 MiB 不符；本树已改为 **99,614,720**。

## 构建 LineageOS / CM 14.1

```bash
repo init -u https://github.com/LineageOS/android.git -b cm-14.1 --depth=1
repo sync -j8

mkdir -p device/gree kernel/gree vendor/gree
cp -r /path/to/G0335D/device/gree/g0335d  device/gree/
cp -r /path/to/G0335D/kernel/gree/msm8996 kernel/gree/
# 先按下面“vendor blobs”生成 vendor/gree/g0335d
cp -r /path/to/G0335D/vendor/gree/g0335d  vendor/gree/

source build/envsetup.sh
lunch lineage_g0335d-userdebug
mka bacon -j$(nproc)
```

产物在 `out/target/product/g0335d/`。

## 构建 TWRP 9.0

```bash
repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni -b twrp-9.0
repo sync -j8

mkdir -p device/gree kernel/gree
cp -r /path/to/G0335D/device/gree/g0335d  device/gree/
cp -r /path/to/G0335D/kernel/gree/msm8996 kernel/gree/

source build/envsetup.sh
lunch omni_g0335d-eng
mka recoveryimage -j$(nproc)
```

产物在 `out/target/product/g0335d/recovery.img`。

TWRP 关键配置：

- `TW_THEME := portrait_hdpi`（1080×2160 会自动按 1.125 倍高度缩放）
- `TW_INPUT_BLACKLIST := "hbtp_vm"`：忽略指纹手势虚拟鼠标，保证触摸走 `synaptics_dsx`
- `TW_INCLUDE_CRYPTO := true`（本机为 FDE；`/data` 当前未加密）
- `TW_NO_USB_STORAGE := true`、`RECOVERY_SDCARD_ON_DATA := true`
- `TW_MAX_BRIGHTNESS := 255`

> 如果使用 TWRP 3.2.3（Android 8.1 分支）而该分支不支持
> `TW_INPUT_BLACKLIST`，可在 recovery 启动脚本中删除 `hbtp_vm` 的
> `/dev/input/event*` 节点，或使用本项目 `port_g3s` 里的 wrapper 方案。

## vendor blobs

完整 vendor blobs 已放在：

- https://github.com/MizhiDR/vendor_gree_g0335d （约 568 MB，2,689 个文件）

CI workflow 会自动 clone 这个仓库。手动构建时：

```bash
git clone https://github.com/MizhiDR/vendor_gree_g0335d vendor/gree/g0335d
```

也可以从手机或 `C:\AndroidCarrierClassTools\gree_g3s\system_dump` 重新生成：

```bash
cd device/gree/g0335d
./extract-files.sh       # adb 需要 root
./setup-makefiles.sh
```

需要 ROM 源码树中存在 `vendor/cm/build/tools/extract_utils.sh`。
本机 `C:\AndroidCarrierClassTools\gree_g3s\system_dump` 也保存了完整的
system/vendor dump，可离线提取。

## GitHub Actions

仓库内已经带有 `.github/workflows/build-lineage.yml`：

- 手动触发：Actions → **Build LineageOS 14.1 (G0335D)** → Run workflow
- 或在命令行：`gh workflow run build-lineage.yml`
- 构建目标：`mka bacon -j4`，产物上传为 artifact `lineage-14.1-g0335d`

> **Important:** GitHub 免费托管 runner 的磁盘和 6 小时任务上限对完整
> cm-14.1 构建很紧张。仓库里的 workflow 已使用
> `maximize-build-space` 释放空间，但仍可能超时或磁盘不足。
> 真正稳定的做法是使用 **self-hosted runner**（至少 4 核 / 16 GB RAM /
> 100 GB 可用磁盘）或本地 WSL/Linux 构建。
>
> 如果仓库里没有 `vendor/gree/g0335d/proprietary`，workflow 仍会尝试编译，
> 但产物缺少 vendor blobs，不能作为完整可启动 ROM 使用。

## 已知限制

- 没有完整 G0335D 内核源码，只有 prebuilt 内核 + 精确 config。
- vendor blobs 需要自行提取；相机、音频、RIL 等可能需要 7.x HAL 适配。
- 设备非 Treble，**不能刷 Android 8.0 GSI**；8.0 只能做完整第三方 ROM 移植。
- `/data` 当前未加密；FDE 解密未测试。
- 非官方设备树，刷机前请先备份 boot/recovery，并确认自己了解风险。

## 致谢

- 基础 CM14.1 设备树：wuxianlin / CyanogenMod GREE 社区
- 实机内核、分区、TWRP 参数：本机 G0335D 实测
