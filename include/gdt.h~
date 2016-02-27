#include "type.h"

#ifndef GDT_H_
#define GDT_H_
struct gdt_entry{
  uint16_t limit_low; //0-15bits of segment limit
  uint16_t base_low;  //0-15bits of segment base
  uint8_t base_mid;   //16-23bits of segment base
  uint8_t _type;
  uint8_t _gran;  
  uint8_t base_high;  //24-31bits of segment base
}__attribute__((packed));

struct gdt_info{
  uint16_t gdt_len;
  uint32_t gdt_base;
}__attribute__((packed));

void init_gdt();

extern void gdt_flush(uint32_t);

#endif
