#!/bin/bash

nasm -f elf64 main.asm -o object/main.o
nasm -f elf64 show_board.asm -o object/show_board.o
nasm -f elf64 fill_space.asm -o object/fill_space.o
nasm -f elf64 input.asm -o object/input.o
nasm -f elf64 print.asm -o object/print.o
nasm -f elf64 exit.asm -o object/exit.o
ld object/main.o \
   object/print.o \
   object/exit.o \
   object/input.o \
   object/show_board.o \
   object/fill_space.o \
   -o tictactoe