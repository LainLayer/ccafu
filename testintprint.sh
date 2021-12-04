#!/bin/bash

# to input edit test.asm
nasm -felf64 test.asm && ld -o test test.o &&./test