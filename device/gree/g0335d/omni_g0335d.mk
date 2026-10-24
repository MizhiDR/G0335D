#
# Minimal product configuration for TWRP 9.0 (omni_g0335d).
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/embedded.mk)

# Minimal TWRP product properties. Do not inherit device.mk: it contains
# full-ROM packages that are not available in the TWRP minimal manifest.
$(call inherit-product, device/gree/g0335d/twrp.mk)

PRODUCT_NAME := omni_g0335d
PRODUCT_DEVICE := g0335d
PRODUCT_BRAND := GREE
PRODUCT_MODEL := G0335D
PRODUCT_MANUFACTURER := GREE

TARGET_VENDOR := gree
