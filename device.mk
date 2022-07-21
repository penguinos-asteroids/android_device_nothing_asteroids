DEVICE_PATH := device/nothing/asteroids
# device/qcom/iot/volcano/target.mk will only be present for iot target.
# It will not affect non-IOT target where it would be absent.
-include $(TOPDIR)device/qcom/iot/volcano/target.mk

TARGET_BOARD_PLATFORM := volcano
TARGET_BOOTLOADER_BOARD_NAME := volcano

BUILD_BROKEN_DUP_RULES := true

#Flag to Enable 64 bit only configuration
TARGET_SUPPORTS_64_BIT_ONLY := true

# Default Android A/B configuration
# Enable virtual A/B
ENABLE_VIRTUAL_AB := true
# Enable virtual A/B compression
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4
PRODUCT_VENDOR_PROPERTIES += ro.virtual_ab.compression.threads=true

# Enable debugfs restrictions
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

#Enable vm support
TARGET_ENABLE_VM_SUPPORT := true

#Enable SMCI-Listeners.
TARGET_ENABLE_SMCI_SYSLISTENER := true

$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Set GRF/Vendor freeze properties
BOARD_SHIPPING_API_LEVEL := 34
BOARD_API_LEVEL := 34

# Opt out of 16K alignment changes
PRODUCT_MAX_PAGE_SIZE_SUPPORTED := 4096

# Enable AVB 2.0
BOARD_AVB_ENABLE := true

# Disable verified boot checks in abl if AVB is not enabled
BOARD_ABL_SIMPLE := false

NEED_AIDL_NDK_PLATFORM_BACKEND := true

#Suppot to compile recovery without msm headers
TARGET_HAS_GENERIC_KERNEL_HEADERS := true

CLEAN_UP_JAVA_IN_VENDOR ?= enforcing

JAVA_IN_VENDOR_SOONG_WHITE_LIST :=\
CuttlefishService\
pasrservice\
VendorPrivAppPermissionTest\

JAVA_IN_VENDOR_MAKE_WHITE_LIST :=\
AEye\
AON\
SnapdragonCamera\

SHIPPING_API_LEVEL := 34
PRODUCT_SHIPPING_API_LEVEL := 34

# Set kernel version and ion flags
TARGET_KERNEL_VERSION := 5.15
TARGET_USES_NEW_ION := true

# Disable DLKM generation until build support is available
TARGET_KERNEL_DLKM_DISABLE := false

# Tech specific flags
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

#####Dynamic partition Handling
###
#### Turning this flag to TRUE will enable dynamic partition/super image creation.
PRODUCT_BUILD_ODM_IMAGE := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_PACKAGES += fastbootd
# Add default implementation of fastboot AIDL.
PRODUCT_PACKAGES += android.hardware.fastboot-service.example_recovery

PRODUCT_COPY_FILES += $(DEVICE_PATH)/init/fstab.default:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.default
PRODUCT_COPY_FILES += $(DEVICE_PATH)/init/fstab.emmc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc

ifneq ("$(wildcard device/qcom/$(TARGET_BOARD_PLATFORM)-kernel/vendor_dlkm/system_dlkm.modules.blocklist)", "")
PRODUCT_COPY_FILES += device/qcom/$(TARGET_BOARD_PLATFORM)-kernel/vendor_dlkm/system_dlkm.modules.blocklist:$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules/system_dlkm.modules.blocklist
endif

BOARD_HAVE_QCOM_FM := false

# Init
PRODUCT_PACKAGES += \
    fstab.default \
    fstab.emmc \
    init.target.rc


$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# RRO configuration
TARGET_USES_RRO := true

TARGET_USES_QSSI := true

#Default vendor image configuration
ENABLE_VENDOR_IMAGE := true

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

BOARD_FRP_PARTITION_NAME := frp

PRODUCT_PACKAGES += fs_config_files
PRODUCT_PACKAGES += gpio-keys.kl

# A/B related packages
PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

PRODUCT_PACKAGES += \
  update_engine_sideload

ifneq (,$(wildcard $(QCPATH)/vsdk-tools))
PRODUCT_HOST_PACKAGES += \
    install_vsdk_py2
PRODUCT_HOST_PACKAGES += \
    install_vsdk_py3
PRODUCT_HOST_PACKAGES += \
    vsdk-metadata
endif

# QRTR related packages
PRODUCT_PACKAGES += qrtr-ns
PRODUCT_PACKAGES += qrtr-lookup
PRODUCT_PACKAGES += libqrtr

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

# Macro allows Camera module to use new service
QTI_CAMERA_PROVIDER_SERVICE := 2.7
QTI_CAMERA_AON_SERVICE := 1.2

# Enable compilation of image_generation_tool
TARGET_USES_IMAGE_GEN_TOOL := true

DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest_volcano.xml
DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml

# Enable Camera techpack with VSDK
ifneq (,$(wildcard $(QCPATH)/chi-cdk))
include $(QCPATH)/chi-cdk/configs/camera_techpack.mk
else ifneq (,$(wildcard $(QCPATH)/camx/chi-cdk))
include $(QCPATH)/camx/chi-cdk/configs/camera_techpack.mk
endif

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules

USE_LIB_PROCESS_GROUP := true

# Dumpstate Feature Flag
PRODUCT_ENABLE_DUMPSTATE_SUPPORT := true

#Enable full treble flag
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true
BOARD_SYSTEMSDK_VERSIONS := 34

ifeq (true,$(BUILDING_WITH_VSDK))
    ALLOW_MISSING_DEPENDENCIES := true
    TARGET_SKIP_CURRENT_VNDK := true
    -include vendor/qcom/vsdk_snapshots_config/config.mk
else
    BOARD_VNDK_VERSION := current
    RECOVERY_SNAPSHOT_VERSION := current
    RAMDISK_SNAPSHOT_VERSION := current
endif

$(warning "BOARD_VNDK_VERSION = $(BOARD_VNDK_VERSION), RECOVERY_SNAPSHOT_VERSION=$(RECOVERY_SNAPSHOT_VERSION), RAMDISK_SNAPSHOT_VERSION=$(RAMDISK_SNAPSHOT_VERSION)")

TARGET_MOUNT_POINTS_SYMLINKS := false

# Fingerprint feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \

PRODUCT_ENABLE_QESDK := true

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

# ODM ueventd.rc
# - only for use with VM support right now
ifeq ($(TARGET_ENABLE_VM_SUPPORT),true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/ueventd-odm.rc:$(TARGET_COPY_OUT_ODM)/etc/ueventd.rc
PRODUCT_PACKAGES += vmmgr vmmgr.rc vmmgr.conf
endif

#qspa service
PRODUCT_PACKAGES += vendor.qti.qspa-service qspa-testclient

PRODUCT_PACKAGES += qspa_vendor.rc

##Armv9-Tests##
PRODUCT_PACKAGES_DEBUG += bti_test_prebuilt \
                          pac_test \
                          mte_tests \
                          dynamic_memcpy_prebuilt
##Armv9-Tests##

PRODUCT_PACKAGES_DEBUG += thermal-test-client

# Enable support for APEX updates
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

#enable virtualization service
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)
