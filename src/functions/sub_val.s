		push	rax
		push	rcx
		push	rsi
		push	rdi
		push	rdx
		.loopsub_val:
			lodsb		; al <- [rsi], rsi++
			inc		rdx
			test	al, al
			je		.donesub_val
			jmp		.loopsub_val
		.donesub_val:
			cmp		rdx, 2
			jle		.finishsub_val
			std		 ; sens inverse pour lodsb
			mov		[rsi - 2], byte 0
			.second_loopsub_val:
				lodsb
				cmp		al, '/'
				je		.second_donesub_val
				mov		[rsi + 1], byte 0
				jmp		.second_loopsub_val
			.second_donesub_val:
			cld
		.finishsub_val:
		pop		rdx
		pop		rdi
		pop		rsi
		pop		rcx
		pop		rax
