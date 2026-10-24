#!/bin/bash
# Build LineageOS/CyanogenMod 14.1 for GREE G3S (G0335D).
# Run this script from the root of the ROM source tree after copying
# device/, kernel/ and vendor/ into it.

set -e

if [ ! -f build/envsetup.sh ]; then
    echo "Run this script from the root of the ROM source tree."
    exit 1
fi

. build/envsetup.sh
lunch lineage_g0335d-userdebug
mka bacon -j"$(nproc)"
