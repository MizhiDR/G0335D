#
# Copyright (C) 2016 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from g0335d device tree
$(call inherit-product, device/gree/g0335d/device.mk)

# Inherit common LineageOS/CyanogenMod phone configuration.
# cm-14.1 uses vendor/cm; LineageOS 15.1+ uses vendor/lineage.
# Use inherit-product-if-exists so the tree still parses in TWRP's minimal
# manifest, where vendor/cm is not present.
$(call inherit-product-if-exists, vendor/cm/config/common_full_phone.mk)

PRODUCT_NAME := lineage_g0335d
PRODUCT_DEVICE := g0335d
PRODUCT_BRAND := GREE
PRODUCT_MODEL := G0335D
PRODUCT_MANUFACTURER := GREE
PRODUCT_GMS_CLIENTID_BASE := android-gree

TARGET_VENDOR := gree
TARGET_VENDOR_PRODUCT_NAME := G0335D
TARGET_VENDOR_DEVICE_NAME := G0335D

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=G0335D \
    PRODUCT_NAME=G0335D

PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_FINGERPRINT=GREE/G0335D/G0335D:7.1.2/N2G47H/:user/dev-keys \
    PRIVATE_BUILD_DESC="HALO 2.1.9 A1"
