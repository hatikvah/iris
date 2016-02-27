;bootloader.asm
;boot the ELF kernel to memory
;and jump into protect mode
;only read less than 128 sections

align 4

[bits 16] 

org 0x7c00

jmp start

memcpy: ;ESI=&source
        ;EDI=&destiny
        ;ecx=length
cld
rep movsb
ret

read_floppy: ;EX:BX->buffer  AL=section number
             ;DH=0/1 DL=device No.=0 
             ;CH=cylindar/lower 8bits CL=section No.
push ds
push cx
push bx
push ax
mov ds,ax
mov cl,0x24
div cl       ;cylindar=ax/36
mov ch,al    ;
mov cl,ah    ;
inc cl       ;
mov al,0x12
cmp cl,al    
ja  set_dh   ;if(cl>18), set_dh()
xor dx,dx
jmp i

set_dh:
mov dh,0x01  ;dl=1
sub cl,al    ;cl=cl-18
i:
mov al,0x01  ;read a sector
mov ah,0x02  
int 13h      ;interrupt 13h

pop ax
pop bx
add bx,0x200
pop cx
pop ds
ret


start:

xor ax,ax
mov ds,ax
mov ss,ax
mov sp,0x7c00  ;stack pointer in real mode


mov bx,0x1000
mov es,bx
mov bx,0x0000
mov ax,0x01

mov cx,0x20  ;change the reg to resize the ker image to boot
rd_floppy_seg:
call read_floppy
inc ax
dec cx
jnz rd_floppy_seg

mov ax,0x1000 ;0x7c51
mov ds,ax
xor eax,eax
mov ax,[0x2a]  ;program header size
mov ebx,[0x1c] ;ebx=program header offset
xor ecx,ecx
mov cx,[0x2c]  ;header amount

_rlct_ker:
push cx
mov ecx,0x1000
mov ds,cx
mov esi,[ebx+0x04]
mov edi,[ebx+0x08]
mov ecx,edi
shr edi,4
mov es,di
xor edi,edi
mov ecx,[ebx+0x10]
call memcpy
add ebx,eax
pop cx
dec cx
jnz _rlct_ker

mov ecx,[0x18]; entry_point
xor eax,eax
mov ds,ax
mov es,ax
mov ss,ax

cli          ;interrupt off
mov eax,gdt_desc
xor eax,eax
mov ds,ax
lgdt [gdt_desc]
mov eax,cr0
or eax,1
mov cr0,eax
jmp 0x08:bt_32


[bits 32]
bt_32:

mov ax,0x10
mov ds,ax
mov es,ax
mov ss,ax
mov gs,ax
mov [e_entry],ecx
jmp ecx

gdt:
gdt_null:
dd 0
dd 0

gdt_code:
dw 0xffff
dw 0x0000
db 0
db 10011010b
db 11001111b
db 0

gdt_data:
dw 0xffff
dw 0x0000
db 0
db 10010010b
db 11001111b
db 0
gdt_end:

gdt_desc:
dw gdt_end-gdt-1
dd gdt

_struct_elf:
e_entry:
dd 0   ;entry of the kernel image  0x18
e_phoff:
dd 0   ;offset of program header   0x1c
e_phnum:
dw 0   ;program header amount      0x2c
e_phentsize:
dw 0   ;e_phentsize ;size of every entry of program header 42=0x2a

_struct_header:
p_offset:
dd  0   ;the offset of first bit   +0x04
p_vaddr:
dd  0   ;address in virtual mem    +0x08
p_filesize:
dd  0   ;size of a section         +0x10

times 510-($-$$) db 0
dw 0xaa55





  
  

