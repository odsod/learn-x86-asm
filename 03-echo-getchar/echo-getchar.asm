; Read a character from stdin and print it

global main

extern getchar
extern printf

section .data

    prompt_cstr: db "Please enter a character: ", 0
    echo_format_cstr: db `You entered: %c\n`, 0

section .text

main:
    enter 0, 0

    push prompt_cstr
    call printf
    add esp, 4

    call getchar
    push eax
    push echo_format_cstr
    call printf
    add esp, 8

    leave
    ret
