#include "type.h"
#include "console.h"
#include "x86.h"

/*WARNING: if this file can debug with gdb,please have a look at the addr of 'static uint16_t* pvid' without const, because the version without keyword 'const' doesn't point to 0xB8000, the vga addr i'd like to set.

/*
Maybe without 'const' the pointers won't be defined with the exact addr,stated
only,this is an essential problem to solve, for it's compulsory to the later development.
*/

static uint8_t cursor_x=0x00;
static uint8_t cursor_y=0x00;
static uint32_t cursor_addr=0;

static uint16_t* const video=(uint16_t *)0xb8000; 
static uint8_t* const pvideo=(uint8_t *)0xb8000;

void move_cursor(){

  cursor_addr=cursor_x+80*cursor_y;
  
  outb(0x3D4,14);//inform to set cursor high 8bits
  outb(0x3D5,cursor_addr>>8);
  outb(0x3D4,15);//inform to set coursor low 8bits
  outb(0x3D5,cursor_addr);
  
}

void console_clean(){

  int i;
  for(i=0;i<25*80;i++){
    pvideo[2*i]=' ';
    pvideo[2*i+1]=0x0F;
  }

  cursor_x=0;
  cursor_y=0;
  move_cursor();
}

void console_put_char(int8_t c){
  if(c=='\r'){
    cursor_x=0;
  }
  else if(c=='\n'){
    cursor_x=0;
    cursor_y++;
  }
  else if(c>=' '){
    video[cursor_x+cursor_y*80]=c|0x0F00;
    cursor_x++;
  }
  
  if(cursor_x>80){
    cursor_x=cursor_x-80;
    cursor_y++;
  }

  if(cursor_y>24){
  
    for(int i=1;i<26;i++){
      for(int j=0;j<80;j++){
        video[(i-1)*80+j]=video[i*80+j];
      }
    }
    cursor_y--;
    //cursor_y=0;
    //cursor_x=0;
  }
  
  move_cursor();
}

void console_write(int8_t* cstr){
  while(*cstr!=0){
    console_put_char(*cstr);
    cstr++;
  }
}


