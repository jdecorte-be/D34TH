	printf: ; lea rsi
		push	rax
		push	rcx
		push	rsi
		push	rdi
		push	rdx
		xor		rdx, rdx
		NOP
		NOP
		NOP
		NOP
		.loop:
			lodsb		; al <- [rsi], rsi++
			inc		rdx
			test	al, al
			je		.done
			jmp		.loop
		.done:
			sub		rsi, rdx
			mov		rax, SYS_write
			mov		rdi, 1
			syscall
			mov		rax, SYS_write
			mov		rdi, 1
			mov     rsi, [rbp + 16]
			add     rsi, mydata.newl
			;lea		rsi, [rel newl]
			mov		rdx, 1
			syscall
		pop		rdx
		pop		rdi
		pop		rsi
		pop		rcx
		pop		rax
	ret
