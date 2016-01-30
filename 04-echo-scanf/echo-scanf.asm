; Read a string from stdin and print it

global main

extern scanf
extern printf

section .data

    prompt_cstr: db "Please enter a string: ", 0

    input_cstr: times 16 db 0
    ; read at most 15 chars and a null byte
    input_scanf_format_cstr: db "%15s", 0

    echo_format_cstr: db `You entered: %s\n`, 0

section .text

main:
    enter 0, 0

    push prompt_cstr
    call printf
    add esp, 4

    push input_cstr
    push input_scanf_format_cstr
    call scanf
    add esp, 8

    push input_cstr
    push echo_format_cstr
    call printf
    add esp, 8

    leave
    ret
