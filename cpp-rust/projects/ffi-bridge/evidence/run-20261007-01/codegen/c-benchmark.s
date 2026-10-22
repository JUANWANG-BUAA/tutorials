	.build_version macos, 27, 0	sdk_version 27, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #208
	stp	d9, d8, [sp, #96]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #112]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #128]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #144]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #160]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #176]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #192]            ; 16-byte Folded Spill
	add	x29, sp, #192
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_offset b8, -104
	.cfi_offset b9, -112
Lloh0:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh1:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh2:
	ldr	x8, [x8]
	str	x8, [sp, #88]
	cmp	w0, #1
	b.eq	LBB0_4
; %bb.1:
	cmp	w0, #3
	b.ne	LBB0_3
; %bb.2:
	mov	x19, x1
	ldr	x0, [x1, #8]
Lloh3:
	adrp	x1, l_.str@PAGE
Lloh4:
	add	x1, x1, l_.str@PAGEOFF
	bl	_strcmp
	cbz	w0, LBB0_68
LBB0_3:
	mov	w0, #2                          ; =0x2
	b	LBB0_66
LBB0_4:
	movi.2d	v8, #0000000000000000
LBB0_5:
	mov	x8, #51                         ; =0x33
	movk	x8, #1, lsl #32
Lloh5:
	adrp	x9, _input@PAGE+16
Lloh6:
	add	x9, x9, _input@PAGEOFF+16
	mov	w10, #8192                      ; =0x2000
LBB0_6:                                 ; =>This Inner Loop Header: Depth=1
	sub	x11, x8, #51
	sub	x12, x8, #34
	sub	x13, x8, #17
	stp	x11, x12, [x9, #-16]
	stp	x13, x8, [x9], #32
	add	x8, x8, #68
	subs	x10, x10, #4
	b.ne	LBB0_6
; %bb.7:
	mov	x19, #0                         ; =0x0
	mov	x8, #31765                      ; =0x7c15
	movk	x8, #32586, lsl #16
	movk	x8, #31161, lsl #32
	movk	x8, #40503, lsl #48
	mov	x9, #2259                       ; =0x8d3
	movk	x9, #34211, lsl #16
	movk	x9, #27272, lsl #32
	movk	x9, #9279, lsl #48
Lloh7:
	adrp	x11, _input@PAGE+8
Lloh8:
	add	x11, x11, _input@PAGEOFF+8
LBB0_8:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_9 Depth 2
	mov	x12, #0                         ; =0x0
	mov	w13, #8192                      ; =0x2000
	mov	x14, x11
LBB0_9:                                 ;   Parent Loop BB0_8 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	x15, x16, [x14, #-8]
	eor	x15, x15, x15, lsr #29
	eor	x16, x16, x16, lsr #29
	add	x17, x19, x9
	add	x12, x12, x9
	madd	x19, x15, x8, x17
	madd	x12, x16, x8, x12
	add	x14, x14, #16
	subs	x13, x13, #2
	b.ne	LBB0_9
; %bb.10:                               ;   in Loop: Header=BB0_8 Depth=1
	add	x19, x12, x19
	add	w10, w10, #1
	cmp	w10, #64
	b.ne	LBB0_8
; %bb.11:
	mov	x10, #0                         ; =0x0
	mov	w11, #0                         ; =0x0
	str	x19, [sp, #56]
Lloh9:
	adrp	x12, _input@PAGE+8
Lloh10:
	add	x12, x12, _input@PAGEOFF+8
LBB0_12:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_13 Depth 2
	mov	x13, #0                         ; =0x0
	mov	w14, #8192                      ; =0x2000
	mov	x15, x12
LBB0_13:                                ;   Parent Loop BB0_12 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	x16, x17, [x15, #-8]
	eor	x16, x16, x16, lsr #29
	eor	x17, x17, x17, lsr #29
	add	x10, x10, x9
	add	x13, x13, x9
	madd	x10, x16, x8, x10
	madd	x13, x17, x8, x13
	add	x15, x15, #16
	subs	x14, x14, #2
	b.ne	LBB0_13
; %bb.14:                               ;   in Loop: Header=BB0_12 Depth=1
	add	x10, x13, x10
	add	w11, w11, #1
	cmp	w11, #64
	b.ne	LBB0_12
; %bb.15:
	mov	x11, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	str	x10, [sp, #64]
LBB0_16:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_17 Depth 2
	mov	x12, #0                         ; =0x0
	mov	x13, #0                         ; =0x0
LBB0_17:                                ;   Parent Loop BB0_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x14, x11, x12
	add	x15, x14, #97
	add	x14, x14, #98
	eor	x15, x15, x15, lsr #29
	eor	x14, x14, x14, lsr #29
	add	x16, x20, x9
	add	x13, x13, x9
	madd	x20, x15, x8, x16
	madd	x13, x14, x8, x13
	add	x12, x12, #2
	cmp	x12, #2, lsl #12                ; =8192
	b.ne	LBB0_17
; %bb.18:                               ;   in Loop: Header=BB0_16 Depth=1
	add	x20, x13, x20
	add	x11, x11, #1
	cmp	x11, #64
	b.ne	LBB0_16
; %bb.19:
	mov	x12, #0                         ; =0x0
	mov	x11, #0                         ; =0x0
	str	x20, [sp, #72]
LBB0_20:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_21 Depth 2
	mov	x13, #0                         ; =0x0
	mov	x14, #0                         ; =0x0
LBB0_21:                                ;   Parent Loop BB0_20 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x15, x12, x13
	add	x16, x15, #97
	add	x15, x15, #98
	eor	x16, x16, x16, lsr #29
	eor	x15, x15, x15, lsr #29
	add	x11, x11, x9
	add	x14, x14, x9
	madd	x11, x16, x8, x11
	madd	x14, x15, x8, x14
	add	x13, x13, #2
	cmp	x13, #2, lsl #12                ; =8192
	b.ne	LBB0_21
; %bb.22:                               ;   in Loop: Header=BB0_20 Depth=1
	add	x11, x14, x11
	add	x12, x12, #1
	cmp	x12, #64
	b.ne	LBB0_20
; %bb.23:
	str	x11, [sp, #80]
	cmp	x19, x10
	b.ne	LBB0_70
; %bb.24:
	cmp	x20, x11
	b.ne	LBB0_71
; %bb.25:
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.26:
	mov	w23, #51712                     ; =0xca00
	movk	w23, #15258, lsl #16
	mov	w21, #25856                     ; =0x6500
	movk	w21, #7629, lsl #16
	ldp	x22, x25, [sp, #40]
	adrp	x24, _sink@PAGE
LBB0_27:                                ; =>This Inner Loop Header: Depth=1
	mov	w0, #0                          ; =0x0
	bl	_run_case
	cmp	x0, x19
	b.ne	LBB0_72
; %bb.28:                               ;   in Loop: Header=BB0_27 Depth=1
	str	x19, [x24, _sink@PAGEOFF]
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.29:                               ;   in Loop: Header=BB0_27 Depth=1
	ldp	x8, x9, [sp, #40]
	sub	x8, x8, x22
	sub	x9, x9, x25
	madd	x8, x8, x23, x9
	cmp	x8, x21
	b.lo	LBB0_27
; %bb.30:
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.31:
	ldp	x22, x25, [sp, #40]
LBB0_32:                                ; =>This Inner Loop Header: Depth=1
	mov	w0, #1                          ; =0x1
	bl	_run_case
	cmp	x0, x19
	b.ne	LBB0_72
; %bb.33:                               ;   in Loop: Header=BB0_32 Depth=1
	str	x19, [x24, _sink@PAGEOFF]
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.34:                               ;   in Loop: Header=BB0_32 Depth=1
	ldp	x8, x9, [sp, #40]
	sub	x8, x8, x22
	sub	x9, x9, x25
	madd	x8, x8, x23, x9
	cmp	x8, x21
	b.lo	LBB0_32
; %bb.35:
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.36:
	ldp	x19, x22, [sp, #40]
LBB0_37:                                ; =>This Inner Loop Header: Depth=1
	mov	w0, #2                          ; =0x2
	bl	_run_case
	cmp	x0, x20
	b.ne	LBB0_72
; %bb.38:                               ;   in Loop: Header=BB0_37 Depth=1
	str	x20, [x24, _sink@PAGEOFF]
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.39:                               ;   in Loop: Header=BB0_37 Depth=1
	ldp	x8, x9, [sp, #40]
	sub	x8, x8, x19
	sub	x9, x9, x22
	madd	x8, x8, x23, x9
	cmp	x8, x21
	b.lo	LBB0_37
; %bb.40:
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.41:
	ldp	x19, x22, [sp, #40]
LBB0_42:                                ; =>This Inner Loop Header: Depth=1
	mov	w0, #3                          ; =0x3
	bl	_run_case
	cmp	x0, x20
	b.ne	LBB0_72
; %bb.43:                               ;   in Loop: Header=BB0_42 Depth=1
	str	x20, [x24, _sink@PAGEOFF]
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.44:                               ;   in Loop: Header=BB0_42 Depth=1
	ldp	x8, x9, [sp, #40]
	sub	x8, x8, x19
	sub	x9, x9, x22
	madd	x8, x8, x23, x9
	cmp	x8, x21
	b.lo	LBB0_42
; %bb.45:
	fcmp	d8, #0.0
	b.le	LBB0_51
; %bb.46:
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.47:
	mov	w19, #0                         ; =0x0
	ldp	x20, x21, [sp, #40]
	mov	x8, #225833675390976            ; =0xcd6500000000
	movk	x8, #16845, lsl #48
	fmov	d0, x8
	fmul	d8, d8, d0
	add	x22, sp, #56
LBB0_48:                                ; =>This Inner Loop Header: Depth=1
	mov	x0, x19
	bl	_run_case
	ldr	x8, [x22, w19, uxtw #3]
	cmp	x0, x8
	b.ne	LBB0_72
; %bb.49:                               ;   in Loop: Header=BB0_48 Depth=1
	str	x0, [x24, _sink@PAGEOFF]
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.50:                               ;   in Loop: Header=BB0_48 Depth=1
	add	w8, w19, #1
	and	w19, w8, #0x3
	ldp	x8, x9, [sp, #40]
	sub	x8, x8, x20
	sub	x9, x9, x21
	madd	x8, x8, x23, x9
	ucvtf	d0, x8
	fcmp	d8, d0
	b.gt	LBB0_48
	b	LBB0_65
LBB0_51:
Lloh11:
	adrp	x0, l_.str.4@PAGE
Lloh12:
	add	x0, x0, l_.str.4@PAGEOFF
	bl	_puts
	mov	w28, #0                         ; =0x0
Lloh13:
	adrp	x19, l_.str.5@PAGE
Lloh14:
	add	x19, x19, l_.str.5@PAGEOFF
LBB0_52:                                ; =>This Inner Loop Header: Depth=1
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.53:                               ;   in Loop: Header=BB0_52 Depth=1
	and	w20, w28, #0x3
	ldp	x22, x26, [sp, #40]
	mov	x0, x20
	bl	_run_case
	mov	x21, x0
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.54:                               ;   in Loop: Header=BB0_52 Depth=1
	add	x8, sp, #56
	ldr	x8, [x8, w20, uxtw #3]
	cmp	x21, x8
	b.ne	LBB0_72
; %bb.55:                               ;   in Loop: Header=BB0_52 Depth=1
	add	w25, w28, #1
	ldp	x8, x9, [sp, #40]
	sub	x8, x8, x22
	sub	x9, x9, x26
	madd	x8, x8, x23, x9
	str	x21, [x24, _sink@PAGEOFF]
Lloh15:
	adrp	x9, _names@PAGE
Lloh16:
	add	x9, x9, _names@PAGEOFF
	ldr	x9, [x9, w20, uxtw #3]
	mov	w10, #524288                    ; =0x80000
	stp	x10, x21, [sp, #24]
	stp	x25, x8, [sp, #8]
	str	x9, [sp]
	mov	x0, x19
	bl	_printf
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.56:                               ;   in Loop: Header=BB0_52 Depth=1
	and	w21, w25, #0x3
	ldp	x26, x27, [sp, #40]
	mov	x0, x21
	bl	_run_case
	mov	x22, x0
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.57:                               ;   in Loop: Header=BB0_52 Depth=1
	add	x8, sp, #56
	ldr	x8, [x8, w21, uxtw #3]
	cmp	x22, x8
	b.ne	LBB0_72
; %bb.58:                               ;   in Loop: Header=BB0_52 Depth=1
	ldp	x8, x9, [sp, #40]
	sub	x8, x8, x26
	sub	x9, x9, x27
	madd	x8, x8, x23, x9
	str	x22, [x24, _sink@PAGEOFF]
Lloh17:
	adrp	x9, _names@PAGE
Lloh18:
	add	x9, x9, _names@PAGEOFF
	ldr	x9, [x9, w21, uxtw #3]
	mov	w10, #524288                    ; =0x80000
	stp	x10, x22, [sp, #24]
	stp	x25, x8, [sp, #8]
	str	x9, [sp]
	mov	x0, x19
	bl	_printf
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.59:                               ;   in Loop: Header=BB0_52 Depth=1
	eor	w20, w20, #0x2
	ldp	x22, x26, [sp, #40]
	mov	x0, x20
	bl	_run_case
	mov	x21, x0
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.60:                               ;   in Loop: Header=BB0_52 Depth=1
	add	x8, sp, #56
	ldr	x8, [x8, w20, uxtw #3]
	cmp	x21, x8
	b.ne	LBB0_72
; %bb.61:                               ;   in Loop: Header=BB0_52 Depth=1
	ldp	x8, x9, [sp, #40]
	sub	x8, x8, x22
	sub	x9, x9, x26
	madd	x8, x8, x23, x9
	str	x21, [x24, _sink@PAGEOFF]
Lloh19:
	adrp	x9, _names@PAGE
Lloh20:
	add	x9, x9, _names@PAGEOFF
	ldr	x9, [x9, w20, uxtw #3]
	mov	w10, #524288                    ; =0x80000
	stp	x10, x21, [sp, #24]
	stp	x25, x8, [sp, #8]
	str	x9, [sp]
	mov	x0, x19
	bl	_printf
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.62:                               ;   in Loop: Header=BB0_52 Depth=1
	sub	w8, w28, #1
	and	w20, w8, #0x3
	ldp	x22, x26, [sp, #40]
	mov	x0, x20
	bl	_run_case
	mov	x21, x0
	add	x1, sp, #40
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	cbnz	w0, LBB0_72
; %bb.63:                               ;   in Loop: Header=BB0_52 Depth=1
	add	x8, sp, #56
	ldr	x8, [x8, w20, uxtw #3]
	cmp	x21, x8
	b.ne	LBB0_72
; %bb.64:                               ;   in Loop: Header=BB0_52 Depth=1
	ldp	x8, x9, [sp, #40]
	sub	x8, x8, x22
	sub	x9, x9, x26
	madd	x8, x8, x23, x9
	str	x21, [x24, _sink@PAGEOFF]
Lloh21:
	adrp	x9, _names@PAGE
Lloh22:
	add	x9, x9, _names@PAGEOFF
	ldr	x9, [x9, w20, uxtw #3]
	mov	w10, #524288                    ; =0x80000
	stp	x10, x21, [sp, #24]
	stp	x25, x8, [sp, #8]
	str	x9, [sp]
	mov	x0, x19
	bl	_printf
	mov	x28, x25
	cmp	w25, #21
	b.ne	LBB0_52
LBB0_65:
	mov	w0, #0                          ; =0x0
LBB0_66:
	ldr	x8, [sp, #88]
Lloh23:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh24:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh25:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB0_73
; %bb.67:
	ldp	x29, x30, [sp, #192]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #176]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #160]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #144]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #128]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #112]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #96]               ; 16-byte Folded Reload
	add	sp, sp, #208
	ret
LBB0_68:
	ldr	x0, [x19, #16]
	add	x1, sp, #56
	bl	_strtod
	ldr	x8, [sp, #56]
	ldrb	w8, [x8]
	mov	w0, #2                          ; =0x2
	cbnz	w8, LBB0_66
; %bb.69:
	mov.16b	v8, v0
	fcmp	d0, #0.0
	mov	x8, #4638144666238189568        ; =0x405e000000000000
	fmov	d0, x8
	fccmp	d8, d0, #0, hi
	b.le	LBB0_5
	b	LBB0_66
LBB0_70:
	bl	_main.cold.1
LBB0_71:
	bl	_main.cold.2
LBB0_72:
	bl	_abort
LBB0_73:
	bl	___stack_chk_fail
	.loh AdrpLdrGotLdr	Lloh0, Lloh1, Lloh2
	.loh AdrpAdd	Lloh3, Lloh4
	.loh AdrpAdd	Lloh5, Lloh6
	.loh AdrpAdd	Lloh7, Lloh8
	.loh AdrpAdd	Lloh9, Lloh10
	.loh AdrpAdd	Lloh13, Lloh14
	.loh AdrpAdd	Lloh11, Lloh12
	.loh AdrpAdd	Lloh15, Lloh16
	.loh AdrpAdd	Lloh17, Lloh18
	.loh AdrpAdd	Lloh19, Lloh20
	.loh AdrpAdd	Lloh21, Lloh22
	.loh AdrpLdrGotLdr	Lloh23, Lloh24, Lloh25
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function run_case
_run_case:                              ; @run_case
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #128
	stp	x26, x25, [sp, #48]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #64]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #112]            ; 16-byte Folded Spill
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	mov	x20, x0
	cbz	w0, LBB1_16
; %bb.1:
	cmp	w20, #1
	b.eq	LBB1_11
; %bb.2:
	cmp	w20, #2
	b.ne	LBB1_24
; %bb.3:
	mov	x21, #0                         ; =0x0
	mov	x19, #0                         ; =0x0
Lloh26:
	adrp	x20, _output@PAGE
Lloh27:
	add	x20, x20, _output@PAGEOFF
Lloh28:
	adrp	x22, _output@PAGE+32
Lloh29:
	add	x22, x22, _output@PAGEOFF+32
LBB1_4:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_9 Depth 2
	str	xzr, [sp, #40]
	add	x0, x21, #97
	add	x2, sp, #40
	mov	w1, #8192                       ; =0x2000
	bl	_rb_generate
                                        ; kill: def $w0 killed $w0 def $x0
	cbnz	w0, LBB1_35
; %bb.5:                                ;   in Loop: Header=BB1_4 Depth=1
	str	xzr, [sp, #16]
	ldr	x0, [sp, #40]
	add	x3, sp, #16
	mov	x1, x20
	mov	w2, #8192                       ; =0x2000
	bl	_rb_copy
	cbnz	w0, LBB1_38
; %bb.6:                                ;   in Loop: Header=BB1_4 Depth=1
	ldr	x8, [sp, #16]
	cmp	x8, #2, lsl #12                 ; =8192
	b.ne	LBB1_36
; %bb.7:                                ;   in Loop: Header=BB1_4 Depth=1
	ldr	x0, [sp, #40]
	bl	_rb_release
                                        ; kill: def $w0 killed $w0 def $x0
	cbnz	w0, LBB1_35
; %bb.8:                                ;   in Loop: Header=BB1_4 Depth=1
	movi.2d	v0, #0000000000000000
	movi.2d	v1, #0000000000000000
	mov.d	v1[0], x19
	mov	x8, x22
	mov	w9, #8192                       ; =0x2000
	movi.2d	v2, #0000000000000000
	movi.2d	v3, #0000000000000000
LBB1_9:                                 ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q4, q5, [x8, #-32]
	ldp	q6, q7, [x8], #64
	add.2d	v1, v4, v1
	add.2d	v0, v5, v0
	add.2d	v2, v6, v2
	add.2d	v3, v7, v3
	subs	x9, x9, #8
	b.ne	LBB1_9
; %bb.10:                               ;   in Loop: Header=BB1_4 Depth=1
	add.2d	v0, v0, v1
	add.2d	v0, v2, v0
	add.2d	v0, v3, v0
	addp.2d	d0, v0
	fmov	x19, d0
	add	x21, x21, #1
	cmp	x21, #64
	b.ne	LBB1_4
	b	LBB1_23
LBB1_11:
	mov	w22, #0                         ; =0x0
	mov	x19, #0                         ; =0x0
Lloh30:
	adrp	x20, _input@PAGE
Lloh31:
	add	x20, x20, _input@PAGEOFF
Lloh32:
	adrp	x21, _output@PAGE
Lloh33:
	add	x21, x21, _output@PAGEOFF
Lloh34:
	adrp	x23, _output@PAGE+32
Lloh35:
	add	x23, x23, _output@PAGEOFF+32
LBB1_12:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_14 Depth 2
	mov	x0, x20
	mov	x1, x21
	mov	w2, #8192                       ; =0x2000
	bl	_rb_transform
	cbnz	w0, LBB1_37
; %bb.13:                               ;   in Loop: Header=BB1_12 Depth=1
	movi.2d	v0, #0000000000000000
	movi.2d	v1, #0000000000000000
	mov.d	v1[0], x19
	mov	x8, x23
	mov	w9, #8192                       ; =0x2000
	movi.2d	v2, #0000000000000000
	movi.2d	v3, #0000000000000000
LBB1_14:                                ;   Parent Loop BB1_12 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q4, q5, [x8, #-32]
	ldp	q6, q7, [x8], #64
	add.2d	v1, v4, v1
	add.2d	v0, v5, v0
	add.2d	v2, v6, v2
	add.2d	v3, v7, v3
	subs	x9, x9, #8
	b.ne	LBB1_14
; %bb.15:                               ;   in Loop: Header=BB1_12 Depth=1
	add.2d	v0, v0, v1
	add.2d	v0, v2, v0
	add.2d	v0, v3, v0
	addp.2d	d0, v0
	fmov	x19, d0
	add	w22, w22, #1
	cmp	w22, #64
	b.ne	LBB1_12
	b	LBB1_23
LBB1_16:
	mov	x19, #0                         ; =0x0
Lloh36:
	adrp	x22, _output@PAGE
Lloh37:
	add	x22, x22, _output@PAGEOFF
Lloh38:
	adrp	x23, _input@PAGE
Lloh39:
	add	x23, x23, _input@PAGEOFF
Lloh40:
	adrp	x24, _output@PAGE+32
Lloh41:
	add	x24, x24, _output@PAGEOFF+32
LBB1_17:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_18 Depth 2
                                        ;     Child Loop BB1_21 Depth 2
	mov	x25, #0                         ; =0x0
	mov	x21, x22
LBB1_18:                                ;   Parent Loop BB1_17 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x0, [x23, x25, lsl #3]
	mov	x1, x21
	bl	_rb_mix
	cbnz	w0, LBB1_34
; %bb.19:                               ;   in Loop: Header=BB1_18 Depth=2
	add	x25, x25, #1
	add	x21, x21, #8
	cmp	x25, #2, lsl #12                ; =8192
	b.ne	LBB1_18
; %bb.20:                               ;   in Loop: Header=BB1_17 Depth=1
	movi.2d	v0, #0000000000000000
	movi.2d	v1, #0000000000000000
	mov.d	v1[0], x19
	mov	x8, x24
	mov	w9, #8192                       ; =0x2000
	movi.2d	v2, #0000000000000000
	movi.2d	v3, #0000000000000000
LBB1_21:                                ;   Parent Loop BB1_17 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q4, q5, [x8, #-32]
	ldp	q6, q7, [x8], #64
	add.2d	v1, v4, v1
	add.2d	v0, v5, v0
	add.2d	v2, v6, v2
	add.2d	v3, v7, v3
	subs	x9, x9, #8
	b.ne	LBB1_21
; %bb.22:                               ;   in Loop: Header=BB1_17 Depth=1
	add.2d	v0, v0, v1
	add.2d	v0, v2, v0
	add.2d	v0, v3, v0
	addp.2d	d0, v0
	fmov	x19, d0
	add	w20, w20, #1
	cmp	w20, #64
	b.ne	LBB1_17
LBB1_23:
	mov	x0, x19
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB1_24:
	mov	x21, #0                         ; =0x0
	mov	x19, #0                         ; =0x0
Lloh42:
	adrp	x22, _output@PAGE+32
Lloh43:
	add	x22, x22, _output@PAGEOFF+32
	b	LBB1_26
LBB1_25:                                ;   in Loop: Header=BB1_26 Depth=1
	add	x21, x21, #1
	cmp	x21, #64
	b.eq	LBB1_23
LBB1_26:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_32 Depth 2
	str	xzr, [sp, #40]
	add	x0, x21, #97
	add	x2, sp, #40
	mov	w1, #8192                       ; =0x2000
	bl	_rb_generate
                                        ; kill: def $w0 killed $w0 def $x0
	cbnz	w0, LBB1_35
; %bb.27:                               ;   in Loop: Header=BB1_26 Depth=1
	ldr	x0, [sp, #40]
	add	x3, sp, #16
	mov	w1, #1                          ; =0x1
	mov	w2, #24                         ; =0x18
	bl	_rb_info
	cbnz	w0, LBB1_39
; %bb.28:                               ;   in Loop: Header=BB1_26 Depth=1
	ldr	x8, [sp, #24]
	cmp	x8, #2, lsl #12                 ; =8192
	b.ne	LBB1_36
; %bb.29:                               ;   in Loop: Header=BB1_26 Depth=1
	ldp	x23, x0, [sp, #32]
	bl	_rb_release
                                        ; kill: def $w0 killed $w0 def $x0
	cbnz	w0, LBB1_35
; %bb.30:                               ;   in Loop: Header=BB1_26 Depth=1
	add	x19, x23, x19
	cmp	w20, #3
	b.eq	LBB1_25
; %bb.31:                               ;   in Loop: Header=BB1_26 Depth=1
	movi.2d	v0, #0000000000000000
	movi.2d	v1, #0000000000000000
	mov.d	v1[0], x19
	mov	x8, x22
	mov	w9, #8192                       ; =0x2000
	movi.2d	v2, #0000000000000000
	movi.2d	v3, #0000000000000000
LBB1_32:                                ;   Parent Loop BB1_26 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q4, q5, [x8, #-32]
	ldp	q6, q7, [x8], #64
	add.2d	v1, v4, v1
	add.2d	v0, v5, v0
	add.2d	v2, v6, v2
	add.2d	v3, v7, v3
	subs	x9, x9, #8
	b.ne	LBB1_32
; %bb.33:                               ;   in Loop: Header=BB1_26 Depth=1
	add.2d	v0, v0, v1
	add.2d	v0, v2, v0
	add.2d	v0, v3, v0
	addp.2d	d0, v0
	fmov	x19, d0
	b	LBB1_25
LBB1_34:
	bl	_run_case.cold.3
LBB1_35:
Lloh44:
	adrp	x8, ___stderrp@GOTPAGE
Lloh45:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh46:
	ldr	x8, [x8]
	str	x0, [sp]
Lloh47:
	adrp	x1, l_.str.6@PAGE
Lloh48:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	x0, x8
	bl	_fprintf
LBB1_36:
	bl	_abort
LBB1_37:
	bl	_run_case.cold.2
LBB1_38:
	bl	_run_case.cold.1
LBB1_39:
	bl	_run_case.cold.4
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpAdd	Lloh32, Lloh33
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpAdd	Lloh38, Lloh39
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpAdd	Lloh47, Lloh48
	.loh AdrpLdrGotLdr	Lloh44, Lloh45, Lloh46
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function main.cold.1
_main.cold.1:                           ; @main.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh49:
	adrp	x0, l___func__.main@PAGE
Lloh50:
	add	x0, x0, l___func__.main@PAGEOFF
Lloh51:
	adrp	x1, l_.str.1@PAGE
Lloh52:
	add	x1, x1, l_.str.1@PAGEOFF
Lloh53:
	adrp	x3, l_.str.2@PAGE
Lloh54:
	add	x3, x3, l_.str.2@PAGEOFF
	mov	w2, #89                         ; =0x59
	bl	___assert_rtn
	.loh AdrpAdd	Lloh53, Lloh54
	.loh AdrpAdd	Lloh51, Lloh52
	.loh AdrpAdd	Lloh49, Lloh50
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function main.cold.2
_main.cold.2:                           ; @main.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh55:
	adrp	x0, l___func__.main@PAGE
Lloh56:
	add	x0, x0, l___func__.main@PAGEOFF
Lloh57:
	adrp	x1, l_.str.1@PAGE
Lloh58:
	add	x1, x1, l_.str.1@PAGEOFF
Lloh59:
	adrp	x3, l_.str.3@PAGE
Lloh60:
	add	x3, x3, l_.str.3@PAGEOFF
	mov	w2, #90                         ; =0x5a
	bl	___assert_rtn
	.loh AdrpAdd	Lloh59, Lloh60
	.loh AdrpAdd	Lloh57, Lloh58
	.loh AdrpAdd	Lloh55, Lloh56
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function run_case.cold.1
_run_case.cold.1:                       ; @run_case.cold.1
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
                                        ; kill: def $w0 killed $w0 def $x0
	bl	_OUTLINED_FUNCTION_0
	bl	_abort
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function run_case.cold.2
_run_case.cold.2:                       ; @run_case.cold.2
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
                                        ; kill: def $w0 killed $w0 def $x0
	bl	_OUTLINED_FUNCTION_0
	bl	_abort
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function run_case.cold.3
_run_case.cold.3:                       ; @run_case.cold.3
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
                                        ; kill: def $w0 killed $w0 def $x0
	bl	_OUTLINED_FUNCTION_0
	bl	_abort
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function run_case.cold.4
_run_case.cold.4:                       ; @run_case.cold.4
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
                                        ; kill: def $w0 killed $w0 def $x0
	bl	_OUTLINED_FUNCTION_0
	bl	_abort
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function OUTLINED_FUNCTION_0
_OUTLINED_FUNCTION_0:                   ; @OUTLINED_FUNCTION_0 Thunk
	.cfi_startproc
; %bb.0:
	adrp	x8, ___stderrp@GOTPAGE
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
	ldr	x8, [x8]
	str	x0, [sp]
	adrp	x1, l_.str.6@PAGE
	add	x1, x1, l_.str.6@PAGEOFF
	mov	x0, x8
	b	_fprintf
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"--profile-seconds"

.zerofill __DATA,__bss,_input,65536,3   ; @input
l___func__.main:                        ; @__func__.main
	.asciz	"main"

l_.str.1:                               ; @.str.1
	.asciz	"benchmark.c"

l_.str.2:                               ; @.str.2
	.asciz	"checksums[0] == checksums[1]"

l_.str.3:                               ; @.str.3
	.asciz	"checksums[2] == checksums[3]"

.zerofill __DATA,__bss,_sink,8,3        ; @sink
l_.str.4:                               ; @.str.4
	.asciz	"case,observation,elapsed_ns,words,checksum"

l_.str.5:                               ; @.str.5
	.asciz	"%s,%u,%llu,%u,%016llx\n"

	.section	__DATA,__const
	.p2align	3, 0x0                          ; @names
_names:
	.quad	l_.str.7
	.quad	l_.str.8
	.quad	l_.str.9
	.quad	l_.str.10

.zerofill __DATA,__bss,_output,65536,3  ; @output
	.section	__TEXT,__cstring,cstring_literals
l_.str.6:                               ; @.str.6
	.asciz	"benchmark API error=%d\n"

l_.str.7:                               ; @.str.7
	.asciz	"per_element"

l_.str.8:                               ; @.str.8
	.asciz	"batch"

l_.str.9:                               ; @.str.9
	.asciz	"copy_out"

l_.str.10:                              ; @.str.10
	.asciz	"owned_handle"

.subsections_via_symbols
