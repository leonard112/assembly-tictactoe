#!/bin/bash

set -e

mkdir object &> /dev/null || true

nasm -f elf64 exit.asm -o object/exit.o
nasm -f elf64 fill_space.asm -o object/fill_space.o
nasm -f elf64 input_cpu.asm -o object/input_cpu.o
nasm -f elf64 input.asm -o object/input.o
nasm -f elf64 main.asm -o object/main.o
nasm -f elf64 print.asm -o object/print.o
nasm -f elf64 random.asm -o object/random.o
nasm -f elf64 show_board.asm -o object/show_board.o
ld object/exit.o \
   object/fill_space.o \
   object/input_cpu.o \
   object/input.o \
   object/main.o \
   object/print.o \
   object/random.o \
   object/show_board.o \
   -o tictactoe