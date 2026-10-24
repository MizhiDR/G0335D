#!/bin/bash
# Build TWRP 9.0 for GREE G3S (G0335D).
# Run this script from the root of the TWRP minimal-manifest source tree after
# copying device/ and kernel/ into it.

set -e

if [ ! -f build/envsetup.sh ]; then
    echo "Run this script from the root of the TWRP source tree."
    exit 1
fi

. build/envsetup.sh
lunch omni_g0335d-eng
mka recoveryimage -j"$(nproc)"
