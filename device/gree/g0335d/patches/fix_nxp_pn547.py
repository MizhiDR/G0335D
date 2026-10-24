#!/usr/bin/env python
#
# Fix the LineageOS cm-14.1 NXP NFC sources for PN547C2.
#
# The GREE G3S uses a PN547C2 (BOARD_NFC_CHIPSET := pn547), which selects
# the non-concurrent-access code paths in the NXP stack.  Those paths are
# not exercised by the PN548C2-based devices the LineageOS tree is normally
# built for, and contain two compile errors:
#
#   1. NativeSecureElement.cpp uses EE_ERROR_EXT_FIELD, but the constant is
#      only defined in the legacy nxp/jni/com_android_nfc.h.
#   2. RoutingManager::stackCallback() uses `se`, but only declares it when
#      NXP_NFCC_ESE_UICC_CONCURRENT_ACCESS_PROTECTION is TRUE (PN548+).
#
# Run this from the root of the LineageOS source tree after cloning
# vendor/nxp-nfc/opensource/Nfc.

from __future__ import print_function

NFC = "vendor/nxp-nfc/opensource/Nfc/nci/jni/NativeSecureElement.cpp"
ROUTING = "vendor/nxp-nfc/opensource/Nfc/nci/jni/RoutingManager.cpp"
NATIVE_MGR = "vendor/nxp-nfc/opensource/Nfc/nci/jni/NativeNfcManager.cpp"


def patch(path, old, new):
    with open(path) as f:
        text = f.read()
    if new in text and new != old:
        print("already patched: %s" % path)
        return
    if old not in text:
        print("pattern not found: %s" % path)
        return
    with open(path, "w") as f:
        f.write(text.replace(old, new, 1))
    print("patched: %s" % path)


patch(
    NFC,
    "static const int EE_ERROR_LISTEN_MODE = -4;",
    "static const int EE_ERROR_LISTEN_MODE = -4;\n"
    "static const int EE_ERROR_EXT_FIELD = -5;",
)

patch(
    ROUTING,
    "#if((NFC_NXP_ESE == TRUE)&&(NXP_NFCC_ESE_UICC_CONCURRENT_ACCESS_PROTECTION == TRUE))\n"
    "    SecureElement& se = SecureElement::getInstance();",
    "#if (NFC_NXP_ESE == TRUE)\n"
    "    SecureElement& se = SecureElement::getInstance();",
)

# SecureElement::checkForWiredModeAccess() is compiled unconditionally and
# calls android::isp2pActivated(), but that helper is only built for chips
# other than PN547C2.  The state variable exists for every chip, so build the
# accessor as well.
patch(
    NATIVE_MGR,
    "#if(NFC_NXP_ESE == TRUE && (NFC_NXP_CHIP_TYPE != PN547C2))\n"
    "bool isp2pActivated();",
    "#if(NFC_NXP_ESE == TRUE)\n"
    "bool isp2pActivated();",
)

patch(
    NATIVE_MGR,
    "#if(NFC_NXP_ESE == TRUE && (NFC_NXP_CHIP_TYPE != PN547C2))\n"
    "/*******************************************************************************\n"
    "**\n"
    "** Function:        isp2pActivated",
    "#if(NFC_NXP_ESE == TRUE)\n"
    "/*******************************************************************************\n"
    "**\n"
    "** Function:        isp2pActivated",
)
