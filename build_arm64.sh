SRC=arm64
ASM=$SRC/asm
COMM=common
BUILD_DIR=build_dir

# Android NDK 配置
ANDROID_NDK_HOME=./android-ndk-r25c
TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64
TARGET=aarch64-linux-android
API_LEVEL=30
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
SIMD_FILES=("_I8MM_" "_ASIMD_" "_ASIMD_DP_" "_ASIMD_HP_" "_BF16_")
SIMD_MACRO=" "
SIMD_OBJ=" "

for SIMD_FILE in "${SIMD_FILES[@]}"; do
    SIMD_MACRO="$SIMD_MACRO-D$SIMD_FILE "
    SIMD_OBJ="$SIMD_OBJ$BUILD_DIR/$SIMD_FILE.o "
    $CC --target=$TARGET --sysroot=$TOOLCHAIN/sysroot \
     -march=armv8.2-a+dotprod+fp16+bf16+i8mm -c $ASM/$SIMD_FILE.S -o $BUILD_DIR/$SIMD_FILE.o
done

# compile cpufp
$CXX -O3 -I$COMM $SIMD_MACRO -c $SRC/cpufp.cpp -o $BUILD_DIR/cpufp.o --sysroot=$TOOLCHAIN/sysroot
$CXX -O3 -z noexecstack -pthread -o cpufp $BUILD_DIR/cpufp.o $BUILD_DIR/smtl.o $BUILD_DIR/table.o $SIMD_OBJ --sysroot=$TOOLCHAIN/sysroot