#include "type.h"

#ifndef IDT_H_
#define IDT_H_

struct idt_info{
  uint16_t idt_limit;
  uint32_t idt_base;
}__attribute__((packed));

struct idt_entry{
  uint16_t off_low;
  uint16_t selector;
  uint8_t always0;
  uint8_t p;
  uint16_t off_high;
}__attribute__((packed));

struct trapframe{
  uint32_t edi;
  uint32_t esi;
  uint32_t ebp;
  uint32_t esp;
  uint32_t ebx;
  uint32_t edx;
  uint32_t ecx;
  uint32_t eax;
  uint32_t gs;
  uint32_t fs;
  uint32_t es;
  uint32_t ds;
  uint32_t trapno;
  uint32_t errcode;
  uint32_t eip;
  uint32_t cs;
  uint32_t eflags;
  uint32_t esp_user;//reserve for ring changing
  uint32_t ss_user;
}__attribute__((packed));

typedef void (*phandler)(struct trapframe*);

void handle_trap(phandler ptr,uint32_t no);
void init_idt();

void ld_idt(uint32_t);
#endif








