#!/usr/bin/env bash
set -euo pipefail
 
SRC=arm64
ASM=$SRC/asm
COMM=common
BUILD_DIR=build_arm64_linux_gnu_gcc9
 
CROSS=aarch64-linux-gnu
CC=${CC:-${CROSS}-gcc}
CXX=${CXX:-${CROSS}-g++}
 
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
 
# ========== GCC 9.4 推荐默认：不要用 +i8mm/+bf16 ==========
# 这个组合在 gcc 9.4 上最稳：NEON + FP16 + DOTPROD
# (如果你的 .S 里有 smmla/bfmmla，会在汇编阶段失败，那就只能升级工具链或切 clang)
ARCH_FLAGS_DEFAULT="-march=armv8.2-a+simd+fp16+dotprod"
 
# 你可以显式开启（但 gcc9.4 多半不认 i8mm/bf16 修饰符）：
# ARCH_FLAGS_I8MM="-march=armv8.6-a+simd+fp16+dotprod+i8mm+bf16"
ARCH_FLAGS="${ARCH_FLAGS:-${ARCH_FLAGS_DEFAULT}}"
 
CFLAGS="-O3 -Wall -Wextra -ffunction-sections -fdata-sections -D_GNU_SOURCE ${ARCH_FLAGS}"
CXXFLAGS="-O3 -Wall -Wextra -ffunction-sections -fdata-sections -D_GNU_SOURCE ${ARCH_FLAGS} -std=c++17"
INCLUDES="-I${COMM} -Iinclude"
 
# 静态链接（如果缺 aarch64 静态 libc/libstdc++，会失败）
LDFLAGS="${LDFLAGS:--static -Wl,--gc-sections -pthread}"
LIBS="-lm -ldl"
 
# 宏定义（对应 #ifdef _I8MM_ 之类）
SIMD_FILES=("_ASIMD_" "_ASIMD_DP_" "_ASIMD_HP_")
SIMD_MACRO=""
SIMD_OBJ=""
 
echo "[*] CC : ${CC}"
echo "[*] CXX: ${CXX}"
echo "[*] ARCH_FLAGS: ${ARCH_FLAGS}"
echo "[*] LDFLAGS: ${LDFLAGS}"
echo
 
echo "[*] build common"
${CXX} ${CXXFLAGS} ${INCLUDES} -c ${COMM}/table.cpp -o ${BUILD_DIR}/table.o
${CXX} ${CXXFLAGS} ${INCLUDES} -pthread -c ${COMM}/smtl.cpp -o ${BUILD_DIR}/smtl.o
 
echo "[*] build asm"
for SIMD_FILE in "${SIMD_FILES[@]}"; do
	  SIMD_MACRO+=" -D${SIMD_FILE}"
	    SIMD_OBJ+=" ${BUILD_DIR}/${SIMD_FILE}.o"
	      echo "    [ASM] ${ASM}/${SIMD_FILE}.S"
	        ${CC} ${CFLAGS} ${SIMD_MACRO} -D${SIMD_FILE} -c ${ASM}/${SIMD_FILE}.S -o ${BUILD_DIR}/${SIMD_FILE}.o
	done
	 
	echo "[*] build cpufp.cpp"
	${CXX} ${CXXFLAGS} ${INCLUDES} ${SIMD_MACRO} -c ${SRC}/cpufp.cpp -o ${BUILD_DIR}/cpufp.o
	 
	echo "[*] link -> cpufp"
	set -x
	${CXX} ${LDFLAGS} -o cpufp \
		  ${BUILD_DIR}/cpufp.o \
		    ${BUILD_DIR}/smtl.o \
		      ${BUILD_DIR}/table.o \
		        ${SIMD_OBJ} \
			  ${LIBS}
	set +x
	 
	echo
	echo "[+] done: ./cpufp"
	file ./cpufp || true
