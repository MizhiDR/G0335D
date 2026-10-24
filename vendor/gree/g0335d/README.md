# vendor/gree/g0335d

Vendor blobs are **not** included in this tree by default.

The device tree expects:

```make
$(call inherit-product-if-exists, vendor/gree/g0335d/g0335d-vendor.mk)
```

Generate them from the connected phone (or an expanded stock ROM) with the
scripts in `device/gree/g0335d`:

```bash
cd device/gree/g0335d
./extract-files.sh            # uses adb; requires root adb
./setup-makefiles.sh          # regenerates g0335d-vendor.mk / Android.mk
```

`extract-files.sh` requires a LineageOS/CyanogenMod source tree that contains
`vendor/cm/build/tools/extract_utils.sh`. For a TWRP-only build the vendor
blobs are not required.

The file list is in:

- `device/gree/g0335d/proprietary-files.txt`
- `device/gree/g0335d/proprietary-files-qc.txt`
- `device/gree/g0335d/proprietary-files-qc-perf.txt`

The connected phone's `/system` and `/system/vendor` already contain these
files. The local `C:\AndroidCarrierClassTools\gree_g3s\system_dump` directory
is also a full system/vendor dump of this device and can be used as an offline
source.
