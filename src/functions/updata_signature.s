    PUSH_ALL

    push rax
    push rdi
    push rsi
    push rdx

    mov rax, 318
	mov		rdi, [rbp + 16]
	add		rdi, mydata.encryption_key
    ;lea rdi, [rel encryption_key]
    mov rsi, 8
    xor rdx, rdx
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax

	mov		rbx, [rbp + 16]
	add		rbx, mydata.encryption_key
	mov		rbx, [rbx]

    ;mov rbx, [rel encryption_key]

	mov		rax, [rbp + 16]
	add		rax, mydata.temp_buf
    mov [rax], rbx

    mov rax, 96

	mov		rdi, [rbp + 16]
	add		rdi, mydata.timeval

    ;lea rdi, [rel timeval]
    xor rsi, rsi
    syscall

	mov		rdi, [rbp + 16]
	add		rdi, mydata.signature

    ;lea rdi, [rel signature]
    add rdi, 47
    mov rcx, 8

	mov		rsi, [rbp + 16]
	add		rsi, mydata.signature
    ;lea rsi, [rel temp_buf]

.convert_checksumupdate_signature:
    mov al, byte [rsi]

	%include "functions/byte_to_hex.s"
    ;call byte_to_hex
    mov [rdi], ax
    inc rsi
    add rdi, 2
    dec rcx
    jnz .convert_checksumupdate_signature

    mov byte [rdi], ':'
    inc rdi

	mov		rsi, [rbp + 16]
	add		rsi, mydata.timeval
    mov     rsi, [rsi]

    ;mov rsi, [rel timeval]
	%include "functions/number_to_string.s"
    ;call number_to_string

    mov byte [rdi], '.'
    inc rdi

	mov		rsi, [rbp + 16]
	add		rsi, mydata.timeval + 8
    mov     rsi, [rsi]

    ;mov rsi, [rel timeval + 8]
	%include "functions/number_to_string0.s"
    ;call number_to_string

    POP_ALL
