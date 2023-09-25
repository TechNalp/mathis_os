[BITS 32]

extern _scrollup
extern _print
extern _clear

global _start

_start:

    mov  ebx, msg
    push ebx
    call _print
    pop  ebx

    mov  eax, msg2
    push eax
    call _print
    pop  eax

    mov eax, 17
    push eax
    call _scrollup
    pop eax
    
end:
    jmp end


msg db 10, 'Bienvenue sur le kernel de Mathis OS', 10, 0
msg2 db 'Version 0.3', 10, 0