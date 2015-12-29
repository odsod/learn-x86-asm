global add_integers

extern scanf
extern printf

section .data

    prompt_format: db "Enter value for %c: ", 0

    x: dd 0
    y: dd 0
    sum: dd 0

    input_format: db "%d", 0
    output_format: db `x + y = %d + %d = %d\n`, 0

section .text

add_integers:
    enter 0, 0
    pusha
    pushf

    push 'x'
    push prompt_format
    call printf
    add esp, 8

    push x
    push input_format
    call scanf
    add esp, 8

    push 'y'
    push prompt_format
    call printf
    add esp, 8

    push y
    push input_format
    call scanf
    add esp, 8

    mov eax, [x]
    add eax, [y]
    mov [sum], eax

    mov eax, [sum]
    push eax
    mov eax, [y]
    push eax
    mov eax, [x]
    push eax
    push output_format
    call printf
    add esp, 16

    popf
    popa
    leave
    ret
