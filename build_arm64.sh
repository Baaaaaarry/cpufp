SRC=arm64
ASM=$SRC/asm
COMM=common
BUILD_DIR=build_dir

# Android NDK 配置
ANDROID_NDK_HOME=/path/to/android-ndk  # 修改为实际 NDK 路径
TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64
TARGET=aarch64-linux-android
API_LEVEL=21  # 根据需求选择最低支持的 API 级别
CXX=$TOOLCHAIN/bin/$TARGET$API_LEVEL-clang++
CC=$TOOLCHAIN/bin/$TARGET$API_LEVEL-clang

# make directory
if [ -d "$BUILD_DIR" ]; then
    rm -rf $BUILD_DIR/*
else
    mkdir $BUILD_DIR
fi

# build common tools
$CXX -O3 -c $COMM/table.cpp -o $BUILD_DIR/table.o --sysroot=$TOOLCHAIN/sysroot
$CXX -O3 -pthread -c $COMM/smtl.cpp -o $BUILD_DIR/smtl.o --sysroot=$TOOLCHAIN/sysroot

# 手动指定 SIMD 特性
SIMD_FILES=("_asimd_" "_asimd_dp_" "_asimd_hp_" "_bf16_")
SIMD_MACRO=" "
SIMD_OBJ=" "

for SIMD_FILE in "${SIMD_FILES[@]}"; do
    SIMD=${SIMD_FILE//_}  # 去掉下划线作为宏定义的名称
    SIMD_MACRO="$SIMD_MACRO-D$SIMD "
    SIMD_OBJ="$SIMD_OBJ$BUILD_DIR/$SIMD_FILE.o "
    $CC --target=$TARGET --sysroot=$TOOLCHAIN/sysroot -c $ASM/$SIMD_FILE.s -o $BUILD_DIR/$SIMD_FILE.o
done

# compile cpufp
$CXX -O3 -I$COMM $SIMD_MACRO -c $SRC/cpufp.cpp -o $BUILD_DIR/cpufp.o --sysroot=$TOOLCHAIN/sysroot
$CXX -O3 -z noexecstack -pthread -o cpufp $BUILD_DIR/cpufp.o $BUILD_DIR/smtl.o $BUILD_DIR/table.o $SIMD_OBJ --sysroot=$TOOLCHAIN/sysroot