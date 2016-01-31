; Do some multiplication and division on an integer from stdin

global main

extern scanf
extern printf

section .data

    enter_x_value_prompt: db "Enter a value for x: ", 0

    integer_format: db "%d", 0

    x_format: db `x = %d\n`, 0
    x_squared_format: db `x^2 = %d\n`, 0
    x_cubed_times_25_format: db `x^3 * 25 = %d\n`, 0
    x_div_100_format: db `x / 100 = %d\n`, 0
    x_mod_100_format: db `x % 100 = %d\n`, 0
    neg_x_mod_100_format: db `-(x % 100) = %d\n`, 0

    x: dd 0

section .text

main:
    enter 0, 0

    push enter_x_value_prompt
    call printf
    add esp, 4

    push x
    push integer_format
    call scanf
    add esp, 8

    mov eax, [x]
    push eax
    push x_format
    call printf
    add esp, 8

    mov eax, [x]
    imul eax
    push eax
    push x_squared_format
    call printf
    add esp, 4
    pop eax ; pop x^2 back into eax
    imul eax, [x]
    imul eax, 25
    push eax
    push x_cubed_times_25_format
    call printf
    add esp, 8

    mov eax, [x]
    cdq
    mov ecx, 100
    idiv ecx ; edx gets the remainder, eax gets the quotient
    push edx ; stash the quotient for later
    push eax
    push x_div_100_format
    call printf
    add esp, 8
    push x_mod_100_format
    call printf
    add esp, 4
    pop eax ; pop x % 100 back into eax
    neg eax
    push eax
    push neg_x_mod_100_format
    call printf
    add esp, 8

    leave
    mov eax, 0
    ret
