		PUSH_ALLr
		and		rdx, 0xFFF        ; rcx = base % 0x1000
		sub		rax, rdx          ; rax = value - (base % 0x1000)
		add		rax, 0x0FFF       ; rax += 0x0FFF
		and		rax, ~0x0FFF      ; rax = align up to next page
		add		rax, rdx          ; rax += (base % 0x1000)
		POP_ALLr
