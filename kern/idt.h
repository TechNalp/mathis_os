#define IDTBASE 0x800
#define IDTSIZE 0xFF

#define INTGATE 0x8E00

#include "debug.h"

struct idtdesc
{
    u16 offset0_15;
    u16 select;
    u16 type;
    u16 offset16_31;
} __attribute__((packed));

#pragma pack(1)
struct idtr
{
    u16 limite;
    u32 base;
} __attribute__((packed));

#pragma pack()

struct idtr kidtr;
struct idtdesc kidt[IDTSIZE];

void init_idt_desc(u16, u32, u16, struct idtdesc *);
void init_idt(void);