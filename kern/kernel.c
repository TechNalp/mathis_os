#include "types.h"
#include "idt.h"
#include "io.h"
#include "gdt.h"
#include "screen.h"

void init_pic(void);

int _main(void);

void _start(void)
{
    kY = 18;
    kattr = 0x5E;

    print_auto_scroll("kernel: Chargement IDT...\n");

    init_idt();

    kattr = 0x4E;

    print_auto_scroll("kernel: IDT charge\n");

    kattr = 0x5E;

    print_auto_scroll("kernel: Configuration PIC...\n");

    init_pic();

    kattr = 0x4E;

    print_auto_scroll("kernel: PIC configure\n");

    kattr = 0x5E;

    print_auto_scroll("kernel: Chargement nouvelle GDT...\n");

    init_gdt();

    // Init pointeur de pile
    asm(" movw $0x18, %ax \n \
          movw %ax, %ss \n \
          movl $0x20000, %esp");

    _main();
}

int _main(void)
{
    kattr = 0x4E;
    print_auto_scroll("kernel: Nouvelle GDT charge\n");

    sti;

    kattr = 0x47;
    print("kernel : interruption autorise\n");
    kattr = 0x07;

    while (1)
        ;
}