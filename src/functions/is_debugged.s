	mov rdi, 0
	mov rax, SYS_ptrace
	xor rsi, rsi
	xor rdx, rdx
	xor r10, r10
	syscall
