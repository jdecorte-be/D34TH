print_rax:

    PUSH_ALL
    ; Utilisation d’un buffer sur la pile
    sub     rsp, 64             ; réserver 32 bytes
    lea     rsi, [rsp + 64]     ; rsi = fin du buffer
    mov     rcx, 0              ; compteur de caractères
    mov     rbx, rax            ; backup rax dans rbx

.convert:
    xor     rdx, rdx
	NOP
	NOP
	NOP
	NOP
    mov     rax, rbx
    mov     rdi, 10
    div     rdi                ; rax = rbx / 10, rdx = reste
    dec     rsi
    add     dl, '0'
    mov     [rsi], dl
    mov     rbx, rax
    inc     rcx
    test    rax, rax
    jnz     .convert

    ; Affichage
    mov     rax, 1              ; syscall write
    mov     rdi, 1              ; stdout
    mov     rdx, rcx            ; taille
    syscall


	mov		rax, SYS_write
	mov		rdi, 1
    mov     rsi, [rbp + 16]
    add     rsi, mydata.newl
	;lea		rsi, [rel newl]
	mov		rdx, 1
	syscall


    add     rsp, 64             ; restaurer la pile
    POP_ALL
    ret

	;   rax = ((value - (base % 0x1000) + 0x0FFF) & ~0x0FFF) + (base % 0x1000)
	align_value:	; rax = value, rdx = base
		; sauvegarder base % 0x1000 dans rcx
		PUSH_ALLr
		and		rdx, 0xFFF        ; rcx = base % 0x1000
		sub		rax, rdx          ; rax = value - (base % 0x1000)
		add		rax, 0x0FFF       ; rax += 0x0FFF
		and		rax, ~0x0FFF      ; rax = align up to next page
		add		rax, rdx          ; rax += (base % 0x1000)
		POP_ALLr
	ret
