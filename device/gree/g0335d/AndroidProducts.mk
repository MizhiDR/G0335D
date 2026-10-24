# The LineageOS/CM product is only advertised when the CM vendor tree is
# present. TWRP's minimal manifest does not ship vendor/cm, so it only sees
# the omni_g0335d product.
PRODUCT_MAKEFILES :=

ifneq ($(wildcard vendor/cm/config/common_full_phone.mk),)
PRODUCT_MAKEFILES += $(LOCAL_DIR)/lineage_g0335d.mk
endif

PRODUCT_MAKEFILES += $(LOCAL_DIR)/omni_g0335d.mk
