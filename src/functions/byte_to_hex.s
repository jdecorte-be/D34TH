    push rcx
    mov ah, al
    shr al, 4
    and ah, 0x0F

    cmp al, 10
    jae .high_letterbyte
    add al, '0'
    jmp .lowbyte
.high_letterbyte:
    add al, 'a' - 10

.lowbyte:
    cmp ah, 10
    jae .low_letterbyte
    add ah, '0'
    jmp .donebyte
.low_letterbyte:
    add ah, 'a' - 10

.donebyte:
    pop rcx
