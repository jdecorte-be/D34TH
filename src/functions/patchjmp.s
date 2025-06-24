patchjmp:
	PUSH_ALL
	mov		qword [rel patchjmp.nbr], 255
	mov		dword [rel patchjmp.ptc], 0
	mov		qword [rel patchjmp.inc], 0
	jmp	.start
	.nbr:	dq 255
	.adr:	times 255 dq 0
	.ptc:	dq 0x421900000000
	.blc:	dq 1942
	.inc:	dq 0
	.start:
	; STEP 1 FINDING ADDR

	mov	r14, rdi
	mov	r15, rsi


	jmp	.cont
	.restart:
	pop	rdi
	pop	rsi
	pop	rcx
	mov	rdi, r14
	.cont:
	mov	rcx, r15
	sub	rcx, r14

	.loop_find_addr:
	push	rcx
	push	rsi
	push	rdi

	mov	rcx, 16
	lea	rsi, [rel .blc]

	repe	cmpsb
	jnz	.noeq



	mov		rax, [rel .inc]
	imul	rax, 8
	lea		rsi, [rel .adr]
	add		rsi, rax


	mov		[rsi],  rdi
	inc		qword [rel .inc]
	mov		rax, [rel .inc]
	cmp		rax, [rel .nbr]
	jne		.restart
	.noeq:
	pop		rdi
	pop		rsi
	pop		rcx
	inc		rdi
	loop	.loop_find_addr

	; Ici on va s'occuper de patcher les addresses
	mov		rdi, r14
	mov		rsi, r15

	jmp	.cont0
	.restart0:
	pop	rdi
	pop	rsi
	pop	rcx
	mov	rdi, r14
	.cont0:
	mov	rcx, r15
	sub	rcx, r14

	.loop_find_addr0:
	push	rcx
	push	rsi
	push	rdi

	mov	rcx, 8
	lea	rsi, [rel .ptc]

	repe	cmpsb
	jnz	.noeq0

	xor		rax,rax
	mov		eax, [rel .ptc]

	imul	rax, 8
	lea		rsi, [rel .adr]
	add		rsi, rax



	mov		rsi, [rsi] ;se trouve les bonnes values
	;sub		rdi, 8
	mov		[rdi], rsi

	inc		qword [rel .ptc]
	jne		.restart0
	.noeq0:
	pop		rdi
	pop		rsi
	pop		rcx
	inc		rdi
	loop	.loop_find_addr0
	POP_ALL
	ret
