# Always advertise both products. The LineageOS product inherits vendor/cm
# conditionally, so the same tree can still be used with TWRP's minimal
# manifest (where vendor/cm is absent).
PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/lineage_g0335d.mk \
    $(LOCAL_DIR)/omni_g0335d.mk
