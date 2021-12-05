#!/bin/bash

# to input edit test.asm
nasm -felf64 test.asm && ld -O3 -s -n -o test test.o &&./test
