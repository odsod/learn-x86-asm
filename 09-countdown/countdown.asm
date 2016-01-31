; Count down to 0

global main

extern scanf
extern printf
extern sleep

section .data

    seconds_prompt: db "How many seconds? ", 0
    unsigned_integer_format: db "%u", 0
    countdown_format: db `%u\n`, 0
    boom: db `Boom!\n`, 0

section .text

main:
    enter 4, 0
    ; ebp - 4: num_seconds

    push seconds_prompt
    call printf
    add esp, 4

    lea eax, [ebp - 4]
    push eax
    push unsigned_integer_format
    call scanf
    add esp, 8

    mov ecx, [ebp - 4]
countdown:
    push ecx
    push countdown_format
    call printf
    add esp, 4
    push 1
    call sleep
    add esp, 4
    pop ecx
    loopnz countdown

    push boom
    call printf
    push 1
    call sleep
    add esp, 4

    leave
    mov eax, 0
    ret
