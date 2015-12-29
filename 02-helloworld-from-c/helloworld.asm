global hello_world

extern printf

section .data

    hello_world_cstr: db `Hello, world!\n`, 0

section .text

hello_world:
    enter 0, 0
    pusha

    push hello_world_cstr ; 32 bit address
    call printf
    add esp, 4 ; 32 bits = 4 bytes

    popa
    leave
    ret
