#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import blob_fixup, blob_fixups_user_type
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import ExtractUtils, ExtractUtilsModule

namespace_imports = [
    "vendor/qcom/common/vendor/adreno/u",
    "vendor/qcom/common/vendor/perf",
    "vendor/qcom/common/vendor/wlan",
]


def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


def lib_fixup_prebuilt_suffix(lib: str, *args, **kwargs):
    return f'{lib}_prebuilt'


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'libgrpc++_unsecure': lib_fixup_prebuilt_suffix,
    (
        'com.qualcomm.qti.dpm.api@1.0',
        'com.qualcomm.qti.imscmservice@*',
        'com.qualcomm.qti.uceservice@*',
        'libmmosal',
        'vendor.qti.data.factory@*',
        'vendor.qti.data.mwqem@1.0',
        'vendor.qti.data.slm@1.0',
        'vendor.qti.diaghal@1.0',
        'vendor.qti.hardware.ListenSoundModel@1.0',
        'vendor.qti.hardware.data.cne.internal.*@*',
        'vendor.qti.hardware.data.connection@*',
        'vendor.qti.hardware.data.connectionfactory-V1-ndk_platform',
        'vendor.qti.hardware.data.dataactivity-V1-ndk_platform',
        'vendor.qti.hardware.data.dynamicdds@*',
        'vendor.qti.hardware.data.flow@1.0',
        'vendor.qti.hardware.data.iwlan@*',
        'vendor.qti.hardware.data.ka-V1-ndk_platform',
        'vendor.qti.hardware.data.latency@1.0',
        'vendor.qti.hardware.data.lce@1.0',
        'vendor.qti.hardware.data.qmi@1.0',
        'vendor.qti.hardware.dpmservice@*',
        'vendor.qti.hardware.embmssl@*',
        'vendor.qti.hardware.limits@*',
        'vendor.qti.hardware.mwqemadapter@1.0',
        'vendor.qti.hardware.qccsyshal@*',
        'vendor.qti.hardware.qccvndhal@1.0',
        'vendor.qti.hardware.radio.am@1.0',
        'vendor.qti.hardware.radio.atcmdfwd@1.0',
        'vendor.qti.hardware.radio.ims-V12-ndk_platform',
        'vendor.qti.hardware.radio.ims@*',
        'vendor.qti.hardware.radio.internal.deviceinfo@1.0',
        'vendor.qti.hardware.radio.lpa@*',
        'vendor.qti.hardware.radio.qcrilhook@1.0',
        'vendor.qti.hardware.radio.qtiradio-V8-ndk_platform',
        'vendor.qti.hardware.radio.qtiradio@*',
        'vendor.qti.hardware.radio.qtiradioconfig-V2-ndk_platform',
        'vendor.qti.hardware.radio.uim@*',
        'vendor.qti.hardware.radio.uim_remote_client@*',
        'vendor.qti.hardware.radio.uim_remote_server@1.0',
        'vendor.qti.hardware.slmadapter@1.0',
        'vendor.qti.hardware.wifidisplaysession@1.0',
        'vendor.qti.ims.callcapability@1.0',
        'vendor.qti.ims.callinfo@1.0',
        'vendor.qti.ims.configservice@*',
        'vendor.qti.ims.connection@1.0',
        'vendor.qti.ims.factory@*',
        'vendor.qti.ims.rcsconfig@*',
        'vendor.qti.ims.rcssip@*',
        'vendor.qti.ims.rcsuce@*',
        'vendor.qti.imsrtpservice@3.0',
        'vendor.qti.latency@*',
    ): lib_fixup_vendor_suffix,
    (
        'libwpa_client',
    ): lib_fixup_remove,
}

blob_fixups: blob_fixups_user_type = {
    'vendor/etc/init/vendor.noth.hardware.camera-service.rc':
        blob_fixup().regex_replace(r'\bNtCamAlgoCapacity\b', 'CameraServiceCapacity'),
    'vendor/etc/media_codecs.xml': blob_fixup()
        .regex_replace('.*media_codecs_(google_audio|google_c2|google_telephony|vendor_audio).*\n', ''),
    (
        'vendor/lib64/libntofflinepostproc.so',
        'vendor/lib64/vendor.qti.hardware.camera.postproc@1.0-service-impl.so',
    ): blob_fixup().replace_needed(
        'vendor.qti.hardware.camera.postproc@1.0.so',
        'vendor.qti.hardware.camera.postproc@1.0-nothing.so',
    ),
}  # fmt: skip

module = ExtractUtilsModule(
    'asteroids',
    'nothing',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
