# Makefile for Iris

#Entry Point of Kernel
#If Iris kernel more than 256KB,change the entry value
ENTRY=0x50000

IMAGE=a.img

BOOTLOADER=boot.bin
BOOTLOADER_ASM=boot/boot.asm

KERNEL_C=kernel/main.c kernel/console.c lib/string.c kernel/printk.c kernel/gdt.c\
         kernel/idt.c kernel/timer.c
KERNEL_ASM=kernel/entry.asm kernel/trap.asm
KERNEL=kern
KERNEL_OBJ=kernel/main.o kernel/entry.o kernel/console.o lib/string.o kernel/printk.o kernel/gdt.o\
           kernel/idt.o kernel/trap.o kernel/timer.o

ASM=nasm
CC=gcc
LD=ld
ASMFLAGS= -f elf
CFLAGS= -std=c99 -I include/ -c -m32 -fno-builtin -nostdinc -fno-stack-protector
LDFLAGS= -m elf_i386 -s -Ttext $(ENTRY)

.PHONY: clean all build everything m

everything: $(KERNEL) $(BOOTLOADER)

m: everything build

all: clean everything build 

clean: 
	-rm -f $(KERNEL_OBJ) $(KERNEL) $(BOOTLOADER)

build: 
	dd if=$(BOOTLOADER) of=$(IMAGE) bs=512 count=1 seek=0 conv=notrunc
	dd if=$(KERNEL) of=$(IMAGE) seek=1 conv=notrunc
	@echo building kernel.image...


$(BOOTLOADER):$(BOOTLOADER_ASM)
	$(ASM) -o $@ $<
	@echo compiling boot.s...done


kern    :$(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o $@ $(KERNEL_OBJ)
	@echo linking kernel...

kernel/console.o: kernel/console.c include/x86.h include/console.h include/type.h
	$(CC) $(CFLAGS) -o $@ $<
	@echo compiling console.c...

kernel/main.o: kernel/main.c  include/console.h include/string.h include/debug.h include/gdt.h\
               include/idt.h include/timer.h
	$(CC) $(CFLAGS) -o $@ $< 
	@echo compiling main.c...

kernel/entry.o:kernel/entry.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
	@echo compiling entry.s...

kernel/printk.o:kernel/printk.c include/string.h include/debug.h\
                include/type.h include/console.h
	$(CC) $(CFLAGS) -o $@ $<

lib/string.o:lib/string.c include/type.h include/string.h
	$(CC) $(CFLAGS) -o $@ $<

kernel/gdt.o:kernel/gdt.c include/type.h include/gdt.h include/debug.h
	$(CC) $(CFLAGS) -o $@ $<

kernel/idt.o:kernel/idt.c include/type.h include/idt.h include/debug.h
	$(CC) $(CFLAGS) -o $@ $<

kernel/trap.o:kernel/trap.asm 
	$(ASM) $(ASMFLAGS) -o $@ $<

kernel/timer.o:kernel/timer.c include/timer.h include/x86.h include/type.h include/idt.h \
               include/debug.h
	$(CC) $(CFLAGS) -o $@ $<













