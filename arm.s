.section .data
@INPUT
@d1: .word  0x92345678, 0x92381234
@d1 : .word  0x12345678, 0x12381234
@d1 :  .word      0x000ed000, 0x7ff68000
@d1: .word  0x12345678, 0x92381234
d1: .word 0x8000d000, 0x7ff68000
d2: .word 0x7fffffff, 0x8007ffff, 0xfff80000, 0x00080000
d3: .word 0xffffffff

.section .text
.global _start

nfpadd:
stmfd sp!, {r0-r4,lr}
ldr r0, =d3
ldr r1, [r0]
eor r8, r8, r1
add r8, r8, #1
ldmfd sp! , {r0-r4,pc}

nfpadd5:

stmfd sp!, {r0-r4,lr}
ldr r0, =d3
ldr r1, [r0]
eor r9, r9, r1
add r9, r9, #1
ldmfd sp! , {r0-r4,pc}

nfpadd1:
lsr r8,r8, #1 
add r10, r10, #1
mov pc, lr

nfpadd2:
stmfd sp!, {r0-r6,lr}
sub r7, r6,r5
add r5, r5, r7
ldr r0, =d1
ldr r1, [r0]
ldr r9,[r0,#4]!
ldr r3,=d2
ldr r4,[r3,#8]!
bic r1,r1,r4
bic r9,r9,r4
ldr r10, =d2
ldr r6, [r10,#12]!
add r1, r1, r6
add r9,r9, r6
lsr r1,r1,r7
mov r8,r1
mov r10, r5
ldmfd sp! , {r0-r6,pc}

nfpadd3:
stmfd sp!, {r0-r6,lr}
add r6, r6, r7
ldr r0, =d1
ldr r1, [r0,#4]
ldr r8,[r0]
ldr r3,=d2
ldr r4,[r3,#8]!
bic r1,r1,r4
bic r8,r8,r4
ldr r5, =d2
ldr r10, [r5,#12]!
add r1, r1, r10

add r8,r8,r10

lsr r1,r1,r7
mov r10, r6
mov r9,r1
ldmfd sp! , {r0-r6,pc}


nfpadd4:

stmfd sp!, {r0-r6,lr}
l1:
lsl r8,r8,#1
sub r10, r10, #1
lsr r0, r8, #19
cmp r0, #0
beq l1
ldmfd sp! , {r0-r6,pc}


nfpmultiply1:
stmfd sp!, {r0-r4,lr}
lsr r5, r5, #12
ldr r0, =d2
ldr r1, [r0,#12]!
sub r5, r5,r1
add r10, r10, #1
ldmfd sp! , {r0-r4,pc}


nfpmultiply2:
stmfd sp!, {r0-r4,lr}
lsr r5, r5, #11
ldr r0, =d2
ldr r1, [r0,#12]!
sub r5, r5,r1
ldmfd sp! , {r0-r4,pc}

_start:
ldr r0, =d1
ldr r1, [r0]
ldr r2,[r0,#4]!
ldr r3,=d2


@ADD_EXPONENT


ldr r4, [r3,#4]!
bic r5, r1,r4
bic r6,r2,r4
lsl r5, r5,#1
lsl r6,r6,#1
asr r5,r5,#20
asr r6,r6,#20
sub r7,r5,r6
cmp r5,r6
mov lr, pc                 @@ conditional function.... !!
bmi nfpadd2
mov lr,pc
bpl nfpadd3


@ADD_MANTISA


lsr r6, r1, #31
cmp r6, #0
mov  lr,pc
bne nfpadd
lsr r6, r2, #31
cmp r6, #0
mov  lr,pc
bne nfpadd5
add r8,r8, r9
lsr r7, r8, #31
cmp r7, #0
mov  lr,pc
bne nfpadd
lsr r6 , r8, #20
cmp r6, #0
mov lr,pc
bne nfpadd1

lsr r6, r8, #19
cmp r6, #0
mov lr,pc
beq nfpadd4
ldr r4, =d2
ldr r5, [r4,#12]!
sub r8, r8,r5

lsl r7, r7, #31
lsl r10, r10, #20
lsr r10,r10,#1
add r7,r7, r10
add r8, r8, r7
ldr r0, =d1
str r8, [r0,#8]!

@MULTIPLY

ldr r0, =d1
ldr r1, [r0]
ldr r2, [r0, #4]!
ldr r3, =d2


@MULTIPLY_EXPONENT

ldr r4, [r3,#4]!
bic r5, r1,r4
bic r6,r2,r4
lsr r5,r5,#19
lsr r6,r6,#19
add r10, r5, r6
lsr r5, r1, #31
lsr r6, r2, #31
eor r7, r5, r6

@MULTIPLY_MANTISSA

ldr r4,[r3, #4]!
bic r5, r1, r
bic r6,r2,r4
ldr r4, [r3, #4]!
add r5,r5,r4
add r6,r6,r4
lsr r5, r5, #4
lsr r6,r6,#
mul r5,r5,r6
lsr  r6, r5, #31
cmp r6, #1
mov lr,pc
bpl nfpmultiply1
mov lr,pc
bmi nfpmultiply2

lsl r10, #19
lsl r7, #31
add r7, r10, r7
add r5, r5, r7
ldr r0, =d1
str r5, [r0,#12]!
