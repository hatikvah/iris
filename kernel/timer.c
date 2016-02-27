#include "type.h"
#include "x86.h"
#include "idt.h"
#include "timer.h"
#include "debug.h"
void timer_handler(struct trapframe* t){
  static uint32_t tick=0;
  printk("%u,%s",tick,".\n");
  tick++;
  
}

void init_timer(uint32_t frqcy){
  uint32_t time_piece=1193180/frqcy;
  
  outb(0x43,0x36);
  outb(0x40,(uint8_t)(time_piece&0xff));
  outb(0x40,(uint8_t)((time_piece>>8)&0xff));
  
  handle_trap(timer_handler,32);
}
