.align 4

#ifdef __APPLE__
.globl _int_add
_int_add:
#else
.globl int_add
int_add:
#endif
    mov x1, #1
    mov x2, #2
.int.add.L1:
    add x1, x1, x2
    add x1, x1, x2
    add x1, x1, x2
    add x1, x1, x2
    add x1, x1, x2
    add x1, x1, x2
    add x1, x1, x2
    add x1, x1, x2
    subs x0, x0, #1
    bne .int.add.L1
    ret

#ifdef __APPLE__
.globl _int_sub
_int_sub:
#else
.globl int_sub
int_sub:
#endif
    mov x1, #1000
    mov x2, #3
.int.sub.L1:
    sub x1, x1, x2
    sub x1, x1, x2
    sub x1, x1, x2
    sub x1, x1, x2
    sub x1, x1, x2
    sub x1, x1, x2
    sub x1, x1, x2
    sub x1, x1, x2
    subs x0, x0, #1
    bne .int.sub.L1
    ret

#ifdef __APPLE__
.globl _int_and
_int_and:
#else
.globl int_and
int_and:
#endif
    mov x1, #0xFF00FF00
    mov x2, #0x0F0F0F0F
.int.and.L1:
    and x1, x1, x2
    and x1, x1, x2
    and x1, x1, x2
    and x1, x1, x2
    and x1, x1, x2
    and x1, x1, x2
    and x1, x1, x2
    and x1, x1, x2
    subs x0, x0, #1
    bne .int.and.L1
    ret

#ifdef __APPLE__
.globl _int_orr
_int_orr:
#else
.globl int_orr
int_orr:
#endif
    mov x1, #0x00FF00FF
    mov x2, #0x0F0F0F0F
.int.orr.L1:
    orr x1, x1, x2
    orr x1, x1, x2
    orr x1, x1, x2
    orr x1, x1, x2
    orr x1, x1, x2
    orr x1, x1, x2
    orr x1, x1, x2
    orr x1, x1, x2
    subs x0, x0, #1
    bne .int.orr.L1
    ret

#ifdef __APPLE__
.globl _int_eor
_int_eor:
#else
.globl int_eor
int_eor:
#endif
    mov x1, #0x12345678
    mov x2, #0x0F0F0F0F
.int.eor.L1:
    eor x1, x1, x2
    eor x1, x1, x2
    eor x1, x1, x2
    eor x1, x1, x2
    eor x1, x1, x2
    eor x1, x1, x2
    eor x1, x1, x2
    eor x1, x1, x2
    subs x0, x0, #1
    bne .int.eor.L1
    ret

#ifdef __APPLE__
.globl _int_lsl
_int_lsl:
#else
.globl int_lsl
int_lsl:
#endif
    mov x1, #1
.int.lsl.L1:
    lsl x1, x1, #1
    lsl x1, x1, #1
    lsl x1, x1, #1
    lsl x1, x1, #1
    lsl x1, x1, #1
    lsl x1, x1, #1
    lsl x1, x1, #1
    lsl x1, x1, #1
    subs x0, x0, #1
    bne .int.lsl.L1
    ret

#ifdef __APPLE__
.globl _int_lsr
_int_lsr:
#else
.globl int_lsr
int_lsr:
#endif
    mov x1, #0x8000000000000000
.int.lsr.L1:
    lsr x1, x1, #1
    lsr x1, x1, #1
    lsr x1, x1, #1
    lsr x1, x1, #1
    lsr x1, x1, #1
    lsr x1, x1, #1
    lsr x1, x1, #1
    lsr x1, x1, #1
    subs x0, x0, #1
    bne .int.lsr.L1
    ret

#ifdef __APPLE__
.globl _int_asr
_int_asr:
#else
.globl int_asr
int_asr:
#endif
    mov x1, #-1
.int.asr.L1:
    asr x1, x1, #1
    asr x1, x1, #1
    asr x1, x1, #1
    asr x1, x1, #1
    asr x1, x1, #1
    asr x1, x1, #1
    asr x1, x1, #1
    asr x1, x1, #1
    subs x0, x0, #1
    bne .int.asr.L1
    ret

#ifdef __APPLE__
.globl _int_mul
_int_mul:
#else
.globl int_mul
int_mul:
#endif
    mov x1, #3
    mov x2, #5
.int.mul.L1:
    mul x1, x1, x2
    mul x1, x1, x2
    mul x1, x1, x2
    mul x1, x1, x2
    mul x1, x1, x2
    mul x1, x1, x2
    mul x1, x1, x2
    mul x1, x1, x2
    subs x0, x0, #1
    bne .int.mul.L1
    ret

#ifdef __APPLE__
.globl _int_madd
_int_madd:
#else
.globl int_madd
int_madd:
#endif
    mov x1, #3
    mov x2, #5
    mov x3, #7
.int.madd.L1:
    madd x1, x1, x2, x3
    madd x1, x1, x2, x3
    madd x1, x1, x2, x3
    madd x1, x1, x2, x3
    madd x1, x1, x2, x3
    madd x1, x1, x2, x3
    madd x1, x1, x2, x3
    madd x1, x1, x2, x3
    subs x0, x0, #1
    bne .int.madd.L1
    ret

#ifdef __APPLE__
.globl _int_msub
_int_msub:
#else
.globl int_msub
int_msub:
#endif
    mov x1, #3
    mov x2, #5
    mov x3, #7
.int.msub.L1:
    msub x1, x1, x2, x3
    msub x1, x1, x2, x3
    msub x1, x1, x2, x3
    msub x1, x1, x2, x3
    msub x1, x1, x2, x3
    msub x1, x1, x2, x3
    msub x1, x1, x2, x3
    msub x1, x1, x2, x3
    subs x0, x0, #1
    bne .int.msub.L1
    ret

#ifdef __APPLE__
.globl _int_sdiv
_int_sdiv:
#else
.globl int_sdiv
int_sdiv:
#endif
    mov x1, #1234567
    mov x2, #3
.int.sdiv.L1:
    sdiv x3, x1, x2
    sdiv x3, x1, x2
    sdiv x3, x1, x2
    sdiv x3, x1, x2
    subs x0, x0, #1
    bne .int.sdiv.L1
    ret

#ifdef __APPLE__
.globl _int_udiv
_int_udiv:
#else
.globl int_udiv
int_udiv:
#endif
    mov x1, #1234567
    mov x2, #3
.int.udiv.L1:
    udiv x3, x1, x2
    udiv x3, x1, x2
    udiv x3, x1, x2
    udiv x3, x1, x2
    subs x0, x0, #1
    bne .int.udiv.L1
    ret

