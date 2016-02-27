#include "type.h"

#ifndef X86_H_
#define X86_H_


//write byte to port
static inline void outb(uint16_t port,uint8_t value){

__asm__ volatile( 
                "out %1,%0"
                :
                :"d" (port),"a" (value)
            );
}

//read byte from port
static inline uint8_t inb(uint16_t port){

uint8_t value;
__asm__ volatile(
                "in %1,%0":"=a" (value):"d" (port)
            );

return value;
}

//write word to port
static inline void outw(uint16_t port,uint16_t value){

__asm__ volatile(
                "out %1,%0"
                :
                :"d" (port),"a" (value)
            );
}

//write word from port
static inline uint16_t inw(uint16_t port){

uint16_t value;
__asm__ volatile(
              "in %1,%0"
              :"=a" (value)
              :"d" (port)
            );
return value;

}

#endif
