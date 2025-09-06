!host_build {
    QMAKE_CFLAGS    += --sysroot=$$[QT_SYSROOT]
    QMAKE_CXXFLAGS  += --sysroot=$$[QT_SYSROOT]
    QMAKE_LFLAGS    += --sysroot=$$[QT_SYSROOT]
}
host_build {
    QT_ARCH = x86_64
    QT_BUILDABI = x86_64-little_endian-lp64
    QT_TARGET_ARCH = arm64
    QT_TARGET_BUILDABI = arm64-little_endian-lp64
} else {
    QT_ARCH = arm64
    QT_BUILDABI = arm64-little_endian-lp64
    QT_LIBCPP_ABI_TAG = 
}
QT.global.enabled_features = shared cross_compile pkg-config rpath c++11 c++14 c++17 c++1z c99 c11 signaling_nan thread future concurrent opensslv30 shared cross_compile shared rpath c++11 c++14 c++17 c++1z reduce_exports openssl
QT.global.disabled_features = static debug_and_release separate_debug_info appstore-compliant simulator_and_device force_asserts framework c++20 c++2a c++2b c++2b reduce_relocations wasm-simd128 wasm-exceptions zstd dbus openssl-linked opensslv11
QT.global.disabled_features += release build_all
QT_CONFIG += shared rpath c++11 c++14 c++17 c++1z reduce_exports openssl release
CONFIG += release  shared cross_compile plugin_manifest
QT_VERSION = 6.5.2
QT_MAJOR_VERSION = 6
QT_MINOR_VERSION = 5
QT_PATCH_VERSION = 2

QT_GCC_MAJOR_VERSION = 12
QT_GCC_MINOR_VERSION = 4
QT_GCC_PATCH_VERSION = 0
QT_EDITION = Open Source
