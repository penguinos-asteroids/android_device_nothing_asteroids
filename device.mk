DEVICE_PATH := device/nothing/asteroids

# device/qcom/iot/volcano/target.mk will only be present for iot target.
# It will not affect non-IOT target where it would be absent.
-include $(TOPDIR)device/qcom/iot/volcano/target.mk

# A/B
ENABLE_VIRTUAL_AB := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4
PRODUCT_VENDOR_PROPERTIES += ro.virtual_ab.compression.threads=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_client \
    update_verifier \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

PRODUCT_PACKAGES += \
    update_engine_sideload

# AIDL
NEED_AIDL_NDK_PLATFORM_BACKEND := true

# API
BOARD_API_LEVEL := 34
BOARD_SHIPPING_API_LEVEL := 34
PRODUCT_SHIPPING_API_LEVEL := 34
SHIPPING_API_LEVEL := 34

# APEX
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Architecture
TARGET_BOARD_PLATFORM := volcano
TARGET_BOOTLOADER_BOARD_NAME := volcano
TARGET_SUPPORTS_64_BIT_ONLY := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# AVB
BOARD_AVB_ENABLE := true
BOARD_ABL_SIMPLE := false

# Biometrics
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# Camera
ifneq (,$(wildcard $(QCPATH)/chi-cdk))
include $(QCPATH)/chi-cdk/configs/camera_techpack.mk
else ifneq (,$(wildcard $(QCPATH)/camx/chi-cdk))
include $(QCPATH)/camx/chi-cdk/configs/camera_techpack.mk
endif

QTI_CAMERA_PROVIDER_SERVICE := 2.7
QTI_CAMERA_AON_SERVICE := 1.2

# Dalvik
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# DebugFS
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

# Dumpstate
PRODUCT_ENABLE_DUMPSTATE_SUPPORT := true

# Emulated Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Filesystem
PRODUCT_PACKAGES += \
    fs_config_files

# FM
BOARD_HAVE_QCOM_FM := false

# Image Generation Tool
TARGET_USES_IMAGE_GEN_TOOL := true

# Init
PRODUCT_COPY_FILES += $(DEVICE_PATH)/init/fstab.default:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.default
PRODUCT_COPY_FILES += $(DEVICE_PATH)/init/fstab.emmc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc

PRODUCT_PACKAGES += \
    fstab.default \
    fstab.emmc \
    init.target.rc

# ION
TARGET_USES_NEW_ION := true

# Kernel
KERNEL_PREBUILT_DIR := $(DEVICE_PATH)-kernel
TARGET_KERNEL_DLKM_DISABLE := false
TARGET_KERNEL_VERSION := 6.1

TARGET_KERNEL_DLKM_AUDIO_OVERRIDE := true
TARGET_KERNEL_DLKM_BT_OVERRIDE := true
TARGET_KERNEL_DLKM_CAMERA_OVERRIDE := true
TARGET_KERNEL_DLKM_NFC_OVERRIDE := true
TARGET_KERNEL_DLKM_ESE_OVERRIDE := true
TARGET_KERNEL_DLKM_DATA_OVERRIDE := true
TARGET_KERNEL_DLKM_DISPLAY_OVERRIDE := true
TARGET_KERNEL_DLKM_MM_DRV_OVERRIDE := true
TARGET_KERNEL_DLKM_SECURE_MSM_OVERRIDE := true
TARGET_KERNEL_DLKM_THERMAL_OVERRIDE := true
TARGET_KERNEL_DLKM_TOUCH_OVERRIDE := true
TARGET_KERNEL_DLKM_VIDEO_OVERRIDE := true
TARGET_KERNEL_DLKM_WLAN_OVERRIDE := true
TARGET_KERNEL_DLKM_MMRM_OVERRIDE := true
TARGET_KERNEL_DLKM_DATARMNET_OVERRIDE := true
TARGET_KERNEL_DLKM_DATARMNETEXT_OVERRIDE := true
TARGET_KERNEL_DLKM_SYNX_OVERRIDE := true
TARGET_KERNEL_DLKM_DATAIPA_OVERRIDE := true
TARGET_KERNEL_DLKM_FASTRPC_OVERRIDE := true
TARGET_KERNEL_DLKM_SPU_OVERRIDE := true

ifneq ("$(wildcard device/qcom/$(TARGET_BOARD_PLATFORM)-kernel/vendor_dlkm/system_dlkm.modules.blocklist)", "")
PRODUCT_COPY_FILES += device/qcom/$(TARGET_BOARD_PLATFORM)-kernel/vendor_dlkm/system_dlkm.modules.blocklist:$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules/system_dlkm.modules.blocklist
endif

# Manifests
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest_volcano.xml

# Page size
PRODUCT_MAX_PAGE_SIZE_SUPPORTED := 4096

# Partitions - Dynamic
PRODUCT_BUILD_ODM_IMAGE := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true

PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd

# Partitions - FRP
BOARD_FRP_PARTITION_NAME := frp

# Partitions - Vendor
ENABLE_VENDOR_IMAGE := true

# QRTR
PRODUCT_PACKAGES += \
    qrtr-ns \
    qrtr-lookup \
    libqrtr

# QSPA
PRODUCT_PACKAGES += \
    vendor.qti.qspa-service \
    qspa-testclient \
    qspa_vendor.rc

# QSSI configuration
TARGET_USES_QSSI := true

# RRO configuration
TARGET_USES_RRO := true

# SMCI
TARGET_ENABLE_SMCI_SYSLISTENER := true

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Storage
PRODUCT_CHARACTERISTICS := nosdcard

# Thermal
PRODUCT_PACKAGES_DEBUG += \
    thermal-test-client

# Treble
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

# Virtualization
TARGET_ENABLE_VM_SUPPORT := true
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

ifeq ($(TARGET_ENABLE_VM_SUPPORT),true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/ueventd-odm.rc:$(TARGET_COPY_OUT_ODM)/etc/ueventd.rc
PRODUCT_PACKAGES += vmmgr vmmgr.rc vmmgr.conf
endif

# VSDK
ifneq (,$(wildcard $(QCPATH)/vsdk-tools))
PRODUCT_HOST_PACKAGES += \
    install_vsdk_py2 \
    install_vsdk_py3 \
    vsdk-metadata
endif

# QTI Components
TARGET_COMMON_QTI_COMPONENTS := \
    adreno \
    alarm \
    audio \
    av \
    bt \
    display \
    gps \
    init \
    media \
    nfc \
    overlay \
    perf \
    telephony \
    usb \
    vibrator \
    wfd \
    wlan
