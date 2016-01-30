; Print each command line argument on a separate line

global main

extern printf

section .data

    argc_format: db `Number of arguments: %d\n`, 0
    string_format: db `%s\n`, 0

section .text

main:
    enter 0, 0
    ; [ebp + 12]: argv
    ; [ebp + 8]: argc
    ; [ebp + 4]: return address to libc driver
    ; [ebp]: libc driver's base pointer 

    mov eax, [ebp + 8]
    dec eax
    push eax
    push argc_format
    call printf
    add esp, 8

    mov ecx, 0
print_next_arg:
    inc ecx
    cmp ecx, [ebp + 8]
    je done
    push ecx

    mov eax, [ebp + 12]
    mov eax, [eax + ecx * 4]
    push eax
    push string_format
    call printf
    add esp, 8

    pop ecx
    jmp print_next_arg

done:
    leave
    mov eax, 0
    ret
