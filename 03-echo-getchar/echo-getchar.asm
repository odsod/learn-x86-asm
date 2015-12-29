global echo_getchar

extern getchar
extern printf

section .data

    prompt_cstr: db "Please enter a character: ", 0
    echo_format_cstr: db "You entered: %c", 0

section .text

echo_getchar:
    enter 0, 0
    pusha
    pushf

    push prompt_cstr
    call printf
    add esp, 4

    call getchar
    push eax
    push echo_format_cstr
    call printf
    add esp, 8

    popf
    popa
    leave
    ret
