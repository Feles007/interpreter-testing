default rel
bits 64

global jt
global asm_test
global asm_test2
global asm_test3

section .text
align 4096


%macro align_to 1
	align %1, db 0xCC
%endmacro

%macro assert 1
	%ifn %1
		%error assert failed: %1
	%endif
%endmacro

%macro fill_to 2
	times (%2 - ($ - %1)) db 0x90
%endmacro


; SysV
%define reg_i0 rdi
%define reg_i1 rsi
%define reg_i2 rdx

; MS
%define reg_i0 rcx
%define reg_i1 rdx
%define reg_i2 r8

%define reg_r rax

align_to 4096

jt:
	mov reg_r, inst_1
	lea reg_r, [reg_i0 * 8 + reg_r]
	jmp reg_r
inst_1:
	lea reg_r, [reg_i1 + 1]
	ret
	fill_to inst_1, 8
inst_2:
	lea reg_r, [reg_i1 - 1]
	ret
	fill_to inst_2, 8
inst_3:
	lea reg_r, [reg_i1 + reg_i2]
	ret
	fill_to inst_3, 8
inst_4:
	mov reg_r, reg_i1
	sub reg_r, reg_i2
	ret
	fill_to inst_4, 8
end:

assert(end - inst_4 == 8)
assert(inst_4 - inst_3 == 8)
assert(inst_3 - inst_2 == 8)
assert(inst_2 - inst_1 == 8)

align_to 4096

asm_test:
	lea r9, [reg_i1 + 1]
	lea r10, [reg_i1 - 1]
	lea r11, [reg_i1 + reg_i2]
	sub reg_i1, reg_i2
	mov reg_r, r9
	cmp reg_i0, 1
	cmove reg_r, r10
	cmp reg_i0, 2
	cmove reg_r, r11
	cmp reg_i0, 3
	cmove reg_r, reg_i1
	ret

align_to 4096

asm_test2:
	mov r9, reg_i0
	and r9, 2     ;     r9: 0 => offset=1, 2 => offset=b
	and reg_i0, 1 ; reg_i0: 0 => +, 1 => -
	; load offset
	mov reg_r, 1
	cmp r9, 2
	cmove reg_r, reg_i2
	; negate, switch if needed
	mov r10, reg_r
	neg r10
	cmp reg_i0, 1
	cmove reg_r, r10

	add reg_r, reg_i1
	ret
