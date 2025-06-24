shuffle:
	PUSH_ALL
	xor		r13, r13
	mov		r14, rdi
	mov		r15, rsi

	mov		rcx, r15
	sub		rcx, r14

	push	rcx
	mov		rax, SYS_mmap
	xor		rdi, rdi
	mov		rsi, rcx
	mov		rdx, PROT_READ | PROT_WRITE
	mov		r10, MAP_PRIVATE | MAP_ANONYMOUS
	mov		r8, -1
	xor		r9, r9
	syscall
	pop		rcx
	mov		r12, rax
	cmp		rax, 0
	jb		.munmap
	push	rcx

	;mov		rsi, r14
	;mov		rdi, r12
	;rep		movsb
	PUSH_ALL
	mov		rax, SYS_open
	lea		rdi,  [rel .urnd_path]
	xor		rsi,  rsi
	xor		rdx,  rdx
	syscall
	mov		r12, rax
	js		.done_shuffle
	mov		rax, SYS_read
	mov		rdi, r12
	lea		rsi, [rel .randbuf]
	mov		rdx, N_BLOCKS
	syscall
	mov		rax, SYS_close
	mov		rdi, r12
	syscall
	mov		rcx, N_BLOCKS - 1
	.fy_loop:
		cmp		rcx, 0
		jl		.done_shuffle
		lea		rax, [rel .randbuf]
		add		rax, rcx
		movzx	eax, byte [rax]
		xor		rdx, rdx
		mov		rbx, rcx
		inc		rbx
		div		rbx
		mov		rbx, rdx
		lea		rsi, [rel .str]
		mov		al, [rsi + rcx]
		mov		dl, [rsi + rbx]
		mov		[rsi + rcx], dl
		mov		[rsi + rbx], al
		dec		rcx
		jmp		.fy_loop
	.done_shuffle:

	POP_ALL

	jmp		.af
	.ptc:	dq 0x696900000001
	.blc:	dq 1942
	.inc:	dq 0
	.str:
	%rep N_BLOCKS
		db %$ - .str
	%endrep
	.urnd_path: db "/dev/urandom", 0
	.randbuf:	times N_BLOCKS db 0
	.af:

	mov		rcx, N_BLOCKS

	.big_loop:
	cmp		rcx, 0
	jle		.noeq

	mov		rax, rcx
	dec		rax
	push	rcx
	mov		rcx, r15
	sub		rcx, r14
	mov		rdi, r14

	lea		rsi, [rel .str]
	add		rsi, rax

	mov		al, [rsi]
	;sub		al, '0'
	mov		 [rel .inc], al
	inc		al
	mov		 [rel .ptc], al
	.loop_first_addr:
	push	rcx
	mov		rcx, 16
	lea		rsi, [rel .blc]
	repe	cmpsb
	pop		rcx
	jz		.continuen
	loop	.loop_first_addr
	jmp		.noeq


	.continuen:
	mov		r9, rdi

	.loop_second_addr:
	push	rcx
	mov		rcx, 8
	lea		rsi, [rel .ptc]
	repe	cmpsb
	pop		rcx
	jz		.continuex
	loop	.loop_second_addr
	jmp		.noeq

	.continuex:
	mov		r10, rdi

	; Donc ici r9 = start
	sub		r9, 16
	; et r10 = end

	mov		rcx, r10
	sub		rcx, r9

	mov		rax, r12
	add		rax, r13
	add		r13, rcx

	mov		rsi, r9
	mov		rdi, rax
	rep		movsb

	pop		rcx
	dec		rcx
	jmp		.big_loop


	.noeq:
	mov		rcx, r15
	sub		rcx, r14
	mov		rsi, r12
	mov		rdi, r14
	rep		movsb

	pop		rcx
	.munmap:
	mov		rax, SYS_munmap
	mov		rdi, r12
	mov		rsi, rcx
	syscall
	POP_ALL
ret
