; Print "Hello, world!" to stdout and exit

global _start

section .data

    sys_exit: equ 1
    sys_write: equ 4
    fd_stdout: equ 1
    hello_world_str: db `Hello, world!\n`
    hello_world_str_len: equ $ - hello_world_str

section .text

_start:
    mov eax, sys_write
    mov ebx, fd_stdout
    mov ecx, hello_world_str
    mov edx, hello_world_str_len
    int 0x80

    mov eax, sys_exit
    mov ebx, 0
    int 0x80
