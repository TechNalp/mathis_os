#include "types.h"
#include "lib.h"
#include "debug.h"

#define __GDT__
#include "gdt.h"

void init_gdt_desc(u32 base, u32 limite, u8 acces, u8 other, struct gdtdesc *desc)
{
    desc->lim0_15 = (limite & 0xffff);
    desc->base0_15 = (base & 0xffff);
    desc->base16_23 = (base & 0xff0000) >> 16;
    desc->acces = acces;
    desc->lim16_19 = (limite & 0xf0000) >> 16;
    desc->other = (other & 0xf);
    desc->base24_31 = (base & 0xff000000) >> 24;
    return;
}

void init_gdt(void)
{
    init_gdt_desc(0x0, 0x0, 0x0, 0x0, &kgdt[0]);
    init_gdt_desc(0x0, 0xFFFFF, 0x9b, 0x0D, &kgdt[1]); // Code
    init_gdt_desc(0x0, 0xFFFFF, 0x93, 0x0D, &kgdt[2]); // Data
    init_gdt_desc(0x0, 0x0, 0x97, 0x0D, &kgdt[3]);     // Stack

    kgdtr.limite = GDTSIZE * 8;
    kgdtr.base = GDTBASE;

    memcpy((char *)kgdtr.base, (char *)kgdt, kgdtr.limite);

    asm("lgdt (_kgdtr)");

    asm(" movw $0x10, %ax \n \
          movw %ax, %ds  \n \
          movw %ax, %es  \n \
          movw %ax, %fs  \n \
          movw %ax, %gs  \n \
          ljmp $0x08, $next \n \
          next:          \n");
}