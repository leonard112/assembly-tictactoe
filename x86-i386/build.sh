#!/bin/bash

nasm -f elf32 main.asm -o object/main.o
nasm -f elf32 show_board.asm -o object/show_board.o
nasm -f elf32 fill_space.asm -o object/fill_space.o
nasm -f elf32 input.asm -o object/input.o
nasm -f elf32 print.asm -o object/print.o
nasm -f elf32 exit.asm -o object/exit.o
ld -m elf_i386 object/main.o object/print.o object/exit.o object/input.o object/show_board.o object/fill_space.o -o tictactoe