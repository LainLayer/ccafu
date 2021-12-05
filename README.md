# C compiler attempt for university (aka CCAFU)

This is a university project in which i try to make a C compiler in nim.
This repo will remain private until I am done with university.

## goals

- tokenize code into tokens (i am here, 80% done)
- parse token list into something
- emit some structure i can easily convert into instructions
- generate elf64 header
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
nimble build
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

- Porth language programming stream playlist: https://www.youtube.com/watch?v=8QP2fDBIxjM&list=PLpM-Dvs8t0VbMZA7wW9aR3EtBqe2kinu4
- Porth language git: https://gitlab.com/tsoding/porth
- Making programming language parsers: https://www.youtube.com/watch?v=lcF-HzlFYKE
- List of C keywords i used: https://en.cppreference.com/w/c/keyword
- Book I bought: compilers, principlas, techniques, and tools by Alfred V.Aho, Ravi Sethi, and Jeffery D.Ullman (english version)
- Elf header man page: https://man7.org/linux/man-pages/man5/elf.5.html
- Understanding the ELF file format: https://linuxhint.com/understanding_elf_file_format/

still looking for a non terrible asm reference