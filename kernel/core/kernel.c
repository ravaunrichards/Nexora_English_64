/* Freestanding NEXORA kernel bring-up core. */
#include <stdint.h>
#include <stddef.h>
#define COM1 0x3F8u
#define MULTIBOOT2_BOOT_MAGIC 0x36d76289u

static inline void outb(uint16_t port, uint8_t value) {
    __asm__ volatile ("outb %0, %1" : : "a"(value), "Nd"(port));
}
static inline uint8_t inb(uint16_t port) {
    uint8_t value;
    __asm__ volatile ("inb %1, %0" : "=a"(value) : "Nd"(port));
    return value;
}
static void serial_init(void) {
    outb(COM1 + 1, 0);
    outb(COM1 + 3, 0x80);
    outb(COM1, 1);
    outb(COM1 + 1, 0);
    outb(COM1 + 3, 3);
    outb(COM1 + 2, 0xc7);
    outb(COM1 + 4, 0x0b);
}
static void putc_serial(char c) {
    while ((inb(COM1 + 5) & 0x20u) == 0) { }
    outb(COM1, (uint8_t)c);
}
static void write_serial(const char *s) {
    while (*s) {
        if (*s == '\n') putc_serial('\r');
        putc_serial(*s++);
    }
}
static void write_hex(uint64_t v) {
    static const char d[] = "0123456789abcdef";
    write_serial("0x");
    for (int i = 60; i >= 0; i -= 4) putc_serial(d[(v >> i) & 15]);
}
static void halt(void) {
    for (;;) __asm__ volatile ("cli; hlt");
}
static void inspect_boot_info(uint64_t address) {
    if (!address) {
        write_serial("NEXORA: no Multiboot2 info pointer\n");
        return;
    }
    const uint32_t *info = (const uint32_t *)(uintptr_t)address;
    uint32_t total = info[0];
    if (total < 16 || total > 16u * 1024u * 1024u) {
        write_serial("NEXORA: invalid Multiboot2 information size\n");
        return;
    }
    write_serial("NEXORA: Multiboot2 info bytes=");
    write_hex(total);
    write_serial("\n");
    uintptr_t p = address + 8, end = address + total;
    while (p + 8 <= end) {
        const uint32_t *tag = (const uint32_t *)p;
        uint32_t type = tag[0], size = tag[1];
        if (size < 8 || p + size > end) {
            write_serial("NEXORA: malformed boot tag; stopping parse\n");
            break;
        }
        if (type == 0) break;
        if (type == 4 && size >= 16) {
            write_serial("NEXORA: lower memory KB=");
            write_hex(tag[2]);
            write_serial(" upper memory KB=");
            write_hex(tag[3]);
            write_serial("\n");
        } else if (type == 6 && size >= 16) {
            write_serial("NEXORA: memory-map tag entry size=");
            write_hex(tag[2]);
            write_serial("\n");
        } else if (type == 8 && size >= 32) {
            const uint64_t *fb = (const uint64_t *)(p + 8);
            write_serial("NEXORA: framebuffer address=");
            write_hex(fb[0]);
            write_serial("\n");
        }
        p = (p + size + 7u) & ~(uintptr_t)7u;
    }
}
void kernel_main(uint64_t magic, uint64_t info_address) {
    serial_init();
    write_serial("\nNEXORA ENGLISH x64 — native kernel bootstrap\n");
    write_serial("NEXORA: entered 64-bit long mode\n");
    write_serial("NEXORA: Multiboot2 magic=");
    write_hex(magic);
    write_serial("\n");
    if (magic != MULTIBOOT2_BOOT_MAGIC) {
        write_serial("NEXORA: FATAL: invalid boot protocol magic\n");
        halt();
    }
    inspect_boot_info(info_address);
    write_serial("NEXORA: bootstrap complete; CPU halted safely\n");
    halt();
}
