		push	rax
		push	rcx
		push	rsi
		push	rdi
		push	rdx
		push	r12

		mov		r12, rax
		xor		rcx, rcx
		NOP
		NOP
		NOP
		NOP
		xor		rdx, rdx
		NOP
		NOP
		NOP
		NOP
		.add_valloop0:
			lodsb
			test	al, al
			je		.add_valdone0
			inc		rdx
			jmp		.add_valloop0
		.add_valdone0:
			dec		rsi
			xchg	rsi, rdi
			.add_valsecond_loop0:
				lodsb
				inc		rcx
				test	al, al
				je		.add_valsecond_done0
				jmp		.add_valsecond_loop0
			.add_valsecond_done0:
				sub		rsi, rcx
				mov		rax, rcx
				rep		movsb
				xchg	rsi, rdi

				cmp		r12, 4
				jne		.add_valfile0
				mov		[rsi - 1], byte '/'
				mov		[rsi], byte 0
				.add_valfile0:
				sub		rsi, rax
				sub		rsi, rdx
		pop		r12
		pop		rdx
		pop		rdi
		pop		rsi
		pop		rcx
		pop		rax
