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
static void write_serial_bytes(const char *s, size_t n) {
    for (size_t i = 0; i < n; ++i) putc_serial(s[i]);
}
static void write_hex(uint64_t v) {
    static const char d[] = "0123456789abcdef";
    write_serial("0x");
    for (int i = 60; i >= 0; i -= 4) putc_serial(d[(v >> i) & 15]);
}
static void halt(void) {
    for (;;) __asm__ volatile ("cli; hlt");
}
static inline void cpuid(uint32_t leaf, uint32_t subleaf,
                         uint32_t *a, uint32_t *b,
                         uint32_t *c, uint32_t *d) {
    __asm__ volatile ("cpuid"
        : "=a"(*a), "=b"(*b), "=c"(*c), "=d"(*d)
        : "a"(leaf), "c"(subleaf));
}
static void report_cpu_features(void) {
    uint32_t a, b, c, d;
    cpuid(0, 0, &a, &b, &c, &d);
    char vendor[12];
    *(uint32_t *)&vendor[0] = b;
    *(uint32_t *)&vendor[4] = d;
    *(uint32_t *)&vendor[8] = c;
    write_serial("NEXORA: CPU vendor=");
    write_serial_bytes(vendor, sizeof(vendor));
    write_serial("\n");

    cpuid(0x80000000u, 0, &a, &b, &c, &d);
    if (a >= 0x80000001u) {
        cpuid(0x80000001u, 0, &a, &b, &c, &d);
        write_serial("NEXORA: CPU long-mode capability=");
        write_serial((d & (1u << 29)) ? "present\n" : "not-reported\n");
    } else {
        write_serial("NEXORA: extended CPUID features unavailable\n");
    }
}
static uint32_t read_u32(const uint8_t *p) {
    return *(const uint32_t *)(const void *)p;
}
static uint64_t read_u64(const uint8_t *p) {
    return *(const uint64_t *)(const void *)p;
}
static void inspect_memory_map(const uint8_t *tag, uint32_t tag_size) {
    if (tag_size < 16) {
        write_serial("NEXORA: malformed memory-map tag header\n");
        return;
    }
    uint32_t entry_size = read_u32(tag + 8);
    if (entry_size < 24) {
        write_serial("NEXORA: unsupported memory-map entry size\n");
        return;
    }
    uint32_t count = 0;
    uint64_t available_bytes = 0;
    for (uint32_t offset = 16; offset <= tag_size && tag_size - offset >= entry_size;
         offset += entry_size) {
        const uint8_t *entry = tag + offset;
        uint64_t base = read_u64(entry);
        uint64_t length = read_u64(entry + 8);
        uint32_t type = read_u32(entry + 16);
        ++count;
        if (type == 1u && UINT64_MAX - available_bytes >= length)
            available_bytes += length;
        (void)base;
    }
    write_serial("NEXORA: memory-map entries=");
    write_hex(count);
    write_serial(" usable bytes=");
    write_hex(available_bytes);
    write_serial("\n");
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
        const uint8_t *tag = (const uint8_t *)p;
        uint32_t type = read_u32(tag);
        uint32_t size = read_u32(tag + 4);
        if (size < 8 || p + size > end) {
            write_serial("NEXORA: malformed boot tag; stopping parse\n");
            break;
        }
        if (type == 0) break;
        if (type == 4 && size >= 16) {
            write_serial("NEXORA: lower memory KB=");
            write_hex(read_u32(tag + 8));
            write_serial(" upper memory KB=");
            write_hex(read_u32(tag + 12));
            write_serial("\n");
        } else if (type == 6) {
            inspect_memory_map(tag, size);
        } else if (type == 8 && size >= 32) {
            write_serial("NEXORA: framebuffer address=");
            write_hex(read_u64(tag + 8));
            write_serial(" pitch=");
            write_hex(read_u32(tag + 16));
            write_serial(" width=");
            write_hex(read_u32(tag + 20));
            write_serial(" height=");
            write_hex(read_u32(tag + 24));
            write_serial("\n");
        }
        p = (p + size + 7u) & ~(uintptr_t)7u;
    }
}

struct idt_gate {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t ist;
    uint8_t attributes;
    uint16_t offset_middle;
    uint32_t offset_high;
    uint32_t reserved;
} __attribute__((packed));
struct idtr {
    uint16_t limit;
    uint64_t base;
} __attribute__((packed));
struct exception_frame {
    uint64_t r15, r14, r13, r12, r11, r10, r9, r8;
    uint64_t rbp, rdi, rsi, rdx, rcx, rbx, rax;
    uint64_t vector, error_code, rip, cs, rflags;
};
static struct idt_gate idt[256] __attribute__((aligned(16)));
extern void (*isr_stub_table[32])(void);

static void idt_init(void) {
    for (uint32_t i = 0; i < 32; ++i) {
        uintptr_t handler = (uintptr_t)isr_stub_table[i];
        idt[i].offset_low = (uint16_t)handler;
        idt[i].selector = 0x08;
        idt[i].ist = 0;
        idt[i].attributes = 0x8e;
        idt[i].offset_middle = (uint16_t)(handler >> 16);
        idt[i].offset_high = (uint32_t)(handler >> 32);
        idt[i].reserved = 0;
    }
    struct idtr descriptor = {
        .limit = (uint16_t)(sizeof(idt) - 1),
        .base = (uint64_t)(uintptr_t)idt
    };
    __asm__ volatile ("lidt %0" : : "m"(descriptor));
}
__attribute__((noreturn))
void nexora_exception_handler(struct exception_frame *frame) {
    write_serial("\nNEXORA: FATAL CPU EXCEPTION vector=");
    write_hex(frame->vector);
    write_serial(" error=");
    write_hex(frame->error_code);
    write_serial(" rip=");
    write_hex(frame->rip);
    write_serial("\n");
    if (frame->vector == 14) {
        uint64_t fault_address;
        __asm__ volatile ("mov %%cr2, %0" : "=r"(fault_address));
        write_serial("NEXORA: page-fault address=");
        write_hex(fault_address);
        write_serial("\n");
    }
    halt();
}

void kernel_main(uint64_t magic, uint64_t info_address) {
    serial_init();
    idt_init();
    write_serial("NEXORA: IDT installed for CPU exceptions 0-31\\n");
    write_serial("\nNEXORA ENGLISH x64 — native kernel bootstrap\n");
    write_serial("NEXORA: entered 64-bit long mode\n");
    write_serial("NEXORA: Multiboot2 magic=");
    write_hex(magic);
    write_serial("\n");
    if (magic != MULTIBOOT2_BOOT_MAGIC) {
        write_serial("NEXORA: FATAL: invalid boot protocol magic\n");
        halt();
    }
    report_cpu_features();
    inspect_boot_info(info_address);
    write_serial("NEXORA: bootstrap complete; CPU halted safely\n");
    halt();
}
