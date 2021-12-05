#include <elf.h>

/*
 * ELF dump of 'test'
 *     4824 (0x12D8) bytes
 */

//TODO: port this to nim as a library that generates ELF headers

Elf64_Dyn dumpedelf_dyn_0[];
struct {
  Elf64_Ehdr ehdr;
  Elf64_Phdr phdrs[2];
  Elf64_Shdr shdrs[5];
  Elf64_Dyn *dyns;
} dumpedelf_0 = {

    .ehdr = {.e_ident = {
                 /* (EI_NIDENT bytes) */
                 /* [0] EI_MAG:        */ 0x7F,
                 'E',
                 'L',
                 'F',
                 /* [4] EI_CLASS:      */ 2, /* (ELFCLASS64) */
                 /* [5] EI_DATA:       */ 1, /* (ELFDATA2LSB) */
                 /* [6] EI_VERSION:    */ 1, /* (EV_CURRENT) */
                 /* [7] EI_OSABI:      */ 0, /* (ELFOSABI_NONE) */
                 /* [8] EI_ABIVERSION: */ 0,
                 /* [9-15] EI_PAD:     */ 0x0,
                 0x0,
                 0x0,
                 0x0,
                 0x0,
                 0x0,
                 0x0,
             },
             .e_type = 2,         /* (ET_EXEC) */
             .e_machine = 62,     /* (EM_X86_64) */
             .e_version = 1,      /* (EV_CURRENT) */
             .e_entry = 0x401072, /* (start address at runtime) */
             .e_phoff = 64,       /* (bytes into file) */
             .e_shoff = 4504,     /* (bytes into file) */
             .e_flags = 0x0,
             .e_ehsize = 64,    /* (bytes) */
             .e_phentsize = 56, /* (bytes) */
             .e_phnum = 2,      /* (program headers) */
             .e_shentsize = 64, /* (bytes) */
             .e_shnum = 5,      /* (section headers) */
             .e_shstrndx = 4},

    .phdrs =
        {
            /* Program Header #0 0x40 */
            {
                .p_type = 1,         /* [PT_LOAD] */
                .p_offset = 0,       /* (bytes into file) */
                .p_vaddr = 0x400000, /* (virtual addr at runtime) */
                .p_paddr = 0x400000, /* (physical addr at runtime) */
                .p_filesz = 176,     /* (bytes in file) */
                .p_memsz = 176,      /* (bytes in mem at runtime) */
                .p_flags = 0x4,      /* PF_R */
                .p_align = 4096,     /* (min mem alignment in bytes) */
            },
            /* Program Header #1 0x78 */
            {
                .p_type = 1,         /* [PT_LOAD] */
                .p_offset = 4096,    /* (bytes into file) */
                .p_vaddr = 0x401000, /* (virtual addr at runtime) */
                .p_paddr = 0x401000, /* (physical addr at runtime) */
                .p_filesz = 136,     /* (bytes in file) */
                .p_memsz = 136,      /* (bytes in mem at runtime) */
                .p_flags = 0x5,      /* PF_R | PF_X */
                .p_align = 4096,     /* (min mem alignment in bytes) */
            },
        },

    .shdrs =
        {
            /* Section Header #0 '' 0x1198 */
            {.sh_name = 0,
             .sh_type = 0, /* [SHT_NULL] */
             .sh_flags = 0,
             .sh_addr = 0x0,
             .sh_offset = 0, /* (bytes) */
             .sh_size = 0,   /* (bytes) */
             .sh_link = 0,
             .sh_info = 0,
             .sh_addralign = 0,
             .sh_entsize = 0},
            /* Section Header #1 '.text' 0x11D8 */
            {.sh_name = 27,
             .sh_type = 1, /* [SHT_PROGBITS] */
             .sh_flags = 6,
             .sh_addr = 0x401000,
             .sh_offset = 4096, /* (bytes) */
             .sh_size = 136,    /* (bytes) */
             .sh_link = 0,
             .sh_info = 0,
             .sh_addralign = 16,
             .sh_entsize = 0},
            /* Section Header #2 '.symtab' 0x1218 */
            {.sh_name = 1,
             .sh_type = 2, /* [SHT_SYMTAB] */
             .sh_flags = 0,
             .sh_addr = 0x0,
             .sh_offset = 4232, /* (bytes) */
             .sh_size = 192,    /* (bytes) */
             .sh_link = 3,
             .sh_info = 4,
             .sh_addralign = 8,
             .sh_entsize = 24},
            /* Section Header #3 '.strtab' 0x1258 */
            {.sh_name = 9,
             .sh_type = 3, /* [SHT_STRTAB] */
             .sh_flags = 0,
             .sh_addr = 0x0,
             .sh_offset = 4424, /* (bytes) */
             .sh_size = 47,     /* (bytes) */
             .sh_link = 0,
             .sh_info = 0,
             .sh_addralign = 1,
             .sh_entsize = 0},
            /* Section Header #4 '.shstrtab' 0x1298 */
            {.sh_name = 17,
             .sh_type = 3, /* [SHT_STRTAB] */
             .sh_flags = 0,
             .sh_addr = 0x0,
             .sh_offset = 4471, /* (bytes) */
             .sh_size = 33,     /* (bytes) */
             .sh_link = 0,
             .sh_info = 0,
             .sh_addralign = 1,
             .sh_entsize = 0},
        },

    .dyns = dumpedelf_dyn_0,
};
Elf64_Dyn dumpedelf_dyn_0[] = {
    /* no dynamic tags ! */};
