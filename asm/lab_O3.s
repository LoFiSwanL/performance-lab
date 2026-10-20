	.arch armv8-a
	.file	"main.c"
	.text
	.align	2
	.p2align 4,,11
	.type	transform.constprop.0, %function
transform.constprop.0:
.LFB25:
	.cfi_startproc
	adrp	x2, .LC0
	ldr	q3, [x2, #:lo12:.LC0]
	adrp	x2, .LC1
	ldr	q2, [x2, #:lo12:.LC1]
	mov	x2, 0
	.p2align 3,,7
.L2:
	mov	v1.16b, v2.16b
	ldr	q0, [x1, x2]
	mla	v1.4s, v0.4s, v3.4s
	ushr	v0.4s, v0.4s, 7
	eor	v0.16b, v1.16b, v0.16b
	str	q0, [x0, x2]
	add	x2, x2, 16
	cmp	x2, 4194304
	bne	.L2
	ret
	.cfi_endproc
.LFE25:
	.size	transform.constprop.0, .-transform.constprop.0
	.align	2
	.p2align 4,,11
	.global	transform
	.type	transform, %function
transform:
.LFB22:
	.cfi_startproc
	cbz	x2, .L5
	sub	x3, x2, #1
	cmp	x3, 2
	bls	.L10
	adrp	x5, .LC0
	lsr	x4, x2, 2
	mov	x3, 0
	ldr	q3, [x5, #:lo12:.LC0]
	adrp	x5, .LC1
	lsl	x4, x4, 4
	ldr	q2, [x5, #:lo12:.LC1]
	.p2align 3,,7
.L8:
	mov	v1.16b, v2.16b
	ldr	q0, [x1, x3]
	mla	v1.4s, v0.4s, v3.4s
	ushr	v0.4s, v0.4s, 7
	eor	v0.16b, v1.16b, v0.16b
	str	q0, [x0, x3]
	add	x3, x3, 16
	cmp	x4, x3
	bne	.L8
	and	x3, x2, -4
	tst	x2, 3
	beq	.L5
.L7:
	ldr	w6, [x1, x3, lsl 2]
	mov	w4, 26125
	mov	w8, 62303
	movk	w4, 0x19, lsl 16
	movk	w8, 0x3c6e, lsl 16
	add	x7, x3, 1
	lsl	x5, x3, 2
	madd	w9, w6, w4, w8
	eor	w6, w9, w6, lsr 7
	str	w6, [x0, x3, lsl 2]
	cmp	x2, x7
	bls	.L5
	add	x7, x5, 4
	add	x3, x3, 2
	ldr	w6, [x1, x7]
	madd	w9, w6, w4, w8
	eor	w6, w9, w6, lsr 7
	str	w6, [x0, x7]
	cmp	x2, x3
	bls	.L5
	add	x5, x5, 8
	ldr	w1, [x1, x5]
	madd	w4, w1, w4, w8
	eor	w1, w4, w1, lsr 7
	str	w1, [x0, x5]
.L5:
	ret
.L10:
	mov	x3, 0
	b	.L7
	.cfi_endproc
.LFE22:
	.size	transform, .-transform
	.align	2
	.p2align 4,,11
	.global	checksum
	.type	checksum, %function
checksum:
.LFB23:
	.cfi_startproc
	mov	x4, x0
	cbz	x1, .L21
	sub	x0, x1, #1
	cmp	x0, 2
	bls	.L22
	lsr	x3, x1, 2
	mov	x2, x4
	movi	v0.4s, 0
	add	x3, x4, x3, lsl 4
	.p2align 3,,7
.L18:
	ldr	q1, [x2], 16
	uaddw	v0.2d, v0.2d, v1.2s
	uaddw2	v0.2d, v0.2d, v1.4s
	cmp	x2, x3
	bne	.L18
	addp	d0, v0.2d
	and	x2, x1, -4
	fmov	x0, d0
	tst	x1, 3
	beq	.L15
.L17:
	ldr	w5, [x4, x2, lsl 2]
	add	x3, x2, 1
	lsl	x6, x2, 2
	add	x0, x0, x5
	cmp	x1, x3
	bls	.L15
	add	x4, x4, x6
	add	x2, x2, 2
	ldr	w3, [x4, 4]
	add	x0, x0, x3
	cmp	x1, x2
	bls	.L15
	ldr	w1, [x4, 8]
	add	x0, x0, x1
.L15:
	ret
	.p2align 2,,3
.L21:
	mov	x0, 0
	ret
.L22:
	mov	x2, 0
	mov	x0, 0
	b	.L17
	.cfi_endproc
.LFE23:
	.size	checksum, .-checksum
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC2:
	.string	"n=%zu rounds=%u checksum=%llu\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB24:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x21, [sp, 32]
	cmp	w0, 1
	.cfi_offset 21, -16
	ble	.L30
	ldr	x0, [x1, 8]
	mov	w2, 10
	mov	x1, 0
	bl	strtoul
	mov	w21, w0
	cbz	w0, .L36
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -24
	.cfi_offset 19, -32
.L25:
	mov	x0, 4194304
	bl	malloc
	mov	x20, x0
	mov	x0, 4194304
	bl	malloc
	cmp	x20, 0
	mov	x19, x0
	ccmp	x0, 0, 4, ne
	beq	.L37
	adrp	x0, .LC3
	mov	x1, x20
	add	x2, x20, 4194304
	ldr	q0, [x0, #:lo12:.LC3]
	adrp	x0, .LC4
	ldr	q5, [x0, #:lo12:.LC4]
	adrp	x0, .LC5
	ldr	q4, [x0, #:lo12:.LC5]
	.p2align 3,,7
.L28:
	mov	v1.16b, v0.16b
	add	v0.2d, v0.2d, v5.2d
	add	v3.2d, v1.2d, v4.2d
	xtn	v2.2s, v1.2d
	xtn2	v2.4s, v3.2d
	str	q2, [x1], 16
	cmp	x2, x1
	bne	.L28
	mov	w3, 0
	b	.L29
	.p2align 2,,3
.L32:
	mov	x20, x19
	mov	x19, x1
.L29:
	add	w3, w3, 1
	mov	x1, x20
	mov	x0, x19
	bl	transform.constprop.0
	cmp	w21, w3
	bne	.L32
	mov	x1, 1048576
	bl	checksum
	mov	w3, w21
	mov	x4, x0
	adrp	x1, .LC2
	add	x1, x1, :lo12:.LC2
	mov	x2, 1048576
	mov	w0, 1
	bl	__printf_chk
	mov	x0, x19
	bl	free
	mov	x0, x20
	bl	free
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	mov	w0, 0
.L24:
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_def_cfa_offset 0
	ret
.L30:
	.cfi_restore_state
	mov	w21, 2000
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -24
	.cfi_offset 19, -32
	b	.L25
.L36:
	.cfi_restore 19
	.cfi_restore 20
	mov	w0, 2
	b	.L24
.L37:
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x0, x20
	bl	free
	mov	x0, x19
	bl	free
	mov	w0, 1
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	b	.L24
	.cfi_endproc
.LFE24:
	.size	main, .-main
	.section	.rodata.cst16,"aM",@progbits,16
	.align	4
.LC0:
	.word	1664525
	.word	1664525
	.word	1664525
	.word	1664525
	.align	4
.LC1:
	.word	1013904223
	.word	1013904223
	.word	1013904223
	.word	1013904223
	.align	4
.LC3:
	.xword	0
	.xword	1
	.align	4
.LC4:
	.xword	4
	.xword	4
	.align	4
.LC5:
	.xword	2
	.xword	2
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
