# Minimal properties for the TWRP build.
# BoardConfig.mk supplies the kernel, partition sizes, TWRP flags and fstab.

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=403 \
    ro.product.first_api_level=25

# Qualcomm display/ION support used by TWRP's fbdev backend.
PRODUCT_PACKAGES += \
    libion \
    libsync
