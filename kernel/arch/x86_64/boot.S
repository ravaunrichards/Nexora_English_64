/* GRUB Multiboot2 enters protected mode; establish a temporary 1 GiB map. */
.section .text.boot,"ax"
.code32
.global _start
.type _start,@function
.extern kernel_main
_start:
    cli
    cld
    movl %eax, boot_magic
    movl %ebx, boot_info
    movl $p3_table, %eax
    orl $3, %eax
    movl %eax, p4_table
    movl $p2_table, %eax
    orl $3, %eax
    movl %eax, p3_table
    xorl %ecx, %ecx
1:
    movl %ecx, %eax
    shll $21, %eax
    orl $0x83, %eax
    movl %eax, p2_table(,%ecx,8)
    movl $0, p2_table+4(,%ecx,8)
    incl %ecx
    cmpl $512, %ecx
    jne 1b
    movl %cr4, %eax
    orl $0x20, %eax
    movl %eax, %cr4
    movl $p4_table, %eax
    movl %eax, %cr3
    movl $0xc0000080, %ecx
    rdmsr
    orl $0x100, %eax
    wrmsr
    lgdt gdt64_pointer
    movl %cr0, %eax
    orl $0x80000001, %eax
    movl %eax, %cr0
    ljmp $0x08, $long_mode_start

.code64
long_mode_start:
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    xorw %ax, %ax
    movw %ax, %fs
    movw %ax, %gs
    leaq stack_top(%rip), %rsp
    andq $-16, %rsp
    movl boot_magic(%rip), %edi
    movl boot_info(%rip), %esi
    call kernel_main
2:
    cli
    hlt
    jmp 2b

.section .rodata
.align 8
gdt64:
    .quad 0
    .quad 0x00af9a000000ffff
    .quad 0x00cf92000000ffff
gdt64_end:
gdt64_pointer:
    .word gdt64_end - gdt64 - 1
    .long gdt64

.section .bss
.align 8
boot_magic: .long 0
boot_info: .long 0
.align 4096
p4_table: .skip 4096
p3_table: .skip 4096
p2_table: .skip 4096
.align 16
stack_bottom: .skip 16384
stack_top:
