extern _isr_default_int, _isr_clock_int, _isr_kbd_int
global _asm_default_int, _asm_irq_0, _asm_irq_1

_asm_default_int:
    call _isr_default_int
    mov al, 0x20
    out 0x20, al
    iret

_asm_irq_0:
    call _isr_clock_int
    mov al, 0x20
    out 0x20,al
    iret
_asm_irq_1:
    call _isr_kbd_int
    mov al, 0x20
    out 0x20, al
    iret