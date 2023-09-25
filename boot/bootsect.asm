%define BASE 0x100
%define KSIZE 50 ; nombre de secteurs de 512 octets à charger

[BITS 16]
[ORG 0x0]

jmp start
%include "UTIL.INC"
start:

    ;initialisation segment en 0x07C00
    mov ax, 0x07C0
    mov ds, ax
    mov es, ax
    mov ax, 0x8000
    mov ss, ax
    mov sp, 0xf000

    ;récupération de l'unité de boot
    mov [bootdrv], dl

    ;affiche un msg
    mov si, msgDebut
    call afficher


;charger le noyau
    xor ax, ax
    int 0x13

    push es
    mov ax, BASE
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, KSIZE
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootdrv]
    int 0x13
    pop es


;initialisation du pointeur sur la GDT (Global Descriptor Table)
    mov ax, gdtend
    mov bx, gdt
    sub ax, bx
    mov word [gdtptr], ax

    xor eax, eax  ;calcule l'adresse linéaire de GDT
    xor ebx, ebx
    mov ax, ds
    mov ecx, eax
    shl ecx, 4
    mov bx, gdt
    add ecx, ebx
    mov dword [gdtptr+2], ecx

;Passage en mode protégé
    cli ; Désactive les intérrutpion
    lgdt [gdtptr] ;Chargement de la GDT
    mov eax, cr0
    or ax, 1
    mov cr0, eax

    jmp next

next:
    mov ax, 0x10  ;segement de donnée
    mov ds, ax
    mov fs, ax
    mov gs, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x9F000

    jmp dword 0x8:0x1000

; saut vers le kernel
    ;jmp dword BASE:0


bootdrv: db 0
msgDebut: db "Chargement du kernel de Mathis OS (version 0.5)...", 13,10, 0


gdt:
    db 0, 0, 0, 0, 0, 0, 0, 0
gdt_cs:
    db 0xFF, 0xFF, 0x0, 0x0, 0x0, 10011011b, 11011111b, 0x0
gdt_ds:
    db 0xFF, 0xFF, 0x0, 0x0, 0x0, 10010011b, 11011111b, 0x0
gdtend:

gdtptr:
    dw 0x0000 ; limite
    dd 0 ; base

;; NOP jusqu'a 510

times 510-($-$$) db 144
dw 0xAA55