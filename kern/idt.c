#include "types.h"
#include "lib.h"
#include "io.h"
#include "idt.h"
#include "debug.h"

void asm_default_int(void);
void asm_irq_0(void);
void asm_irq_1(void);

void init_idt_desc(u16 select, u32 offset, u16 type, struct idtdesc *desc)
{
    desc->offset0_15 = (offset & 0xffff);
    desc->select = select;
    desc->type = type;
    desc->offset16_31 = (offset & 0xffff0000) >> 16;
    return;
}

void init_idt(void)
{
    int i;

    for (i = 0; i < IDTSIZE; i++)
    {
        init_idt_desc(0x08, (u32)asm_default_int, INTGATE, &kidt[i]);
    }
    init_idt_desc(0x08, (u32)asm_irq_0, INTGATE, &kidt[32]); // Horloge
    init_idt_desc(0x08, (u32)asm_irq_1, INTGATE, &kidt[33]); // Clavier

    kidtr.limite = IDTSIZE * 8;
    kidtr.base = IDTBASE;

    memcpy((char *)kidtr.base, (char *)kidt, kidtr.limite);

    asm("lidtl (_kidtr)");
}