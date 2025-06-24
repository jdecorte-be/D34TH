		push	rax
		push	rcx
		push	rsi
		push	rdi
		push	rdx
		.loopsub_val0:
			lodsb		; al <- [rsi], rsi++
			inc		rdx
			test	al, al
			je		.donesub_val0
			jmp		.loopsub_val0
		.donesub_val0:
			cmp		rdx, 2
			jle		.finishsub_val0
			std		 ; sens inverse pour lodsb
			mov		[rsi - 2], byte 0
			.second_loopsub_val0:
				lodsb
				cmp		al, '/'
				je		.second_donesub_val0
				mov		[rsi + 1], byte 0
				jmp		.second_loopsub_val0
			.second_donesub_val0:
			cld
		.finishsub_val0:
		pop		rdx
		pop		rdi
		pop		rsi
		pop		rcx
		pop		rax
