	.arch armv8-a
	.file	"main.c"
	.text
	.align	2
	.global	transform
	.type	transform, %function
transform:
.LFB0:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	str	xzr, [sp, 40]
	b	.L2
.L3:
	ldr	x0, [sp, 40]
	lsl	x0, x0, 2
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	ldr	w1, [x0]
	mov	w0, 26125
	movk	w0, 0x19, lsl 16
	mul	w1, w1, w0
	mov	w0, 62303
	movk	w0, 0x3c6e, lsl 16
	add	w2, w1, w0
	ldr	x0, [sp, 40]
	lsl	x0, x0, 2
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	ldr	w0, [x0]
	lsr	w1, w0, 7
	ldr	x0, [sp, 40]
	lsl	x0, x0, 2
	ldr	x3, [sp, 24]
	add	x0, x3, x0
	eor	w1, w2, w1
	str	w1, [x0]
	ldr	x0, [sp, 40]
	add	x0, x0, 1
	str	x0, [sp, 40]
.L2:
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 8]
	cmp	x1, x0
	bcc	.L3
	nop
	nop
	add	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	transform, .-transform
	.align	2
	.global	checksum
	.type	checksum, %function
checksum:
.LFB1:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, 8]
	str	x1, [sp]
	str	xzr, [sp, 16]
	str	xzr, [sp, 24]
	b	.L5
.L6:
	ldr	x0, [sp, 24]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	uxtw	x0, w0
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	str	x0, [sp, 16]
	ldr	x0, [sp, 24]
	add	x0, x0, 1
	str	x0, [sp, 24]
.L5:
	ldr	x1, [sp, 24]
	ldr	x0, [sp]
	cmp	x1, x0
	bcc	.L6
	ldr	x0, [sp, 16]
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	checksum, .-checksum
	.section	.rodata
	.align	3
.LC0:
	.string	"n=%zu rounds=%u checksum=%llu\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB2:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	str	w0, [sp, 28]
	str	x1, [sp, 16]
	mov	x0, 1048576
	str	x0, [sp, 64]
	ldr	w0, [sp, 28]
	cmp	w0, 1
	ble	.L9
	ldr	x0, [sp, 16]
	add	x0, x0, 8
	ldr	x0, [x0]
	mov	w2, 10
	mov	x1, 0
	bl	strtoul
	b	.L10
.L9:
	mov	w0, 2000
.L10:
	str	w0, [sp, 36]
	ldr	w0, [sp, 36]
	cmp	w0, 0
	bne	.L11
	mov	w0, 2
	b	.L12
.L11:
	ldr	x0, [sp, 64]
	lsl	x0, x0, 2
	bl	malloc
	str	x0, [sp, 40]
	ldr	x0, [sp, 64]
	lsl	x0, x0, 2
	bl	malloc
	str	x0, [sp, 48]
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L13
	ldr	x0, [sp, 48]
	cmp	x0, 0
	bne	.L14
.L13:
	ldr	x0, [sp, 40]
	bl	free
	ldr	x0, [sp, 48]
	bl	free
	mov	w0, 1
	b	.L12
.L14:
	str	xzr, [sp, 56]
	b	.L15
.L16:
	ldr	x0, [sp, 56]
	lsl	x0, x0, 2
	ldr	x1, [sp, 40]
	add	x0, x1, x0
	ldr	x1, [sp, 56]
	str	w1, [x0]
	ldr	x0, [sp, 56]
	add	x0, x0, 1
	str	x0, [sp, 56]
.L15:
	ldr	x1, [sp, 56]
	ldr	x0, [sp, 64]
	cmp	x1, x0
	bcc	.L16
	str	wzr, [sp, 32]
	b	.L17
.L18:
	ldr	x2, [sp, 64]
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 48]
	bl	transform
	ldr	x0, [sp, 40]
	str	x0, [sp, 72]
	ldr	x0, [sp, 48]
	str	x0, [sp, 40]
	ldr	x0, [sp, 72]
	str	x0, [sp, 48]
	ldr	w0, [sp, 32]
	add	w0, w0, 1
	str	w0, [sp, 32]
.L17:
	ldr	w1, [sp, 32]
	ldr	w0, [sp, 36]
	cmp	w1, w0
	bcc	.L18
	ldr	x1, [sp, 64]
	ldr	x0, [sp, 40]
	bl	checksum
	mov	x3, x0
	ldr	w2, [sp, 36]
	ldr	x1, [sp, 64]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldr	x0, [sp, 40]
	bl	free
	ldr	x0, [sp, 48]
	bl	free
	mov	w0, 0
.L12:
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
