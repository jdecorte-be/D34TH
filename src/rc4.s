; RC4 function that handles both encryption and decryption
; Parameters:
; rdi = buffer address (input/output)
; rsi = size to process
; rdx = key (optional, if 0 uses default key)
rc4:
    PUSH_ALL

    mov r8, rsi

    sub rsp, 256
    mov r14, rsp

    xor rcx, rcx
.init_sbox:
    mov [r14 + rcx], cl
    inc rcx
    cmp rcx, 256
    jne .init_sbox

    test rdx, rdx
    jnz .use_provided_key
    mov     rbx, [rbp + 16]
    add     rbx, mydata.encryption_key
    mov     rbx, [rbx]
    jmp .continue_key_setup
.use_provided_key:
    mov rbx, rdx
.continue_key_setup:
    sub rsp, 8
    mov [rsp], rbx
    mov r15, rsp

    xor rcx, rcx
    xor rdx, rdx
.ksa_loop:
    ; j = (j + S[i] + key[i % keylen]) % 256
    movzx rax, byte [r14 + rcx]
    add rdx, rax
    mov rax, rcx
    and rax, 7
    movzx rax, byte [r15 + rax]
    add rdx, rax
    and rdx, 0xFF

    mov al, [r14 + rcx]
    mov bl, [r14 + rdx]
    mov [r14 + rcx], bl
    mov [r14 + rdx], al

    inc rcx
    cmp rcx, 256
    jne .ksa_loop

    mov rsi, rdi
    mov rcx, r8
    xor r10, r10
    xor r11, r11

.prga_loop:
    test rcx, rcx
    jz .rc4_done

    inc r10
    and r10, 0xFF

    movzx rax, byte [r14 + r10]
    add r11, rax
    and r11, 0xFF

    mov al, [r14 + r10]
    mov bl, [r14 + r11]
    mov [r14 + r10], bl
    mov [r14 + r11], al

    movzx rax, byte [r14 + r10]
    movzx rbx, byte [r14 + r11]
    add rax, rbx
    and rax, 0xFF
    mov al, [r14 + rax]

    xor [rsi], al

    inc rsi
    dec rcx
    jmp .prga_loop

.rc4_done:
    add rsp, 264
    POP_ALL
    ret
