# C compiler attempt for university, aka CCAFU (UNFINIHSED)
![build](https://github.com/LainLayer/ccafu/workflows/CI/badge.svg)

This is a university project in which i try to make a C compiler in nim.
This repo will remain private until I am done with university.

## goals

- tokenize code into tokens (i am here, 80% done)
- parse token list into something (5%)
- emit some structure i can easily convert into instructions
- generate elf64 header (maybe not, documentation is really bad)
- create binary file
- have actually useful errors

Ideally I would like to not use `ld` or `nasm`

## notes

This compiler will only support Linux 64 bit binaries.

There are no current plans for any other system support, and why would you even use
anything else?

There are currently no plans to create debugging features or compiler optimizations.

I am also doing this to learn nim. I know my code is bad and i could have done X.
Once I make the repo public, you may tell me all about it.

## building

### debug

```
nimble build -d:debug
```

### release

```
nimble build -d:release --opt:speed --gc:arc
```

## usage

```
./compiler file.c
```
creates `file` which should hopefully be an elf64 linux executable

## references

- Compiler Series: https://github.com/bisqwit/compiler_series
- Porth language programming stream playlist: https://www.youtube.com/watch?v=8QP2fDBIxjM&list=PLpM-Dvs8t0VbMZA7wW9aR3EtBqe2kinu4
- Porth language git: https://gitlab.com/tsoding/porth
- Bang Programming language coding stream playlist: https://www.youtube.com/watch?v=7a_YKCeMCMA&list=PLpM-Dvs8t0Vbr6JPYZwudpU4KfPnDoJOJ
- Making programming language parsers: https://www.youtube.com/watch?v=lcF-HzlFYKE
- List of C keywords i used: https://en.cppreference.com/w/c/keyword
- Book I bought: compilers, principlas, techniques, and tools by Alfred V.Aho, Ravi Sethi, and Jeffery D.Ullman (english version)
- Elf header man page: https://man7.org/linux/man-pages/man5/elf.5.html
- Understanding the ELF file format: https://linuxhint.com/understanding_elf_file_format/



### These are a blog series "Introduction to the ELF Format" by Keith Makan:
- The ELF Header (Part 1): https://blog.k3170makan.com/2018/09/introduction-to-elf-format-elf-header.html
- Understanding Program Headers (Part 2): https://blog.k3170makan.com/2018/09/introduction-to-elf-format-part-ii.html
- The Section Headers (Part 3): https://blog.k3170makan.com/2018/09/introduction-to-elf-file-format-part.html
- The Symbol Table and Relocations (part 4): https://blog.k3170makan.com/2018/10/introduction-to-elf-format-part-vi.html

### ASM
still looking for a non terrible asm reference

no idea if this even makes sense but its a start:
- https://en.wikipedia.org/wiki/X86_instruction_listings
