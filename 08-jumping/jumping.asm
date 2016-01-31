; Read two integers from stdin and print which one is the bigger 

global main

extern scanf
extern printf

section .data

    assign_prompt: db "%c = ", 0

    scanf_integer_format: db "%d", 0

    less_than_format: db "%c < %c", 0
    equals_format: db "%c = %c", 0

    x: dd 0
    y: dd 0

section .text

main:
    enter 0, 0

    push 'x'
    push assign_prompt
    call printf
    add esp, 8

    push x
    push scanf_integer_format
    call scanf
    add esp, 8

    push 'y'
    push assign_prompt
    call printf
    add esp, 8

    push y
    push scanf_integer_format
    call scanf
    add esp, 8

    mov eax, [x]
    cmp eax, [y]
    je x_equals_y
    jl x_less_than_y

y_less_than_x:
    push 'x'
    push 'y'
    push less_than_format
    call printf
    jmp exit

x_less_than_y:
    push 'y'
    push 'x'
    push less_than_format
    call printf
    jmp exit

x_equals_y:
    push 'x'
    push 'y'
    push equals_format
    call printf

exit:
    leave
    mov eax, 0
    ret
